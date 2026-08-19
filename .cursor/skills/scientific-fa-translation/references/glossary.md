# Glossary

Living list for this skill. Classify against Keep English vs Translate,
then add a row if it is new. Domain terms of art (including one word)
and multi-word technical collocations stay English: store and emit the
**source form**, not a Persian calque.

## Rules

1. **Keep English:** algorithm / library / protocol / product names;
   acronyms (`API`, `PCR`, `GPU`, `CI`, …); formulas, code, units,
   statistics (`p`, `n`, `SD`, …); people’s names, journals, DOIs;
   **domain terms of art, including one-word field nouns and their
   operation verbs** (`node`, `deployment`, `configure`);
   **multi-word technical collocations as whole phrases**.
   Output the exact English form in one LTR isolate. Never substitute a
   Persian neologism. Never calque or half-translate a collocation.
2. **Write in Persian:** narrative verbs and sentence structure;
   general words (روش، نتایج، بررسی) when they are not a field term
   of art and not inside a keep-English collocation; **generic** IMRAD
   headings (مقدمه، بحث، …); conceptual explanation for the reader.
   Never leave those in English. Domain headings that are names or
   collocations stay English (see Headings in `scientific-style.md`).
3. If a *name*, *field term*, or *collocation* is missing from **Keep
   English**, keep the English form and add a row. If a *generic
   scholarly word* is missing from **Translate** and it is not a field
   term and not part of a collocation, write Persian and add a row.
4. A Translate row never wins against a domain term of art. It also
   does not split a longer English NP that contains that word. Lone
   `node` is still `node`, not گره. `deployment` is still
   `deployment`, not استقرار.
5. Do not add فرهنگستان coinages for named artifacts unless the user
   puts them in this file.
6. Matching is case-sensitive only when the source is (e.g. `BERT` vs
   a generic `bert` identifier in code — follow the source).
7. No Persian morphology on English tokens (`APIها`, `Goی`). Plural is
   English inside the isolate (`APIs`, `nodes`).
8. One English form per concept in a document. Do not mix `node` and
   گره, or `deployment` and استقرار.

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
| credits | سپاسگزاری |
| changelog | تاریخچه تغییرات |
| spam | هرزنامه |
| activation | فعال‌سازی |
| invalid | نامعتبر |
| grandfathering | معافیت عطف‌به‌ماسبق |
| steganography | پنهان‌نگاری |

Translate rows are generic scholarly / IMRAD / document-chrome only.
They do **not** apply when the same spelling is a field term of art
in the source (`node`, `deployment`, `configuration`, `transaction`
in a spec, `block` in a Bitcoin doc). Those stay English. `dataset`
as a named corpus (`ImageNet`, `GLUE`) is a product/name and stays
English.

## Keep English

Non-exhaustive. Anything of this kind stays English even if unlisted.

### Domain terms of art

Field lexicon, including **one word**. Test: would this token appear
in that field’s glossary or man page? Then keep English. Also keep
the operation verb of the same term. Not «گره»، «استقرار»،
«پیکربندی»، «پیاده‌سازی»، «دیوار آتش».

| Term | Notes |
| --- | --- |
| node / nodes | never گره; also `Other nodes` |
| deployment / deploy | never استقرار; also `deployment and configuration` |
| configuration / configure | never پیکربندی as the field term |
| implementation / implement | never پیاده‌سازی for the field term; also `reference implementation` |
| integration | never یکپارچه‌سازی when the source is this term |
| firewall / firewalls | never دیوار آتش; also `firewalling services` |
| encryption | never رمزنگاری as the field term |
| commands | CLI/sysadmin term; never فرمان‌ها |
| fee | Bitcoin (and similar) field noun; never کارمزد when used as that lexicon |
| transaction / block / miner | Bitcoin (and similar) field nouns; never تراکنش / بلوک / استخراج‌کننده when used as that lexicon |
| consensus | field term; also `soft fork`, `hard fork` |
| policy | field term when it is that document’s lexicon (`service policies`); generic scholarly “policy” in IMRAD prose may still be سیاست |

### Atomic collocations

Keep the **entire source phrase** in one isolate. Do not calque or
half-translate. Add new document NPs here as whole rows.

| Term | Notes |
| --- | --- |
| composable APIs | not «APIهای ترکیب‌پذیر» |
| reusable Go packages | not «بسته‌های Go» |
| Kubernetes cluster | not «خوشه Kubernetes»; also `Kubernetes clusters` |
| OpenStack services | not «سرویس‌های OpenStack»; also `OpenStack packages`, `OpenStack architecture` |
| Ubuntu Cloud archive repository | not «مخزن Ubuntu Cloud archive»; also `RDO repository` |
| Other nodes | not «گره‌های دیگر» when that is the source heading/NP |
| controller node | also `compute node`, `Block Storage node` |
| Identity service | also `Image service`, `Compute service`, `Networking service` |
| provider networks | also `provider network`, `self-service networks` |
| Install and configure components | heading; not «نصب و پیکربندی مؤلفه‌ها» |
| Get started with OpenStack | domain heading; keep English |
| Conceptual architecture | also `Logical architecture`, `The OpenStack architecture` |
| deployment and configuration | not «استقرار و پیکربندی»; lone `deployment` also stays English |
| account with administrative privileges | not «حسابی با امتیازهای مدیریتی» |
| underlying infrastructure | not «زیرساخت زیربنایی» |
| firewalling services | not «خدمات دیوار آتش» |
| single disk partition | not «افراز دیسک واحد» |
| physical server | not «کارساز فیزیکی» |
| reference implementation | not «پیاده‌سازی مرجع» |
| test vectors | not «بردارهای آزمون» |
| backwards compatibility | collocation; keep English |
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
