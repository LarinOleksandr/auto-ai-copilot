---
name: ui-consistency-check
description: Use when reviewing UI changes for consistency with the UI and UX baselines.
---

# .codex/skills/ui-consistency-check/SKILL.md

## Name

`$ui-consistency-check`

## Purpose

Verify UI changes follow baseline UI and UX rules.

## When to use

Invoke when any apply:

- user requests a UI consistency review
- a change affects user-facing components
- new views or flows are added

## Inputs

- Target routes or components
- Screenshots or URLs (if any)

## Procedure

1. Review `KB_UI_BASELINE` and `KB_UX_BASELINE`.
2. Check for:
   - consistent typography and spacing
   - clear loading, empty, and error states
   - accessible focus states
   - predictable form validation feedback
   - mobile layout stability (no clipped controls)
3. List issues with file paths and fixes.
4. If no issues, state that explicitly.

## Output format

For each issue:

- **Issue**: `<summary>`
- **Location**: `<file:line or component>`
- **Baseline**: `<UI or UX rule>`
- **Recommendation**: `<fix>`

If clean:

- Confirm UI consistency
- List 2-4 strengths

## Quick reference

| Do | Do not |
| --- | --- |
| Cite UI/UX baselines | Rely on personal preference |
| Include specific fixes | Provide vague feedback |

## Example

Issue: "No visible focus state on primary button"
Location: `frontend/web/components/Button.tsx:45`
Baseline: `KB_UI_BASELINE`
Recommendation: "Add focus ring class"

## Rationalization table

| Excuse | Reality |
| --- | --- |
| "It looks fine" | Must match baseline rules. |
| "We can fix UI later" | UI consistency is part of quality. |

## Red flags

- "I will skip the baseline review"
- "I will not cite baseline rules"

## Common mistakes

- Missing focus states
- Inconsistent spacing between pages

## Acceptance checks

- Issues cite baseline rules
- Recommendations are actionable
