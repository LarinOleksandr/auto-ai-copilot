# Feature PRD - Template

Use this when you are adding or changing one feature inside an existing product.

## Product context (reference)

- Product PRD reference: `ROOT_AGENTS_ARTIFACTS/prds/<product-prd-file>.md` (or write "Unknown")
- Supported Product PRD capability: (copy the capability name; or write "Unknown")
- Product baseline to follow: scope boundaries, success metrics, and non-functional baselines from the Product PRD
- Deviations: if this feature changes a product-level decision, update the Product PRD first

## Impacted user profile(s)

Reference the Product PRD user profile(s). Do not rewrite the full profile here.

- Primary impacted profile:
- Secondary impacted profiles (if any):
- Context difference (only if this feature changes when/where they use the product):

## Supported jobs-to-be-done

Reference the Product PRD JTBD section. Do not rewrite the full JTBD here.

- Primary job supported:
- Functional jobs supported:
- Trigger(s) supported:
- Desired outcome(s) impacted (pick 1-3 measurable outcomes):
- Constraints to respect (only what matters for this feature):

## Goal

- One sentence goal:

## Problem

- What problem this feature solves (1-3 sentences):

## Success signal

One sentence is enough. This is the outcome we expect after release.

- How we will know it worked (example: "time-to-complete drops from X to Y", "error rate drops below Z", "users complete flow without support"):

## User flow (detailed)

- Entry point(s):
- Steps (3-10 steps):
- Empty states (if any):
- Error states (what the user sees; no silent failure):

## Scope

- In scope:
- Out of scope:

## Acceptance criteria

Write measurable pass/fail statements (so tests can be written without guessing).

These must satisfy (or refine) the capability-level acceptance criteria from the Product PRD.

Prefer criteria that include:

- exact inputs (UI action, API payload, file size, query, etc.)
- exact expected results (UI state, status code, response body, stored data)
- limits (latency/size/rate limits) when they matter
- failure behavior (what the user sees; no silent failure)

- ...

## Edge cases and failure behavior

- ...

## Non-functional requirements (only what matters)

State only deltas from the Product PRD baselines.

- Performance:
- Reliability:
- Security / privacy:
- Accessibility:
- Observability:

## Protected contracts check

- Protected contracts doc: `DOC_PROJECT_PROTECTED_CONTRACTS`
- Impacts protected contracts: Yes / No
- If Yes:
  - What breaks (plain language):
  - User decision: Approved / Rejected
  - Migration plan (short):
  - Rollback plan (short):

### AI quality requirements (only if this feature includes AI)

- Quality target (what "good output" means):
- How we reduce wrong answers:
- Safety: what the system must never do:
- Evaluation plan (how we test quality):

## Validation plan

- Tests to add/update:
- Smoke path (manual quick check):

## Assumptions and open questions (only if needed)

- ASSUMPTION:
  - VALIDATE BY:
  - IMPACT IF FALSE:
- OPEN QUESTION:
  - OWNER:
  - DUE:
