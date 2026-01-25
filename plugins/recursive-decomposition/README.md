# Recursive Decomposition Plugin

Strategies for handling long-context tasks through programmatic decomposition and recursive self-invocation.

## What This Plugin Does

- **Filters Context**: Uses Grep/Glob to narrow down search spaces before deep analysis
- **Chunks Information**: Partitions inputs by size, semantics, or keywords for manageable processing
- **Orchestrates Sub-Agents**: Recursively launches parallel agents to handle independent segments
- **Synthesizes Results**: Aggregates findings from multiple sources into coherent outputs
- **Verifies Answers**: Mitigates "context rot" by cross-checking on smaller context windows

## When to Use

- Tasks involving 10+ files or codebases requiring broad searches
- Input exceeding ~50k tokens where single-prompt context is insufficient
- Complex multi-hop queries requiring evidence from scattered sources
- Codebase-wide pattern analysis or migration planning
- When you hear: "analyze all files", "search across the codebase", or "aggregate from these documents"

## Skills Included

- **recursive-decomposition** - Core strategies for filtering, chunking, recruiting sub-agents, and synthesizing results for long-context operations.

## License

MIT
