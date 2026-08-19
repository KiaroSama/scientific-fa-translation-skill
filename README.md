# skills

Personal [Cursor Agent Skills](https://cursor.com/docs/skills). Clone this
repository to `~/.cursor/skills` so every folder that contains a `SKILL.md`
is discovered automatically.

```bash
git clone git@github.com:isArman/skills.git ~/.cursor/skills
```

If that path already exists, add this repo as a remote there or merge the
contents. After `git pull`, reload Cursor or type `/scientific-fa-translation`
in Agent chat to confirm the skill is visible.

Each skill is a directory named after its `name` frontmatter field. Cursor
walks `~/.cursor/skills` recursively; keep `SKILL.md` in the skill folder,
not at the repo root.

## Skills

| Skill | Invoke | Purpose |
| --- | --- | --- |
| [scientific-fa-translation](scientific-fa-translation/SKILL.md) | `/scientific-fa-translation` | Academic English → Persian translation; print PDF with precise RTL at `~/Documents/books` |

### scientific-fa-translation

Translates papers, articles, books, and technical documentation into
formal scientific Persian. Cursor chat is only a short status note plus
the output path. It is not the RTL surface.

**Deliverable.** A printable PDF at `~/Documents/books/<slug>.pdf`,
created if needed. Preferred engine: XeLaTeX + `xepersian`
(`assets/rtl-document.tex`). Fallback: Chromium print of the RTL HTML
template. HTML is produced only when asked for, or as that fallback.

**Keep English** (LTR-isolated; no فرهنگستان coinages):

- Algorithm, library, protocol, and product names
- Acronyms such as `API`, `PCR`, `GPU`, `CI`
- Formulas, code, units, and statistics (`p`, `n`, `SD`)
- People’s names, journal names, and DOIs

**Write in Persian** (do not leave these in English):

- Verbs and sentence structure
- General scholarly words (روش، نتایج، بررسی)
- Section titles (مقدمه، بحث)
- Conceptual explanation for the reader

**Also locked:** Western digits; figure labels like `شکل 3`; source
images unchanged (no mirroring or redrawing); code blocks always LTR
and left-aligned; bibliography not translated; ask on scientific
ambiguity.

Layout:

```text
scientific-fa-translation/
  SKILL.md
  assets/rtl-document.tex
  assets/rtl-document.html
  references/scientific-style.md
  references/rtl-bidi.md
  references/pdf-output.md
  references/glossary.md
  scripts/build-pdf.sh
```

## License

MIT. See [LICENSE](LICENSE).
