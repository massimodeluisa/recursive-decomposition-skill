# Recursive Decomposition Skill

This repository contains a Claude Code skill for handling long-context tasks through recursive decomposition strategies.

## Key Concept

Instead of loading all context into the processing window, treat inputs as environmental variables accessible through code. Decompose problems recursively, process segments independently, aggregate results programmatically.

## When This Skill Activates

- Tasks involving 10+ files
- Input exceeding ~50k tokens
- Phrases like "analyze all", "aggregate from", "search across"
- Multi-document QA or codebase-wide analysis

## Core Strategies

1. **Filter** — Use Grep/Glob to narrow before deep analysis
2. **Chunk** — Partition by size, semantics, or keywords
3. **Recurse** — Launch parallel sub-agents via Task tool
4. **Verify** — Re-check on smaller windows
5. **Synthesize** — Aggregate with deduplication

## File Structure

```
plugins/recursive-decomposition/skills/recursive-decomposition/
├── SKILL.md           # Core instructions (always loaded when triggered)
├── references/        # Detailed strategies (loaded as needed)
└── examples/          # Concrete walkthroughs (loaded as needed)
```

## Based On

[Recursive Language Models](https://arxiv.org/abs/2512.24601) — Zhang, Kraska, Khattab (2025)
