# Example: Multi-Document Feature Aggregation

This example demonstrates recursive decomposition for extracting and aggregating information across multiple documents.

## Task
"What features are planned across all our PRD documents? Create a consolidated feature roadmap."

## Decomposition Strategy

### Phase 1: Discover Documents

```
Step 1: Find all PRD documents
- Glob("**/PRD*.md") → 12 files
- Glob("**/prd-*.md") → 5 files
- Glob("docs/product/*.md") → 8 files
- Deduplicate: 18 unique PRD documents

Step 2: Assess total size
- Total: ~85k tokens across all documents
- Decision: Recursive decomposition required
```

### Phase 2: Categorize Documents

```
Quick scan of document headers:
- Q1 PRDs: 4 documents (~20k tokens)
- Q2 PRDs: 5 documents (~25k tokens)
- Q3 PRDs: 4 documents (~18k tokens)
- Technical PRDs: 3 documents (~12k tokens)
- Archived: 2 documents (exclude)

Active documents: 16 (~75k tokens)
```

### Phase 3: Define Extraction Schema

```
For each document, extract:
{
  "document": "filename",
  "product_area": "string",
  "features": [
    {
      "name": "string",
      "description": "string",
      "priority": "P0|P1|P2",
      "status": "planned|in-progress|shipped",
      "target_quarter": "Q1|Q2|Q3|Q4"
    }
  ],
  "dependencies": ["feature_name"],
  "stakeholders": ["team_name"]
}
```

### Phase 4: Parallel Extraction

```
Launch extraction agents by category:

Agent 1 (Q1 PRDs):
Task(subagent_type="Explore", prompt="""
Read each PRD in docs/product/q1/:
- PRD-auth-improvements.md
- PRD-dashboard-v2.md
- PRD-mobile-notifications.md
- PRD-api-versioning.md

Extract features using this schema: [schema]
Return structured JSON for each document.
""")

Agent 2 (Q2 PRDs): [similar for Q2 documents]
Agent 3 (Q3 PRDs): [similar for Q3 documents]
Agent 4 (Technical PRDs): [similar for technical documents]
```

### Phase 5: Aggregate and Deduplicate

```
Collect from all agents:
- Agent 1: 12 features extracted
- Agent 2: 15 features extracted
- Agent 3: 11 features extracted
- Agent 4: 8 features extracted
- Total: 46 features

Deduplication:
- "Dark mode" mentioned in 3 PRDs → merge
- "API v2" mentioned in 2 PRDs → merge
- After dedup: 38 unique features
```

### Phase 6: Build Dependency Graph

```
Analyze dependencies:
- "Dashboard v2" depends on "API v2"
- "Mobile notifications" depends on "Auth improvements"
- "Reporting" depends on "Dashboard v2", "Data pipeline"

Create directed graph of dependencies
Identify critical path
```

### Phase 7: Generate Consolidated Roadmap

```
# Feature Roadmap (Consolidated from 16 PRDs)

## Q1 2025
### P0 - Critical
1. **Auth Improvements** (PRD-auth-improvements.md)
   - OAuth2 support
   - SSO integration
   Status: In Progress

2. **API Versioning** (PRD-api-versioning.md)
   - v2 API release
   - Deprecation timeline
   Status: Planned

### P1 - High Priority
3. **Dashboard v2** (PRD-dashboard-v2.md)
   - Depends on: API v2
   ...

## Q2 2025
...

## Dependencies Graph
[ASCII visualization of dependencies]

## Cross-cutting Concerns
- Performance: 5 features mention performance requirements
- Security: 3 features have security implications
- Mobile: 4 features affect mobile experience
```

### Phase 8: Verification

```
Spot-check verification:
1. Re-read PRD-auth-improvements.md
   - Verify: OAuth2 support listed as P0 ✓
   - Verify: Q1 target ✓

2. Re-read PRD-dashboard-v2.md
   - Verify: Depends on API v2 ✓
   - Verify: 4 sub-features extracted ✓

3. Cross-check dependency claims
   - API v2 → Dashboard v2 dependency confirmed ✓
```

## Expected Output

```markdown
# Consolidated Feature Roadmap

## Summary
- 16 PRDs analyzed
- 38 unique features identified
- 12 cross-document dependencies mapped
- 4 quarters covered

## Feature Matrix

| Feature | Priority | Quarter | Status | Dependencies |
|---------|----------|---------|--------|--------------|
| Auth Improvements | P0 | Q1 | In Progress | - |
| API v2 | P0 | Q1 | Planned | - |
| Dashboard v2 | P1 | Q1 | Planned | API v2 |
| Mobile Notifications | P1 | Q2 | Planned | Auth |
...

## By Product Area
### Core Platform (12 features)
...

### Mobile (8 features)
...

## Risk Analysis
- 3 features with unresolved dependencies
- 2 features with conflicting timelines
- 1 feature missing stakeholder assignment
```

## Metrics

- **Documents processed:** 16
- **Features extracted:** 38
- **Sub-agents used:** 4 (parallel)
- **Total tokens:** ~75k (distributed across agents)
- **Verification queries:** 3
- **Processing pattern:** Map-reduce with verification
