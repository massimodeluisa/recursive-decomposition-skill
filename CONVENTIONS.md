# CONVENTIONS: recursive-decomposition skill

Rules for this repository. When another document disagrees, this file wins.

Related: [AGENTS.md](./AGENTS.md), [CONTRIBUTING.md](./CONTRIBUTING.md), [skills/recursive-decomposition/SKILL.md](./skills/recursive-decomposition/SKILL.md), [CHANGELOG.md](./CHANGELOG.md), [LICENSE](./LICENSE).

---

## 1. Language

- Everything in this repository is English: Markdown, manifests, commit messages, PR titles.

---

## 2. Skill format

The skill follows the [Agent Skills specification](https://agentskills.io/specification) and the discovery rules of the [skills CLI](https://github.com/vercel-labs/skills).

| Rule | Value |
|------|-------|
| Skill directory | `skills/recursive-decomposition/` (the directory name equals the frontmatter `name`) |
| `name` | `recursive-decomposition`: lowercase letters, digits, single hyphens, 64 chars max; never changes |
| `description` | One line, double-quoted, 1 to 1024 chars, says what the skill does and when to use it, ends with a `Triggers:` list; never summarises the workflow |
| Body | Under 500 lines; rules as short `MUST / SHOULD / NEVER` bullets; tables for decisions; agent-agnostic tool names |
| References | One level deep in `references/`, linked with relative paths from `SKILL.md` |
| Executable code | None. Repository tooling is bash + jq under `.github/scripts/` |
| Plugin manifests | `.claude-plugin/plugin.json` (name, version, description, author, license, keywords) and `.claude-plugin/marketplace.json` with a single entry `source: "./"` and no `version` field |

---

## 3. Sources

- Every claim about the method or its results cites the paper: Zhang, Kraska, Khattab, Recursive Language Models, arXiv:2512.24601 (2025).
- Numbers appear only with their source; a number without a source is a bug.
- Worked examples may use Claude Code tool names when they say so; the skill body stays agent-agnostic.

---

## 4. Prose

- No em dash (U+2014). Use commas, colons, or periods.
- No filler: "seamless", "robust", "leverage", "not only... but also", "it's important to note".
- Terse. Tables for decisions, numbered steps for procedures, one idea per bullet.
- Code blocks are runnable as written.

---

## 5. File naming

- Markdown files: `kebab-case.md`. Root policy docs: `UPPERCASE.md`.
- Plans and specs: `docs/superpowers/{plans,specs}/YYYY-MM-DD-<slug>.md`.

---

## 6. Git and changelog

- Commits: `type: summary`, lowercase, imperative, subject only. No body, no trailers, never `Co-Authored-By` or any LLM attribution. Types: `feat`, `fix`, `chore`, `refactor`, `docs`, `ci`.
- One logical change per commit.
- `CHANGELOG.md` follows [Keep a Changelog 1.1.0](https://keepachangelog.com/en/1.1.0/) with `### Added`, `### Changed`, `### Removed`, `### Fixed`. Work accumulates under `## [Unreleased]`, one short past-simple line per commit, until a release moves it under a version heading.
- No force-push to `main`. No secrets in the repository.

---

## 7. Versioning

- SemVer. The version lives in `.claude-plugin/plugin.json` and in `metadata.version` of `SKILL.md`; both change together. The marketplace entry carries no version so `plugin.json` wins.
- Bump on every user-visible change: patch for wording, minor for new sections or references, major for a changed protocol.

---

## 8. Validation checklist

Run before every commit that touches the skill:

```bash
bash .github/scripts/validate-skill.sh
bash .github/scripts/eval-skill.sh check
npx -y skills@latest add . -l
claude plugin validate .
```

Expected: the validator prints `OK`, the skills CLI lists exactly one skill (`recursive-decomposition`), the plugin validator passes. CI runs the first two on every push.

---

## 9. Safety

- The skill never instructs destructive operations; it reads, searches and delegates.
- Sub-agent briefs must not leak secrets from the files they read into summaries.
