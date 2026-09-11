# Agents: recursive-decomposition skill

Start here when an agent edits this repository.

## Read these first (mandatory)

| Doc | Why |
|-----|-----|
| [CONVENTIONS.md](./CONVENTIONS.md) | Skill format, sources, prose, git, versioning, validation |
| [CONTRIBUTING.md](./CONTRIBUTING.md) | Change workflow |
| [skills/recursive-decomposition/SKILL.md](./skills/recursive-decomposition/SKILL.md) | The skill itself |
| [CHANGELOG.md](./CHANGELOG.md) | Release history |

Follow CONVENTIONS.md for every change. This file is a short checklist only. `CLAUDE.md` is a symlink to this file.

## Language policy

- Markdown, manifests, commits: English only.

## Non-negotiables

1. Every number or claim about the paper cites arXiv:2512.24601; nothing invented.
2. `SKILL.md` stays under 500 lines with a single-line, double-quoted description.
3. The skill name and the plugin name never change.
4. Bump `version` in `.claude-plugin/plugin.json` and `SKILL.md` together on every user-visible change.
5. No em dash, no filler, no co-author trailers, no Python.

## Commands

```bash
bash .github/scripts/validate-skill.sh
bash .github/scripts/eval-skill.sh check
npx -y skills@latest add . -l
claude plugin validate .
```
