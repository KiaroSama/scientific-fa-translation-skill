# Terminology policy

Single owner of the keep-English / write-Persian split. `scientific-style.md`
owns register and orthography, `glossary.md` holds the house lists,
`glossary-domains.md` holds per-field packs, and `term-pairs.tsv` is the
machine-readable half that `scripts/check-fa.py` enforces. Do not restate
this policy anywhere else.

## Level

Two levels, because a sysadmin install guide and a journal paper cannot take
the same treatment. Announce the level in the first chat message.

| Level | For | One-word field nouns |
| --- | --- | --- |
| `system-docs` (default) | install guides, protocol specs, product docs, RFC/BIP, runbooks | English (`node`, `deployment`, `configure`) |
| `journal` | papers, theses, review articles for a general scientific audience | Persian, English gloss allowed once |

Both levels keep named artifacts, acronyms, formulas, and multi-word
technical labels in English. The level only moves the boundary for ordinary
one-word field nouns and their operation verbs. The user switches with
«سطح journal» or «سطح system-docs».

## Decision procedure

Ordered. First match wins. Apply to each source token or noun phrase.

0. **Document chrome.** A generic IMRAD or book label — `Abstract`,
   `Introduction`, `Methods`, `Results`, `Discussion`, `Conclusion`,
   `References`, `Figure`, `Table`, `Equation`, `Section`, `Appendix`,
   `Contents` / `Table of contents` / `Brief contents`, `Foreword`,
   `Preface` — is Persian, always, at every level. This step exists so a
   source glossary cannot drag `Introduction` into English. It applies
   only to the bare label, never to a heading that names an artifact. A
   book contents page is translated and printed; omitting it is a missing
   section, not a layout choice.
1. **Named artifact.** Product, project, algorithm, library, protocol,
   standard, opcode, identifier, acronym, unit, statistical symbol,
   person, journal, conference, DOI, URL, licence → English.
2. **Multi-word technical label.** A 2–5 word noun phrase that names a
   component, role, requirement class, or configuration in this document
   → English, the **whole** phrase, one isolate. Covers *X of Y*,
   *Adjective + Name*, and *Name + common noun*.
3. **Field term of art** (see the test below) → English at `system-docs`,
   including the operation verb of the same term. At `journal`, Persian
   unless step 1 or 2 already claimed it.
4. **Listed as Persian** in `glossary.md` → Persian.
5. **Otherwise** ordinary scholarly prose → Persian.

Tie-break when steps 1–3 are genuinely uncertain: at `system-docs` keep the
whole noun phrase English and add a row to the glossary; at `journal` write
Persian and gloss the English once. Never resolve uncertainty by
half-translating.

## The field-term test

A token is a field term of art when at least one of these holds:

- it appears in the source document's own glossary or terminology section;
- it appears in the upstream project's official glossary, man page,
  `--help` output, or spec index;
- the source itself marks it as defined — monospace, italics on first
  use, or capitalised mid-sentence.

It is **not** a field term when it is used in its ordinary dictionary sense
in a sentence that is about something else. In «increase security using
firewalls and encryption», `security` is ordinary prose and becomes امنیت,
while `firewalls` and `encryption` are the document's lexicon and stay
English.

## Isolation and morphology

Mechanics live in `rtl-bidi.md`. Three rules belong here because they are
terminology decisions, not layout:

- One isolate per whole noun phrase, never one isolate per word.
- Regular English plurals of a kept term drop `-s` / `-es` / `-ies`. The
  singular stem stays in the isolate; Persian `ها` (or `های` / `هایی`)
  follows it: `\en{service}ها`, `\en{platform}ها`, `\en{API}ها`,
  `\en{OpenStack service}ها`. Never `services`, `platforms`, `APIs`,
  `nodes`. Names that merely end in *s* (`Kubernetes`, `Windows`) stay
  as written. Do not attach any other Persian affix (`\en{Go}ی`).
- No Persian head noun in front of an English name. `\en{OpenStack
  service}ها` stays whole; «سرویس‌های OpenStack» is a half-translation,
  not a compromise.

## First mention and consistency

At `system-docs`, no gloss on first mention. At `journal`, one gloss is
allowed the first time a Persian term carries an English concept.

One form per concept for the whole document, in both directions: never mix
`node` and گره, and never mix `node` with an unisolated bare `node`. For
anything longer than a few pages, produce the `terms.tsv` described in
`long-documents.md` **before** translating the body — the recorded
`password` / گذرواژه drift came from deciding terminology while drafting.

## Forbidden output

The canonical list is `term-pairs.tsv`, not prose. Each row pairs a source
term with the Persian calque that must never replace it, a scope
(`universal` or a domain pack), and a `levels` column: `system-docs` for
one-word field nouns (skipped at `--level journal`) or `all` for
multi-word labels kept English at both levels. Add a row there in the
same commit as any new Keep-English note, then confirm with:

```bash
scripts/check-fa.py path/to/doc.tex --level system-docs --domains openstack --strict
```

Common `system-docs` rows today: `node`, `deployment`, `configuration`,
`implementation`, `integration`, `firewall`, `encryption`, `command`,
`server`, `partition`, `filter`. At `journal` those one-word forms are
Persian. Domain rows cover `password` (OpenStack install guides),
`cluster` (Kubernetes), `transaction` / `block` / `fee` (Bitcoin),
`dataset` (ML). Scoping matters: `block` is the Bitcoin lexicon but
ordinary prose in a materials-science paper, so it must not be a
universal rule. A kept-term plural is `\en{node}ها`, not `nodes` and
not گره‌ها.
