---
name: optimize-performance
description: Use when reviewing code for performance bottlenecks and optimization opportunities.
---

# .codex/skills/optimize-performance/SKILL.md

## Name

`$optimize-performance`

## Purpose

Review code for performance bottlenecks and propose optimizations.

## When to use

Invoke when any apply:

- user requests performance review
- performance regressions are suspected
- a new feature may impact latency, throughput, or memory

## Inputs

- Target area (folder or feature)
- Constraints (latency, cost, mobile, bundle size)

## Procedure

1. Restate the review scope and constraints.
2. Scan the code and identify issues in these areas:
   - Database and data access
   - Algorithm efficiency
   - Memory management
   - Async and concurrency
   - Network and I/O
   - Dependencies and build
   - Frontend performance
   - Caching
3. For each issue, report location, impact, and a concrete fix.
4. If code is well optimized, state that clearly and list minor improvements only.
5. If dependency changes are suggested, include justification and alternatives (`KB_REPOSITORY_RULES`).

## Output format

For each issue identified:

1. **Issue**: Describe the performance problem
2. **Location**: File/function/line
3. **Impact**: Severity (Critical/High/Medium/Low) and expected degradation
4. **Current Complexity**: Time/space complexity when applicable
5. **Recommendation**: Specific optimization strategy
6. **Code Example**: Optimized version when useful
7. **Expected Improvement**: Quantify if possible

If code is well optimized:

- Confirm optimization status
- List best practices already present
- Note minor improvements (if any)

## Quick reference

| Do | Do not |
| --- | --- |
| Focus on real bottlenecks | Suggest speculative rewrites |
| Include dependency justification | Add dependencies without approval |

## Example

Issue: "Repeated N+1 query in list endpoint"
Location: `backend/api/list.ts:42`
Impact: High, linear latency growth
Recommendation: Add eager loading

## Rationalization table

| Excuse | Reality |
| --- | --- |
| "No need to quantify impact" | Severity and impact are required. |
| "Add any library" | New dependencies require approval. |

## Red flags

- "I will skip the location"
- "I will add a dependency without approval"

## Common mistakes

- Missing file references
- Over-optimizing without evidence

## Acceptance checks

- Issues include location and impact
- Recommendations are specific
- Dependency suggestions include justification
