# House glossary

Domain-agnostic lists. The policy that decides which list a token belongs to
lives in `terminology.md`; do not re-derive it here. Field-specific
vocabulary lives in `glossary-domains.md`, and the forbidden Persian calques
live in `term-pairs.tsv` where the checker can read them.

Three tiers, deliberately:

| File | Scope | Lifetime |
| --- | --- | --- |
| `glossary.md` | any scientific document | permanent |
| `glossary-domains.md` | one field, reusable across documents | permanent |
| `glossary.local.md` in the working tree | one document | discarded with the job |

Append a row here **only** if it generalises past the document in hand. A
`LOCKED_IN` state name or an author's byline belongs in `glossary.local.md`;
putting it here dilutes the file the agent has to read on every job and
creates cross-domain false positives.

## Always Persian

Document chrome. Step 0 of the decision procedure: these are Persian at
every level, and no source glossary overrides them. Applies to the bare
label only — a heading that names an artifact stays English.

| English | Persian |
| --- | --- |
| abstract | چکیده |
| introduction | مقدمه |
| methods / materials and methods | روش‌ها / مواد و روش‌ها |
| results | نتایج |
| discussion | بحث |
| conclusion | نتیجه‌گیری |
| related work | کارهای مرتبط |
| acknowledgments | سپاسگزاری |
| references / bibliography | منابع |
| figure | شکل |
| table | جدول |
| equation | معادله |
| section | بخش |
| appendix | پیوست |
| paper / article | مقاله |
| book | کتاب |
| chapter | فصل |
| copyright | حق نشر |
| changelog | تاریخچه تغییرات |
| credits | سپاسگزاری |

## Persian unless it is this document's field term

Ordinary scholarly vocabulary. Persian by default, English when the
field-term test in `terminology.md` says the source is using it as its own
defined lexicon. This is the tier that used to contradict itself: `dataset`
is مجموعه داده in a clinical paper and `dataset` in an ML paper, and both
are correct.

| English | Persian | Stays English when |
| --- | --- | --- |
| method | روش | part of a named method |
| analysis / study | بررسی | named study or corpus |
| hypothesis | فرضیه | — |
| experiment | آزمایش | — |
| dataset | مجموعه داده | ML lexicon, or a named corpus (`ImageNet`, `GLUE`) |
| specification | مشخصات | the document *is* a spec |
| limitation | محدودیت | — |
| motivation | انگیزه | — |
| rationale | استدلال | — |
| tradeoffs | بده‌بستان‌ها | — |
| alternatives | جایگزین‌ها | — |
| activation | فعال‌سازی | protocol activation (BIP 8/9) |
| invalid | نامعتبر | a defined validity state |
| policy | سیاست | `service policyها` and similar labels |
| spam | هرزنامه | — |
| steganography | پنهان‌نگاری | — |
| grandfathering | معافیت عطف‌به‌ماسبق | — |

## Keep English — classes

Non-exhaustive by design. Anything of the same kind stays English even when
unlisted; that is what makes step 1 of the decision procedure workable.

| Class | Examples |
| --- | --- |
| Algorithms, models, architectures | `transformer`, `backpropagation`, `gradient descent`, `Adam`, `BERT`, `ResNet` |
| Libraries, tools, products, projects | `PyTorch`, `NumPy`, `TensorFlow`, `Kubernetes`, `OpenStack`, `Bitcoin` |
| Protocols and standards | `HTTP`, `AMQP`, `Segwit`, `Taproot` |
| Acronyms | `API`, `PCR`, `GPU`, `CI`, `CPU`, `TPU`, `RMSE`, `BLEU`, `RAM` |
| Statistical symbols | `p`, `n`, `M`, `SD`, `SE`, `df` |
| SI units | `km`, `ms`, `°C`, `GiB` |
| Code and identifiers | anything inside a listing; `scriptPubKey`, `fit(x)` |
| People, journals, conferences | author bylines, venue names, `et al.` |
| Locators | DOI, URL, arXiv id, licence names (`MIT`, `BSD-3-Clause`) |

## Universal terms of art

The recurring infrastructure lexicon. These stay English in any technical
document at `system-docs` level, including the operation verb of the same
term. Each has a row in `term-pairs.tsv` with `levels` `system-docs`, so
the checker fails the build on the Persian calque unless `--level journal`.

| Term | Also covers |
| --- | --- |
| node / nodeها | `controller node`, `compute node`, `Other nodeها` |
| deployment / deploy | `deployment and configuration` |
| configuration / configure | `Install and configure components` |
| implementation / implement | `reference implementation` |
| integration | — |
| firewall / firewallها | `firewalling serviceها`, `restrictive firewallها` |
| encryption | — |
| command / commandها | `command-line clientها` |
| server | `physical server`, `database server` |
| partition | `single disk partition` |
| filter | — |

At `journal` level these become Persian unless the surrounding phrase is a
named artifact or a multi-word label.

## Per-document glossary

Create `glossary.local.md` next to the working `.tex` or `.html`, with the
same two-tier shape, and record the document's own names: state constants,
opcode lists, author bylines, deployment identifiers, table captions kept
whole. Emit `terms.tsv` alongside it (`long-documents.md`) so the choice is
reviewable before the body is drafted, and pass a local pairs file to the
checker when the document needs extra forbidden forms. `--pairs` is merged
onto `term-pairs.tsv`; it does not replace the house list:

```bash
scripts/check-fa.py doc.tex --level system-docs --pairs glossary.local.tsv --domains openstack --strict
```
