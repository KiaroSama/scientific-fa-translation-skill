---
name: scientific-fa-translation
description: >
  Translate scientific documents, papers, articles, books, and technical
  docs into academic Persian (Farsi) with strict RTL/bidi and untranslated
  English technical terms. Also reviews an existing Persian translation
  against these rules. Use when the user asks to ترجمه, translate a
  paper/article/book/docs, راست‌چین, RTL, PDF, چاپ, or Persian scientific
  translation.
  Do NOT use for coding, explaining code, commit messages, UI copy,
  literary translation, or casual Persian chat.
---

# Scientific Persian translation

English → academic Persian for papers, articles, books, and technical
documentation. Accuracy, consistent terminology, and print-ready RTL outrank
literary fluency. Cursor chat is not the RTL surface.

## When to use

- Translate a scientific or technical document into Persian.
- Review a finished Persian translation against these rules
  (`references/review.md`).
- User mentions ترجمه علمی, راست‌چین, RTL, PDF, چاپ, paper, article, book.

Not for: writing or explaining code, commit messages, PRs, UI copy, literary
or marketing translation, casual Persian conversation.

## Locked defaults

Override only when the user says so.

| Decision | Default |
| --- | --- |
| Direction | English → فارسی علمی |
| Register | Formal فارسی معیار. No colloquial forms. |
| Terminology | Decision procedure in `references/terminology.md`, level `system-docs` |
| First mention | No gloss for English terms unless the level or glossary says otherwise |
| Output | Printable PDF at `~/Documents/books/<slug>.pdf`. Chat is a short pointer, not RTL. |
| PDF engine | XeLaTeX + `xepersian`; Chromium then WeasyPrint on the HTML template when TeX is absent |
| HTML | Only on request, or as that fallback |
| Digits | Western (`3.14`, not `۳٫۱۴`) |
| Dates | Source calendar and format, one isolate. No Jalali conversion unless asked. |
| Figures/tables | `شکل 3`, `جدول 2` — label translated, number unchanged |
| Images | Same files, order, size, placement. Never mirror, crop, redraw, or drop. |
| Code blocks | Always LTR and left-aligned |
| Abstract/footnotes | Translate |
| Bibliography | Do not translate (authors, titles, journals, DOIs, URLs) |
| Ambiguity | Claim-changing ambiguity blocks and is asked; the rest is queued (`references/long-documents.md`) |

## Workflow

1. **Preflight.** `scripts/preflight.sh` — know which engine and fonts
   exist before promising a build. Confirm source, target, and level.
2. **Ingest.** `references/source-ingest.md`: fetch the source, extract
   figures, write `inventory.md` and `manifest.txt` in the working tree.
   Never translate from memory when a fetch fails.
3. **Terminology first.** Scan domain terms, apply
   `references/terminology.md`, and write `terms.tsv` plus
   `glossary.local.md` **before** drafting. For a long document show the
   close calls to the user first.
4. **Read** `references/scientific-style.md` and `references/rtl-bidi.md`.
   For anything past ~15 pages also `references/long-documents.md`.
5. **Translate** section by section. Do not add, omit, or soften claims;
   preserve hedges (`may`, `might`, `suggest`, `remain unknown`).
6. **Isolate** every LTR run in the print source — whole clusters, one
   isolate each (`references/rtl-bidi.md`).
7. **Lint.** `scripts/check-fa.py doc.tex --domains <pack>` and clear
   every error. Lint each part as you finish it, not at the end.
8. **Build and verify.** `scripts/build-pdf.sh doc.tex <slug> --verify`,
   then look at the rasterised pages. Run the judgement checklist below.

If the user asks for HTML only, use `assets/rtl-document.html`. If they ask
for Markdown, wrap the body in `<div lang="fa" dir="rtl">`, still isolate
LTR spans, and say print RTL will be weaker than PDF. Reverse translation
(FA→EN) only on explicit request; then drop the RTL rules and keep technical
terms in English.

## Terminology in one paragraph

Full policy and the field-term test: `references/terminology.md`. Ordered,
first match wins: generic document chrome (`Abstract`, `Figure`) is always
Persian; named artifacts and acronyms are English; a 2–5 word technical
label is English as **one whole isolate**; a field term of art is English at
`system-docs` level, including its operation verb (`node`, `deployment`,
`configure` — never گره / استقرار / پیکربندی); everything else is Persian.
Never half-translate (`خوشه Kubernetes`, `سرویس‌های OpenStack`), never
attach Persian morphology to a Latin token (`APIها`), and never mix two
forms of one concept in a document. Forbidden calques are enforced from
`references/term-pairs.tsv`.

Example: «در این روش از \en{gradient descent} برای کمینه کردن تابع هزینه
استفاده می‌شود.» — روش / کمینه کردن / استفاده می‌شود Persian, the term
English.

Example: «برای \en{configure} هر \en{node} باید از یک
\en{account with administrative privileges} استفاده کنید.» — not «برای
پیکربندی هر گره».

## Persian mechanics

Full rules: `references/scientific-style.md`. UTF-8; `ک` not `ك`, `ی` not
`ي`; نیم‌فاصله in `می‌شود`, `می‌توان`, `نمی‌کند`, `داده‌ها`; punctuation
`،` `؛` `؟` `«»`; formal verb forms only. All machine-checked.

## RTL

Full rules: `references/rtl-bidi.md`; engines and measured limits:
`references/pdf-output.md`. Chat does not need to be RTL.

On the PDF, non-negotiable: isolate every English term, whole collocation,
number cluster, formula, URL, and inline code with `\lr{…}` (or
`<span dir="ltr">`). Slash-, arrow-, or parenthesis-joined English
(`OP_IF/OP_NOTIF`, `STARTED -> LOCKED_IN`, `1.0.1 (2026-08-09)`) is **one**
isolate — split across two spans it renders reversed on the page. Listings
are LTR and left-aligned. Math stays LTR. Do not mirror images. After a
trailing English insertion the Persian period must belong to the Persian
sentence.

## Output

Default: printable PDF at `~/Documents/books/<slug>.pdf`
(`$HOME/Documents/books`, created if needed). Report that absolute path, the
page count, and the engine used.

1. Read `references/pdf-output.md`. Prefer `assets/rtl-document.tex`.
2. Persian prose in the `.tex`; English runs in `\lr{…}` / `\en{…}`.
3. Listings in `\begin{latin}…\end{latin}`. Captions translated,
   identifiers kept (`Figure 3` → `شکل 3`).
4. `\includegraphics` each copied source image; order, aspect, and
   subfigure layout preserved.
5. Bibliography in a `latin` section, source language. Fill the colophon
   with source, licence, and retrieval date.
6. `scripts/build-pdf.sh path/to/doc.tex <slug> --verify`. Without TeX the
   same script takes the filled-in `assets/rtl-document.html`; embed
   Vazirmatn with `scripts/fetch-vazirmatn.sh` and never the UI-FD cut.

## Quality gate

**Machine-checked** — `scripts/check-fa.py` must exit clean. It covers
orthography (`ک`/`ی`, نیم‌فاصله, Western digits, Persian punctuation),
forbidden calques, half-translated noun phrases, Persian affixes on Latin
tokens, split isolates, un-isolated Latin runs, listing direction, mirrored
artwork, missing images, and terminology drift. Do not re-check these by
hand.

**Judgement** — only these five, and they are the whole point:

- [ ] No added, omitted, or softened scientific claim; hedges intact
- [ ] Terminology consistent with `terms.tsv`, one form per concept
- [ ] Every source figure present, unmirrored, in source order, with a
      translated caption
- [ ] Rasterised pages actually read correctly (periods, parentheses,
      listings, no missing-glyph boxes) — not judged from `pdftotext`
- [ ] Claim-changing ambiguities were asked, not guessed; the rest are
      reported

**Delivery** — final PDF at `~/Documents/books/<slug>.pdf`, chat is a short
pointer with the path, page count, engine, and queued questions.
