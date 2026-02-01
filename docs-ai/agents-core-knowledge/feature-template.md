# docs-ai/agents-core-knowledge/feature-template.md

## Agent summary

- Single template for feature requests
- Agent chooses required sections based on complexity
- Do not plan or implement until required fields are confirmed

---

## Trigger and flow

- User can request a feature without mentioning this template.
- The agent classifies feature complexity and selects required sections.
- The agent drafts a feature brief from repo context, then asks the user to confirm or fill gaps.
- Ask only for missing required fields, in one pass, before planning or implementation.
- If feature research is warranted, incorporate the outcomes into the feature brief before asking the user to confirm scope and acceptance criteria (see `KB_FEATURE_RESEARCH`). Use a separate research brief artifact only when it adds value.
- If a required field is unknown, write "Unknown" and confirm with the user.
- If scope/areas/risks/tests are unclear, propose them and confirm before implementation.
- Assume inputs are incomplete unless stated otherwise; make minimal assumptions and state them explicitly.
- Default delivery approach: ship the simplest solution that meets acceptance criteria.
- Proactively highlight likely issues, risks, and edge cases (including failure modes) before implementation.
- If the validation plan is unclear, propose generating a test plan (`$test-plan <short feature description>`) and ask the user to confirm before doing so.
- Always check protected contracts (`DOC_PROJECT_PROTECTED_CONTRACTS`):
  - call out if the feature impacts them
  - if the feature introduces a new stable contract people will rely on, propose adding it (simple words; user approves/rejects)

---

## Complexity levels

**Small**

- Single component or service
- No schema/contract changes
- No new workflows or services

Required sections: Goal, Scope, Out of scope, Acceptance criteria, Affected areas, Constraints (if any), Validation plan.

**Medium**

- Multiple components or API surface changes
- Behavior changes across boundaries

Required sections: Small + Existing behavior, Data models, Edge cases, User impact, Dependencies/owners, Research brief (when applicable).

**Large**

- Schema/contract changes
- New agents/services/workflows
- Broad refactors

Required sections: Full template + Risks + References + Rollout/rollback + Research brief.
Also invoke `$architecture-review` before implementation.

---

## Template

## Goal

Clear, single-sentence description of what is being built.

## Problem

What problem this feature solves. No background or history.

## Scope

What is included in this feature. List concrete capabilities only.

## Out of scope

What is explicitly excluded. Prevents accidental expansion.

## Acceptance criteria

Observable conditions that must be met for the feature to be considered complete.

### Keep it consistent with the Product PRD (important)

Acceptance criteria exist at two levels. They are the same concept ("what done means"), but different detail.

1) Product PRD (capability-level)

- Short and outcome-focused (usually 1-3 bullets).
- Tied to the capability and its priority.
- Avoid test-level details (no deep API status code lists unless the PRD is purely API).

2) Feature (feature-level)

- Detailed enough to build and test without guessing.
- Includes inputs, expected results, limits (when they matter), and failure behavior.

### Linkage rule (to avoid confusion)

Every feature must say which Product PRD capability it delivers.

- The feature-level acceptance criteria must satisfy (or refine) the capability-level acceptance criteria.
- They must not contradict the Product PRD.
- If you discover the Product PRD criteria are wrong, update the Product PRD first, then continue.

## Affected areas

Folders, services, or modules expected to change.

## Constraints

Hard limits that must be respected (performance, security, API compatibility, architectural rules).

## Protected contracts (project-level)

- Read `DOC_PROJECT_PROTECTED_CONTRACTS`.
- State: "Impacts protected contracts: Yes/No".
- If "Yes": list the exact contract(s) and ask for explicit approval before proceeding.

## Assumptions

Only assumptions required to proceed.

## Existing behavior

What the system does today that is relevant to this feature.

## Related code

Links or excerpts of code to be touched (only relevant parts).

## Data models

Relevant entities, DTOs, or schemas involved. Prefer `shared/types/`.

## Edge cases

Known special cases or failure modes specific to this feature.

## Validation plan

Tests to add/update and any required smoke paths.

## Research brief (timeboxed; when applicable)

Pointer to the research brief artifact and any decisions/defaults it proposes.

## Dependencies/owners

External services, teams, or systems involved.

## User impact

Expected UX/behavior changes.

## Risks

Potential regressions or migration hazards.

## Rollout/rollback

Notes on rollout steps or how to safely revert.

## References

Links to prior decisions, threads, or schemas (only if relevant).

## Deliverables

Exact outputs expected from this feature (code, schemas, migrations, docs).




