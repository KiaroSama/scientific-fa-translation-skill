# Skills

This repository is a Cursor personal-skills tree. Each skill is a top-level
folder (`<name>/SKILL.md`). It is usually cloned as `~/.cursor/skills`
itself; a clone elsewhere is installed with `./skills-install.sh`, which
symlinks each skill in. Cursor only looks one level deep, so a skill at
`~/.cursor/skills/<repo>/<skill>/` or under a nested `.cursor/skills/` is
invisible — `./skills-install.sh --check` reports that.

When the user wants to translate a paper, article, book, or technical
document into scientific Persian — or asks for RTL, چاپ, or a PDF, or asks
whether a finished Persian translation follows the rules — read and follow
`scientific-fa-translation/SKILL.md` before producing output. Do this even if
`/scientific-fa-translation` is missing from the slash menu.

Do not use that skill for coding, commits, UI copy, or casual chat.

## Working on the skills themselves

- The terminology policy has one owner:
  `scientific-fa-translation/references/terminology.md`. Lists live in
  `glossary.md` and `glossary-domains.md`; forbidden Persian calques live in
  `references/term-pairs.tsv`. Do not restate the policy in a second file.
- A new rule that a machine could check belongs in
  `scripts/check-fa.py` with a fixture in `tests/fixtures/`, not only in
  prose. Run `bash scientific-fa-translation/tests/run.sh` after touching
  the checker or a fixture.
- Keep `SKILL.md` short. It is loaded in full whenever the skill triggers;
  detail belongs in `references/`.
