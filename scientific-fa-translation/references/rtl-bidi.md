# RTL and bidirectional isolation

Precise right-to-left layout is not `text-align: right`. Persian is RTL;
English terms, digits, math, and URLs are LTR. The Unicode Bidirectional
Algorithm will misplace punctuation and parentheses unless every LTR run
is isolated.

This skill writes HTML (`lang="fa"` `dir="rtl"`). Do not rely on Cursor
chat Markdown for the deliverable.

## Document root

Use `assets/rtl-document.html`. The root must be:

```html
<html lang="fa" dir="rtl">
```

CSS on that template:

- `body`: `direction: rtl; unicode-bidi: isolate;`
- `.ltr`, `pre`, `code`, `kbd`, `samp`, `math`: `direction: ltr; unicode-bidi: isolate;`

Do not set `dir="rtl"` on `pre` or `code`.

## Isolate every LTR run

Wrap each English term, acronym, number cluster, citation key, formula,
URL, file path, and inline code:

```html
<span dir="ltr">gradient descent</span>
<span dir="ltr">Adam (Kingma &amp; Ba, 2015)</span>
<span dir="ltr">p &lt; 0.05</span>
<span dir="ltr">https://doi.org/10.0000/example</span>
```

`<bdi>` is acceptable when the span is a single proper name. Prefer
`<span dir="ltr">` for anything with parentheses, punctuation, or digits.

A whole English bibliography, code listing, or equation block gets
`dir="ltr"` on the container, not on every token.

## Wrong vs right

Parentheses and the sentence period are the usual failures.

```html
<!-- Wrong: parens and the period attach to the English run -->
الگوریتم Adam (Kingma &amp; Ba, 2015) استفاده شد.

<!-- Right -->
الگوریتم <span dir="ltr">Adam (Kingma &amp; Ba, 2015)</span> استفاده شد.
```

```html
<!-- Wrong: trailing English steals the Persian period -->
نتایج با RMSE بهتر شد.

<!-- Right -->
نتایج با <span dir="ltr">RMSE</span> بهتر شد.
```

If a sentence *ends* on an LTR span and the period still renders on the
wrong side after isolation, append an RLM (U+200F) immediately after the
closing `</span>` and before `.`:

```html
این روش بر پایه <span dir="ltr">backpropagation</span>‏.
```

Do not scatter RLM/LRM through the file as decoration. Isolation first;
RLM only for a leftover end-of-sentence period.

## What must stay LTR

| Content | How |
| --- | --- |
| Technical English terms | `<span dir="ltr">` |
| Western digits and numeric ranges | `<span dir="ltr">3.14</span>`, `<span dir="ltr">2017–2024</span>` |
| Display/inline math | `dir="ltr"` on the math container; keep LaTeX source unchanged |
| Fenced code / `pre` | `dir="ltr"` (template already does this) |
| URLs, DOIs, emails | `<span dir="ltr">` or `<a dir="ltr">` |
| File paths and identifiers | `<span dir="ltr">` |
| Reference list | a `dir="ltr"` section |

## Headings, lists, tables, figures

- Headings are RTL prose. Isolate LTR fragments inside them the same way.
- Lists inherit RTL from `body`. Isolate LTR items or fragments per item.
- Table captions are RTL (`جدول 2. …`). Isolate the number: `جدول <span dir="ltr">2</span>.`
- Numeric table cells are LTR. Persian prose cells stay RTL.
- Do not reverse column order unless the user asks.
- Figure captions: `شکل <span dir="ltr">3</span>. …` Isolate any English
  term inside the caption.

## Markdown fallback

Only when the user demands Markdown:

```html
<div lang="fa" dir="rtl">

متن فارسی با <span dir="ltr">transformer</span>.

</div>
```

GitHub-flavored Markdown will still break some bidi cases. Say so, and
prefer HTML.

Never reverse English letter order by hand. Never rewrite `(Adam)` as
`)Adam(` to “fix” RTL.

## Self-check

1. Open the HTML file, not the chat transcript.
2. Scan every English island: parentheses enclose the English, not the
   Persian.
3. Sentence-final periods sit at the right edge of the Persian sentence.
4. Code and math blocks read left-to-right.
5. No `ك` / `ي` introduced while editing markup.
