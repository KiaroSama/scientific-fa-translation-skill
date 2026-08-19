# Glossary

Living list for this skill. Classify against Keep English vs Translate,
then add a row if it is new. Multi-word technical collocations are
atomic: store and emit the **whole phrase**, not the pieces.

## Rules

1. **Keep English:** algorithm / library / protocol / product names;
   acronyms (`API`, `PCR`, `GPU`, `CI`, …); formulas, code, units,
   statistics (`p`, `n`, `SD`, …); people’s names, journals, DOIs;
   **multi-word technical collocations as whole phrases**.
   Output the exact English form in one LTR isolate. Never substitute a
   Persian neologism. Never calque or half-translate a collocation.
2. **Write in Persian:** verbs and sentence structure; general words
   (روش، نتایج، بررسی) when they are not inside a keep-English
   collocation; section titles (مقدمه، بحث، …); conceptual explanation
   for the reader. Never leave those in English.
3. If a *name* or a *collocation* is missing from **Keep English**, keep
   the whole English NP and add a row. If a *general word* is missing
   from **Translate** and it is not part of a collocation, write Persian
   and add a row.
4. A Translate row for one word does not split a longer English NP that
   contains it.
5. Do not add فرهنگستان coinages for named artifacts unless the user
   puts them in this file.
6. Matching is case-sensitive only when the source is (e.g. `BERT` vs
   a generic `bert` identifier in code — follow the source).
7. No Persian morphology on English tokens (`APIها`, `Goی`). Plural is
   English inside the isolate (`APIs`).

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
| specification | مشخصات |
| copyright | حق نشر |
| motivation | انگیزه |
| rationale | استدلال |
| tradeoffs | بده‌بستان‌ها |
| alternatives | جایگزین‌ها |
| backwards compatibility | سازگاری پس‌رو |
| reference implementation | پیاده‌سازی مرجع |
| test vectors | بردارهای آزمون |
| deployment | استقرار |
| credits | سپاسگزاری |
| changelog | تاریخچه تغییرات |
| consensus | اجماع |
| soft fork / softfork | فورک نرم |
| hard fork / hardfork | فورک سخت |
| node | گره |
| miner | استخراج‌کننده |
| transaction | تراکنش |
| block | بلوک |
| fee | کارمزد |
| spam | هرزنامه |
| policy | سیاست |
| activation | فعال‌سازی |
| invalid | نامعتبر |
| grandfathering | معافیت عطف‌به‌ماسبق |
| steganography | پنهان‌نگاری |

`dataset` as a named corpus (`ImageNet`, `GLUE`) is a product/name and
stays English. A Translate row (`deployment` → استقرار) does not split
`deployment and configuration`; that collocation stays English.

## Keep English

Non-exhaustive. Anything of this kind stays English even if unlisted.

### Atomic collocations

Keep the **entire source phrase** in one isolate. Do not calque or
half-translate. Add new document NPs here as whole rows.

| Term | Notes |
| --- | --- |
| composable APIs | not «APIهای ترکیب‌پذیر» |
| reusable Go packages | not «بسته‌های Go» |
| Kubernetes cluster | not «خوشه Kubernetes» |
| deployment and configuration | not «استقرار و پیکربندی» when used as a domain label |
| Continuous Delivery workflows | not «جریان‌های کاری پیوسته» |
| version-controlled approach to operations | not a word-for-word calque |

### Algorithms, libraries, protocols, products

| Term | Notes |
| --- | --- |
| transformer | architecture / model family |
| backpropagation | |
| gradient descent | |
| Adam | optimizer name |
| BERT, GPT, ResNet, YOLO | model / product names |
| PyTorch, NumPy, TensorFlow | libraries |
| Bitcoin | network / product |
| Taproot, Tapleaf, Tapscript, Taptree | Bitcoin script / output family |
| Segwit | protocol name |
| BitVM | protocol / product |
| Miniscript | compiler / language name |
| Nostr, IPFS, BitTorrent | products / protocols |
| inscription | named embedding technique |
| pay-to-contract | named commitment scheme |
| blobspace | named scheme |
| GetBlockTemplate, GBT | protocol / API name |

### Acronyms

| Term | Notes |
| --- | --- |
| API, PCR, GPU, CI | keep as-is |
| CPU, TPU, RMSE, BLEU | same class |
| BIP, UTXO, P2WPKH, P2WSH, P2TR, P2A | Bitcoin |
| NUMS | nothing-up-my-sleeve |
| RAM | |
| OP_RETURN, OP_PUSHDATA, OP_SUCCESS, OP_IF, OP_NOTIF | opcodes |

### Formulas, code, units, statistics

| Term | Notes |
| --- | --- |
| p, n, SD | also `M`, `SE`, `df` |
| SI units | `km`, `ms`, `°C`, … |
| code / identifiers | never translate listings |
| scriptPubKey, scriptSig, redeemScript | identifiers |
| witness, annex, control block, keypath | named stack / spend artifacts |

### People, journals, DOIs

| Term | Notes |
| --- | --- |
| author names | Latin script |
| journal / conference names | |
| DOI, URL | |
| et al. | inside citations |
| Dathon Ohm | BIP 110 author |
| Luke-Jr | credit |

### Unsorted names

| Term | Notes |
| --- | --- |
| BSD-3-Clause | license |
| reduced_data | BIP 9 deployment name |
| LOCKED_IN, ACTIVE, DEFINED, STARTED, EXPIRED, FAILED | BIP 9 states |
| BIP9, BIP8, BIP16, BIP141, BIP341, BIP342, BIP433, BIP-3 | BIP identifiers |

Add rows as documents are translated.
