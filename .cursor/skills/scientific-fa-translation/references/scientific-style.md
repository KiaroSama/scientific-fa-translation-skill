# Academic Persian style

House style for this skill. It is stricter than general translation:
faithfulness to the source science first, then readable فارسی معیار.

## Register

- Formal written Persian. No spoken reductions: not `میشه`, `می‌خواد`,
  `چونکه` as a default, `اصلاً` as filler.
- Prefer clear scientific prose over sentence-level calques. Do not
  copy English *clause* word order when it produces unreadable Persian.
  Do not “fix” a technical NP by translating it word-by-word either:
  that is a collocation calque and is forbidden (see Terminology).
- Keep the author's epistemic stance. `may` / `might` / `suggest` /
  `appear to` / `remain unknown` must not become certainty.
- Do not add background, examples, or conclusions the source lacks.
- Do not drop hedges, limitations, negative results, or sample-size
  caveats to sound smoother.

## Orthography

- Encoding: UTF-8.
- Persian letters: `ک` not `ك`, `ی` not `ي`. Normalize Arabic forms if
  they appear in a draft.
- نیم‌فاصله (U+200C) where Persian orthography requires it, including
  `می‌شود`, `می‌توان`, `نمی‌کند`, `شده‌اند`, and standard adjectival
  compounds.
- Punctuation: `،` `؛` `؟` `!` `«»`. Use `…` sparingly. Do not use Latin
  `,` `;` `?` or `"` for Persian prose.
- Scientific numbers stay Western digits: `3.14`, `2e-5`, `95%`. Do not
  convert to `۳٫۱۴`.
- Decimal point stays `.` inside numbers. Persian `٫` is not used here.
- SI units stay SI (`km`, `ms`, `°C`). Do not convert unit systems.

## Terminology

Policy lives in `glossary.md`. Named artifacts, **domain terms of
art** (including one-word field nouns), and **atomic multi-word
collocations** stay English. Ordinary scholarly language is Persian.

**Keep English** (LTR-isolated). Do not coin فرهنگستان equivalents.

- Algorithm, library, protocol, and product names
- Acronyms (`API`, `PCR`, `GPU`, `CI`, and the same class)
- Formulas, code, units, statistics (`p`, `n`, `SD`, …)
- People’s names, journal names, DOIs (and bibliography entries)
- Domain terms of art: if the token belongs in that field’s glossary
  or man page, keep English even as one word, and keep the operation
  verb of the same term (`node`, `deployment`, `configure`,
  `implement`, `firewalls`, `encryption`). Never گره / استقرار /
  پیکربندی / پیاده‌سازی for those sources. A Translate row does not
  override this.
- Multi-word technical collocations: a 2–5 word domain label in the
  source is one English unit, including *X of Y* and *Name + common
  noun* (`OpenStack services`, `OpenStack packages`,
  `Kubernetes cluster`, `controller node`). Do not calque. Do not
  half-translate (`خوشه Kubernetes`, `APIهای ترکیب‌پذیر`,
  `سرویس‌های OpenStack`, `بسته‌های OpenStack`,
  `مخزن Ubuntu Cloud archive`). No Persian affixes on English
  tokens. If unsure, keep the whole NP in English.

**Write in Persian.** Do not leave these in English.

- Narrative verbs and sentence structure (پوشش می‌دهد، استفاده کنید)
  — not `configure` / `implement` when those are the field operations
- General words: روش، نتایج، بررسی — only when they are *not* a field
  term of art and *not* inside a keep-English collocation
- Generic IMRAD / book section titles: مقدمه، بحث، … (table below)
- Headings that *are* a product name or technical collocation stay
  English as one isolate (`The OpenStack services`,
  `Conceptual architecture`, `Get started with OpenStack`)
- Conceptual explanation for the reader (the clause around a term)

One English form per named concept for the whole document. On first
use, do not add a gloss like `نزول گرادیان (gradient descent)` unless
the glossary says to. Do not mix `node` and گره.

When unsure whether a token is a term of art, keep it English and add
it to Keep English. Do not default a field noun to Persian.

## What not to translate

Leave unchanged (aside from LTR markup):

- Names of algorithms, libraries, protocols, and products
- Acronyms (`API`, `PCR`, `GPU`, `CI`, …)
- Domain terms of art, including one-word field nouns and their
  operation verbs (`node`, `configure`, `deployment`)
- Multi-word technical collocations (whole NP, one isolate)
- Formulas, code, units, statistical symbols (`p`, `n`, `SD`, …)
- People’s names; journal, conference, and DOI/URL strings
- Bibliography entries: authors, article titles, journals, years
- Raster and vector figures: same files as the source

## What must be Persian

Translate; do not keep the English wording:

- Narrative verbs and clause structure (not field-operation verbs)
- Generic scholarly words (`method` → روش, `results` → نتایج,
  `analysis` / `study` → بررسی) when they are not field terms of art
- Generic section titles (`Introduction` → مقدمه, `Discussion` → بحث، …)
- Conceptual explanation for the reader, including abstract, captions
  (not image files), footnotes, and quotes in the scientific register

Do **not** Persianize a heading that is itself a collocation or named
artifact. `The OpenStack services` stays `The OpenStack services`,
not «سرویس‌های OpenStack». `Install and configure components` stays
English; do not emit «نصب و پیکربندی مؤلفه‌ها».

## Cross-references and labels

| Source | Persian |
| --- | --- |
| Figure 3 | شکل 3 |
| Table 2 | جدول 2 |
| Equation (4) | معادله (4) |
| Section 3.2 | بخش 3.2 |
| Appendix A | پیوست A |
| Theorem / Lemma / Proof | قضیه / لم / اثبات — keep the number LTR |

Do not localize the numeral.

## Images and figures

The translation must *show* the same figures the source shows.

- Copy the original files (PNG, JPEG, SVG, PDF page extract, etc.).
  Point `\includegraphics` or `img src` at those copies. Do not redraw,
  screenshot-replace, or generate a new figure.
- Keep document order: if Figure 3 follows the paragraph that cites
  it, the translation does the same.
- Keep subfigure layout (`a`/`b`/`c`), aspect ratio, and resolution.
  Do not crop, pad, or scale in a way that changes what is visible.
- Do not mirror or rotate for RTL. Plots, UI captures, anatomy, and
  diagrams stay optically identical to the source.
- Labels *inside* the image (axis text, legends baked into a PNG)
  stay as in the source. Do not edit pixels to Persianize them.
- Translate only the caption and any prose that refers to the figure.
- `alt` may be a short Persian description for accessibility; it
  must not replace the image.
- If an image file is missing or unreadable, insert a visible comment
  in the `.tex` or HTML and tell the user. Do not invent a substitute
  figure.

## Citations in the body

Keep citation keys in source form, isolated as LTR:

- `(Smith et al., 2021)` stays `(Smith et al., 2021)`
- `[12]` stays `[12]`
- `DOI` links stay URLs

Do not translate `et al.` Do not convert Harvard to Vancouver or the
reverse.

## Headings (typical article)

Use these **only** for generic IMRAD / book labels. If the source
heading is a domain NP (`Host networking`, `Conceptual architecture`,
`The OpenStack services`), keep it English in one isolate.

Use these unless the source uses a different scheme; then stay parallel.

| English | Persian |
| --- | --- |
| Abstract | چکیده |
| Introduction | مقدمه |
| Related work | کارهای مرتبط |
| Methods / Materials and methods | روش‌ها / مواد و روش‌ها |
| Results | نتایج |
| Discussion | بحث |
| Conclusion | نتیجه‌گیری |
| Acknowledgments | سپاسگزاری |
| References / Bibliography | منابع |
| Appendix | پیوست |

## Ambiguity

If a pronoun, scope of negation, or technical reading would change the
science, stop and ask. Do not pick the “more fluent” reading.

If the source is truncated, OCR-garbled, or a formula is unreadable,
leave a short HTML comment at that spot and tell the user. Do not
invent the missing science.
