# Domain packs

Field-specific vocabulary, kept out of `glossary.md` so the house list stays
short and so a term from one field cannot leak into another. Read only the
pack that matches the source. Pack names match the `scope` column of
`term-pairs.tsv`:

```bash
scripts/check-fa.py doc.tex --domains openstack
```

Everything below is Keep English unless a row says otherwise. Rows are the
whole source phrase — one isolate, no calque, no half-translation.

## openstack

Cloud install guides and service documentation.

| Term | Also covers |
| --- | --- |
| OpenStack services | `OpenStack packages`, `OpenStack architecture`, `OpenStack components` |
| Identity service | `Image service`, `Compute service`, `Networking service`, `Block Storage node` |
| controller node | `compute node`, `additional nodes`, `Other nodes` |
| provider networks | `provider network`, `self-service networks` |
| AMQP message broker | `message broker`, `message queue` |
| web-based user interface | `browser plug-ins`, `command-line clients` |
| database | `database password`, `database passwords`, `database server` |
| password security | `password`, `passwords`, `service account passwords`, `user name/password` |
| interrelated services | `supporting services`, `complementary services`, `advanced services` |
| example architecture | `functional example architecture`, `minimum configuration` |
| Hardware requirements | `hardware requirements`, `minimum requirements`, `system requirements`, `hardware resources` |
| performance and redundancy requirements | — |
| Ubuntu Cloud archive repository | `RDO repository` |
| account with administrative privileges | — |
| underlying infrastructure | — |
| Network layout | figure caption, kept whole |
| Default ports that OpenStack components use | table caption, kept whole |
| Default ports that secondary services related to OpenStack components use | table caption, kept whole |
| Get started with OpenStack | heading |
| Conceptual architecture | `Logical architecture`, `The OpenStack architecture` |
| Host networking | heading |
| Install and configure components | heading |

`password` is this pack's most error-prone row: it reads like ordinary prose
and drifts to گذرواژه in glossaries and screenshots even when the body keeps
it English. Enforced by the `openstack` scope in `term-pairs.tsv`.

## bitcoin

Protocol specifications, BIPs, script and consensus documents.

| Term | Also covers |
| --- | --- |
| transaction / block / miner | field nouns; never تراکنش / بلوک / استخراج‌کننده in this lexicon |
| fee | never کارمزد in this lexicon |
| consensus | `soft fork`, `hard fork` |
| activation | `deployment` parameters, BIP 8/9 activation states |
| Taproot, Tapleaf, Tapscript, Taptree | output and script family |
| Segwit, BitVM, Miniscript | protocol, product, language names |
| inscription, pay-to-contract, blobspace | named schemes |
| GetBlockTemplate, GBT | protocol / API names |
| scriptPubKey, scriptSig, redeemScript | identifiers |
| witness, annex, control block, keypath | named stack and spend artifacts |
| UTXO, P2WPKH, P2WSH, P2TR, P2A, BIP, NUMS | acronyms |
| OP_RETURN, OP_PUSHDATA, OP_SUCCESS, OP_IF, OP_NOTIF | opcodes; joined pairs are one isolate |
| LOCKED_IN, ACTIVE, DEFINED, STARTED, EXPIRED, FAILED | BIP 9 states |
| BIP9, BIP8, BIP16, BIP141, BIP341, BIP342, BIP433, BIP-3 | identifiers |

State transitions and opcode pairs arrive joined by punctuation
(`STARTED -> LOCKED_IN`, `OP_IF/OP_NOTIF`) and must be a single isolate.

## kubernetes

| Term | Also covers |
| --- | --- |
| Kubernetes cluster | `Kubernetes clusters`; never «خوشه Kubernetes» |
| namespace, controller, operator, sidecar | field nouns |
| Custom Resource Definition, CRD | — |
| control plane | `worker node` |

## gitops

Flux, Argo, and continuous-delivery documentation.

| Term | Also covers |
| --- | --- |
| GitOps Toolkit | — |
| composable APIs | never «APIهای ترکیب‌پذیر» |
| reusable Go packages | never «بسته‌های Go» |
| Continuous Delivery workflows | — |
| version-controlled approach to operations | keep whole; do not calque |
| reconciliation, drift, source controller | field nouns |

## ml

Machine-learning papers. Usually read at `journal` level, where one-word
field nouns become Persian — so this pack is mostly named artifacts.

| Term | Also covers |
| --- | --- |
| transformer, backpropagation, gradient descent | architectures and methods |
| Adam, AdamW, SGD | optimiser names |
| BERT, GPT, ResNet, YOLO | model names |
| PyTorch, NumPy, TensorFlow, JAX | libraries |
| ImageNet, GLUE, COCO | named corpora; a *named* dataset is a product |
| RMSE, BLEU, F1, AUC | metrics |

`dataset` as a common noun is مجموعه داده at `journal` level; as a named
corpus it is English. That split is the reason this pack exists rather than
a universal `dataset` rule.

## Adding a pack

1. New file section here, named after the scope you will pass to
   `--domains`.
2. Rows for the whole source phrases, not single words, unless the single
   word passes the field-term test.
3. For every term that a translator would plausibly calque, add a row to
   `term-pairs.tsv` with that scope. A pack without checker rows is
   documentation, not enforcement.
