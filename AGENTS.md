# AGENTS.md

Guidance for Codex and any other agent working **on** this repository.
The skill's own instructions are in
`scientific-fa-translation-skill/SKILL.md`; do not restate them here, so
there is one place to change them.

## Project Overview

This repository packages a single agent skill: English → academic Persian
(Farsi) translation of papers, articles, books, and technical
documentation, with print-ready RTL output. The same skill directory
installs into Codex, Claude Code, and Cursor unchanged.

## Build Commands

```bash
# Package the skill (creates the .skill zip)
zip -r scientific-fa-translation-skill.skill \
  scientific-fa-translation-skill -x "*.DS_Store" -x "*__pycache__*"

# Install to the Codex skills directory
cp -r scientific-fa-translation-skill ~/.codex/skills/

# Checker regression tests
bash tests/run.sh

# Lint
shellcheck -S warning $(git ls-files '*.sh')
python3 -m py_compile $(git ls-files '*.py')
```

Every agent uses the same layout, one level deep:

```text
~/.codex/skills/scientific-fa-translation-skill/SKILL.md
~/.claude/skills/scientific-fa-translation-skill/SKILL.md
~/.cursor/skills/scientific-fa-translation-skill/SKILL.md
```

Copy the `scientific-fa-translation-skill/` **directory**, not the repo
root — the repo root also carries `tests/`, CI, and these guidance files,
which are not part of the skill. The frontmatter `name` must keep matching
the directory name.

## Architecture

- `scientific-fa-translation-skill/SKILL.md` — the skill definition:
  frontmatter (`name`, `description`) plus locked defaults, workflow, and
  the quality gate. Loaded in full whenever the skill triggers.
- `scientific-fa-translation-skill/references/` — detailed policy loaded
  on demand. `terminology.md` is the sole owner of the keep-English vs
  write-Persian decision procedure; `glossary.md` and
  `glossary-domains.md` hold the lists, `term-pairs.tsv` the
  machine-readable forbidden calques. Then `scientific-style.md`
  (register, orthography), `rtl-bidi.md` (isolation), `pdf-output.md`
  (engines, fonts, verification), `source-ingest.md` (fetching the
  source), `long-documents.md` (sectioning, resume, ambiguity queue),
  `review.md` (reviewing a finished translation).
- `scientific-fa-translation-skill/scripts/` — `preflight`, `build-pdf`,
  and `fetch-vazirmatn` exist twice, as `.sh` and `.ps1` with the same
  name and the same behaviour; `check-fa.py`, `prepare-figures.py`,
  `crop-source-figures.py`, and `extract-pdf-pages.py` are cross-platform
  Python and are not duplicated. A behaviour change to one shell script
  must land in its twin in the same commit, or the two platforms drift.
- `scientific-fa-translation-skill/assets/` — `rtl-document.tex` and
  `rtl-document.html` print templates
- `tests/` — repo tooling, not shipped in the `.skill`

`check-fa.py` resolves the house term list as `../references/term-pairs.tsv`
relative to itself, so `scripts/` and `references/` must stay siblings.

## Working on the skill itself

- The terminology policy has one owner: `references/terminology.md`. Do
  not restate it in a second file.
- A new rule that a machine could check belongs in `scripts/check-fa.py`
  with a fixture in `tests/fixtures/`, not only in prose. Run
  `bash tests/run.sh` after touching the checker or a fixture. Pass
  `--level journal` when the fixture is a paper, not a sysadmin guide.
- Keep `SKILL.md` short; detail belongs in `references/`.
- `SKILL.md` must stay tool-neutral. Anything true of only one host tool
  belongs in that tool's repo-level file (`AGENTS.md`, `CLAUDE.md`, or the
  `.cursor/rules` entry), not in the shared policy.
- Paths in prose use `$HOME/...`, never `/home/<user>/...`, so the same
  instruction reads correctly on Linux, macOS, WSL, and Git Bash.
- Re-run the packaging command after changing anything under
  `scientific-fa-translation-skill/`, so the committed `.skill` does not
  go stale.

## Dev loop

This repo is tooling for a skill, not a running service. The loop is
lint → test → build a PDF; there is nothing to keep running.

- Lint / test / build commands are above and in `.github/workflows/ci.yml`;
  use those rather than reinventing them. The deliverable is built with
  `scientific-fa-translation-skill/scripts/build-pdf.sh <file.tex|file.html>
  <slug> --verify` after `scripts/check-fa.py <file> --strict`. Run
  `scripts/preflight.sh` to see which engines/fonts/tools the machine has.
- No repository-level package deps: everything is Python 3 stdlib or
  system packages baked into the environment (`shellcheck`,
  `python3-pil`/Pillow, `poppler-utils`, `fonts-vazirmatn`,
  `texlive-xetex` + `texlive-lang-arabic` for xepersian, `latexmk`,
  `google-chrome`). Any boot-time update script is intentionally a no-op.
- The `.sh` scripts assume a POSIX shell; the `.ps1` twins target
  PowerShell 5.1, so they run in the shell that ships with Windows. Do not
  use PowerShell-7-only syntax (`??`, ternaries, `ForEach-Object
  -Parallel`). `tests/run.sh` is POSIX-only — on Windows run it under WSL
  or Git Bash.

## Known toolchain issue (also seen on Cursor Cloud)

- The preferred `.tex`/XeLaTeX path can fail on TeX Live 2023 — a
  toolchain mismatch, not a missing dependency. The shipped
  `assets/rtl-document.tex` sets a Latin `\setdigitfont` (Western digits,
  by design), which xepersian 25.0 rejects with
  `xepersian-mathdigitspec Error: The font "TeX Gyre Termes" does not
  contain U+06F0`. Build via the documented HTML path instead
  (`scripts/build-pdf.sh doc.html <slug> --verify`, Chromium engine) to
  produce a print-ready RTL PDF. Only touch the template's digit-font
  handling if the `.tex` path itself is the task.
- Headless `google-chrome` prints harmless `dbus`/`UPower` errors to
  stderr in a container; the PDF is still written — look for the
  "bytes written to file …" line, not the noise.
- `scripts/fetch-vazirmatn.sh fonts/` reuses the installed Vazirmatn
  system face offline (no network needed) to drop the TTFs beside an
  HTML build. `--verify` rasterises sample pages to PNG; judge RTL from
  those images, never from `pdftotext`.
- A page-range PDF is `scripts/extract-pdf-pages.py in.pdf out.pdf 1-20`
  after the full build. Never loop `insert_pdf` per page — that
  duplicates XObjects and explodes file size.
