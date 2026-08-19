# Printable PDF output

Cursor chat is **not** the RTL surface. Do not spend effort right-aligning
the conversation. The deliverable is a printable PDF with maximum bidi
precision.

Read this file whenever the output is a paper, article, book, or the
user asks for PDF / چاپ.

## Destination (locked)

Every final PDF is written to:

```text
~/Documents/books/<slug>.pdf
```

Expand `~` to the user's home directory (`$HOME/Documents/books`).

1. `mkdir -p "$HOME/Documents/books"`
2. `<slug>` is a filesystem-safe stem from the source title (ASCII
   kebab-case is fine, e.g. `attention-is-all-you-need`).
3. Copy the finished PDF there. That path is what you report in chat.
4. Re-running the same document may overwrite the same slug. A
   different work needs a different slug. Never leave the only copy
   inside the workspace or `/tmp`.

Working files (`.tex`, copied figures, `.html` fallback) may live in
the workspace. They are not the deliverable.

## Engine order

Use the first that works. Check with `command -v` before compiling.
`scripts/build-pdf.sh` walks this list: XeLaTeX for `.tex`, then Chromium,
then WeasyPrint for `.html` (or a sibling `.html` if `xelatex` is missing).

| Priority | Engine | When |
| --- | --- | --- |
| 1 | XeLaTeX + `xepersian` | Default. Most precise Persian print RTL. |
| 2 | Headless Chromium / Chrome print of the RTL HTML template | If `xelatex` or `xepersian` is missing. |
| 3 | WeasyPrint on the same HTML | If no TeX and no Chrome. |

Do not use pdfLaTeX. Do not use pandoc's default PDF engine without
`xepersian` / `bidi` — mixed Persian/English punctuation will be wrong.

If nothing can produce a PDF, say so and list what to install. Still
write the `.tex` (and figures) so the user can compile later.

## XeLaTeX + xepersian (preferred)

Start from `assets/rtl-document.tex`. Load `hyperref`, `graphicx`, and
`geometry` **before** `xepersian`.

1. Detect a Persian-capable text font:
   `fc-list :lang=fa file family | head`
   Prefer Vazirmatn, then Shabnam, Sahel, Amiri, DejaVu Sans.
2. Latin serif for `\setlatintextfont` and `\setdigitfont` so digits
   stay Western (`TeX Gyre Termes`, `Liberation Serif`, `Times New Roman`,
   `DejaVu Serif`).
3. Monospace for listings (`TeX Gyre Cursor`, `DejaVu Sans Mono`,
   `Liberation Mono`).
4. Substitute those names into the template. Do not ship a PDF whose
   Persian letters are missing-glyph boxes.
5. Copy source images next to the `.tex` (e.g. `figures/`) and include
   them with `\includegraphics`. Same files, order, and aspect as the
   source. Do not mirror.
6. Compile with `scripts/build-pdf.sh path/to/doc.tex <slug>`
   (runs `xelatex` twice, then copies to `~/Documents/books`).
   If `xelatex` is missing, the same script accepts `path/to/doc.html`.

### Bidi mapping

| Role | xepersian |
| --- | --- |
| Persian prose | default (RTL) |
| English term, acronym, citation, URL, number | `\lr{…}` |
| Code listing | `\begin{latin}…\end{latin}` around `verbatim` / `Verbatim` |
| Inline code | `\lr{\texttt{…}}` |
| Math | leave in math mode (LTR) |
| Bibliography | `latin` environment, source language |
| Figure | `\includegraphics`, caption in Persian with `\lr` on terms |

Never wrap a listing in an RTL environment. Never `\includegraphics`
with a horizontal flip.

Western digits: `\setdigitfont` to a Latin font, and `\lr{3}` / `\lr{3.14}`
for numbers that sit inside Persian sentences.

## HTML font (Chromium and WeasyPrint)

The HTML template names Vazirmatn. A family name is not enough: if that
font is not installed, the PDF will show missing-glyph boxes.

1. Detect a Persian-capable font: `fc-list :lang=fa family | head`.
2. If Vazirmatn (or another `fa` face) is not installed, run
   `scripts/fetch-vazirmatn.sh path/to/fonts` next to the HTML file.
   Copy **Regular** and **Bold** only. Never the `UI-FD` / Farsi-digits
   cut — that family draws `۳٫۱۴` and violates the Western-digit lock.
3. Keep the template's `@font-face` `url("fonts/Vazirmatn-Regular.ttf")`
   (and Bold) so Chromium and WeasyPrint embed the files. Relative URLs
   must resolve from the HTML directory; `build-pdf.sh` `cd`s there.
4. Latin fallback for `pre`/`code`: DejaVu Sans Mono or Liberation Mono.

## Chromium fallback

Only when XeLaTeX is unavailable. Fill `assets/rtl-document.html` with
full isolation (see `rtl-bidi.md`), using `file://` URLs or relative
paths that resolve on disk. Prefer:

```bash
scripts/build-pdf.sh path/to/translation.html <slug>
```

Manual equivalent:

```bash
mkdir -p "$HOME/Documents/books"
chromium --headless --disable-gpu --no-pdf-header-footer \
  --print-to-pdf="$HOME/Documents/books/<slug>.pdf" \
  "file://$(realpath translation.html)"
```

Try `chromium`, `chromium-browser`, `google-chrome`, or
`google-chrome-stable`. A4 via CSS `@page { size: A4; margin: 2.2cm; }`
(already in the HTML template when printing).

## WeasyPrint fallback

When there is no XeLaTeX and no Chrome. Same HTML as Chromium. The
script tries `weasyprint`, then `python3 -c "import weasyprint"`.

Needs Pango/Cairo (typical on Debian: `libpango-1.0-0`, `libcairo2`).
Install the Python package in a venv, or with
`pip install --user --break-system-packages weasyprint` if the OS
blocks system-site pip (PEP 668). Do not use sudo.

WeasyPrint reads `@font-face` from disk. Run it with the HTML file's
directory as cwd (the build script does this).

## Chat after success

One short message: what was translated, and the absolute PDF path.
No attempt at chat RTL. Do not paste the article body into chat.
