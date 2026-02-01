---
name: design-review
description: Review UX/flow decisions and propose improvements (timeboxed; artifact-based).
---

# .codex/skills/design-review/SKILL.md

## Name

`$design-review`

## Purpose

Run a focused design/UX review of a feature or user flow and produce a short, actionable review artifact.

## When to use

Invoke when any apply:

- a feature changes a user-facing flow and you want to confirm clarity/usability
- UI/UX requirements are ambiguous and need a quick, structured check
- you want alternatives for layout/content/interaction without implementing code yet
- the user explicitly requests a design review

## Inputs

- Feature or flow to review (1 sentence)
- Target users (if known)
- Constraints (brand, devices, accessibility, copy tone)
- Screenshots/links (optional)

If any are missing, propose defaults and ask once for confirmation.

## Timebox

Default: 30 minutes (or the smallest useful scope). If the review grows, propose narrowing scope.

## Procedure

1. Establish the review scope
   - 1???3 key user flows
   - key screens/states (empty, loading, error)
2. Identify risks and opportunities
   - confusion points
   - missing states/feedback
   - accessibility or mobile issues
3. Propose improvements
   - concrete recommendations (copy, layout, steps)
   - ???good/better/best??? options only if requested
4. Produce the artifact
   - write `ROOT_AGENTS_ARTIFACTS/design-reviews/<task-slug>.design-review.md`
   - keep it short and implementable

## Artifact format (required)

- Goal
- Scope (flows reviewed)
- Findings (top issues)
- Recommendations (ordered)
- Open questions (only if blocking)

## Acceptance checks

- Scope is explicit and timeboxed
- Recommendations are actionable (not abstract)
- Artifact path is created and referenced in the thread


