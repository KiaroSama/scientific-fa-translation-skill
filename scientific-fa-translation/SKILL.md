---
name: scientific-fa-translation
description: >
  Translate scientific documents, papers, articles, books, and technical
  docs into academic Persian (Farsi) with strict RTL/bidi and untranslated
  English technical terms. Use when the user asks to ترجمه, translate a
  paper/article/book/docs, راست‌چین, RTL, or Persian scientific translation.
  Do NOT use for coding, explaining code, commit messages, UI copy,
  literary translation, or casual Persian chat.
---

# Scientific Persian translation

English → academic Persian for papers, articles, books, and technical
documentation. Accuracy, consistent terminology, and correct RTL/bidi
outrank literary fluency.

## When to use

- Translate a scientific or technical document into Persian.
- User mentions ترجمه علمی, راست‌چین, RTL, paper, article, or book.

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
| Output | UTF-8 HTML file from `assets/rtl-document.html` (`lang="fa"` `dir="rtl"`). |
| Digits | Western (`3.14`, not `۳٫۱۴`). |
| Figures/tables | `شکل 3`, `جدول 2` — label translated, number unchanged. |
| Abstract/footnotes | Translate. |
| Bibliography | Do not translate (authors, titles, journals, DOIs, URLs). |
| Ambiguity | Ask. Do not guess a scientific claim. |

Chat Markdown cannot do precise RTL. Always write a file. A short chat
note that points to the file is enough.

## Workflow

1. Confirm source, target (default EN→FA), and output path. If the user
   pastes text, still write an HTML file named from the source title.
2. Read `references/scientific-style.md` and `references/rtl-bidi.md`
   before drafting.
3. Inventory structure: headings, figures, tables, equations, code,
   footnotes, citations.
4. Scan domain terms. Check `references/glossary.md`. New terms stay
   English; append them to the glossary.
5. Translate section by section. Do not add, omit, or soften claims.
   Preserve hedge language (`may`, `might`, `suggest`, `remain unknown`).
6. RTL pass: isolate every LTR run. See `references/rtl-bidi.md`.
7. Consistency pass: same English term for the same concept throughout.
8. Run the checklist below before finishing.

If the user asks for Markdown, wrap the body in `<div lang="fa" dir="rtl">`
and still isolate LTR spans. If they ask for XeLaTeX/`xepersian`, say so
and keep math LTR. Reverse translation (FA→EN) only on explicit request;
then drop RTL rules and keep technical terms in English.

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
identifiers), and structural headings (`مقدمه`, `روش‌ها`, `نتایج`, `بحث`).

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

Full rules: `references/rtl-bidi.md`. Non-negotiable.

- Root element: `lang="fa"` `dir="rtl"`.
- Start from `assets/rtl-document.html`.
- Isolate every English term, number cluster, formula, URL, and code
  span with `<span dir="ltr">…</span>` or `<bdi>`.
- `pre`, `code`, and math blocks are LTR.
- Do not reverse English letters. Do not hand-flip parentheses; isolate
  the LTR span instead.
- After an English insertion at the end of a Persian sentence, the
  Persian period must belong to that sentence (isolation or RLM).

## Output

1. Copy `assets/rtl-document.html`.
2. Set `<title>` and keep the CSS.
3. Put translation in `<body>`. Headings, lists, and footnotes stay.
4. Translate captions; keep identifiers (`Figure 3` → `شکل 3`).
5. Leave the reference list in the source language, in an LTR section.

## Quality checklist

- [ ] No added, omitted, or softened scientific claims
- [ ] Hedge language preserved
- [ ] Terms match the glossary; no silent Persianization of jargon
- [ ] Citations, equations, numbers, and units unchanged
- [ ] `ک`/`ی` Persian; نیم‌فاصله present; no colloquial forms
- [ ] Every mixed LTR run is isolated; punctuation attaches correctly
- [ ] Bibliography, DOIs, and URLs not translated
- [ ] Deliverable is a `dir="rtl"` file, not chat-only Markdown
