---
name: feature-development
description: Manage feature development readiness. Use when a user requests a new feature or behavior change, including short or vague requests that need structured clarification.
---

# .codex/skills/feature-development/SKILL.md

## Name

`$feature-development`

## Purpose

Transform a feature request into a confirmed, actionable feature brief.

## When to use

Invoke when any apply:

- user requests a new feature or behavior change
- requirements are partial or unclear
- feature spans multiple components or services

## Inputs

- Feature request (even a short description)
- Constraints (if known)
- References (if any)

## Procedure

1. Classify complexity
   - small, medium, or large using `KB_FEATURE_TEMPLATE`
2. Assess risk and unknowns
   - if risk/unknowns are likely, do a timeboxed research pass and incorporate the outcomes into the feature brief (see `KB_FEATURE_RESEARCH`)
   - if a separate, persisted research brief is needed, propose `$feature-research`
3. Draft the feature brief
   - fill required sections from repo context first
   - include any research outcomes as constraints/defaults and edge cases
4. Ask only for missing required fields
   - single pass, clear questions
5. Confirm before changes
   - confirm scope, out of scope, and acceptance criteria
6. Trigger follow-ups
   - invoke `$architecture-review` for large or cross-boundary changes
   - invoke `$plan-creation` when change complexity requires it
7. Validation gate (when near done)
   - propose `/test-plan` (and `/test-in-browser` when UI is involved) and ask the user to confirm before running them
8. Finish gate (when done)
   - update project docs during `$commit-push-create-pr` (context/roadmap/insights, when needed)
   - propose `$commit-push-create-pr` and ask the user to confirm before committing

## Acceptance checks

- Required sections are complete or explicitly "Unknown"
- Missing required fields are confirmed with the user
- Scope and out-of-scope are explicit
- Follow-up triggers applied when needed

