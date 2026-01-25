<p align="center">
  <img src="assets/logo.png" alt="Recursive Decomposition Skill" width="200">
</p>

<h1 align="center">Recursive Decomposition Skill</h1>

<p align="center">
  <strong>Handle long-context tasks with Claude Code through recursive decomposition</strong>
</p>

<p align="center">
  <a href="#installation"><img src="https://img.shields.io/badge/Claude_Code-Plugin-blueviolet?style=flat-square" alt="Claude Code Plugin"></a>
  <a href="https://arxiv.org/abs/2512.24601"><img src="https://img.shields.io/badge/arXiv-2512.24601-b31b1b?style=flat-square" alt="arXiv Paper"></a>
  <a href="LICENSE"><img src="https://img.shields.io/badge/License-MIT-green?style=flat-square" alt="MIT License"></a>
  <a href="https://agentskills.io"><img src="https://img.shields.io/badge/Format-Agent_Skills-orange?style=flat-square" alt="Agent Skills Format"></a>
</p>

<p align="center">
  <a href="#what-it-does">What It Does</a> •
  <a href="#installation">Installation</a> •
  <a href="#usage">Usage</a> •
  <a href="#how-it-works">How It Works</a> •
  <a href="#benchmarks">Benchmarks</a> •
  <a href="#acknowledgments">Acknowledgments</a>
</p>

---

## The Problem

When analyzing large codebases, processing many documents, or aggregating information across dozens of files, Claude's context window becomes a bottleneck. As context grows, **"context rot"** degrades performance:

- Missed details in long documents
- Decreased accuracy on information retrieval
- Hallucinated connections between distant content
- Degraded reasoning over large evidence sets

## The Solution

This skill implements **Recursive Language Model (RLM)** strategies from [Zhang, Kraska, and Khattab's 2025 research](https://arxiv.org/abs/2512.24601), enabling Claude Code to handle inputs **up to 2 orders of magnitude beyond normal context limits**.

Instead of cramming everything into context, Claude learns to:

1. **Filter** — Narrow search space before deep analysis
2. **Chunk** — Partition inputs strategically
3. **Recurse** — Spawn sub-agents for independent segments
4. **Verify** — Re-check answers on smaller, focused windows
5. **Synthesize** — Aggregate results programmatically

---

## What It Does

| Task Type | Without Skill | With Skill |
|-----------|---------------|------------|
| Analyze 100+ files | Context overflow / degraded results | Systematic coverage via decomposition |
| Multi-document QA | Missed information | Comprehensive extraction |
| Codebase-wide search | Manual iteration | Parallel sub-agent analysis |
| Information aggregation | Incomplete synthesis | Map-reduce pattern |

### Real Test Results

We tested on the [Anthropic Cookbook](https://github.com/anthropics/anthropic-cookbook) (196 files, 356MB):

```
Task: "Find all Anthropic API calling patterns across the codebase"

Results:
├── Files scanned: 142
├── Files with API calls: 18
├── Patterns identified: 8 distinct patterns
├── Anti-patterns detected: 4
└── Output: Comprehensive report with file:line references
```

---

## Installation

### Via Claude Code Marketplace

```bash
# Add the marketplace
claude plugin marketplace add massimodeluisa/recursive-decomposition-skill

# Install the plugin
claude plugin install recursive-decomposition@recursive-decomposition
```

### From Local Clone

```bash
# Clone the repository
git clone https://github.com/massimodeluisa/recursive-decomposition-skill.git ~/recursive-decomposition-skill

# Add as local marketplace
claude plugin marketplace add ~/recursive-decomposition-skill

# Install the plugin
claude plugin install recursive-decomposition
```

### Manual Installation (Skills Directory)

```bash
# Copy skill directly to Claude's skills directory
cp -r plugins/recursive-decomposition/skills/recursive-decomposition ~/.claude/skills/
```

After installation, **restart Claude Code** for the skill to take effect.

### Updating

```bash
# Update marketplace index
claude plugin marketplace update

# Update the plugin
claude plugin update recursive-decomposition@recursive-decomposition
```

---

## Usage

The skill activates automatically when you describe tasks involving:

- Large-scale file analysis (`"analyze all files in..."`)
- Multi-document processing (`"aggregate information from..."`)
- Codebase-wide searches (`"find all occurrences across..."`)
- Long-context reasoning (`"summarize these 50 documents..."`)

### Example Prompts

```
"Analyze error handling patterns across this entire codebase"

"Find all TODO comments in the project and categorize by priority"

"What API endpoints are defined across all route files?"

"Summarize the key decisions from all meeting notes in /docs"

"Find security vulnerabilities across all Python files"
```

### Trigger Phrases

The skill recognizes these patterns:
- `"analyze all files"`
- `"process this large document"`
- `"aggregate information from"`
- `"search across the codebase"`
- Tasks involving 10+ files or 50k+ tokens

---

## When to Use

The skill is designed for **complex, long-context tasks**. Use it when:

- Analyzing 10+ files simultaneously
- Processing documents exceeding 50k tokens
- Performing codebase-wide pattern analysis
- Extracting information from multiple scattered sources
- Multi-hop reasoning requiring evidence synthesis

**When NOT to use:**

- Single file edits → Direct processing is faster
- Specific function lookup → Use Grep directly
- Tasks < 30k tokens → Overhead not worth it
- Time-critical operations → Latency matters more than completeness

---

## How It Works

### Decomposition Strategies

#### 1. Filter Before Deep Analysis
```
1000 files → Glob filter → 100 files
100 files  → Grep filter → 20 files
20 files   → Deep analysis
```
**Result:** 50x reduction before expensive processing

#### 2. Strategic Chunking
- **Uniform:** Split by line count or natural boundaries
- **Semantic:** Partition by logical units (functions, classes)
- **Keyword-based:** Group by shared characteristics

#### 3. Parallel Sub-Agents
```
Main Agent
├── Sub-Agent 1 (Batch A) ─┐
├── Sub-Agent 2 (Batch B) ─┼── Parallel
├── Sub-Agent 3 (Batch C) ─┘
└── Synthesize results
```

#### 4. Verification Pass
Re-check synthesized answers against focused evidence to catch context rot errors.

---

## Benchmarks

From the [RLM paper](https://arxiv.org/abs/2512.24601):

| Task | Direct Model | With RLM | Improvement |
|------|--------------|----------|-------------|
| Multi-hop QA (6-11M tokens) | 70% | 91% | **+21%** |
| Linear aggregation | Baseline | +28-33% | **Significant** |
| Quadratic reasoning | <0.1% | 58% | **Massive** |
| Context scaling | 2^14 tokens | 2^18 tokens | **16x** |

**Cost:** RLM approaches are ~3x cheaper than summarization baselines while achieving superior quality.

---

## Repository Structure

```
recursive-decomposition-skill/
├── .claude-plugin/
│   └── marketplace.json          # Marketplace manifest
├── plugins/
│   └── recursive-decomposition/
│       ├── .claude-plugin/
│       │   └── plugin.json       # Plugin manifest
│       ├── README.md             # Plugin documentation
│       └── skills/
│           └── recursive-decomposition/
│               ├── SKILL.md      # Core skill instructions
│               └── references/
│                   ├── rlm-strategies.md
│                   ├── cost-analysis.md
│                   ├── codebase-analysis.md
│                   └── document-aggregation.md
├── assets/
│   └── logo.png                  # Project logo
├── AGENTS.md                     # Agent-facing docs
├── CONTRIBUTING.md               # Contribution guidelines
├── LICENSE
└── README.md
```

---

## Skill Contents

| File | Purpose |
|------|---------|
| [`SKILL.md`](plugins/recursive-decomposition/skills/recursive-decomposition/SKILL.md) | Core decomposition strategies and patterns |
| [`references/rlm-strategies.md`](plugins/recursive-decomposition/skills/recursive-decomposition/references/rlm-strategies.md) | Detailed techniques from the RLM paper |
| [`references/cost-analysis.md`](plugins/recursive-decomposition/skills/recursive-decomposition/references/cost-analysis.md) | When to use recursive vs. direct approaches |
| [`references/codebase-analysis.md`](plugins/recursive-decomposition/skills/recursive-decomposition/references/codebase-analysis.md) | Full walkthrough: multi-file error handling analysis |
| [`references/document-aggregation.md`](plugins/recursive-decomposition/skills/recursive-decomposition/references/document-aggregation.md) | Full walkthrough: multi-document feature extraction |

---

## Acknowledgments

This skill is based on the **Recursive Language Models** research paper. Huge thanks to the authors for their groundbreaking work:

<table>
  <tr>
    <td align="center">
      <a href="https://x.com/a1zhang">
        <b>Alex L. Zhang</b>
      </a>
      <br>
      <a href="https://x.com/a1zhang">@a1zhang</a>
      <br>
      <sub>MIT CSAIL</sub>
    </td>
    <td align="center">
      <a href="https://x.com/tim_kraska">
        <b>Tim Kraska</b>
      </a>
      <br>
      <a href="https://x.com/tim_kraska">@tim_kraska</a>
      <br>
      <sub>MIT Professor</sub>
    </td>
    <td align="center">
      <a href="https://x.com/lateinteraction">
        <b>Omar Khattab</b>
      </a>
      <br>
      <a href="https://x.com/lateinteraction">@lateinteraction</a>
      <br>
      <sub>MIT CSAIL, Creator of DSPy</sub>
    </td>
  </tr>
</table>

### Paper

> **Recursive Language Models**
>
> *Alex L. Zhang, Tim Kraska, Omar Khattab*
>
> arXiv:2512.24601 • December 2025
>
> We propose Recursive Language Models (RLMs), an inference technique enabling LLMs to handle prompts up to two orders of magnitude beyond model context windows through programmatic decomposition and recursive self-invocation over prompt segments.

<p>
  <a href="https://arxiv.org/abs/2512.24601"><img src="https://img.shields.io/badge/arXiv-2512.24601-b31b1b?style=for-the-badge" alt="arXiv Paper"></a>
  <a href="https://arxiv.org/pdf/2512.24601"><img src="https://img.shields.io/badge/PDF-Download-blue?style=for-the-badge" alt="PDF Download"></a>
</p>

---

## References

- [Agent Skills Specification](https://agentskills.io/specification)
- [Claude Code Documentation](https://docs.anthropic.com/claude-code)

---

## Contributing

Contributions welcome! Please see [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

---

## Author

<p>
  <a href="https://x.com/massimodeluisa">
    <img src="https://img.shields.io/badge/X-@massimodeluisa-000000?style=flat-square&logo=x" alt="X (Twitter)">
  </a>
  <a href="https://github.com/massimodeluisa">
    <img src="https://img.shields.io/badge/GitHub-massimodeluisa-181717?style=flat-square&logo=github" alt="GitHub">
  </a>
</p>

**Massimo De Luisa** — [@massimodeluisa](https://x.com/massimodeluisa)

---

## License

MIT License — see [LICENSE](LICENSE) for details.

---
