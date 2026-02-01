# docs-ai/agents-core-knowledge/testing.md

## Agent summary

- Defines testing expectations by layer
- Ensures changes are verifiable and safe
- Focuses on coverage, not tooling details

---

## Tooling constraints

- Use stack-defined frameworks from the current project stack (`DOC_PROJECT_CONTEXT`); fall back to the baseline in `KB_TECH_STACK`.
- Do not add new test dependencies without explicit approval (see `KB_REPOSITORY_RULES`).

---

## UI validation (required)

- For UI-related tasks, validate using Playwright + MCP DevTools and capture screenshots as proof.
- See `KB_UI_TESTING_PLAYWRIGHT`.

## Testing levels

- **Unit**: isolated logic (UI components, pure functions, validators)
- **Workflow**: orchestrator graphs and node interactions
- **Integration**: service boundaries (API, Edge Functions); include integration tests for new/changed API endpoints
- **Smoke**: critical end-to-end paths

---

## Layer expectations

- **Frontend**: component + interaction tests for changed behavior; add unit tests for new/changed utility functions and validators
- **Orchestrator**: workflow-level tests (not nodes only)
- **Embeddings**: API boundary tests + vector shape checks
- **Supabase**: migration validation + RLS allow/deny tests
- **Infra**: stack start/stop verification

---

## Required coverage

- Happy path for new/changed behavior
- Failure path for:
  - validation errors
  - external dependency failure (LLM, service)
- Schema validation failures explicitly tested

---

## Validation gate (workflow)

When a change is close to "done" (feature scope implemented or bug fix applied), the agent should:

- propose generating a test plan (`$test-plan`) if it's not already clear
- ask the user to confirm before doing it
- propose `$testing-in-browser` when UI behavior needs manual verification and ask the user to confirm before running it

When proposing a validation plan for new/changed features, suggest a minimal set of tests that includes at least:

- one happy-path test per boundary touched
- one failure-path test per boundary touched

---

## Smoke paths

For workflow changes, verify at least:

- trigger -> execution -> validated output
- render/export path if UI or documents are involved

For UI/layout changes, verify at least:

- manual mobile responsiveness check (small viewport, no clipped controls, no horizontal scrolling)

---

## Rules

- Tests must fail before fix and pass after.
- Do not mock core contracts or schemas.
- Prefer fewer, meaningful tests over broad shallow coverage.

---

## Change checklist

- Relevant tests added or updated.
- Smoke path executed locally.
- CI parity maintained (local results match CI).





---

## Definition of done

- Tests and validations pass; no TypeScript errors.
- If tests are not added or run, state why.
- Schemas/validators updated where behavior changed.
- DB changes include migrations + contract/schema updates.
- Planning artifact updated when required.
- Generated artifacts handled via product flow, not committed.
- Instruction docs or skills updated if workflow or constraints changed.

