# Cost-Performance Analysis for Recursive Decomposition

This reference provides guidance on when recursive decomposition is cost-effective versus direct processing.

## Decision Framework

### Use Direct Processing When:
- Input < 30k tokens
- Task involves < 5 files
- Answer is localized to one section
- Latency is critical
- Simple lookup or single transformation

### Use Recursive Decomposition When:
- Input > 50k tokens
- Task spans 10+ files
- Information must be aggregated across sources
- Comprehensive analysis is required
- Quality matters more than speed

### Gray Zone (30k-50k tokens):
- Consider task complexity
- Evaluate quality requirements
- Factor in time constraints
- Default to decomposition if unsure about completeness

## Cost Structure

### Direct Processing
```
Cost = Input tokens × Price per token
Latency = Single API call
Quality = Degrades with context length
```

### Recursive Decomposition
```
Cost = (Σ sub-call tokens) + coordination overhead
Latency = Max(sub-call latencies) + synthesis time
Quality = Maintains with proper chunking
```

## Break-Even Analysis

From RLM research:

**Token Threshold:** ~50k tokens
- Below: Direct processing often cheaper
- Above: Decomposition maintains quality at comparable or lower cost

**Quality Threshold:** ~30k tokens
- Below: Direct processing quality acceptable
- Above: Context rot begins degrading results

**Cost Comparison (from paper):**
- RLM approaches: ~$0.99 for complex multi-hop QA
- Summarization baselines: 3x more expensive
- Direct long-context: Cheaper but lower quality

## Parallelization Benefits

When sub-tasks are independent, parallel execution provides:

```
Serial: T = t1 + t2 + t3 + ... + tn
Parallel: T = max(t1, t2, t3, ..., tn) + synthesis

Speedup = n / (1 + synthesis_overhead/avg_subtask_time)
```

For 10 independent sub-tasks of 30 seconds each:
- Serial: 300 seconds
- Parallel (with 10s synthesis): ~40 seconds
- Speedup: ~7.5x

## Variance Considerations

RLM approaches show high variance in outlier cases:

**Median cost:** Comparable to direct processing
**95th percentile:** 2-3x median
**99th percentile:** Can exceed 5x median

Causes of high variance:
- Excessive sub-calling by model
- Redundant processing
- Deep recursion chains
- Inefficient chunking

Mitigations:
- Set sub-call budgets
- Track and deduplicate queries
- Limit recursion depth
- Monitor token usage

## Optimization Strategies

### 1. Aggressive Filtering
Filter 90% of content before detailed analysis:
```
1000 files → Glob filter → 100 files
100 files → Grep filter → 20 files
20 files → Detailed analysis
Cost reduction: ~10x
```

### 2. Sampling for Estimation
For aggregation tasks, sample before exhaustive processing:
```
Sample 10% of items
Estimate answer distribution
If high confidence: extrapolate
If uncertain: process remaining
```

### 3. Early Termination
For search tasks:
```
Process chunks until answer found
Skip remaining chunks
Add verification pass
```

### 4. Caching
For repeated analysis:
```
Cache chunk analysis results
Reuse for similar queries
Invalidate on source changes
```

## Tool Selection by Cost-Performance

| Scenario | Recommended Approach |
|----------|---------------------|
| Find one file by name | Glob (direct) |
| Find function definition | Grep (direct) |
| Understand module | Read + follow imports |
| Analyze 5 related files | Read all (direct) |
| Search pattern in codebase | Task + Explore agent |
| Aggregate across 50+ files | Task + parallel agents |
| Multi-hop reasoning | Task + recursive decomposition |

## Quality vs. Cost Tradeoff Matrix

```
                    Low Cost          High Cost
High Quality    | Filtered RLM    | Exhaustive RLM
                | (targeted)      | (thorough)
                |-----------------|----------------
Low Quality     | Direct (short)  | Direct (long)
                | (acceptable)    | (context rot)
```

Target: Upper-left quadrant (Filtered RLM for targeted, high-quality results at low cost)
