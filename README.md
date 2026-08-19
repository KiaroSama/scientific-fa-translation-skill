# skills

Personal [Cursor Agent Skills](https://cursor.com/docs/skills). Each skill is
a top-level folder containing a `SKILL.md`.

## Install

Cursor looks for `~/.cursor/skills/<skill-name>/SKILL.md`, exactly one level
deep. Since every skill here sits at the repository root, cloning the
repository **as** that directory is the simplest layout:

```bash
git clone git@github.com:isArman/skills.git ~/.cursor/skills
```

If the clone belongs somewhere else, keep it there and symlink the skills in:

```bash
git clone git@github.com:isArman/skills.git ~/src/skills
~/src/skills/skills-install.sh
```

`skills-install.sh` recognises both layouts, is safe to re-run, and with
`--check` reports problems without changing anything. What does **not** work
is a skill more than one level deep — a clone at
`~/.cursor/skills/<repo>/<skill>/`, or a nested `.cursor/skills/` inside this
repository. The script fails loudly on both.

In Agent chat, ask to translate, or type `/scientific-fa-translation`. If the
slash menu is empty — common on Cloud Agent follow-ups — write it in prose:
"use the scientific-fa-translation skill". After `git pull`, start a **new**
agent on `main`; follow-ups in a running agent do not reliably reload skills.

## Skills

| Skill | Invoke | Purpose |
| --- | --- | --- |
| [scientific-fa-translation](scientific-fa-translation/SKILL.md) | `/scientific-fa-translation` | Academic English → Persian translation; print PDF with precise RTL at `~/Documents/books` |

### scientific-fa-translation

Translates papers, articles, books, and technical documentation into formal
scientific Persian, and reviews finished translations against the same rules.
Cursor chat is only a short status note plus the output path; it is not the
RTL surface.

**Deliverable.** A printable PDF at `~/Documents/books/<slug>.pdf`. Preferred
engine XeLaTeX + `xepersian`; Chromium then WeasyPrint on the RTL HTML
template when TeX is absent. Run `scripts/preflight.sh` to see which of those
exist on the machine before planning a build.

**Terminology.** Named artifacts, acronyms, formulas, multi-word technical
collocations, and — at `system-docs` level — one-word field terms of art and
their operation verbs stay English in an LTR isolate. Generic document
chrome, narrative verbs, and conceptual explanation are Persian. The ordered
decision procedure, the field-term test, and the two levels are in
[`references/terminology.md`](scientific-fa-translation/references/terminology.md);
the lists are in `glossary.md` and `glossary-domains.md`. Nothing restates
the policy, so there is one place to change it.

**Enforcement.** `scripts/check-fa.py` fails the build on the mechanical
rules — orthography, forbidden Persian calques, half-translated noun phrases,
Persian affixes on Latin tokens, split isolates, un-isolated Latin runs, RTL
listings, mirrored artwork, missing images, figure direction, terminology
drift. The checklist left in `SKILL.md` is only the five items a machine
cannot judge.
`tests/run.sh` keeps the checker honest with clean and deliberately broken
fixtures.

```bash
scripts/preflight.sh
scripts/check-fa.py doc.tex --domains openstack
scripts/build-pdf.sh doc.tex my-slug --verify
bash tests/run.sh
```

Layout:

```text
scientific-fa-translation/
  SKILL.md
  assets/rtl-document.tex        assets/rtl-document.html
  references/terminology.md      policy: keep English vs write Persian
  references/glossary.md         house lists
  references/glossary-domains.md per-field packs
  references/term-pairs.tsv      forbidden calques, machine-readable
  references/scientific-style.md register, orthography, mechanics
  references/rtl-bidi.md         isolation rules
  references/pdf-output.md       engines, fonts, verification
  references/source-ingest.md    fetching and extracting the source
  references/long-documents.md   sectioning, resume, ambiguity queue
  references/review.md           reviewing a finished translation
  scripts/preflight.sh           what this machine can build
  scripts/check-fa.py            mechanical checker
  scripts/prepare-figures.py     flatten alpha; catch pdfimages negatives
  scripts/build-pdf.sh           compile and verify
  scripts/fetch-vazirmatn.sh     font for the HTML path
  tests/                         checker regression tests
```

## License

MIT. See [LICENSE](LICENSE). Vazirmatn, fetched by
`scripts/fetch-vazirmatn.sh`, is under the SIL Open Font License 1.1; keep
its licence beside the font files when shipping HTML.
