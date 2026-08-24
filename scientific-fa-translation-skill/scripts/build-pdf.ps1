<#
.SYNOPSIS
    Compile a Persian print document and copy the PDF to
    $HOME\Documents\books. Windows counterpart of build-pdf.sh.

.DESCRIPTION
    Engine order for .tex: XeLaTeX (via latexmk when present). For .html:
    a Chromium browser (Edge, then Chrome), then WeasyPrint. A *missing*
    engine falls back; a *failing* engine does not - it reports the error
    and stops, so a broken build is never quietly downgraded.

    Only the destination path is written to stdout; every diagnostic goes
    to stderr, so `$pdf = .\build-pdf.ps1 doc.tex slug` captures the path.

.PARAMETER Path
    The .tex or .html source to compile.

.PARAMETER Slug
    Filesystem-safe stem for the output PDF. Defaults to the source stem.

.PARAMETER Verify
    Report page count and embedded fonts, and rasterise sample pages to
    PNG. Judge RTL from those images, never from pdftotext.

.PARAMETER Engine
    Force one engine: tex, chromium, or weasyprint.

.EXAMPLE
    .\build-pdf.ps1 doc.tex my-slug -Verify

.EXAMPLE
    .\build-pdf.ps1 doc.html my-slug -Engine chromium -Verify

.NOTES
    Targets Windows PowerShell 5.1; PowerShell 7 works too. This file is
    deliberately pure ASCII: 5.1 decodes a BOM-less .ps1 with the system
    ANSI code page, where a UTF-8 em dash turns into a curly quote that
    terminates a string and breaks the parse. Keep it ASCII-only.

    The Python helpers in this directory (check-fa.py, prepare-figures.py,
    crop-source-figures.py, extract-pdf-pages.py) are cross-platform
    already - run them with `python scripts\check-fa.py ...`.
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory = $true, Position = 0)]
    [string]$Path,

    [Parameter(Position = 1)]
    [string]$Slug,

    [switch]$Verify,

    [ValidateSet('tex', 'chromium', 'weasyprint')]
    [string]$Engine
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
# Persian filenames and TeX log lines are UTF-8; do not let the console
# code page mangle them.
try { [Console]::OutputEncoding = [Text.UTF8Encoding]::new($false) } catch { }
# Assignment, not indexing: indexing would mutate the caller's global
# dictionary and leave '*:Encoding' set for the rest of their session.
$PSDefaultParameterValues = @{ '*:Encoding' = 'utf8' }

function Write-Log {
    param([string]$Message)
    [Console]::Error.WriteLine("build-pdf: $Message")
}

function Get-Tool {
    # Resolve an executable on PATH; $null when absent. Filtering on
    # Application guarantees $LASTEXITCODE is meaningful after a call.
    param([string]$Name)
    $cmd = Get-Command -Name $Name -CommandType Application -ErrorAction SilentlyContinue
    if ($cmd) { return $cmd.Source }
    return $null
}

function Invoke-Tool {
    # Run an executable, capture merged stdout+stderr, return the exit code.
    #
    # 2>&1 on a native command wraps each stderr line in an ErrorRecord and
    # emits it through WriteError, which honours $ErrorActionPreference. Under
    # 'Stop' the first stderr line would throw - and headless Chromium, latexmk
    # -silent, and a failing `python -c import` all write to stderr on success
    # paths. Relax the preference for the duration of the call only.
    param([string]$Exe, [string[]]$Arguments)
    $previous = $ErrorActionPreference
    $ErrorActionPreference = 'Continue'
    try {
        $out = & $Exe @Arguments 2>&1
        $code = $LASTEXITCODE
    }
    finally {
        $ErrorActionPreference = $previous
    }
    return [pscustomobject]@{ ExitCode = $code; Output = $out }
}

function Write-ToolOutput {
    param($Output)
    if ($null -eq $Output) { return }
    $Output | ForEach-Object { [Console]::Error.WriteLine($_) }
}

function Test-XeLaTeX {
    if (-not (Get-Tool 'xelatex')) { return $false }
    # xepersian is the part that is usually missing on a bare TeX install.
    if (Get-Tool 'kpsewhich') {
        $r = Invoke-Tool 'kpsewhich' @('xepersian.sty')
        if ($r.ExitCode -ne 0) { return $false }
    }
    return $true
}

function Find-Chromium {
    # Edge ships with Windows and is the same Chromium engine, so it is the
    # first choice here; Chrome and a bare chromium build follow.
    foreach ($name in 'msedge', 'chrome', 'chromium') {
        $p = Get-Tool $name
        if ($p) { return $p }
    }
    $roots = @(
        $env:ProgramFiles,
        ${env:ProgramFiles(x86)},
        $env:LOCALAPPDATA
    ) | Where-Object { $_ }
    $relative = @(
        'Microsoft\Edge\Application\msedge.exe',
        'Google\Chrome\Application\chrome.exe',
        'Chromium\Application\chrome.exe'
    )
    foreach ($rel in $relative) {
        foreach ($root in $roots) {
            $candidate = Join-Path $root $rel
            if (Test-Path -LiteralPath $candidate -PathType Leaf) { return $candidate }
        }
    }
    return $null
}

function Show-TexError {
    param([string]$LogFile)
    if (-not (Test-Path -LiteralPath $LogFile -PathType Leaf)) { return }
    Write-Log "--- first TeX errors in $LogFile ---"
    Get-Content -LiteralPath $LogFile -Encoding UTF8 |
        Where-Object { $_ -like '!*' } |
        Select-Object -First 20 |
        ForEach-Object { [Console]::Error.WriteLine($_) }
    Write-Log '--- last 25 log lines ---'
    Get-Content -LiteralPath $LogFile -Encoding UTF8 -Tail 25 |
        ForEach-Object { [Console]::Error.WriteLine($_) }
}

# 0 = built, 1 = engine unavailable, 2 = engine present but failed.
function Invoke-TexBuild {
    param([string]$SourceName, [string]$Stem, [string]$Destination)
    if (-not (Test-XeLaTeX)) { return 1 }
    $pdf = "$Stem.pdf"
    $log = "$Stem.log"
    if (Get-Tool 'latexmk') {
        Write-Log 'engine: latexmk -xelatex'
        $r = Invoke-Tool 'latexmk' @(
            '-xelatex', '-interaction=nonstopmode', '-halt-on-error',
            '-silent', $SourceName)
    }
    else {
        Write-Log 'engine: xelatex (two passes)'
        $r = Invoke-Tool 'xelatex' @(
            '-interaction=nonstopmode', '-halt-on-error', $SourceName)
        if ($r.ExitCode -eq 0) {
            $r = Invoke-Tool 'xelatex' @(
                '-interaction=nonstopmode', '-halt-on-error', $SourceName)
        }
    }
    if ($r.ExitCode -ne 0) { Show-TexError $log; return 2 }
    if (-not (Test-Path -LiteralPath $pdf -PathType Leaf)) {
        Write-Log "expected PDF missing: $pdf"
        return 2
    }
    Copy-Item -LiteralPath $pdf -Destination $Destination -Force
    return 0
}

function ConvertTo-FileUri {
    param([string]$LiteralPath)
    return ([Uri](Resolve-Path -LiteralPath $LiteralPath).ProviderPath).AbsoluteUri
}

function Invoke-HtmlBuild {
    param([string]$Html, [string]$Destination)

    if ($Engine -ne 'weasyprint') {
        $browser = Find-Chromium
        if ($browser) {
            Write-Log "engine: $([IO.Path]::GetFileName($browser)) --print-to-pdf"
            # A dedicated profile directory keeps the headless run from
            # attaching to an already-open Edge/Chrome window, which is the
            # usual reason --print-to-pdf silently writes nothing on Windows.
            $profileDir = Join-Path ([IO.Path]::GetTempPath()) ('fa-pdf-' + [Guid]::NewGuid().ToString('N'))
            try {
                # Without a virtual-time budget Chromium can print before the
                # webfonts finish loading, which produces fallback boxes for
                # Persian. --disable-gpu paints raster images as black
                # rectangles; do not pass it.
                $r = Invoke-Tool $browser @(
                    '--headless=new',
                    '--no-pdf-header-footer',
                    '--virtual-time-budget=10000',
                    '--run-all-compositor-stages-before-draw',
                    "--user-data-dir=$profileDir",
                    "--print-to-pdf=$Destination",
                    (ConvertTo-FileUri $Html)
                )
            }
            finally {
                Remove-Item -LiteralPath $profileDir -Recurse -Force -ErrorAction SilentlyContinue
            }
            if ($r.ExitCode -ne 0) {
                Write-ToolOutput $r.Output
                return 2
            }
            # Headless Chromium can exit 0 without writing the file.
            if (-not (Test-Path -LiteralPath $Destination -PathType Leaf)) {
                Write-Log "the browser exited 0 but wrote no PDF: $Destination"
                Write-ToolOutput $r.Output
                return 2
            }
            return 0
        }
    }

    if (Get-Tool 'weasyprint') {
        Write-Log 'engine: weasyprint (keeps its bidi warnings; read them)'
        $r = Invoke-Tool 'weasyprint' @($Html, $Destination)
        if ($r.ExitCode -ne 0) {
            Write-ToolOutput $r.Output
            return 2
        }
        return 0
    }

    $python = Get-Tool 'python'
    if (-not $python) { $python = Get-Tool 'python3' }
    if ($python) {
        $probe = Invoke-Tool $python @('-c', 'import weasyprint')
        if ($probe.ExitCode -eq 0) {
            Write-Log 'engine: weasyprint (python module)'
            $code = 'from weasyprint import HTML; import sys; HTML(sys.argv[1]).write_pdf(sys.argv[2])'
            $r = Invoke-Tool $python @('-c', $code, $Html, $Destination)
            if ($r.ExitCode -ne 0) {
                Write-ToolOutput $r.Output
                return 2
            }
            return 0
        }
    }

    Write-Log 'no HTML engine: install Edge/Chrome, or WeasyPrint in a venv'
    Write-Log '  (py -m venv .venv; .venv\Scripts\pip install weasyprint)'
    return 1
}

function Test-OutputPdf {
    param([string]$Pdf, [string]$WorkDir, [string]$Stem)
    $item = Get-Item -LiteralPath $Pdf -ErrorAction SilentlyContinue
    if (-not $item -or $item.Length -eq 0) {
        Write-Log "VERIFY FAIL: $Pdf is empty"
        return $false
    }
    $pages = $null
    if (Get-Tool 'pdfinfo') {
        $r = Invoke-Tool 'pdfinfo' @($Pdf)
        $line = $r.Output | Where-Object { $_ -match '^Pages:\s+(\d+)' } | Select-Object -First 1
        if ($line -and "$line" -match '^Pages:\s+(\d+)') { $pages = [int]$Matches[1] }
        if ($pages) { Write-Log "pages: $pages" } else { Write-Log 'pages: unknown' }
    }
    if (Get-Tool 'pdffonts') {
        Write-Log 'embedded fonts:'
        $r = Invoke-Tool 'pdffonts' @($Pdf)
        $r.Output | Select-Object -First 8 | ForEach-Object { [Console]::Error.WriteLine($_) }
        $embedded = $r.Output | Select-Object -Skip 2 | Where-Object { "$_" -match '\byes\b' }
        if (-not $embedded) {
            Write-Log 'VERIFY WARN: no embedded font; Persian may render as boxes'
        }
    }
    if (Get-Tool 'pdftoppm') {
        $prefix = Join-Path $WorkDir "verify-$Stem"
        Invoke-Tool 'pdftoppm' @('-png', '-r', '110', '-f', '1', '-l', '1', $Pdf, "$prefix-first") | Out-Null
        if ($pages -and $pages -gt 1) {
            Invoke-Tool 'pdftoppm' @('-png', '-r', '110', '-f', "$pages", '-l', "$pages", $Pdf, "$prefix-last") | Out-Null
        }
        Write-Log "rasterised samples: $prefix-*.png -- look at them, do not"
        Write-Log '  judge RTL from pdftotext'
    }
    else {
        Write-Log 'pdftoppm missing: install poppler to rasterise sample pages'
        Write-Log '  (winget install oschwartz10612.Poppler, or scoop install poppler)'
    }
    return $true
}

# --- main -------------------------------------------------------------

if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) {
    Write-Log "not a file: $Path"
    exit 1
}

$srcItem = Get-Item -LiteralPath $Path
$srcDir = $srcItem.DirectoryName
$srcName = $srcItem.Name
$srcStem = [IO.Path]::GetFileNameWithoutExtension($srcName)
$ext = $srcItem.Extension.TrimStart('.').ToLowerInvariant()
if (-not $Slug) { $Slug = $srcStem }

$destDir = Join-Path $HOME 'Documents\books'
$dest = Join-Path $destDir "$Slug.pdf"
New-Item -ItemType Directory -Path $destDir -Force | Out-Null

$rc = 1
Push-Location -LiteralPath $srcDir
try {
    switch ($ext) {
        'tex' {
            if ($Engine -eq 'chromium' -or $Engine -eq 'weasyprint') {
                $html = "$srcStem.html"
                if (-not (Test-Path -LiteralPath $html -PathType Leaf)) {
                    Write-Log "no $html next to the .tex"
                    exit 1
                }
                $rc = Invoke-HtmlBuild $html $dest
            }
            else {
                $rc = Invoke-TexBuild $srcName $srcStem $dest
                if ($rc -eq 2) {
                    Write-Log 'XeLaTeX is installed but the document failed to compile.'
                    Write-Log 'Fix the TeX error above. Not falling back - a fallback here'
                    Write-Log '  would hide a real error in the .tex.'
                    exit 1
                }
                if ($rc -eq 1) {
                    Write-Log 'xelatex or xepersian not available (see scripts\preflight.ps1)'
                    $html = "$srcStem.html"
                    if (Test-Path -LiteralPath $html -PathType Leaf) {
                        Write-Log "falling back to $html"
                        $rc = Invoke-HtmlBuild $html $dest
                    }
                    else {
                        Write-Log 'write the HTML from assets\rtl-document.html and retry:'
                        Write-Log "  build-pdf.ps1 $(Join-Path $srcDir $html) $Slug"
                        exit 1
                    }
                }
            }
        }
        { $_ -in 'html', 'htm' } {
            $rc = Invoke-HtmlBuild $srcName $dest
        }
        default {
            Write-Log "expected .tex or .html, got: $srcName"
            exit 2
        }
    }

    if ($rc -ne 0) {
        Write-Log 'build failed'
        exit 1
    }

    if ($Verify) { Test-OutputPdf $dest $srcDir $Slug | Out-Null }
}
finally {
    Pop-Location
}

Write-Output $dest
exit 0
