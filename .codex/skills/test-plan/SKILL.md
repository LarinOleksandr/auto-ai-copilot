---
name: test-plan
description: Use when you need a comprehensive, repo-consistent test plan for a feature or change.
---

# .codex/skills/test-plan/SKILL.md

## Name

`$test-plan`

## Purpose

Create a clear, repo-consistent test plan for the requested change.

## When to use

Invoke when any apply:

- validation needs are unclear
- the change touches UI behavior or API endpoints
- user requests a test plan

## Inputs

- Short target description
- Known constraints (if any)

## Procedure

1. Restate the test target as a short statement.
2. Identify boundaries touched (choose only what applies):
   - Frontend UI
   - API / Edge Functions
   - Orchestrator workflows
   - Embeddings service
   - Supabase (schema/RLS)
3. Propose a minimal test suite using `KB_TESTING` expectations:
   - Use stack-defined frameworks and existing repo tooling (`KB_TECH_STACK`)
   - Do not add new test dependencies without explicit approval (`KB_REPOSITORY_RULES`)
   - Unit tests for core functions/validators
   - Integration tests for new/changed API endpoints
   - Error handling aligned with `KB_ERROR_HANDLING` and `KB_API_CONVENTIONS`
   - Edge cases and failure modes per boundary
4. Include mobile compatibility checks when UI is involved.
5. For each proposed test, include:
   - what it covers (happy/failure path)
   - inputs and expected outputs/behavior
   - where it should live (service/folder)
6. If required details are missing, ask only the minimum clarifications.
7. If tests are run, report results; otherwise state why not.

## Output format

### 1) Scope

- Target: `<one sentence>`
- Boundaries touched: `<list>`
- Assumptions: `<list or "None">`
- Risks / edge cases to prioritize: `<list>`

### 2) Unit tests

- **Test**: `<name>`
- **Location**: `<path>`
- **Covers**: `<behavior>`
- **Cases**: `<bullet list>`

### 3) Integration tests (API / Edge)

- **Endpoint**: `<method> <path>`
- **Location**: `<path>`
- **Happy path**: `<what to assert>`
- **Error handling**: `<status + error.code + message safety>`
- **Edge cases**: `<list>`

### 4) Mobile compatibility checks (UI)

- **Manual check**: small viewport pass criteria
- **Routes/views**: `<list>`

### 5) Next questions (only if blocked)

- `<question 1>`
- `<question 2>`

### 6) Execution report

- Ran tests: `<yes/no>`
- Commands: `<commands or "N/A">`
- Results: `<pass/fail summary, key failures if any>`

## Quick reference

| Do | Do not |
| --- | --- |
| Keep tests minimal and relevant | Add new dependencies without approval |
| Include error cases | Skip validation failures |

## Example

Target: "Add new export endpoint"

You:
- List unit tests for validators
- List integration tests for the endpoint
- Include failure cases

## Rationalization table

| Excuse | Reality |
| --- | --- |
| "We can skip failure cases" | Error paths are required by `KB_ERROR_HANDLING`. |
| "Mobile checks are optional" | They are required when UI is involved. |

## Red flags

- "No need to mention test locations"
- "I will add a new dependency without approval"

## Common mistakes

- Missing schema validation failures
- Missing error handling cases

## Acceptance checks

- Test plan matches output format
- Boundaries and risks listed
- Execution report included
