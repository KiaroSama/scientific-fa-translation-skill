# skills

Personal [Cursor Agent Skills](https://cursor.com/docs/skills). Clone this
repository **outside** `~/.cursor/skills`, then symlink each skill in.

Do **not** clone this repo into `~/.cursor/skills`. That nests the skill
at `~/.cursor/skills/.cursor/skills/…`, which is not the personal-skill
path Cursor expects.

```bash
git clone git@github.com:isArman/skills.git ~/Desktop/skills
mkdir -p ~/.cursor/skills
ln -s ~/Desktop/skills/.cursor/skills/scientific-fa-translation \
      ~/.cursor/skills/scientific-fa-translation
```

That yields the normal path:
`~/.cursor/skills/scientific-fa-translation/SKILL.md`.

To edit the skill, open `~/Desktop/skills` as the Cursor workspace
(project skills still live under `.cursor/skills/`). In Agent chat,
ask to translate (or type `/scientific-fa-translation`). If the slash
menu is empty — common on Cloud Agent follow-ups — write it in prose:
“use the scientific-fa-translation skill”.

After `git pull` on a new machine, start a **new** Agent on branch
`main`. Follow-ups in an already-running Cloud Agent do not reliably
reload project skills.

## Skills

| Skill | Invoke | Purpose |
| --- | --- | --- |
| [scientific-fa-translation](.cursor/skills/scientific-fa-translation/SKILL.md) | `/scientific-fa-translation` | Academic English → Persian translation; print PDF with precise RTL at `~/Documents/books` |

### scientific-fa-translation

Translates papers, articles, books, and technical documentation into
formal scientific Persian. Cursor chat is only a short status note plus
the output path. It is not the RTL surface.

**Deliverable.** A printable PDF at `~/Documents/books/<slug>.pdf`,
created if needed. Preferred engine: XeLaTeX + `xepersian`
(`assets/rtl-document.tex`). Fallbacks: Chromium print of the RTL HTML
template, then WeasyPrint on the same HTML. HTML is produced only when
asked for, or as that fallback. Embed Vazirmatn Regular/Bold (not UI-FD)
via `@font-face` when the font is not installed on the system.

**Keep English** (LTR-isolated; no فرهنگستان coinages):

- Algorithm, library, protocol, and product names
- Acronyms such as `API`, `PCR`, `GPU`, `CI`
- Domain terms of art, including one-word field nouns and their
  operation verbs (`node`, `deployment`, `configure` — not گره /
  استقرار / پیکربندی)
- Multi-word technical collocations as one English unit (no calque,
  no half-translation: `Kubernetes cluster`, not «خوشه Kubernetes»;
  `OpenStack services`, not «سرویس‌های OpenStack»)
- Formulas, code, units, and statistics (`p`, `n`, `SD`)
- People’s names, journal names, and DOIs

**Write in Persian** (do not leave these in English):

- Narrative verbs and sentence structure (not `configure` / `implement`
  when those are the field operations)
- General scholarly words (روش، نتایج، بررسی) when they are not field
  terms of art
- Generic section titles (مقدمه، بحث)
- Domain headings that are names or collocations stay English
  (`The OpenStack services`, not «سرویس‌های OpenStack»)
- Conceptual explanation for the reader

**Also locked:** Western digits; figure labels like `شکل 3`; source
images unchanged (no mirroring or redrawing); code blocks always LTR
and left-aligned; bibliography not translated; ask on scientific
ambiguity.

Layout:

```text
.cursor/skills/scientific-fa-translation/
  SKILL.md
  assets/rtl-document.tex
  assets/rtl-document.html
  references/scientific-style.md
  references/rtl-bidi.md
  references/pdf-output.md
  references/glossary.md
  scripts/build-pdf.sh
  scripts/fetch-vazirmatn.sh
```

## License

MIT. See [LICENSE](LICENSE).
