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
| Technical terms | Named artifacts stay English. Multi-word technical collocations stay English as one unit. General scholarly language is Persian. |
| First mention | Named English terms: English only, no gloss, unless `references/glossary.md` says so. |
| Output | Printable PDF at `~/Documents/books/<slug>.pdf`. Chat is a short pointer, not RTL. |
| PDF RTL | Maximum precision via XeLaTeX + `xepersian`. See `references/pdf-output.md`. |
| HTML | Only if the user asks for HTML, or as the Chromium / WeasyPrint fallback. |
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
4. Scan domain terms. Check `references/glossary.md`. New *names* and
   new multi-word technical collocations stay English (whole NP);
   new general words get a Persian row. Append both.
5. Translate section by section. Do not add, omit, or soften claims.
   Preserve hedge language (`may`, `might`, `suggest`, `remain unknown`).
6. RTL pass on the print source (`.tex` with `\lr` / `latin`, or HTML
   isolation if falling back). See `references/rtl-bidi.md`.
7. Consistency pass: same English term for the same concept throughout.
8. Compile the PDF to `~/Documents/books/<slug>.pdf` with
   `scripts/build-pdf.sh` (`.tex` or `.html`). Run the checklist.

If the user asks for HTML only, use `assets/rtl-document.html`. If they
ask for Markdown, wrap the body in `<div lang="fa" dir="rtl">` and still
isolate LTR spans; say that print RTL will be weaker than PDF. Reverse
translation (FA→EN) only on explicit request; then drop RTL rules and
keep technical terms in English.

## Keep English vs write Persian

House split. Full lists: `references/glossary.md`.

**Keep English** (LTR isolate: `\lr` / `<span dir="ltr">`). Do not
Persianize. Do not invent فرهنگستان equivalents.

- Names of algorithms, libraries, protocols, and products
- Acronyms: `API`, `PCR`, `GPU`, `CI`, and others of that kind
- Formulas, code, units, and statistics (`p`, `n`, `SD`, …)
- People’s names, journal names, and DOIs
  (also conference names, URLs, and bibliography titles)
- **Multi-word technical collocations (atomic).** A 2–5 word domain
  label in the source is one English unit. Possessive of, *X of Y*,
  and *Adjective + Name* are still one NP (`OpenStack services`,
  `Ubuntu Cloud archive repository`, `controller node`). Do not
  calque. Do not half-translate. If unsure whether it is a term of
  art or ordinary prose, keep the **whole NP** in English and add it
  to the glossary.

  Isolate the entire phrase in one `\lr{…}` / `\en{…}`. Do not attach
  Persian morphology (`APIها`, `Goی`). Do not wrap an English name
  with a Persian head noun (`خوشه …`, `بسته‌های …`, `سرویس‌های …`,
  `مخزن …`, `گره‌های …`).

  Forbidden: `apiهای ترکیب‌پذیر`, `خوشه Kubernetes`, `بسته‌های Go`,
  `بسته‌های OpenStack`, `سرویس‌های OpenStack`,
  `مخزن Ubuntu Cloud archive`, `گره‌های دیگر` when the source is
  `Other nodes`, `استقرار و پیکربندی` when the source is
  `deployment and configuration`, `نصب و پیکربندی مؤلفه‌ها` when
  the source is `Install and configure components`.
  Required: `composable APIs`, `Kubernetes cluster`,
  `reusable Go packages`, `OpenStack packages`, `OpenStack services`,
  `Ubuntu Cloud archive repository`, `Other nodes`,
  `deployment and configuration`, `Install and configure components`.

**Write in Persian.** Translate these out of English. Never leave the
English word in the Persian sentence.

- Verbs and sentence structure
- General scholarly words: روش، نتایج، بررسی (also مقدمه-level
  vocabulary: مقاله، روش‌ها، بحث، …) — only when they are *not*
  inside a keep-English collocation
- Generic IMRAD / book headings in the table in
  `references/scientific-style.md` (مقدمه، بحث، چکیده، …)
- Conceptual explanation for the reader: the surrounding *clause* that
  *says what a term means* is Persian. The term itself — including a
  multi-word collocation — stays English. A glossary Translate row for
  a single word does **not** split a collocation that contains it.

**Headings.** Generic article headings (`Abstract`, `Introduction`)
are Persian. If the source heading *is* a named artifact or a
technical collocation (`The OpenStack services`,
`Conceptual architecture`, `Get started with OpenStack`,
`Host networking`), keep the **entire heading** English in one
isolate. Do not Persianize the generic word and leave the name
(`سرویس‌های OpenStack`).

Example: «در این روش از \en{gradient descent} برای کمینه کردن تابع
هزینه استفاده می‌شود.» — روش / کمینه کردن / استفاده می‌شود are
Persian; `gradient descent` stays English.

Example: «\en{GitOps Toolkit} مجموعه‌ای از \en{composable APIs} و
\en{reusable Go packages} است.» — not «APIهای ترکیب‌پذیر».

Example: «\en{OpenStack} از طریق مجموعه‌ای از سرویس‌های مرتبط یک
راه‌حل \en{Infrastructure-as-a-Service (IaaS)} فراهم می‌کند.» Then
name the set as \en{OpenStack services}, not «سرویس‌های OpenStack».

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
- Isolate every English term, **whole technical collocation**, number
  cluster, formula, URL, and inline code with `\lr{…}` (or
  `<span dir="ltr">` on the HTML fallback).
  Slash-, arrow-, or parenthesis-joined English (`OP_IF/OP_NOTIF`,
  `STARTED -> LOCKED_IN`, `1.0.1 (2026-08-09)`) is **one** isolate, not
  two spans with punctuation between them.
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
   If `xelatex` is missing, still write the `.tex`, then compile
   `assets/rtl-document.html` (filled in) with the same script:
   `scripts/build-pdf.sh path/to/doc.html <slug>`.
   Embed Vazirmatn via `@font-face` (`scripts/fetch-vazirmatn.sh`).
   Do not use the UI-FD / Farsi-digits cut of that family.

HTML (`assets/rtl-document.html`) is only for an explicit HTML ask or
the Chromium / WeasyPrint fallback in `references/pdf-output.md`.

## Quality checklist

- [ ] No added, omitted, or softened scientific claims
- [ ] Hedge language preserved
- [ ] Names/acronyms/formulas/units/stats/people/journals/DOIs stay English
- [ ] Multi-word technical collocations are one English isolate; no calque or half-translation
- [ ] No Persian head + English name (`خوشه Kubernetes`, `سرویس‌های OpenStack`, `بسته‌های OpenStack`, `مخزن …`)
- [ ] Domain headings that are collocations/names stay entirely English; only generic IMRAD headings are Persian
- [ ] Verbs, general words, and conceptual explanations are Persian
- [ ] Citations, equations, numbers, and units unchanged
- [ ] `ک`/`ی` Persian; نیم‌فاصله present; no colloquial forms
- [ ] Every mixed LTR run is isolated (`\lr` / `dir="ltr"`); punctuation attaches correctly
- [ ] Joined English (`a/b`, `a -> b`, `1.0.1 (2026-08-09)`) is a single isolate
- [ ] HTML-engine PDFs embed a real `fa` font (not missing-glyph boxes); digits stay Western
- [ ] Every code block is LTR, left-aligned, source text unchanged
- [ ] Every source image is present, unmirrored, in the same place
- [ ] Bibliography, DOIs, and URLs not translated
- [ ] Chat is a short pointer, not an RTL article
- [ ] Final PDF exists at `~/Documents/books/<slug>.pdf`
