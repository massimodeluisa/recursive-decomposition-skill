# Recursive Decomposition Skill Restructure Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Bring `massimodeluisa/recursive-decomposition-skill` to the same structure and quality bar as `massimodeluisa/nerdfonts-skill`: root plugin layout, trigger-based skill, restructured README with a social preview, house docs, CI validation, version 1.1.0.

**Architecture:** Docs-only repository. `skills/recursive-decomposition/SKILL.md` plus four references; root `.claude-plugin/plugin.json` and `marketplace.json` (`source: "./"`); root docs (README, AGENTS, CONVENTIONS, CONTRIBUTING, CHANGELOG, LICENSE); `assets/` with the social preview, its HTML source and two logo variants; `.github/` with a bash validator and a workflow (no Python, no Rust needed here).

**Tech Stack:** Markdown, JSON manifests, bash + jq for validation, GitHub Actions, `npx skills` CLI, `claude plugin` CLI.

**Spec:** Decisions approved in chat on 2026-08-28 (design summary in the "Global Constraints" below; the model repository is `~/Git/PersonalProjects/nerdfonts-skill`).

## Global Constraints

- Repository root: `/Users/massimodeluisa/Git/PersonalProjects/recursive-decomposition-skill` (git `main`, remote origin). Use absolute paths or `builtin cd`.
- Task 1 (layout move) is already done by another worker before Tasks 2 to 5 start: the skill lives at `skills/recursive-decomposition/`, manifests at the root, `CLAUDE.md` is a symlink to `AGENTS.md`, `plugins/` is gone.
- English only. No em dash (U+2014). No AI filler. Kebab-case file names, root docs `UPPERCASE.md`.
- Commits: `type: summary`, lowercase, imperative, subject only, no body, no trailers, never a `Co-Authored-By` line.
- No Python anywhere. Repository tooling is bash + jq.
- The skill name `recursive-decomposition` and the plugin name never change (skills.sh identity and existing marketplace installs depend on them).
- Version `1.1.0` in `.claude-plugin/plugin.json` (already set by Task 1) and in `SKILL.md` `metadata.version`.
- Do not push. The orchestrator pushes after the user validates.
- Paper facts must match the existing README and SKILL.md claims (arXiv 2512.24601; Zhang, Kraska, Khattab, 2025; 2^14 to 2^18 tokens; about 3x cheaper than summarisation baselines; benchmark table). Do not invent numbers.

---

### Task 2: `SKILL.md` rewrite and reference notes

**Files:**
- Modify: `skills/recursive-decomposition/SKILL.md` (replace entirely)
- Modify: `skills/recursive-decomposition/references/codebase-analysis.md` (add one note line)
- Modify: `skills/recursive-decomposition/references/document-aggregation.md` (add one note line)

**Interfaces:**
- Consumes: the four existing reference files (unchanged content).
- Produces: frontmatter `name: recursive-decomposition`, double-quoted single-line `description`, `metadata.version: "1.1.0"`; relative links `references/<file>.md` that the validator (Task 4) checks.

- [ ] **Step 1: Failing check**

Run: `grep -c '^description: "' skills/recursive-decomposition/SKILL.md`
Expected: `0` (the current description is unquoted and summarises the workflow).

- [ ] **Step 2: Replace `skills/recursive-decomposition/SKILL.md` with this exact content**

````markdown
---
name: recursive-decomposition
description: "Handle tasks that exceed the context window by decomposing them: size and filter the input, chunk it, run recursive sub-agents on independent parts, verify on small windows, and synthesise programmatically, following the Recursive Language Models (RLM) research by Zhang, Kraska and Khattab (2025). Use when a task spans 10+ files or 50k+ tokens, or when asked to analyze all files, process a large document, aggregate information from many sources, or search across a codebase. Triggers: long context, context rot, large codebase, many files, big document, multi-document, aggregate, summarize everything, codebase-wide, recursive, sub-agents, map-reduce."
license: MIT
metadata:
  author: massimodeluisa
  version: "1.1.0"
  paper: https://arxiv.org/abs/2512.24601
---

# Recursive Decomposition

Long inputs degrade model quality: details get missed, distant parts get linked by guesswork, reasoning drifts. The RLM paper calls it context rot. Instead of loading everything into the context window, treat the input as an environment you query with tools: size it, narrow it, split it, delegate independent parts to sub-agents, verify on small windows, and merge results programmatically. Based on [Recursive Language Models](https://arxiv.org/abs/2512.24601) (Zhang, Kraska, Khattab, 2025).

## How to use

- `/recursive-decomposition`: apply the protocol below to the current task.
- `/recursive-decomposition <path or question>`: size that input first, then run the protocol on it.

## When it applies

| Situation | Approach |
|-----------|----------|
| 10+ files, 50k+ tokens, or a multi-hop question across scattered sources | Decompose (this skill) |
| 30k to 50k tokens | Decompose when completeness matters; otherwise read directly |
| Under 30k tokens, one file, or a localized answer | Read directly |

## Protocol

1. **Size the input** before reading anything: count files (glob, `find`), lines (`wc -l`), bytes (`ls -lh`), pages for PDFs.
2. **Filter** the search space with searches (content search, file patterns, keywords, file types) before opening any file. Chain filters: file type, then keyword, then meaning.
3. **Chunk** what remains: natural units (functions, classes, sections), line ranges, or keyword partitions. Batches of 5 to 10 files.
4. **Recurse**: give each independent batch to a sub-agent with a self-contained brief (files, question, output schema); run batches in parallel.
5. **Verify** the synthesised answer on a smaller window: extract the minimal evidence and re-check it; settle disagreements with a targeted re-read.
6. **Synthesise programmatically**: aggregate the structured results, deduplicate, categorise, then write the answer with file and line references.

## Rules

- MUST size the input before reading it
- MUST search before reading a directory; NEVER list a tree recursively as a substitute for search
- MUST read large files by line range: over 2,000 lines or 50 KB never in one read; PDFs over 100 pages or 30 MB by metadata or split
- NEVER load more than 5 files into the main context without a written batch plan
- MUST give every sub-agent its own context: the files, the question, the output schema
- MUST spot-check the synthesised result against the sources before answering
- SHOULD read definitions first (`grep -n "function"`) and bodies later; tables of contents and abstracts before full text
- NEVER run the same query over the same content in several sub-agents; partition once into disjoint batches

## Tools, agent-agnostic

| Need | Use |
|------|-----|
| Find files | the file search or glob tool, or `find` |
| Find content | the content search or grep tool, never a full read |
| Size | `wc -l`, `ls -lh`, page count |
| Read | the file reader with an offset and a limit, or `sed -n 'START,ENDp'` |
| Delegate | the sub-agent or task tool, one brief per batch |
| Aggregate | a scratch file or structured notes, then one final pass |

Tool names differ between agents (Claude Code, Codex, Cursor, Gemini CLI); map the row to your agent's equivalent.

## Patterns

### Codebase analysis

"Find all error handling patterns." Glob the source files, grep `catch|throw|Error|except`, batch the matches by module (5 to 10 files), one sub-agent per batch with a fixed report schema, merge into a categorised summary with file references. Worked example: [references/codebase-analysis.md](references/codebase-analysis.md).

### Multi-document question answering

"What features are planned across all PRDs?" Glob the documents, size them, define an extraction schema (name, priority, status, quarter), one sub-agent per document group, deduplicate and categorise, spot-check three entries against the sources. Worked example: [references/document-aggregation.md](references/document-aggregation.md).

### Aggregation

"Summarise all TODO comments." Grep `TODO|FIXME|HACK`, group by module, extract context and priority per group, produce a prioritised list.

### Long output

Split the output into sections, generate each independently, store intermediate results in a file, stitch them with a coherence pass.

## Cost and quality

Decomposition spends coordination tokens and keeps quality: in the RLM paper, RLM runs were about 3x cheaper than summarisation baselines and scaled from 2^14 to 2^18 tokens with higher accuracy on multi-hop tasks. Thresholds and break-even: [references/cost-analysis.md](references/cost-analysis.md).

## Anti-patterns

| Anti-pattern | Fix |
|--------------|-----|
| Reading everything first "to get context" | Size, filter, then read by range |
| Decomposing a five-file task | Read directly |
| Sub-agents without the question or the schema | Self-contained briefs |
| Trusting the merged answer | Spot-check on a small window |
| Re-querying the same content in several sub-agents | Partition once, disjoint batches |

## References

- [references/rlm-strategies.md](references/rlm-strategies.md): decomposition strategies from the paper
- [references/cost-analysis.md](references/cost-analysis.md): when to decompose, break-even thresholds
- [references/codebase-analysis.md](references/codebase-analysis.md): worked example, error handling across a codebase
- [references/document-aggregation.md](references/document-aggregation.md): worked example, feature extraction across PRDs
- Paper: [Recursive Language Models](https://arxiv.org/abs/2512.24601), Zhang, Kraska, Khattab, arXiv:2512.24601
````

- [ ] **Step 3: Add the tool-name note to the two worked examples**

Insert as the third line (after the `# ...` title and its following blank line) of both `references/codebase-analysis.md` and `references/document-aggregation.md`, followed by a blank line:

```markdown
Tool calls below use Claude Code names (`Glob`, `Grep`, `Task`); map them to your agent's file search, content search and sub-agent tools.
```

- [ ] **Step 4: Check**

Run:
```bash
grep -c '^description: "' skills/recursive-decomposition/SKILL.md
wc -l skills/recursive-decomposition/SKILL.md
grep -c $'\xe2\x80\x94' skills/recursive-decomposition/SKILL.md skills/recursive-decomposition/references/*.md
grep -n -E "view_file|run_command|read_file" skills/recursive-decomposition/SKILL.md || echo NO_AGENT_SPECIFIC_TOOL_NAMES
```
Expected: `1`; a line count under 120; `0` for every file; `NO_AGENT_SPECIFIC_TOOL_NAMES`.

- [ ] **Step 5: Commit**

```bash
git add skills/recursive-decomposition
git commit -m "feat: rewrite skill with trigger description and agent-agnostic protocol"
```

---

### Task 3: Root documentation

**Files:**
- Modify: `README.md` (replace entirely)
- Modify: `AGENTS.md` (replace entirely; `CLAUDE.md` is a symlink to it)
- Create: `CONVENTIONS.md`
- Modify: `CONTRIBUTING.md` (replace entirely)
- Create: `CHANGELOG.md`

**Interfaces:**
- Consumes: asset file names decided in Task 5 (`assets/og.png`, `assets/logo-light.png`, `assets/logo-dark.png`), the validator command from Task 4 (`bash .github/scripts/validate-skill.sh`).
- Produces: the docs the validator checks for em dashes.

- [ ] **Step 1: Replace `README.md` with this exact content**

```markdown
<p align="center">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="assets/logo-dark.png">
    <img src="assets/logo-light.png" alt="Recursive Decomposition Skill" width="160">
  </picture>
</p>

<h1 align="center">Recursive Decomposition Skill</h1>

<p align="center">
  <strong>Decompose long-context tasks. Keep the context small.</strong><br />
  An <a href="https://agentskills.io">Agent Skill</a> for Claude Code, Codex, Cursor and compatible agents, based on the Recursive Language Models research
</p>

<p align="center">
  <a href="https://skills.sh/massimodeluisa/recursive-decomposition-skill"><img src="https://skills.sh/b/massimodeluisa/recursive-decomposition-skill" alt="skills.sh" /></a>
  <a href="https://arxiv.org/abs/2512.24601"><img src="https://img.shields.io/badge/arXiv-2512.24601-b31b1b?style=flat-square" alt="arXiv paper" /></a>
  <a href="LICENSE"><img src="https://img.shields.io/badge/License-MIT-green?style=flat-square" alt="MIT License" /></a>
  <a href="https://agentskills.io"><img src="https://img.shields.io/badge/Format-Agent_Skills-orange?style=flat-square" alt="Agent Skills format" /></a>
</p>

<p align="center">
  <a href="#install">Install</a> ·
  <a href="#usage">Usage</a> ·
  <a href="#how-it-works">How it works</a> ·
  <a href="#repository-structure">Structure</a> ·
  <a href="#acknowledgments">Acknowledgments</a>
</p>

<p align="center">
  <img src="assets/og.png" alt="Recursive Decomposition Skill: decompose long-context tasks, keep the context small" width="800" />
</p>

---

## The problem

Large codebases, dozens of documents, long reports: as the context grows, models miss details, link distant parts by guesswork and lose accuracy. The Recursive Language Models paper calls it context rot.

## What it does

When a task spans 10+ files or 50k+ tokens, the skill makes the agent treat the input as an environment to query instead of text to swallow:

1. **Size** the input before reading anything.
2. **Filter** the search space with searches, not reads.
3. **Chunk** what remains into batches of 5 to 10 files or natural units.
4. **Recurse** with one sub-agent per batch, each with a self-contained brief.
5. **Verify** the merged answer on a small window against the sources.
6. **Synthesise** programmatically, with file and line references.

Tested on the [Anthropic Cookbook](https://github.com/anthropics/anthropic-cookbook) (196 files): 142 files scanned, 18 with API calls, 8 patterns and 4 anti-patterns reported with file:line references.

## Install

With the [skills CLI](https://github.com/vercel-labs/skills):

```bash
npx skills add massimodeluisa/recursive-decomposition-skill
```

Add `-g` for a user-level install, `-a claude-code` (or another agent) to target one agent.

As a Claude Code plugin:

```bash
claude plugin marketplace add massimodeluisa/recursive-decomposition-skill
claude plugin install recursive-decomposition@recursive-decomposition-skill
```

Manual: copy `skills/recursive-decomposition` into `~/.claude/skills/` (or your agent's skills directory) and restart the agent.

## Usage

- `/recursive-decomposition` applies the protocol to the current task.
- `/recursive-decomposition src/` sizes that input first, then runs the protocol.

The skill also activates on its own for prompts like:

```text
Analyze error handling patterns across this entire codebase
Find all TODO comments in the project and categorize by priority
What API endpoints are defined across all route files?
Summarize the key decisions from all meeting notes in docs/
Find security issues across all Python files
```

## How it works

| Situation | Approach |
|-----------|----------|
| 10+ files, 50k+ tokens, or a multi-hop question across scattered sources | Decompose |
| 30k to 50k tokens | Decompose when completeness matters; otherwise read directly |
| Under 30k tokens, one file, or a localized answer | Read directly |

Results reported in the [paper](https://arxiv.org/abs/2512.24601):

| Task | Direct model | With RLM |
|------|--------------|----------|
| Multi-hop QA (6 to 11M tokens) | 70% | 91% |
| Linear aggregation | baseline | +28 to 33% |
| Quadratic reasoning | under 0.1% | 58% |
| Context scaling | 2^14 tokens | 2^18 tokens |

RLM runs were about 3x cheaper than summarisation baselines.

## Repository structure

```text
recursive-decomposition-skill/
├── .claude-plugin/          plugin.json, marketplace.json (the repo is the plugin)
├── .github/                 bash validator and CI workflow
├── skills/recursive-decomposition/
│   ├── SKILL.md             protocol, rules, patterns
│   └── references/          rlm-strategies, cost-analysis, codebase-analysis, document-aggregation
├── assets/                  social preview, logo (light and dark)
├── AGENTS.md · CONVENTIONS.md · CONTRIBUTING.md · CHANGELOG.md
└── LICENSE
```

## Acknowledgments

This skill is based on the **Recursive Language Models** paper. Thanks to the authors:

<table>
  <tr>
    <td align="center"><a href="https://x.com/a1zhang"><b>Alex L. Zhang</b></a><br><sub>MIT CSAIL</sub></td>
    <td align="center"><a href="https://x.com/tim_kraska"><b>Tim Kraska</b></a><br><sub>MIT</sub></td>
    <td align="center"><a href="https://x.com/lateinteraction"><b>Omar Khattab</b></a><br><sub>MIT CSAIL, creator of DSPy</sub></td>
  </tr>
</table>

> **Recursive Language Models**, Alex L. Zhang, Tim Kraska, Omar Khattab, arXiv:2512.24601, December 2025. [Abstract](https://arxiv.org/abs/2512.24601) · [PDF](https://arxiv.org/pdf/2512.24601)

This skill is an independent project and is not affiliated with the authors or MIT.

## Author

<p>
  <a href="https://x.com/massimodeluisa"><img src="https://img.shields.io/badge/X-@massimodeluisa-000000?style=flat-square&logo=x" alt="X" /></a>
  <a href="https://github.com/massimodeluisa"><img src="https://img.shields.io/badge/GitHub-massimodeluisa-181717?style=flat-square&logo=github" alt="GitHub" /></a>
</p>

**Massimo De Luisa**: [massimo.deluisa.bio](https://massimo.deluisa.bio)

## License

MIT, see [LICENSE](LICENSE).
```

- [ ] **Step 2: Replace `AGENTS.md` with this exact content**

```markdown
# Agents: recursive-decomposition skill

Entrypoint for agentic tooling working on this repository.

## Read these first (mandatory)

| Doc | Why |
|-----|-----|
| **[CONVENTIONS.md](./CONVENTIONS.md)** | Skill format, sources, prose, git, versioning, validation |
| **[CONTRIBUTING.md](./CONTRIBUTING.md)** | Change workflow |
| **[skills/recursive-decomposition/SKILL.md](./skills/recursive-decomposition/SKILL.md)** | The skill itself |
| **[CHANGELOG.md](./CHANGELOG.md)** | Release history |

Follow **CONVENTIONS.md** for every change. This file is a short checklist only. `CLAUDE.md` is a symlink to this file.

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
npx -y skills@latest add . -l
claude plugin validate .
```
```

- [ ] **Step 3: Create `CONVENTIONS.md` with this exact content**

```markdown
# CONVENTIONS: recursive-decomposition skill

Mandatory rules for humans and agents working on this repository. When any other document disagrees, this file wins.

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
npx -y skills@latest add . -l
claude plugin validate .
```

Expected: the validator prints `OK`, the skills CLI lists exactly one skill (`recursive-decomposition`), the plugin validator passes. CI runs the first two on every push.

---

## 9. Safety

- The skill never instructs destructive operations; it reads, searches and delegates.
- Sub-agent briefs must not leak secrets from the files they read into summaries.
```

- [ ] **Step 4: Replace `CONTRIBUTING.md` with this exact content**

```markdown
# Contributing

Thanks for improving the `recursive-decomposition` skill.

> Rules live in [CONVENTIONS.md](./CONVENTIONS.md). Agent entrypoint: [AGENTS.md](./AGENTS.md).

## Before you start

1. Read CONVENTIONS.md.
2. Branch from an up-to-date `main`: `fix/...`, `feat/...`, `docs/...`.
3. Confirm the toolchain: bash, jq, Node 22 (`npx`), `claude` CLI (optional, for `claude plugin validate`).

## What to contribute

| Welcome | Needs an issue first |
|---------|----------------------|
| Corrections that cite the paper or a reproducible test | Changing the protocol or the thresholds |
| New worked examples under `references/` | Adding executable scripts to the skill |
| Shorter, clearer wording | Splitting the skill into several skills |
| Agent-specific notes that stay out of the skill body | Non-English content |

## Verify

```bash
bash .github/scripts/validate-skill.sh
npx -y skills@latest add . -l
claude plugin validate .
```

## Pull request

- One topic per PR.
- English description: what changed and the source of every new claim.
- CI must be green.

## License

Contributions are licensed under the repository [MIT license](./LICENSE).
```

- [ ] **Step 5: Create `CHANGELOG.md` with this exact content**

```markdown
# Changelog

All notable changes to this project are documented here. The format follows [Keep a Changelog 1.1.0](https://keepachangelog.com/en/1.1.0/) and versions follow [Semantic Versioning](https://semver.org/).

## [Unreleased]

## [1.1.0] - 2026-08-28

### Added

- Added the skills CLI install path, the bash validator and the GitHub Actions workflow.
- Added CONVENTIONS.md, CHANGELOG.md and a short AGENTS.md; CLAUDE.md is now a symlink to it.
- Added the social preview image, its HTML source and light and dark logo variants under assets/.

### Changed

- Moved the skill to the root plugin layout: `skills/recursive-decomposition/` with the plugin manifest at the repository root.
- Rewrote SKILL.md with a trigger-based description, a six-step protocol, rules and agent-agnostic tool names.
- Restructured the README around install, usage, how it works and acknowledgments.

### Removed

- Removed the `plugins/` directory and the plugin README.

## [1.0.1] - 2026-01-25

### Fixed

- Corrected the skill structure and the YAML frontmatter.

## [1.0.0] - 2026-01-16

### Added

- Initial release of the recursive-decomposition skill and its references.
```

- [ ] **Step 6: Check**

Run: `grep -c $'\xe2\x80\x94' README.md AGENTS.md CONVENTIONS.md CONTRIBUTING.md CHANGELOG.md; readlink CLAUDE.md; grep -n -i python README.md AGENTS.md CONVENTIONS.md CONTRIBUTING.md CHANGELOG.md`
Expected: `0` for each file, `AGENTS.md`, and only the line in README example prompts ("all Python files") plus the "no Python" rule lines.

- [ ] **Step 7: Commit**

```bash
git add README.md AGENTS.md CONVENTIONS.md CONTRIBUTING.md CHANGELOG.md
git commit -m "docs: restructure readme and add house docs"
```

---

### Task 4: Bash validator and CI workflow

**Files:**
- Create: `.github/scripts/validate-skill.sh`
- Create: `.github/workflows/validate.yml`

**Interfaces:**
- Consumes: `skills/recursive-decomposition/SKILL.md`, `.claude-plugin/*.json`, root docs.
- Produces: `bash .github/scripts/validate-skill.sh` prints `OK` and exits 0, or `ERROR: ...` lines and exits 1.

- [ ] **Step 1: Create `.github/scripts/validate-skill.sh`**

```bash
#!/usr/bin/env bash
# Validates the recursive-decomposition skill tree: frontmatter, size, links, manifests, prose.
set -u

root="$(cd "$(dirname "$0")/../.." && pwd)"
skill_dir="$root/skills/recursive-decomposition"
skill="$skill_dir/SKILL.md"
errors=0

fail() {
  printf 'ERROR: %s\n' "$1"
  errors=$((errors + 1))
}

if [ ! -f "$skill" ]; then
  fail "skills/recursive-decomposition/SKILL.md: missing"
else
  name="$(sed -n 's/^name: //p' "$skill" | head -1)"
  [ "$name" = "recursive-decomposition" ] || fail "SKILL.md: name must be recursive-decomposition (got '$name')"
  description="$(sed -n 's/^description: //p' "$skill" | head -1)"
  [ -n "$description" ] || fail "SKILL.md: description missing"
  case "$description" in
    \"*\") ;;
    *) fail "SKILL.md: description must be one double-quoted line" ;;
  esac
  length="$(printf '%s' "$description" | wc -m | tr -d ' ')"
  [ "$length" -le 1026 ] || fail "SKILL.md: description is $length chars, limit 1024"
  lines="$(wc -l < "$skill" | tr -d ' ')"
  [ "$lines" -lt 500 ] || fail "SKILL.md: $lines lines, must stay under 500"
  skill_version="$(sed -n 's/^  version: "\(.*\)"$/\1/p' "$skill" | head -1)"
  grep -o '\]([^)]*)' "$skill" | sed 's/^](//; s/)$//' | grep -v -E '^(https?://|#|mailto:)' | while read -r link; do
    [ -e "$skill_dir/${link%%#*}" ] || printf 'ERROR: SKILL.md: broken link %s\n' "$link"
  done | tee /tmp/validate-links.txt
  if [ -s /tmp/validate-links.txt ]; then errors=$((errors + $(wc -l < /tmp/validate-links.txt))); fi
fi

for manifest in "$root/.claude-plugin/plugin.json" "$root/.claude-plugin/marketplace.json"; do
  if [ ! -f "$manifest" ]; then
    fail "${manifest#"$root"/}: missing"
  elif ! jq . "$manifest" > /dev/null 2>&1; then
    fail "${manifest#"$root"/}: invalid JSON"
  fi
done
if [ -f "$root/.claude-plugin/plugin.json" ] && [ -f "$root/.claude-plugin/marketplace.json" ]; then
  plugin_name="$(jq -r '.name' "$root/.claude-plugin/plugin.json")"
  [ "$plugin_name" = "recursive-decomposition" ] || fail "plugin.json: name must be recursive-decomposition"
  plugin_version="$(jq -r '.version' "$root/.claude-plugin/plugin.json")"
  [ "${skill_version:-}" = "" ] || [ "$skill_version" = "$plugin_version" ] || fail "SKILL.md metadata.version ($skill_version) and plugin.json version ($plugin_version) differ"
  source="$(jq -r '.plugins[0].source' "$root/.claude-plugin/marketplace.json")"
  [ "$source" = "./" ] || fail "marketplace.json: plugins[0].source must be ./"
  entries="$(jq '.plugins | length' "$root/.claude-plugin/marketplace.json")"
  [ "$entries" = "1" ] || fail "marketplace.json: exactly one plugin entry expected"
  [ "$(jq '.plugins[0] | has("version")' "$root/.claude-plugin/marketplace.json")" = "false" ] || fail "marketplace.json: the plugin entry must not pin a version"
fi

for doc in "$root"/README.md "$root"/AGENTS.md "$root"/CONVENTIONS.md "$root"/CONTRIBUTING.md "$root"/CHANGELOG.md "$skill" "$skill_dir"/references/*.md; do
  [ -f "$doc" ] || continue
  if grep -q $'\xe2\x80\x94' "$doc"; then fail "${doc#"$root"/}: contains an em dash (U+2014)"; fi
done

if [ "$errors" -gt 0 ]; then
  exit 1
fi
printf 'OK\n'
```

Make it executable: `chmod +x .github/scripts/validate-skill.sh`.

- [ ] **Step 2: Run it**

Run: `bash .github/scripts/validate-skill.sh; echo "exit=$?"`
Expected: `OK` and `exit=0` once Tasks 2 and 3 are in place; otherwise one `ERROR:` line per problem.

- [ ] **Step 3: Create `.github/workflows/validate.yml`**

```yaml
name: validate

on:
  push:
  pull_request:

jobs:
  validate:
    runs-on: ubuntu-latest
    env:
      DISABLE_TELEMETRY: "1"
    steps:
      - uses: actions/checkout@v7
      - uses: actions/setup-node@v7
        with:
          node-version: 22
      - name: Validate skill files
        run: bash .github/scripts/validate-skill.sh
      - name: Discover the skill with the skills CLI
        run: |
          npx -y skills@latest add . -l 2>&1 | tee discovery.log
          grep -q "recursive-decomposition" discovery.log
```

- [ ] **Step 4: Commit**

```bash
git add .github
git commit -m "ci: add skill validation script and workflow"
```

---

### Task 5: Assets

**Files:**
- Create: `assets/og.png`, `assets/og.html`, `assets/logo-light.png`, `assets/logo-dark.png`
- Delete: `assets/logo.png`

**Interfaces:**
- Consumes: rendered files prepared by the orchestrator in `/tmp/nf-brand/`: `og-rd.png` (1280x640), `og-rd.html`, `rd-logo-light.png`, `rd-logo-dark.png` (440x440, transparent).
- Produces: the file names the README (Task 3) references.

- [ ] **Step 1: Copy and rename**

```bash
cp /tmp/nf-brand/og-rd.png assets/og.png
cp /tmp/nf-brand/rd-logo-light.png assets/logo-light.png
cp /tmp/nf-brand/rd-logo-dark.png assets/logo-dark.png
cp /tmp/nf-brand/og-rd.html assets/og.html
git rm -q assets/logo.png
```

- [ ] **Step 2: Fix the HTML source**

In `assets/og.html`: replace `file:///tmp/nf-brand/rd-logo-dark.png` with `logo-dark.png`, and prepend as the first line: `<!-- Social preview source. Render from the repository root with: "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" --headless=new --disable-gpu --hide-scrollbars --force-device-scale-factor=2 --window-size=1280,640 --screenshot=/tmp/og-2x.png "file://$PWD/assets/og.html" && magick /tmp/og-2x.png -resize 50% -strip assets/og.png. Needs the Geist, Geist Mono and MesloLGM Nerd Font families installed. Glyphs in the bottom strip are Nerd Fonts icons (see nerdfonts.com). -->`

- [ ] **Step 3: Check**

Run: `magick identify assets/og.png assets/logo-light.png assets/logo-dark.png | cut -d' ' -f1-3; grep -c 'file:///' assets/og.html; ls assets`
Expected: `assets/og.png PNG 1280x640`, both logos `PNG 440x440`, `0`, and the four files only.

- [ ] **Step 4: Commit**

```bash
git add assets
git commit -m "docs: add social preview and logo variants"
```

---

### Task 6: Verify

- `bash .github/scripts/validate-skill.sh` prints `OK`.
- `npx -y skills@latest add . -l` prints `Found 1 skill` and `recursive-decomposition`.
- `claude plugin validate .` passes.
- `git status --short` is empty; `git log --oneline` shows the Task 1 to 5 commits on top of `1780d46`.
- The orchestrator reviews the README and pushes after the user validates.
