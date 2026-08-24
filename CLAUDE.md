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
# Package the skill from the committed tree, so a fetched fonts/
# directory, a stray build artefact, or a CRLF working copy cannot
# end up inside the .skill.
git archive --format=zip -o scientific-fa-translation-skill.skill \
  HEAD scientific-fa-translation-skill

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
- `scientific-fa-translation-skill/scripts/` — executable helpers.
  `preflight`, `build-pdf`, and `fetch-vazirmatn` exist twice, as `.sh`
  and `.ps1` with the same name and the same behaviour; `check-fa.py`,
  `prepare-figures.py`, `crop-source-figures.py`, and
  `extract-pdf-pages.py` are cross-platform Python and are not duplicated.
  A behaviour change to one shell script must land in its twin in the same
  commit, or the two platforms drift.
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
- The `.sh` scripts assume a POSIX shell; the `.ps1` twins must run on
  **both** Windows PowerShell 5.1 and PowerShell 7.x. Do not use
  PowerShell-7-only syntax (`??`, ternaries, `ForEach-Object -Parallel`),
  and keep every `.ps1` pure ASCII — 5.1 decodes a BOM-less script with the
  system ANSI code page, where a UTF-8 em dash becomes a curly quote that
  terminates a string and breaks the parse. CI enforces both.
- Route every native-command call in a `.ps1` through its `Invoke-Tool`
  helper, and hand it a resolved path from `Get-Tool`, never a bare name.
  Three traps make a bare call unsafe: on 5.1 `2>&1` turns native stderr
  into `ErrorRecord`s that honour `$ErrorActionPreference`; a session that
  sets `$PSNativeCommandUseErrorActionPreference` (7.3+) makes a non-zero
  exit code throw; and command discovery can resolve a name to an alias or
  cmdlet, leaving `$LASTEXITCODE` stale. See `references/pdf-output.md`.
- `tests/run.sh` is POSIX-only — on Windows run it under WSL or Git Bash.

## Known toolchain issue

The preferred `.tex`/XeLaTeX path can fail on TeX Live 2023: the shipped
`assets/rtl-document.tex` sets a Latin `\setdigitfont` (Western digits, by
design), which xepersian 25.0 rejects with `xepersian-mathdigitspec Error:
The font "TeX Gyre Termes" does not contain U+06F0`. Build via the HTML
path instead (`scripts/build-pdf.sh doc.html <slug> --verify`, Chromium
engine). Only touch the template's digit-font handling if the `.tex` path
itself is the task.

A variable font cannot be selected by family name. Windows normally has
Vazirmatn installed as `Vazirmatn-VariableFont_wght.ttf`; XeTeX then hands
the driver a named instance, which `xdvipdfmx` refuses with `Invalid TTC
index` and `dvipdfmx:fatal: Invalid font: -1 (4)`. The same file loaded by
*path* embeds fine, so run `fetch-vazirmatn` in the document's own
directory before the `.tex` build and let the template pick up
`fonts/Vazirmatn-Regular.ttf`.
