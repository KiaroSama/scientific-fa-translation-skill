# Scientific Persian Translation Skill

[![ci](https://github.com/KiaroSama/scientific-fa-translation-skill/actions/workflows/ci.yml/badge.svg)](https://github.com/KiaroSama/scientific-fa-translation-skill/actions/workflows/ci.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Claude Code](https://img.shields.io/badge/Claude%20Code-Skill-blueviolet.svg)](https://code.claude.com/docs/en/skills)
[![Cursor](https://img.shields.io/badge/Cursor-Skill-blue.svg)](https://cursor.com/docs/skills)
[![Codex](https://img.shields.io/badge/Codex-Skill-black.svg)](https://github.com/openai/codex/blob/main/docs/skills.md)

An agent skill for academic English → scientific Persian, with print-ready
RTL. One skill directory, loaded unchanged by Claude Code, Cursor, and
Codex.

## Features

- **Translation** — papers, articles, books, and technical documentation
  into formal فارسی معیار; claims, hedges, and figures preserved
- **Review mode** — audits a finished Persian translation against the same
  rules
- **Terminology policy** — an ordered decision procedure for what stays
  English, with two levels (`journal`, `system-docs`) and per-field packs
- **Print-ready RTL** — XeLaTeX + `xepersian`, with a Chromium/WeasyPrint
  HTML fallback; every LTR run isolated so bidi cannot reverse it
- **Linux, macOS, and Windows** — each shell script has a PowerShell twin
  of the same name; the Python helpers run anywhere
- **Mechanical enforcement** — `check-fa.py` fails the build on
  orthography, calques, split isolates, mirrored artwork, and more

## Installation

```bash
git clone https://github.com/KiaroSama/scientific-fa-translation-skill.git
cd scientific-fa-translation-skill
```

Then copy the skill folder into your agent's skills directory:

```bash
cp -r scientific-fa-translation-skill ~/.claude/skills/   # Claude Code
cp -r scientific-fa-translation-skill ~/.cursor/skills/   # Cursor
cp -r scientific-fa-translation-skill ~/.codex/skills/    # Codex
```

Or install just the packaged skill, without cloning:

```bash
mkdir -p ~/.claude/skills
curl -fsSL -o /tmp/fa.skill \
  https://raw.githubusercontent.com/KiaroSama/scientific-fa-translation-skill/main/scientific-fa-translation-skill.skill
unzip -o /tmp/fa.skill -d ~/.claude/skills/
```

On Windows, PowerShell:

```powershell
git clone https://github.com/KiaroSama/scientific-fa-translation-skill.git
Copy-Item -Recurse `
  scientific-fa-translation-skill\scientific-fa-translation-skill `
  $HOME\.claude\skills\
```

All three tools look exactly one level deep, so the result must be:

```text
~/.claude/skills/scientific-fa-translation-skill/SKILL.md
```

Note the repeated name above: the outer directory is the clone, the inner
one is the skill. Copy the **inner directory**, not the repo root — the
repo root also carries `tests/`, CI, and the per-tool guidance files,
which are not part of the skill. For a project-scoped install, copy into
`.claude/skills/`, `.cursor/skills/`, or `.codex/skills/` at the project
root instead.

To update later, `git pull` and copy again, then start a **new** agent
session — follow-ups in a running agent do not reliably reload skills.

## Usage

The skill activates automatically when you ask an agent to:

- Translate a paper, article, book, or technical docs into Persian
- Produce a راست‌چین / RTL / چاپ-ready Persian PDF
- Check whether a finished Persian translation follows the rules

Explicit invocation is `/scientific-fa-translation-skill` in Claude Code
and Cursor, `$scientific-fa-translation-skill` in Codex; `/skills` lists
what is loaded. If the menu is empty — common on Cursor Cloud Agent
follow-ups — write it in prose: "use the scientific-fa-translation-skill".
After updating the skill, start a **new** agent session; follow-ups in a
running agent do not reliably reload skills.

### Example prompts

```
"Translate this arXiv paper into Persian and give me a printable PDF"
"این راهنمای نصب OpenStack را به فارسی علمی ترجمه کن"
"Does this Persian translation follow the terminology rules?"
```

**Deliverable.** A printable PDF at `$HOME/Documents/books/<slug>.pdf`
(`%USERPROFILE%\Documents\books` on native Windows). Preferred engine
XeLaTeX + `xepersian`; Chromium then WeasyPrint on the RTL HTML template
when TeX is absent. Agent chat is only a short status note plus the output
path — it is not the RTL surface. Run `scripts/preflight.sh` to see which
engines exist on the machine before planning a build.

**Terminology.** Named artifacts, acronyms, formulas, multi-word technical
collocations, and — at `system-docs` level — one-word field terms of art
and their operation verbs stay English in an LTR isolate. Generic document
chrome, narrative verbs, and conceptual explanation are Persian. The
ordered decision procedure, the field-term test, and the two levels are in
[`references/terminology.md`](scientific-fa-translation-skill/references/terminology.md);
the lists are in `glossary.md` and `glossary-domains.md`. Nothing restates
the policy, so there is one place to change it.

**Enforcement.** `scripts/check-fa.py --level <level> --strict` fails the
build on the mechanical rules — orthography, forbidden calques at that
level, half-translated noun phrases, English `-s` plurals of kept terms,
split isolates, un-isolated Latin runs and number clusters, RTL listings,
mirrored artwork, missing images, figure direction, full-page rasters,
terminology drift. `--pairs` merges onto the house list. The checklist left
in `SKILL.md` is only the five items a machine cannot judge. `tests/run.sh`
keeps the checker honest with clean and deliberately broken fixtures.

```bash
cd scientific-fa-translation-skill
scripts/preflight.sh
scripts/check-fa.py doc.tex --level system-docs --domains openstack --strict
scripts/build-pdf.sh doc.tex my-slug --verify
cd .. && bash tests/run.sh
```

On native Windows, use the PowerShell twins — same names, same behaviour:

```powershell
cd scientific-fa-translation-skill
.\scripts\preflight.ps1
python scripts\check-fa.py doc.tex --level system-docs --domains openstack --strict
.\scripts\build-pdf.ps1 doc.tex my-slug -Verify
```

The `.ps1` scripts run on Windows PowerShell 5.1 and on PowerShell 7.x, so
the shell that ships with Windows is enough and `pwsh` works too. They are
Windows-only by design — under `pwsh` on Linux or macOS each exits 2 and
points at its `.sh` twin. The `.py` helpers are cross-platform and need no
port. `tests/run.sh` is POSIX-only — run it under WSL or Git Bash. See
`references/pdf-output.md` for the Windows engine notes (Edge as the
browser fallback, MiKTeX for TeX, poppler for `-Verify` rasterisation).

## Repository contents

```text
scientific-fa-translation-skill/       the skill; copy this into your skills dir
├── SKILL.md                           core policy, workflow, quality gate
├── assets/
│   ├── rtl-document.tex               XeLaTeX + xepersian template
│   └── rtl-document.html              Chromium / WeasyPrint fallback
├── references/
│   ├── terminology.md                 policy: keep English vs write Persian
│   ├── glossary.md                    house lists
│   ├── glossary-domains.md            per-field packs
│   ├── term-pairs.tsv                 forbidden calques, machine-readable
│   ├── scientific-style.md            register, orthography, mechanics
│   ├── rtl-bidi.md                    isolation rules
│   ├── pdf-output.md                  engines, fonts, verification
│   ├── source-ingest.md               fetching and extracting the source
│   ├── long-documents.md              sectioning, resume, ambiguity queue
│   └── review.md                      reviewing a finished translation
└── scripts/                           .sh and .ps1 are twins; .py is portable
    ├── preflight.sh    preflight.ps1        what this machine can build
    ├── build-pdf.sh    build-pdf.ps1        compile and verify
    ├── fetch-vazirmatn.sh  ….ps1            font for the HTML path
    ├── check-fa.py                    mechanical checker
    ├── prepare-figures.py             flatten alpha; catch pdfimages negatives
    ├── crop-source-figures.py         crop artwork; never embed a full PDF page
    └── extract-pdf-pages.py           page-range PDF without duplicating XObjects

scientific-fa-translation-skill.skill  packaged zip of the above
tests/                                 checker regression tests (not shipped)
CLAUDE.md  AGENTS.md  .cursor/rules/   per-tool guidance for working on this repo
```

## Development

```bash
bash tests/run.sh
shellcheck -S warning $(git ls-files '*.sh')
python3 -m py_compile $(git ls-files '*.py')

# repackage after changing anything under scientific-fa-translation-skill/
# (from the committed tree: never an ignored fonts/ or build artefact)
git archive --format=zip -o scientific-fa-translation-skill.skill \
  HEAD scientific-fa-translation-skill
```

CI runs all of the above on every push and pull request, and additionally
fails if `SKILL.md` drifts out of the skill directory, if a guidance file
goes missing, if prose reintroduces a non-portable `/home/<user>` path, or
if the committed `.skill` no longer matches the directory it packages.

See `CLAUDE.md` / `AGENTS.md` for the contributor rules — terminology
ownership, checker fixtures, and the known TeX Live 2023 digit-font issue.

## Author

Kiaro Sama — [@KiaroSama](https://github.com/KiaroSama)

## License

MIT. See [LICENSE](LICENSE). Vazirmatn, fetched by
`scripts/fetch-vazirmatn.sh`, is under the SIL Open Font License 1.1; keep
its licence beside the font files when shipping HTML.
