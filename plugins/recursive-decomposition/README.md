# Recursive Decomposition Plugin

A Claude Code plugin for handling long-context tasks through recursive decomposition strategies based on [Recursive Language Models (RLM) research](https://arxiv.org/abs/2512.24601) by Zhang, Kraska, and Khattab (2025).

## What This Plugin Does

This plugin enables Claude to handle tasks that exceed comfortable context limits (typically 30k+ tokens or 10+ files) by:

- **Filtering before deep analysis** - Narrowing search space systematically
- **Strategic chunking** - Partitioning inputs for parallel processing
- **Recursive sub-agents** - Spawning independent analysis tasks
- **Answer verification** - Re-checking synthesized results on focused windows
- **Programmatic synthesis** - Aggregating results without context overflow

**Real-world impact:** Handles inputs up to 2 orders of magnitude beyond normal context limits, with benchmarks showing 21-58% accuracy improvements on long-context tasks.

## When to Use

The skill automatically activates when Claude detects:

- Tasks involving 10+ files or 50k+ tokens
- Phrases like "analyze all files", "process this large document", "aggregate information from", "search across the codebase"
- Codebase-wide pattern analysis
- Multi-document information extraction
- Multi-hop questions requiring scattered evidence

## Skills Included

- **recursive-decomposition** - Core strategies for programmatic decomposition, chunking, filtering, and recursive self-invocation

## Installation

### From Marketplace

```bash
# Add this marketplace
/plugin marketplace add massimodeluisa/recursive-decomposition-skill

# Install the plugin
/plugin install recursive-decomposition
```

### Manual Installation

Copy this plugin directory to your Claude Code plugins directory:

```bash
cp -r plugins/recursive-decomposition ~/.claude/plugins/
```

## Usage Examples

```
"Find all error handling patterns across the entire codebase"
"Summarize all TODO comments and categorize by priority"
"What API endpoints are defined across all route files?"
"Analyze security vulnerabilities in all Python files"
```

The plugin handles the decomposition automatically - no special syntax required.

## Plugin Structure

```
recursive-decomposition/
├── .claude-plugin/
│   └── plugin.json              # Plugin manifest
└── skills/
    └── recursive-decomposition/
        ├── SKILL.md             # Core decomposition strategies
        └── references/
            ├── rlm-strategies.md
            ├── cost-analysis.md
            ├── codebase-analysis.md
            └── document-aggregation.md
```

## Research Foundation

Based on "Recursive Language Models" (Zhang, Kraska, Khattab, 2025):
- arXiv: [2512.24601](https://arxiv.org/abs/2512.24601)
- Enables context scaling from 2^14 to 2^18 tokens (16x)
- ~3x more cost-effective than summarization baselines

## License

MIT - See [LICENSE](../../LICENSE)

## Author

Massimo De Luisa ([@massimodeluisa](https://x.com/massimodeluisa))
