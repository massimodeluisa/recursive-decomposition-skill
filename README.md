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
