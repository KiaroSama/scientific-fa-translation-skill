# Glossary

Living list for this skill. The agent must keep English technical terms
and append new ones here when they appear in a source.

## Rules

1. If a term is in **Keep English**, output that exact English form
   inside an LTR isolate. Never substitute a Persian neologism.
2. If a term is in **Translate**, use the Persian listed here every time.
3. If a term is missing: keep English, then add a row under the matching
   domain (or `Unsorted`).
4. Do not add فرهنگستان coinages unless the user puts them in this file.
5. Matching is case-sensitive only when the source is (e.g. `BERT` vs
   a generic `bert` identifier in code — follow the source).

## Translate (ordinary scholarly words)

These are not “technical terms” in the house-style sense.

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
| hypothesis | فرضیه |
| experiment | آزمایش |
| dataset (generic prose) | مجموعه داده |
| limitation | محدودیت |

`dataset` as a named corpus (`ImageNet`, `GLUE`) stays English.

## Keep English

Non-exhaustive. Anything of this kind stays English even if unlisted.

### Names and artifacts

| Term | Notes |
| --- | --- |
| transformer | architecture / model family |
| attention | keep when it names the mechanism; prose “توجه” only if non-technical |
| backpropagation | |
| gradient descent | |
| Adam | optimizer name |
| BERT, GPT, ResNet, YOLO | model names |
| PyTorch, NumPy, TensorFlow | libraries |
| API, GPU, CPU, TPU, PCR, RMSE, BLEU | acronyms |
| p, n, M, SD, SE, CI, df | statistics |
| et al. | inside citations |

### Unsorted

| Term | Notes |
| --- | --- |
| | |

Add rows as documents are translated.
