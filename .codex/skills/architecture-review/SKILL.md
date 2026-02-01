---
name: architecture-review
description: Check a proposed change for architectural compliance, surface conflicts, and propose compliant alternatives.
---

# .codex/skills/architecture-review/SKILL.md

## Name

`$architecture-review`

## Purpose

Check a proposed change for architectural compliance, surface conflicts, and propose compliant alternatives.

## When to use

Invoke when any apply:

- new service, workflow, or runtime boundary
- changes span multiple layers or services
- schema/contract changes impact multiple components
- a request appears to conflict with architecture principles
- user asks for an architecture review in plain language

## Inputs

- Goal (one sentence)
- Affected areas (folders/services)
- Proposed change summary
- Known constraints or risks
- If inputs are missing, ask once or infer from the request

## Output location

- File path: `ROOT_AGENTS_ARTIFACTS/architectural-reviews/<task-slug>.arch-review.md`
- One review per task
- Use a short kebab-case task slug derived from the goal

## Procedure

0. Review protected contracts
   - read `DOC_PROJECT_PROTECTED_CONTRACTS`
   - list which protected contracts are impacted (if any)
1. Map changes to layers
   - domain / application / adapters / frameworks
   - verify dependency direction
2. Check boundaries
   - no cross-service imports
   - shared types and schemas used correctly
3. Validate domain rules (if domain changes)
   - aggregates, value objects, invariants
4. Check cross-cutting concerns
   - logging/observability at adapters/infra
   - security at use cases or adapters
   - config from outer layers only
5. Identify conflicts
   - list violations with file/area references
6. Propose compliant alternatives
   - minimal-change options first
7. Record outcome
   - approve, approve with changes, or block with rationale
8. Write the review file
   - summary, conflicts, alternatives, and outcome
   - include a "Protected contracts impact" section:
     - not impacted / impacted (list)
     - if impacted: what would break, and what user approval is required before implementation
    - include suggested follow-up work if a refactor is recommended

## Acceptance checks

- All touched layers are identified
- Dependency direction is validated
- Conflicts and alternatives are explicit
- Outcome is recorded before implementation
- Review file exists in `ROOT_AGENTS_ARTIFACTS/architectural-reviews/`

