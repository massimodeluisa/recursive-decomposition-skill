# Example: Codebase-Wide Error Handling Analysis

This example demonstrates recursive decomposition for analyzing error handling patterns across a large codebase.

## Task
"Analyze all error handling patterns in this codebase and provide a comprehensive report on consistency, gaps, and recommendations."

## Decomposition Strategy

### Phase 1: Filter and Identify (Constant complexity)

```
Step 1: Identify relevant file types
- Glob("**/*.ts") → 450 files
- Glob("**/*.tsx") → 120 files
- Total: 570 files

Step 2: Filter for error-related code
- Grep("catch|throw|Error|exception", type="ts") → 89 files
- Grep("try.*catch|\.catch\\(", type="ts") → 67 files
- Union: 102 unique files with error handling
```

### Phase 2: Partition for Parallel Processing

```
Partition by module:
- src/api/* → 23 files (Batch A)
- src/services/* → 31 files (Batch B)
- src/components/* → 28 files (Batch C)
- src/utils/* → 12 files (Batch D)
- Other → 8 files (Batch E)
```

### Phase 3: Launch Parallel Sub-Agents

```
Task(subagent_type="Explore", prompt="""
Analyze error handling in src/api/*.
For each file with error handling:
1. Identify error handling patterns used
2. Note any error types defined or caught
3. Check for consistent error propagation
4. Flag any unhandled promise rejections
Return structured findings.
""")

# Launch 5 agents in parallel for batches A-E
```

### Phase 4: Aggregate Results

```
Collect findings from all sub-agents:
- Batch A: HTTP error handling, custom ApiError class
- Batch B: Service-level try/catch, logging patterns
- Batch C: UI error boundaries, toast notifications
- Batch D: Utility error wrappers, validation errors
- Batch E: Mixed patterns, some inconsistencies
```

### Phase 5: Synthesize Report

```
Categories identified:
1. API Layer: ApiError, HttpError, ValidationError
2. Service Layer: ServiceError, DatabaseError
3. UI Layer: Error boundaries, user-facing messages
4. Utilities: Generic error wrappers

Patterns:
- Consistent: HTTP errors always include status code
- Gap: Database errors don't preserve original error
- Recommendation: Add error codes for client handling
```

### Phase 6: Verify with Spot Checks

```
Verification queries:
1. "Confirm ApiError is used consistently in src/api/"
2. "Check if DatabaseError preserves stack traces"
3. "Verify error boundaries cover all route components"
```

## Expected Output Structure

```markdown
# Error Handling Analysis Report

## Executive Summary
- 102 files contain error handling logic
- 4 main error categories identified
- 3 consistency issues found
- 5 recommendations provided

## Error Type Taxonomy
### API Errors (src/api/)
- ApiError: Base class for HTTP errors
- ValidationError: Request validation failures
- AuthenticationError: Auth failures

### Service Errors (src/services/)
...

## Pattern Analysis
### Consistent Patterns
1. All API routes wrap handlers in try/catch
2. Errors include request ID for tracing
...

### Inconsistencies Found
1. Some services swallow errors without logging
2. Database errors lose original stack trace
...

## Recommendations
1. Implement error codes enum
2. Add error boundary to remaining routes
...
```

## Metrics

- **Files analyzed:** 102
- **Sub-agents used:** 5
- **Total tokens processed:** ~150k (across all agents)
- **Equivalent direct context:** Would require 150k token window
- **Quality:** High (no context rot)
