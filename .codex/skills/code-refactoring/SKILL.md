---
name: code-refactoring
description: Perform a structural change without altering external behavior.
---

# .codex/skills/code-refactoring/SKILL.md

## Name

`$code-refactoring`

## Purpose

Perform a structural change without altering external behavior.

## When to use

Invoke when any apply:

- code needs cleanup or reorganization
- behavior must remain unchanged
- refactor spans multiple files or folders

## Inputs

- Refactor goal (one sentence)
- Must-not-change constraints (APIs, outputs, behavior)
- Optional references (plan or architecture review)

## Procedure

0. Review protected contracts
   - read `DOC_PROJECT_PROTECTED_CONTRACTS`
   - treat it as the default must-not-change set for refactors
1. Confirm intent
   - verify behavior must remain unchanged
2. Propose scope and risks
   - list affected areas and potential regressions
   - confirm before edits
3. Check for existing artifacts
   - use `ROOT_AGENTS_ARTIFACTS/plans/<task-slug>.plan.md` if present
   - use `ROOT_AGENTS_ARTIFACTS/architectural-reviews/<task-slug>.arch-review.md` if present
4. Decide validation
   - propose tests or smoke paths
   - confirm before edits
5. Implement minimal changes
   - avoid unrelated refactors
6. Summarize and report
   - what changed
   - validation status
   - if the refactor introduced or clarified a stable contract people will rely on, propose adding it to `DOC_PROJECT_PROTECTED_CONTRACTS` (simple words; user approves/rejects)

## Acceptance checks

- Behavior unchanged (by intent and validation)
- Scope and risks confirmed before edits
- Tests/validation executed or explicitly deferred
- Summary provided

