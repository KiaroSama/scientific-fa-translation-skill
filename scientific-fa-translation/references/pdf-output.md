# Printable PDF output

Cursor chat is **not** the RTL surface. Do not spend effort right-aligning
the conversation. The deliverable is a printable PDF with maximum bidi
precision.

Read this file whenever the output is a paper, article, book, or the user
asks for PDF / چاپ.

## Destination (locked)

```text
~/Documents/books/<slug>.pdf
```

Expand `~` to `$HOME/Documents/books`, create it if needed. `<slug>` is a
filesystem-safe stem from the source title (`attention-is-all-you-need`).
Re-running the same document overwrites the same slug; a different work gets
a different slug. Never leave the only copy in the workspace or `/tmp`.
Working files live in the tree described in `source-ingest.md`.

## Preflight

Run this **first**, before choosing an approach:

```bash
scripts/preflight.sh
```

It reports which engines and fonts actually exist and prints the install
command for what is missing. Do not plan a XeLaTeX build on a machine
without XeLaTeX and then discover it at compile time — decide up front, and
tell the user which engine will be used and what that costs.

## Engine order

| Priority | Engine | When |
| --- | --- | --- |
| 1 | XeLaTeX + `xepersian` | best Persian print RTL; needs a TeX install |
| 2 | Headless Chromium print of the RTL HTML | no TeX; full CSS bidi support |
| 3 | WeasyPrint on the same HTML | no TeX and no Chrome |

Do not use pdfLaTeX. Do not use pandoc's default PDF engine without
`xepersian` / `bidi`.

Debian/Ubuntu install for the preferred path:

```bash
sudo apt install texlive-xetex texlive-lang-arabic texlive-fonts-recommended
```

If nothing can produce a PDF, say so, list what to install, and still write
the `.tex` and figures so the user can compile later.

## XeLaTeX + xepersian

Start from `assets/rtl-document.tex`. Load `graphicx`, `hyperref`, and
`geometry` **before** `xepersian`. The template resolves fonts itself with
`\IfFontExistsTF`, so there is nothing to hand-edit — but confirm the chosen
face covers Persian:

```bash
fc-list :lang=fa family | sort -u
```

Prefer Vazirmatn, then Shabnam, Sahel, Amiri, DejaVu Sans. Latin serif for
`\setlatintextfont` and `\setdigitfont` so digits stay Western; a monospace
face for listings.

### Bidi mapping

| Role | xepersian |
| --- | --- |
| Persian prose | default (RTL) |
| English term, acronym, citation, URL, number | `\lr{…}` / `\en{…}` |
| Code listing | `\begin{latin}…\end{latin}` around `Verbatim` |
| Inline code | `\lr{\texttt{…}}` |
| Math | math mode (LTR) |
| Bibliography | `latin` environment, source language |
| Figure | `\includegraphics`, Persian caption with `\en` on terms |

Numbers inside Persian sentences get `\lr{3}` / `\lr{3.14}` even with a
Latin `\setdigitfont`; the wrap is what makes the result independent of the
digit-font setting. Verify once per document with the digit smoke test
below rather than trusting the setting.

Two traps the template already handles, worth knowing why:

- `\lr` inside `\section` or `\caption` reaches `hyperref` bookmarks and
  breaks them. The template disables it there with
  `\pdfstringdefDisableCommands`. The checker warns if that guard is
  missing.
- A table that runs past one page needs `longtable`, not a hand-split
  `tabular`. Port lists and requirement matrices always hit this.

## HTML engines: measured behaviour

The HTML path is not a poor relation — on a machine without TeX it is the
path — but it has one hard limit worth knowing before writing a 174-page
document. WeasyPrint 69 does not implement `unicode-bidi: isolate` and says
so on every run:

```text
WARNING: Ignored `unicode-bidi: isolate`, property not supported yet.
```

What that means in practice, measured on rendered output rather than assumed:

- A `dir="ltr"` **attribute** still creates a bidi embedding, and that is
  what actually places English runs correctly. Keep the attribute on every
  isolate; keep the CSS property too, for Chromium and browsers.
- Ordinary cases — `Adam (Kingma & Ba, 2015)`, a trailing `RMSE` before the
  sentence period, `STARTED -> LOCKED_IN` inside one span — render
  correctly even without the property, because the base direction plus the
  Unicode algorithm resolve them.
- The case that genuinely breaks is a cluster split across two spans:
  `<span dir="ltr">OP_IF</span>/<span dir="ltr">OP_NOTIF</span>` renders as
  `OP_NOTIF/OP_IF`. One span around `OP_IF/OP_NOTIF` renders correctly.

So on the HTML path the whole-cluster rule in `rtl-bidi.md` is not a style
preference, it is the difference between right and wrong output. The
checker's `split-isolate` rule exists for this, and Chromium is preferred
over WeasyPrint when both are present.

Surface WeasyPrint's warnings instead of discarding them; `build-pdf.sh`
keeps them.

## HTML font

The template names Vazirmatn. A family name is not enough — without the font
the PDF shows missing-glyph boxes.

1. `fc-list :lang=fa family | head`
2. If no `fa` face is installed: `scripts/fetch-vazirmatn.sh path/to/fonts`
   next to the HTML. Regular and Bold only. Never the `UI-FD` /
   Farsi-digits cut, which draws `۳٫۱۴` and violates the Western-digit
   lock.
3. Keep the template's `@font-face` `url("fonts/Vazirmatn-Regular.ttf")` so
   both engines embed the files. Relative URLs resolve from the HTML
   directory; `build-pdf.sh` `cd`s there.
4. Latin fallback for `pre`/`code`: DejaVu Sans Mono or Liberation Mono.

## Chromium

```bash
scripts/build-pdf.sh path/to/translation.html <slug>
```

Manual equivalent, with the flag that matters — without a virtual-time
budget Chromium can print before webfonts finish loading:

```bash
mkdir -p "$HOME/Documents/books"
chromium --headless --disable-gpu --no-pdf-header-footer \
  --virtual-time-budget=10000 \
  --print-to-pdf="$HOME/Documents/books/<slug>.pdf" \
  "file://$(realpath translation.html)"
```

Try `chromium`, `chromium-browser`, `google-chrome`, `google-chrome-stable`.
A4 comes from the template's `@page`.

## WeasyPrint

Needs Pango/Cairo (Debian: `libpango-1.0-0`, `libcairo2`). Install in a venv,
or `pip install --user --break-system-packages weasyprint` when the OS blocks
system pip (PEP 668). Do not use sudo. It reads `@font-face` from disk, so it
must run with the HTML file's directory as cwd — the build script does this.

## Verify the artifact

A PDF that exists is not a PDF that is correct. `build-pdf.sh --verify` runs
all of this; do it every time.

```bash
pdfinfo out.pdf | grep -E 'Pages|Page size'
pdffonts out.pdf | head                    # a real fa face, no fallback
pdftoppm -png -r 110 -f 1 -l 2 out.pdf /tmp/check-p
```

Then **look at the PNG**. Do not treat `pdftotext` as visual truth on an RTL
PDF; it reorders. What to look for is in `review.md`.

Digit smoke test, once per document: put `3.14` in a Persian sentence, build,
rasterise, and confirm the glyphs are `3.14` and not `۳٫۱۴`.

## Chat after success

One short message: what was translated, the absolute PDF path, the page
count, the engine used, and any queued ambiguities. No chat RTL. Do not
paste the article body into chat.
