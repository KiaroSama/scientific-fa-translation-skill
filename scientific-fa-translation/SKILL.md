---
name: scientific-fa-translation
description: >
  Translate scientific documents, papers, articles, books, and technical
  docs into academic Persian (Farsi) with strict RTL/bidi and untranslated
  English technical terms. Use when the user asks to ترجمه, translate a
  paper/article/book/docs, راست‌چین, RTL, PDF, چاپ, or Persian scientific
  translation.
  Do NOT use for coding, explaining code, commit messages, UI copy,
  literary translation, or casual Persian chat.
---

# Scientific Persian translation

English → academic Persian for papers, articles, books, and technical
documentation. Accuracy, consistent terminology, and print-ready RTL
outrank literary fluency. Cursor chat is not the RTL surface.

## When to use

- Translate a scientific or technical document into Persian.
- User mentions ترجمه علمی, راست‌چین, RTL, PDF, چاپ, paper, article, or book.

## When not to use

- Writing, explaining, or reviewing code.
- Commit messages, PRs, UI copy, literary or marketing translation.
- Casual Persian conversation that is not a translation request.

## Locked defaults

Override only when the user says so.

| Decision | Default |
| --- | --- |
| Direction | English → فارسی علمی |
| Register | Formal فارسی معیار. No colloquial forms. |
| Technical terms | Keep English. Do not invent فرهنگستان equivalents. |
| First mention | English only. No Persian gloss unless `references/glossary.md` says so. |
| Output | Printable PDF at `~/Documents/books/<slug>.pdf`. Chat is a short pointer, not RTL. |
| PDF RTL | Maximum precision via XeLaTeX + `xepersian`. See `references/pdf-output.md`. |
| HTML | Only if the user asks for HTML, or as the Chromium-print fallback. |
| Digits | Western (`3.14`, not `۳٫۱۴`). |
| Figures/tables | `شکل 3`, `جدول 2` — label translated, number unchanged. |
| Images | Same files, order, size, and placement as the source. Do not mirror, crop, redraw, or drop. |
| Code blocks | Always LTR and left-aligned. Never RTL, never `text-align: right`. |
| Abstract/footnotes | Translate. |
| Bibliography | Do not translate (authors, titles, journals, DOIs, URLs). |
| Ambiguity | Ask. Do not guess a scientific claim. |

Chat is a short status note plus the PDF path. Do not right-align the
conversation and do not paste the article into chat.

## Workflow

1. Confirm source and target (default EN→FA). Default deliverable is a
   PDF. Read `references/pdf-output.md` before compiling.
2. Read `references/scientific-style.md` and `references/rtl-bidi.md`
   before drafting.
3. Inventory structure: headings, figures, tables, equations, code,
   footnotes, citations. Copy every source image into the working
   tree (`figures/` next to the `.tex`) and keep the same sequence
   relative to the surrounding text.
4. Scan domain terms. Check `references/glossary.md`. New terms stay
   English; append them to the glossary.
5. Translate section by section. Do not add, omit, or soften claims.
   Preserve hedge language (`may`, `might`, `suggest`, `remain unknown`).
6. RTL pass on the print source (`.tex` with `\lr` / `latin`, or HTML
   isolation if falling back). See `references/rtl-bidi.md`.
7. Consistency pass: same English term for the same concept throughout.
8. Compile the PDF to `~/Documents/books/<slug>.pdf`. Run the checklist.

If the user asks for HTML only, use `assets/rtl-document.html`. If they
ask for Markdown, wrap the body in `<div lang="fa" dir="rtl">` and still
isolate LTR spans; say that print RTL will be weaker than PDF. Reverse
translation (FA→EN) only on explicit request; then drop RTL rules and
keep technical terms in English.

## What stays English

Leave these in an LTR isolate. Do not Persianize them.

- Algorithm, library, protocol, product, and model names
- Acronyms (`API`, `PCR`, `GPU`, `CI`, `RMSE`)
- Code, commands, file paths, identifiers
- LaTeX/math, chemical formulas, gene names, binomial species names
- Units and statistics (`p`, `n`, `M`, `SD`, `CI`, SI units)
- Author names, journal and conference names, DOIs, URLs
- Paper titles inside the reference list

Translate ordinary prose: methods, results, discussion, captions (except
identifiers and the image files themselves), and structural headings
(`مقدمه`, `روش‌ها`, `نتایج`, `بحث`).

Do not translate filler words into English. `paper` → مقاله, `method` →
روش, `result` → نتیجه — unless the glossary marks that token as a proper
name.

## Persian mechanics

Full rules: `references/scientific-style.md`.

- UTF-8. Persian letters only: `ک` not `ك`, `ی` not `ي`.
- نیم‌فاصله (U+200C) in `می‌شود`, `می‌توان`, `نمی‌کند`, and standard
  compounds.
- Punctuation: `،` `؛` `؟` `«»`. Not Latin `,` `;` `?` `""`.
- Formal verb forms only (`می‌شود` not `میشه`).

## RTL

Full rules: `references/rtl-bidi.md`. For PDF: `references/pdf-output.md`.

Chat does not need to be RTL.

On the **PDF** (non-negotiable when producing a printable file):

- Prefer XeLaTeX + `xepersian` from `assets/rtl-document.tex`.
- Isolate every English term, number cluster, formula, URL, and inline
  code with `\lr{…}` (or `<span dir="ltr">` on the HTML fallback).
- Code listings are LTR and left-aligned: `latin` + `verbatim` /
  `Verbatim`, or `<pre dir="ltr">`. Never RTL, never right-aligned.
- Math stays LTR. Do not reverse English letters or hand-flip
  parentheses.
- Do not mirror images. `\includegraphics` / `<img>` the source files.
- After an English insertion at the end of a Persian sentence, the
  Persian period must belong to that sentence (`\lr` isolation or RLM).

## Output

Default: printable PDF. Always save the final file at
`~/Documents/books/<slug>.pdf` (`$HOME/Documents/books`). Create the
directory if needed. Report that absolute path in chat.

1. Read `references/pdf-output.md`. Prefer `assets/rtl-document.tex`.
2. Put Persian prose in the `.tex`. Wrap English runs with `\lr{…}`
   or `\en{…}`.
3. Listings in `\begin{latin}…\end{latin}`. Captions translated;
   identifiers kept (`Figure 3` → `شکل 3`).
4. `\includegraphics` each source image (copied into `figures/`).
   Preserve order, aspect ratio, and subfigure layout. Do not
   regenerate or flip artwork.
5. Bibliography in a `latin` section, source language.
6. `scripts/build-pdf.sh path/to/doc.tex <slug>`
   → `$HOME/Documents/books/<slug>.pdf`.

HTML (`assets/rtl-document.html`) is only for an explicit HTML ask or
the Chromium-print fallback in `references/pdf-output.md`.

## Quality checklist

- [ ] No added, omitted, or softened scientific claims
- [ ] Hedge language preserved
- [ ] Terms match the glossary; no silent Persianization of jargon
- [ ] Citations, equations, numbers, and units unchanged
- [ ] `ک`/`ی` Persian; نیم‌فاصله present; no colloquial forms
- [ ] Every mixed LTR run is isolated (`\lr` / `dir="ltr"`); punctuation attaches correctly
- [ ] Every code block is LTR, left-aligned, source text unchanged
- [ ] Every source image is present, unmirrored, in the same place
- [ ] Bibliography, DOIs, and URLs not translated
- [ ] Chat is a short pointer, not an RTL article
- [ ] Final PDF exists at `~/Documents/books/<slug>.pdf`
