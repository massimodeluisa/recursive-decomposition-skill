# RLM Decomposition Strategies - Detailed Reference

This reference contains detailed strategies derived from the Recursive Language Models paper (Zhang, Kraska, Khattab, 2025).

## The Context Rot Problem

As context length increases, model performance degrades ("context rot"). This manifests as:
- Decreased accuracy on information retrieval
- Missed details in long documents
- Hallucinated connections between distant content
- Degraded reasoning over large evidence sets

RLM strategies bypass context rot by keeping the active context window small while accessing larger datasets programmatically.

## Emergent Decomposition Behaviors

The RLM research identified these naturally-emerging strategies in capable models:

### 1. Code-Based Filtering

Models use programmatic filtering to narrow search spaces:

```python
# Example: Finding relevant config files
import re

# Use regex to filter before deep analysis
config_pattern = r'(database|connection|auth)'
relevant_files = [f for f in all_files if re.search(config_pattern, f.content)]
```

**Application in Claude Code:**
- Use Grep with regex patterns before reading files
- Apply Glob patterns to narrow file sets
- Chain multiple filters: file type → keyword → semantic

### 2. Divide-and-Conquer Chunking

Observed chunking strategies:

**Uniform Chunking:**
```
Split 1000-line file into 10 chunks of 100 lines
Process each chunk independently
Merge results with overlap handling
```

**Semantic Chunking:**
```
Identify natural boundaries (functions, classes, sections)
Each chunk = one logical unit
Preserve unit integrity over size uniformity
```

**Keyword-Based Partitioning:**
```
Group items by shared characteristics
All error-related code → Chunk A
All API definitions → Chunk B
Process each category with specialized prompts
```

### 3. Recursive Self-Invocation Patterns

**Single-Level Recursion (most common):**
```
Main Agent
├── Sub-Agent 1 (Chunk A)
├── Sub-Agent 2 (Chunk B)
└── Sub-Agent 3 (Chunk C)
    └── Synthesize results
```

**Multi-Level Recursion (complex tasks):**
```
Main Agent
├── Sub-Agent 1
│   ├── Sub-Sub-Agent 1a
│   └── Sub-Sub-Agent 1b
├── Sub-Agent 2
│   ├── Sub-Sub-Agent 2a
│   └── Sub-Sub-Agent 2b
└── Synthesize hierarchically
```

### 4. Verification Through Re-Query

Mitigate context rot in verification:

```
Step 1: Generate answer from large context
Step 2: Extract claimed evidence locations
Step 3: Re-read only those specific locations
Step 4: Verify answer against fresh, focused context
Step 5: If mismatch, investigate discrepancy
```

### 5. Variable-Based Output Construction

For outputs exceeding comfortable generation limits:

```
# Instead of generating 10,000 words at once:

section_1 = generate("Write introduction...")
section_2 = generate("Write methodology...")
section_3 = generate("Write results...")
section_4 = generate("Write conclusion...")

# Stitch with coherence
full_output = stitch_with_transitions([section_1, section_2, section_3, section_4])
```

## Claude Code Constraints

To ensure optimal performance within Claude's environment:

-   **Code Processing Limit**: ~2,000 lines. Files larger than this should not be read entirely into context. Use `grep` or read specific line ranges.
-   **PDF Size Limit**: ~30MB or 100 pages per request. Exceeding this often leads to errors or truncation.
-   **Text File Limit**: ~50KB is a safe maximum for a single `view_file` operation without chunking.
-   **Context Window**: While large, optimal reasoning occurs with <30k tokens. Use decomposition to stay within this "reasoning sweet spot".

## Task Complexity Classification

### Constant Complexity (O(1))
- Single needle in haystack
- Finding one specific item
- Strategy: Binary search filtering

### Linear Complexity (O(n))
- Must examine all items once
- Aggregation, counting, summarization
- Strategy: Map-reduce with chunking

### Quadratic Complexity (O(n²))
- Pairwise comparisons needed
- Finding relationships between items
- Strategy: Blocked pairwise with sampling

### Logarithmic Complexity (O(log n))
- Hierarchical search
- Finding in sorted/structured data
- Strategy: Divide and conquer

## Model-Specific Observations

From the RLM paper:

**Conservative Models (e.g., GPT-5):**
- Fewer, more targeted sub-calls
- Better cost efficiency
- May miss edge cases

**Aggressive Models (e.g., Qwen3-Coder):**
- Many sub-calls, sometimes redundant
- More thorough coverage
- Higher variance in costs

**Optimization:** Adjust decomposition granularity based on model tendencies. More conservative chunking for aggressive models, more exhaustive for conservative ones.

## Failure Modes and Mitigations

### Infinite Recursion
**Problem:** Sub-agent spawns sub-sub-agents indefinitely
**Mitigation:** Set explicit depth limits; verify chunk sizes decrease

### Redundant Processing
**Problem:** Same content processed multiple times
**Mitigation:** Track processed segments; deduplicate before synthesis

### Context Loss
**Problem:** Sub-agents lack necessary context for their sub-task
**Mitigation:** Include minimal necessary context in each sub-query; pass relevant metadata

### Synthesis Errors
**Problem:** Aggregated results contain contradictions or gaps
**Mitigation:** Verification pass over synthesized output; spot-check against source

## Performance Benchmarks (from paper)

| Task Type | Direct Model | RLM Approach | Improvement |
|-----------|--------------|--------------|-------------|
| Multi-hop QA (6-11M tokens) | 70% | 91% | +21% |
| Linear aggregation | Baseline | +28-33% | Significant |
| Quadratic reasoning | <0.1% | 58% | Massive |
| Context scaling | 2^14 tokens | 2^18 tokens | 16x |

## When NOT to Use Recursive Decomposition

- Tasks with <10k tokens of input
- Single-file operations
- Questions answerable from one location
- Time-critical operations where latency matters more than completeness
- Tasks where the overhead of coordination exceeds the benefit
