# Academic Persian style

Register, orthography, and document mechanics. Terminology is not decided
here — `terminology.md` owns the keep-English split, and bidi is
`rtl-bidi.md`.

## Register

- Formal written Persian. No spoken reductions: not `میشه`, `می‌خواد`,
  `چونکه` as a default, `اصلاً` as filler.
- Prefer clear scientific prose over sentence-level calques. Do not copy
  English *clause* order when it produces unreadable Persian.
- Keep the author's epistemic stance. `may` / `might` / `suggest` /
  `appear to` / `remain unknown` must not become certainty.
- Do not add background, examples, or conclusions the source lacks.
- Do not drop hedges, limitations, negative results, or sample-size
  caveats to sound smoother.

## Common EN→FA failures

Faithfulness is the first rule, but these five patterns produce prose that
is technically accurate and still unreadable.

1. **English passive kept as Persian passive.** `The model was trained on…`
   → «مدل روی … آموزش داده شد» is fine; a chain of three passives in one
   sentence is not. Recast the middle one as active when the agent of the
   sentence is obvious.
2. **Ezafe chains.** More than three linked اضافه constructions
   («بررسی نتایج ارزیابی کارایی سیستم») force the reader to re-parse.
   Break the chain with a verb or a preposition.
3. **Over-nominalisation.** English science nominalises freely; Persian
   reads better with the verb restored. `perform an evaluation of` →
   «ارزیابی می‌کنیم», not «انجام یک ارزیابی از».
4. **Bidi-heavy sentences.** With this skill's terminology policy a
   sentence can end up more English than Persian. Never *start* a Persian
   sentence with an LTR isolate — put a Persian subject or preposition
   first, because a line that begins left-to-right reads as a layout bug
   in print. If more than about half a sentence is isolates, split it.
5. **First person.** Keep the source's stance: `we trained` → «آموزش
   دادیم», `it is assumed` → «فرض می‌شود». Do not promote an impersonal
   source to first person or the reverse.

## Orthography

- Encoding UTF-8.
- Persian letters: `ک` not `ك`, `ی` not `ي`. Normalise Arabic forms that
  appear in a draft.
- نیم‌فاصله (U+200C) where Persian orthography requires it: `می‌شود`,
  `می‌توان`, `نمی‌کند`, `شده‌اند`, plural `داده‌ها`, and standard
  adjectival compounds.
- Punctuation `،` `؛` `؟` `!` `«»`. Not Latin `,` `;` `?` `"` in Persian
  prose. `…` sparingly.
- Scientific numbers stay Western: `3.14`, `2e-5`, `95%`. Never `۳٫۱۴`.
- Decimal point stays `.`; Persian `٫` is not used.
- SI units stay SI (`km`, `ms`, `°C`). Do not convert unit systems.

`scripts/check-fa.py` fails the build on the letters, ZWNJ verbs and
plurals, Latin comma/semicolon/question mark, Eastern digits, and Arabic
decimal separators in this section. SI unit conversion, hedges, and
register are judgement — `review.md`.

## Dates and numerals

- Dates stay in the source calendar and format: `2026-08-09` remains
  `2026-08-09`, isolated as one LTR run. Do not convert to Jalali unless
  the user asks; if they do, add the Gregorian in parentheses inside the
  same isolate on first mention.
- Version strings, RFC numbers, and port numbers are identifiers, not
  quantities. Never reformat them.
- Ranges keep the source dash and are one isolate: `2017–2024`,
  `300-400`.
- Percentages keep the Latin sign: `55%`.

## Cross-references and labels

| Source | Persian |
| --- | --- |
| Figure 3 | شکل 3 |
| Table 2 | جدول 2 |
| Equation (4) | معادله (4) |
| Section 3.2 | بخش 3.2 |
| Appendix A | پیوست A |
| Theorem / Lemma / Proof | قضیه / لم / اثبات |

Do not localise the numeral, and keep it in an LTR isolate. Prefer real
`\ref` / `\label` over typed numbers when the translation renumbers
anything; a hand-typed number silently rots.

## Headings

Generic labels take the Persian in `glossary.md`. A heading that *is* a
named artifact or a technical label stays English in one isolate — `The
OpenStack serviceها`, `Conceptual architecture`, `Host networking`, `Get
started with OpenStack`. Do not Persianise the generic word and leave the
name behind.

## Figures

The translation must *show* the same figures the source shows.

- Copy the original files (PNG, JPEG, SVG, extracted PDF page). Point
  `\includegraphics` or `img src` at those copies. Do not redraw,
  screenshot-replace, or generate a substitute.
- Run `scripts/prepare-figures.py figures/ --check` after ingest. Flatten
  PNG alpha onto white. If a file is a near-black dump, compare it with a
  `pdftoppm` of the source page; invert only when that page is light
  (`--invert-dark`).
- HTML: `dir="ltr"` on every `<img>`. XeLaTeX: `\includegraphics` inside
  `LTR`. The checker fails without those.
- Keep document order, subfigure layout (`a`/`b`/`c`), aspect ratio, and
  resolution. Do not crop or pad in a way that changes what is visible.
- Never mirror or rotate for RTL.
- Text baked into the image stays as in the source. Do not edit pixels to
  Persianise axis labels or legends.
- Translate the caption and the prose that refers to the figure.
- `alt` may be a short Persian description; it must not replace the image.
- If a file is missing or unreadable, leave a visible comment at that spot
  and tell the user. Do not invent a figure. The checker fails on an
  `\includegraphics` target that is not on disk.

## Tables

- Persian prose cells are RTL; numeric cells are LTR and left-aligned.
- Do not reverse column order unless the user asks.
- A table that runs past one page needs `longtable` with a repeated
  header, not a manually split table. Real documents (port lists,
  requirement matrices) hit this constantly.
- A caption that is a technical label stays English whole; only the
  `جدول N.` prefix is Persian.

## Footnotes, quotes, and links

- Footnote markers follow the Persian text direction; the note body
  follows its own content. An English-only note stays in a `latin`
  environment.
- Quote Persian prose with `«»`. An English title inside Persian prose
  keeps its own quoting from the source and sits in one isolate.
- URLs are isolates and must be allowed to break, or they overflow the
  page silently: `\url` plus `xurl` in TeX, `overflow-wrap: break-word` in
  CSS. Note `word-break: break-word` is not a valid CSS value and
  WeasyPrint drops it.
- A long URL broken mid-string inside a Persian paragraph is legible but
  reads badly — the `https://` fragment ends up alone at the far end of
  the previous line. Prefer giving a long URL its own block-level line, a
  footnote, or the bibliography, rather than burying it in running RTL
  prose.

## Citations

Keep citation keys in source form, isolated as LTR: `(Smith et al., 2021)`,
`[12]`, DOI links. Do not translate `et al.`, and do not convert Harvard to
Vancouver or the reverse.

Bibliography entries are not translated: authors, titles, journals, years,
publishers, DOIs, URLs.

## Ambiguity

If a pronoun, the scope of a negation, or a technical reading would change
the science, stop and ask. Do not pick the more fluent reading.

For a document long enough that stopping forty times is impractical, use
the queue in `long-documents.md`: a claim-changing ambiguity blocks, and
everything else is recorded and reported once at the end.

If the source is truncated, OCR-garbled, or a formula is unreadable, leave a
comment at that spot and tell the user. Do not invent the missing science.
