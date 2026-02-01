---
name: bug-fix
description: Diagnose and fix bugs or regressions. Use when a user reports broken or incorrect behavior, tests fail due to a defect, or a bug fix is requested.
---

# .codex/skills/bug-fix/SKILL.md

## Name

`$bug-fix`

## Purpose

Resolve a specific defect while preserving intended behavior.

## When to use

Invoke when any apply:

- user reports broken or incorrect behavior
- regression is suspected
- a failing test indicates a defect

## Inputs

- Bug description (expected vs actual)
- Repro steps (or "Unknown")
- Errors/logs (if any)
- Constraints (no API changes, perf limits, etc.)

## Procedure

0. Review protected contracts
   - read `DOC_PROJECT_PROTECTED_CONTRACTS`
   - treat it as must-not-break unless the user explicitly approves a breaking change
1. Confirm the bug statement
   - restate expected vs actual behavior
2. Gather missing repro details
   - ask once for missing steps, logs, or environment info
3. Investigate root cause (before any fix)
   - read errors and logs fully
   - reproduce the issue
   - check recent changes that could explain it
   - compare against a working path or similar code
   - state a single, clear hypothesis
4. Propose scope and risks
   - list affected areas and likely regressions
   - confirm before edits
5. Decide validation
   - propose tests or smoke paths
   - confirm before edits
6. Fix with minimal change
   - avoid unrelated refactors
7. Verify or explain deferral
   - run agreed tests or state why not
8. Summarize
   - root cause, fix, and validation status
   - if this bug fix revealed a new stable contract people will rely on, propose adding it to `DOC_PROJECT_PROTECTED_CONTRACTS` (simple words; user approves/rejects)
   - if there is a durable lesson learned or guardrail that will prevent repeat mistakes, add a short entry to `DOC_PROJECT_INSIGHTS` (otherwise do not)
     - keep it 3-6 bullets and focus on why it matters, the root cause/constraint, the fix/decision, and the prevention

## Acceptance checks

- Expected behavior restored
- Root cause investigated before fixes
- Scope and risks confirmed before edits
- Validation executed or explicitly deferred
- Summary includes root cause and fix

