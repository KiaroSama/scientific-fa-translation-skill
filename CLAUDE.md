# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working
with code in this repository.

## Project Overview

This repository packages a single agent skill: English → academic Persian
(Farsi) translation of papers, articles, books, and technical
documentation, with print-ready RTL output. The same skill directory
installs into Claude Code, Cursor, and Codex unchanged.

## Build Commands

```bash
# Package the skill (creates the .skill zip)
zip -r scientific-fa-translation-skill.skill \
  scientific-fa-translation-skill -x "*.DS_Store" -x "*__pycache__*"

# Install to the Claude Code skills directory
cp -r scientific-fa-translation-skill ~/.claude/skills/

# Checker regression tests
bash tests/run.sh

# Lint
shellcheck -S warning $(git ls-files '*.sh')
python3 -m py_compile $(git ls-files '*.py')
```

## Architecture

Standard skill structure, payload isolated in one directory so it can be
copied straight into any agent's skills folder:

- `scientific-fa-translation-skill/SKILL.md` — the skill definition:
  frontmatter (`name`, `description`) plus locked defaults, workflow, and
  the quality gate. This is what loads when the skill triggers.
- `scientific-fa-translation-skill/references/` — detailed policy loaded
  on demand:
  - `terminology.md` — sole owner of the keep-English vs write-Persian
    decision procedure; `glossary.md` and `glossary-domains.md` hold the
    lists, `term-pairs.tsv` the machine-readable forbidden calques
  - `scientific-style.md` — register, orthography, mechanics
  - `rtl-bidi.md` — LTR isolation rules
  - `pdf-output.md` — engines, fonts, verification
  - `source-ingest.md` — fetching and extracting the source
  - `long-documents.md` — sectioning, resume, ambiguity queue
  - `review.md` — reviewing a finished translation
- `scientific-fa-translation-skill/scripts/` — executable helpers:
  `preflight.sh`, `check-fa.py`, `build-pdf.sh`, `prepare-figures.py`,
  `crop-source-figures.py`, `extract-pdf-pages.py`, `fetch-vazirmatn.sh`
- `scientific-fa-translation-skill/assets/` — `rtl-document.tex` and
  `rtl-document.html` print templates
- `tests/` — repo tooling, not shipped in the `.skill`; clean and
  deliberately broken fixtures that keep `check-fa.py` honest

`check-fa.py` resolves the house term list as `../references/term-pairs.tsv`
relative to itself, so `scripts/` and `references/` must stay siblings.

## Skill Design Principles

- `SKILL.md` stays short — it is loaded in full whenever the skill
  triggers; detail belongs in `references/`.
- The terminology policy has exactly one owner (`references/terminology.md`).
  Do not restate it in a second file.
- A new rule a machine could check belongs in `scripts/check-fa.py` with a
  fixture in `tests/fixtures/`, not only in prose. Run `bash tests/run.sh`
  after touching the checker or a fixture; pass `--level journal` when the
  fixture is a paper rather than a sysadmin guide.
- `SKILL.md` stays tool-neutral. Anything true of only one host tool
  belongs in that tool's repo-level file (`CLAUDE.md`, `AGENTS.md`, or the
  `.cursor/rules` entry).
- Paths in prose use `$HOME/...`, never `/home/<user>/...`, so the same
  instruction reads correctly on Linux, macOS, WSL, and Git Bash.
- Shell scripts assume a POSIX shell. On native Windows run them under
  WSL or Git Bash; PowerShell is not supported for the build loop.

## Known toolchain issue

The preferred `.tex`/XeLaTeX path can fail on TeX Live 2023: the shipped
`assets/rtl-document.tex` sets a Latin `\setdigitfont` (Western digits, by
design), which xepersian 25.0 rejects with `xepersian-mathdigitspec Error:
The font "TeX Gyre Termes" does not contain U+06F0`. Build via the HTML
path instead (`scripts/build-pdf.sh doc.html <slug> --verify`, Chromium
engine). Only touch the template's digit-font handling if the `.tex` path
itself is the task.
