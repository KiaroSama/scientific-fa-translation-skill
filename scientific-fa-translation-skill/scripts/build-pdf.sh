#!/usr/bin/env bash
# Compile a Persian print document and copy the PDF to $HOME/Documents/books.
#
#   build-pdf.sh <file.tex|file.html> [slug] [--verify] [--engine ENGINE]
#
# Engine order for .tex: XeLaTeX (via latexmk when present). For .html:
# Chromium, then WeasyPrint. A missing engine falls back; a *failing* engine
# does not — it reports the error and stops, so a broken build is never
# quietly downgraded.
set -uo pipefail

usage() {
  echo "usage: build-pdf.sh <file.tex|file.html> [slug] [--verify]" \
       "[--engine tex|chromium|weasyprint]" >&2
  exit 2
}

[[ $# -ge 1 ]] || usage

src=""
slug=""
verify=0
engine=""
while [[ $# -gt 0 ]]; do
  case "$1" in
    --verify) verify=1; shift ;;
    --engine) engine=${2:-}; shift 2 ;;
    -h|--help) usage ;;
    -*) echo "build-pdf.sh: unknown option: $1" >&2; usage ;;
    *) if [[ -z $src ]]; then src=$1; elif [[ -z $slug ]]; then slug=$1;
       else usage; fi; shift ;;
  esac
done

[[ -n $src ]] || usage
if [[ ! -f $src ]]; then
  echo "build-pdf.sh: not a file: $src" >&2
  exit 1
fi

src_dir=$(cd "$(dirname "$src")" && pwd)
src_base=$(basename "$src")
ext=${src_base##*.}
stem_src=${src_base%.*}
stem=${slug:-$stem_src}
dest_dir="${HOME}/Documents/books"
dest="${dest_dir}/${stem}.pdf"

mkdir -p "$dest_dir"
cd "$src_dir" || exit 1

log() { printf 'build-pdf: %s\n' "$*" >&2; }

have_xelatex() {
  command -v xelatex >/dev/null 2>&1 || return 1
  # xepersian is the part that is usually missing on a bare TeX install.
  # Exit code alone is not enough: MiKTeX's kpsewhich can exit 0 while
  # printing nothing for a package the basic install does not carry.
  if command -v kpsewhich >/dev/null 2>&1; then
    [ -n "$(kpsewhich xepersian.sty 2>/dev/null)" ] || return 1
  fi
  return 0
}

find_chrome() {
  local c
  for c in chromium chromium-browser google-chrome google-chrome-stable; do
    if command -v "$c" >/dev/null 2>&1; then printf '%s\n' "$c"; return 0; fi
  done
  return 1
}

# A PDF that exists is not a PDF that is complete. XeLaTeX can exit 0 while
# the xdvipdfmx driver dies, leaving a truncated file with a valid header and
# no trailer - poppler then reports "Couldn't find trailer dictionary".
pdf_is_complete() {
  local f=$1
  [[ -s $f ]] || return 1
  [[ $(head -c 5 "$f") == '%PDF-' ]] || return 1
  tail -c 2048 "$f" | grep -q '%%EOF' || return 1
  return 0
}

show_tex_error() {
  local logfile=$1
  [[ -f $logfile ]] || return 0
  local errs
  errs=$(grep -n '^!' "$logfile" | head -20)
  if [[ -n $errs ]]; then
    log "--- first TeX errors in ${logfile} ---"
    printf '%s\n' "$errs" >&2
  else
    # A truncated log with no '!' line usually means the engine died mid-run
    # rather than rejecting the document - say so instead of printing an
    # empty section under a heading that promises errors.
    log "no '!' error line in ${logfile}; the engine stopped mid-run"
  fi
  log "--- last 25 log lines ---"
  tail -25 "$logfile" >&2
}

# 0 = built, 1 = engine unavailable, 2 = engine present but failed.
compile_tex() {
  have_xelatex || return 1
  local pdf="${stem_src}.pdf" logfile="${stem_src}.log"
  local out rc use_latexmk=0
  command -v latexmk >/dev/null 2>&1 && use_latexmk=1

  # Clear artefacts from a previous run first. Without this a stale .log
  # makes "latexmk left no .log" read as "latexmk reached the compiler", so
  # the fallback never fires and the old log gets reported as this build's
  # error; a stale .pdf could likewise be shipped as a success.
  rm -f "$logfile" "$pdf"

  if [[ $use_latexmk -eq 1 ]]; then
    log "engine: latexmk -xelatex"
    out=$(latexmk -xelatex -interaction=nonstopmode -halt-on-error \
                  -silent "$src_base" 2>&1); rc=$?
    if [[ $rc -ne 0 && ! -f $logfile ]]; then
      # No .log at all means the compiler was never reached - a latexmk
      # problem (it is a Perl script, so a missing Perl kills it) rather
      # than a broken document. Any real TeX error writes a .log first, so
      # retrying here cannot hide one.
      log "latexmk wrote no .log, so it never reached the compiler:"
      printf '%s\n' "$out" >&2
      log "retrying with xelatex directly"
      use_latexmk=0
    fi
  fi

  if [[ $use_latexmk -eq 0 ]]; then
    log "engine: xelatex (two passes)"
    out=$(xelatex -interaction=nonstopmode -halt-on-error "$src_base" 2>&1); rc=$?
    if [[ $rc -eq 0 ]]; then
      out=$(xelatex -interaction=nonstopmode -halt-on-error "$src_base" 2>&1); rc=$?
    fi
  fi

  if [[ $rc -ne 0 ]]; then
    if [[ -f $logfile ]]; then
      show_tex_error "$logfile"
    else
      # Never claim "the error is above" when nothing was printed.
      log "no ${logfile} was written; the engine's own output follows"
      printf '%s\n' "$out" >&2
    fi
    return 2
  fi
  [[ -f $pdf ]] || { log "expected PDF missing: ${src_dir}/${pdf}"; return 2; }
  # A zero exit code from xelatex only means TeX itself was happy. The PDF
  # driver runs afterwards and reports its own failure in the log while
  # xelatex still exits 0, so check for that before believing it.
  if [[ -f $logfile ]] && grep -q 'driver return code' "$logfile"; then
    log "the PDF driver failed even though xelatex exited 0:"
    grep -n 'driver return code' "$logfile" >&2
    printf '%s\n' "$out" >&2
    return 2
  fi
  if ! pdf_is_complete "$pdf"; then
    log "${pdf} is truncated (no %%EOF); the driver did not finish"
    printf '%s\n' "$out" >&2
    return 2
  fi
  cp -f "$pdf" "$dest" || return 2
  return 0
}

html_to_pdf() {
  local html=$1 out=$2 chrome
  if [[ $engine != weasyprint ]] && chrome=$(find_chrome); then
    log "engine: $chrome --print-to-pdf"
    # Without a virtual-time budget Chromium can print before the webfonts
    # finish loading, which produces fallback boxes for Persian.
    # --disable-gpu paints raster images as black rectangles; do not pass it.
    "$chrome" --headless=new --no-pdf-header-footer \
      --virtual-time-budget=10000 \
      --run-all-compositor-stages-before-draw \
      --print-to-pdf="$out" "file://$(realpath "$html")" || return 2
    return 0
  fi
  if command -v weasyprint >/dev/null 2>&1; then
    log "engine: weasyprint (keeps its bidi warnings; read them)"
    weasyprint "$html" "$out" || return 2
    return 0
  fi
  if python3 -c "import weasyprint" >/dev/null 2>&1; then
    log "engine: weasyprint (python module)"
    python3 -c 'from weasyprint import HTML; import sys;
HTML(sys.argv[1]).write_pdf(sys.argv[2])' "$html" "$out" || return 2
    return 0
  fi
  log "no HTML engine: install Chromium, or WeasyPrint in a venv"
  log "  (python3 -m venv … && pip install weasyprint; see pdf-output.md)"
  return 1
}

verify_pdf() {
  local pdf=$1
  pdf_is_complete "$pdf" || {
    log "VERIFY FAIL: $pdf is empty or truncated (no %%EOF trailer)"; return 1; }
  local pages=""
  if command -v pdfinfo >/dev/null 2>&1; then
    pages=$(pdfinfo "$pdf" 2>/dev/null | awk '/^Pages:/{print $2}')
    log "pages: ${pages:-unknown}"
  fi
  if command -v pdffonts >/dev/null 2>&1; then
    log "embedded fonts:"
    pdffonts "$pdf" 2>/dev/null | sed -n '1,8p' >&2
    if ! pdffonts "$pdf" 2>/dev/null | tail -n +3 | grep -q 'yes'; then
      log "VERIFY WARN: no embedded font; Persian may render as boxes"
    fi
  fi
  if command -v pdftoppm >/dev/null 2>&1; then
    local out_prefix="${src_dir}/verify-${stem}"
    local last=${pages:-1}
    pdftoppm -png -r 110 -f 1 -l 1 "$pdf" "${out_prefix}-first" 2>/dev/null
    if [[ -n $pages && $pages -gt 1 ]]; then
      pdftoppm -png -r 110 -f "$last" -l "$last" "$pdf" \
        "${out_prefix}-last" 2>/dev/null
    fi
    log "rasterised samples: ${out_prefix}-*.png — look at them, do not"
    log "  judge RTL from pdftotext"
  fi
  return 0
}

rc=0
case "$ext" in
  tex)
    if [[ $engine == chromium || $engine == weasyprint ]]; then
      html="${stem_src}.html"
      [[ -f $html ]] || { log "no $html next to the .tex"; exit 1; }
      html_to_pdf "$html" "$dest"; rc=$?
    else
      compile_tex; rc=$?
      if [[ $rc -eq 2 ]]; then
        log "XeLaTeX is installed but the build failed."
        log "Fix the problem reported above. Not falling back to HTML — a"
        log "  fallback here would hide a real error in the .tex."
        exit 1
      fi
      if [[ $rc -eq 1 ]]; then
        log "xelatex or xepersian not available (see scripts/preflight.sh)"
        html="${stem_src}.html"
        if [[ -f $html ]]; then
          log "falling back to $html"
          html_to_pdf "$html" "$dest"; rc=$?
        else
          log "write the HTML from assets/rtl-document.html and retry:"
          log "  $0 ${src_dir}/${html} ${stem}"
          exit 1
        fi
      fi
    fi
    ;;
  html|htm)
    html_to_pdf "$src_base" "$dest"; rc=$?
    ;;
  *)
    echo "build-pdf.sh: expected .tex or .html, got: $src_base" >&2
    exit 2
    ;;
esac

if [[ $rc -ne 0 ]]; then
  log "build failed"
  exit 1
fi

# Verification that cannot fail the build is decoration. If --verify was
# asked for and it fails, do not print the destination path as though the
# document were usable.
if [[ $verify -eq 1 ]] && ! verify_pdf "$dest"; then
  log "verification failed; this PDF is not usable"
  exit 1
fi

echo "$dest"
