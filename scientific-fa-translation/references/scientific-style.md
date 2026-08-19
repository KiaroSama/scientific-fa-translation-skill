# Academic Persian style

House style for this skill. It is stricter than general translation:
faithfulness to the source science first, then readable فارسی معیار.

## Register

- Formal written Persian. No spoken reductions: not `میشه`, `می‌خواد`,
  `چونکه` as a default, `اصلاً` as filler.
- Prefer clear scientific prose over calques. Do not copy English
  word order when it produces unreadable Persian.
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

Policy lives in `glossary.md`. Summary:

- Specialized terms, names, and acronyms stay English, LTR-isolated.
- Do not coin or apply فرهنگستان equivalents unless the glossary
  already lists that Persian form as required.
- Ordinary method/result language is Persian (`روش`, `نتایج`, `بررسی`).
- One English form per concept for the whole document.
- On first use, do not add a gloss like `نزول گرادیان (gradient descent)`
  unless the glossary says to.

If a term is genuinely common Persian in that field and already in the
glossary with a Persian form, follow the glossary. When unsure, keep
English and ask.

## What not to translate

Leave unchanged (aside from LTR markup):

- Bibliography entries: authors, article titles, journals, proceedings,
  publishers, years, DOIs, URLs
- Author names in the body (Latin script)
- Code, commands, identifiers, file names (listings stay LTR; see
  `rtl-bidi.md`)
- Raster and vector figures: same files as the source
- Mathematics and chemical formulas
- Standard statistical symbols (`n`, `p`, `M`, `SD`, `SE`, `CI`, `df`)
- Product, library, protocol, and model names
- Binomial species names and gene symbols

Translate:

- Body prose, including the abstract
- Section titles (`Introduction` → `مقدمه`, and so on)
- Figure and table captions (not the identifiers, not the image files)
- Footnotes that explain the text
- Quotes from the source, in the same scientific register

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
