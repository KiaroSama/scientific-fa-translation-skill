# Glossary

Living list for this skill. Classify every token against the two
columns below, then add a row if it is new.

## Rules

1. **Keep English:** algorithm / library / protocol / product names;
   acronyms (`API`, `PCR`, `GPU`, `CI`, …); formulas, code, units,
   statistics (`p`, `n`, `SD`, …); people’s names, journals, DOIs.
   Output the exact English form in an LTR isolate. Never substitute a
   Persian neologism.
2. **Write in Persian:** verbs and sentence structure; general words
   (روش، نتایج، بررسی); section titles (مقدمه، بحث، …); conceptual
   explanation for the reader. Never leave those in English.
3. If a *name* is missing from **Keep English**, keep English and add
   a row. If a *general word* is missing from **Translate**, write
   Persian and add a row.
4. Do not add فرهنگستان coinages for named artifacts unless the user
   puts them in this file.
5. Matching is case-sensitive only when the source is (e.g. `BERT` vs
   a generic `bert` identifier in code — follow the source).

## Translate (Persian)

Verbs, structure, general scholarly words, section titles. Conceptual
prose around a term is also Persian even when the term itself is
English.

| English | Persian |
| --- | --- |
| abstract | چکیده |
| introduction | مقدمه |
| methods | روش‌ها |
| results | نتایج |
| discussion | بحث |
| conclusion | نتیجه‌گیری |
| references | منابع |
| figure | شکل |
| table | جدول |
| equation | معادله |
| section | بخش |
| appendix | پیوست |
| paper / article | مقاله |
| book | کتاب |
| method | روش |
| analysis / study (generic) | بررسی |
| hypothesis | فرضیه |
| experiment | آزمایش |
| dataset (generic prose) | مجموعه داده |
| limitation | محدودیت |

`dataset` as a named corpus (`ImageNet`, `GLUE`) is a product/name and
stays English.

## Keep English

Non-exhaustive. Anything of this kind stays English even if unlisted.

### Algorithms, libraries, protocols, products

| Term | Notes |
| --- | --- |
| transformer | architecture / model family |
| backpropagation | |
| gradient descent | |
| Adam | optimizer name |
| BERT, GPT, ResNet, YOLO | model / product names |
| PyTorch, NumPy, TensorFlow | libraries |

### Acronyms

| Term | Notes |
| --- | --- |
| API, PCR, GPU, CI | keep as-is |
| CPU, TPU, RMSE, BLEU | same class |

### Formulas, code, units, statistics

| Term | Notes |
| --- | --- |
| p, n, SD | also `M`, `SE`, `df` |
| SI units | `km`, `ms`, `°C`, … |
| code / identifiers | never translate listings |

### People, journals, DOIs

| Term | Notes |
| --- | --- |
| author names | Latin script |
| journal / conference names | |
| DOI, URL | |
| et al. | inside citations |

### Unsorted names

| Term | Notes |
| --- | --- |
| | |

Add rows as documents are translated.
