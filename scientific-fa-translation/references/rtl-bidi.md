# RTL and bidirectional isolation

Precise right-to-left layout is not `text-align: right`. Persian is RTL;
English terms, digits, math, and URLs are LTR. The Unicode Bidirectional
Algorithm will misplace punctuation and parentheses unless every LTR run
is isolated.

**Cursor chat is not the RTL surface.** Do not right-align the
conversation. For papers, articles, and books the deliverable is a
PDF (`references/pdf-output.md`) with maximum bidi precision.

When the print engine is XeLaTeX, isolate with `\lr{…}` / `\en{…}` and
put listings in a `latin` environment (see `assets/rtl-document.tex`).
The HTML rules below apply to an explicit HTML ask or the Chromium
print fallback (`assets/rtl-document.html`).

## Document root

Use `assets/rtl-document.html`. The root must be:

```html
<html lang="fa" dir="rtl">
```

CSS on that template:

- `body`: `direction: rtl; unicode-bidi: isolate;`
- `.ltr`, `pre`, `code`, `kbd`, `samp`, `math`: `direction: ltr; unicode-bidi: isolate;`
- `pre`: `text-align: left;` plus `dir="ltr"` on the element

Never set `dir="rtl"` or `text-align: right` on `pre`, `code`, or a
wrapper around a listing.

## Code blocks are never RTL

This is a hard rule. Fenced listings, `pre`, file dumps, REPL
sessions, and algorithm listings stay left-to-right and left-aligned
even though the document is Persian.

```html
<!-- Required HTML shape (Chromium fallback) -->
<pre dir="ltr"><code>def fit(x):
    return x @ w
</code></pre>
```

```tex
% Required XeLaTeX shape (PDF)
\begin{latin}
\begin{Verbatim}[fontsize=\small,frame=single]
def fit(x):
    return x @ w
\end{Verbatim}
\end{latin}
```

```html
<!-- Forbidden -->
<pre dir="rtl">...</pre>
<pre style="text-align: right">...</pre>
<pre>  <!-- inherits RTL from body; still wrong without dir="ltr" -->
```

Also:

- Do not translate comments, identifiers, or strings inside code.
- Do not reorder glyphs, reverse indentation, or convert spaces.
- Inline code in Persian prose is LTR: `<code dir="ltr">fit(x)</code>`
  or wrap with `<span dir="ltr"><code>…</code></span>`.
- Markdown fallback: do not leave a bare ` ``` ` fence inside a
  `dir="rtl"` div. Wrap it in `<pre dir="ltr"><code>`.

## Isolate every LTR run

Wrap each English term, acronym, number cluster, citation key, formula,
URL, file path, and inline code:

```html
<span dir="ltr">gradient descent</span>
<span dir="ltr">Adam (Kingma &amp; Ba, 2015)</span>
<span dir="ltr">p &lt; 0.05</span>
<span dir="ltr">https://doi.org/10.0000/example</span>
```

XeLaTeX (PDF):

```tex
\en{gradient descent}
\en{Adam (Kingma \& Ba, 2015)}
\en{p < 0.05}
```

`<bdi>` is acceptable when the span is a single proper name. Prefer
`<span dir="ltr">` (HTML) or `\lr`/`\en` (TeX) for anything with
parentheses, punctuation, or digits.

A whole English bibliography, code listing, or equation block gets
`dir="ltr"` on the HTML container, or a `latin` environment in TeX,
not a token-by-token wrap.

## Wrong vs right

Parentheses and the sentence period are the usual failures.

```html
<!-- Wrong: parens and the period attach to the English run -->
الگوریتم Adam (Kingma &amp; Ba, 2015) استفاده شد.

<!-- Right -->
الگوریتم <span dir="ltr">Adam (Kingma &amp; Ba, 2015)</span> استفاده شد.
```

```tex
الگوریتم \en{Adam (Kingma \& Ba, 2015)} استفاده شد.
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
| Fenced code / `pre` | `dir="ltr"` on `<pre>` plus left-align; never RTL |
| XeLaTeX listing | `latin` + `verbatim` / `Verbatim`; never an RTL wrap |
| Inline `code` | `dir="ltr"` on `code`, or `\lr{\texttt{…}}` |
| Images / SVG | unchanged files; no flip; `\includegraphics` or `<img>` |
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
- The `<img>` / `<svg>` itself is not RTL content. Do not mirror it
  (`transform: scaleX(-1)` is forbidden). Place it in the same
  relative position as the source. Width/height follow the source
  aspect ratio.

```html
<figure>
  <img src="figures/fig-3.png" alt="…" width="720" height="420">
  <figcaption>شکل <span dir="ltr">3</span>. معماری <span dir="ltr">transformer</span>.</figcaption>
</figure>
```

## Markdown fallback

Only when the user demands Markdown:

```html
<div lang="fa" dir="rtl">

متن فارسی با <span dir="ltr">transformer</span>.

<pre dir="ltr"><code>print(x)</code></pre>

<figure>
  <img src="figures/fig-3.png" alt="…" width="720" height="420">
  <figcaption>شکل <span dir="ltr">3</span>. …</figcaption>
</figure>

</div>
```

GitHub-flavored Markdown will still break some bidi cases. Say so, and
prefer HTML. A bare Markdown fence inside a RTL container is not
enough; wrap listings in `<pre dir="ltr">`.

Never reverse English letter order by hand. Never rewrite `(Adam)` as
`)Adam(` to “fix” RTL.

## Self-check

1. Open the HTML file, not the chat transcript.
2. Scan every English island: parentheses enclose the English, not the
   Persian.
3. Sentence-final periods sit at the right edge of the Persian sentence.
4. Code blocks are LTR, left-aligned, and optically identical to the
   source listing. Images are the source files, unmirrored, in source
   order.
5. No `ك` / `ي` introduced while editing markup.
