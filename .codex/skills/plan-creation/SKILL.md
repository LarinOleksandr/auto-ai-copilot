---
name: plan-creation
description: Create a concrete, executable plan file for large or risky changes.
---

# .codex/skills/plan-creation/SKILL.md

## Name

`$plan-creation`

## Purpose

Create a short, executable plan file for large or risky changes.

Keep plans right-sized: if a step cannot be implemented and verified safely, split it.

## When to use

Invoke when any apply:

- change spans multiple components or layers
- schema, contract, or data model changes
- new agent, workflow, or service
- refactor touching shared or core logic

## Inputs

- Goal (one sentence)
- Scope (in / out; if missing, the agent proposes and confirms)
- Affected areas (folders/components; if missing, the agent proposes and confirms)
- Risks (if any; if missing, the agent proposes and confirms)
- Validation intent (optional; if missing, the agent proposes it)

## Output location

- File path: `ROOT_AGENTS_ARTIFACTS/plans/<task-slug>.plan.md`
- One plan file per task
- Do not overwrite plans from other tasks
- Use a short kebab-case task slug derived from the goal

## Procedure

1. Identify change boundaries
   - list touched components/layers
   - list contracts/schemas/data affected
   - review `DOC_PROJECT_PROTECTED_CONTRACTS` and call out any protected items the plan might impact
   - if scope/areas/risks are unclear, propose and confirm before finalizing the plan
2. Add design system initialization steps when UI is involved
   - If the plan touches `frontend/web/**` or includes UI work:
     - include an early step: ???Confirm design preset (keep current or switch)???
     - include the execution step: ???Initialize or update design system??? via `/app-design-setup`
     - include verification: basic UI loads + baseline focus/validation/loading behaviors
   - Do not paste preset URLs into the plan; reference `frontend/web/config/app-design-preset.json`.
3. Write ordered steps (small, integrated, verifiable)
   - smallest viable sequence; include dependency ordering
   - for each step, include only:
     - Deliverable: what changes
     - Integration: where it is wired in (avoid orphan code)
     - Verify: how to confirm it works (1-3 bullets)
   - use exact file paths in Deliverables and Integration (repo-relative only; no absolute OS paths)
   - keep steps bite-sized (a few minutes each)
4. If coding is involved, add an implementation plan
   - mirror the steps above, phrased as ???do X, then verify Y???
   - include the exact command and expected outcome for each verify step when known
   - avoid deep test enumeration or UI review checklists; reference `/test-plan` or `/design-review` instead
5. Add a validation section (high-signal only)
   - tests to add/update (names/locations, not full suites)
   - smoke path(s)
   - schema validation points (if any)
6. Add rollback notes (only if data/schema involved)
   - if the plan breaks a protected contract, include the user approval gate + migration + rollback here
7. Write or update the plan file
   - minimal and executable
   - reflects current intended approach

## Plan file structure (required)

- Goal (one sentence)
- Scope / Non-scope
- Affected areas
- Steps (ordered; each step has Deliverable + Integration + Verify)
- Implementation plan (coding only; ???do X, then verify Y???)
- Risks
- Validation (tests + smoke path)
- References (optional; existing plans or architecture reviews)
- Rollback notes (only if applicable)

## Acceptance checks

- Planning triggers applied correctly
- Plan file exists in `ROOT_AGENTS_ARTIFACTS/plans/`
- Steps are ordered and implementable
- Steps are right-sized (small + verifiable)
- No orphan work (each step includes Integration)
- Implementation plan included for coding tasks
- Validation is concrete and testable
- Schema/contract impacts are explicit
- Rollback included when data/schema is affected


