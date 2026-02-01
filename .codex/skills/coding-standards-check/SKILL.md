---
name: coding-standards-check
description: Use when reviewing changes for coding standards, consistency, and basic maintainability.
---

# .codex/skills/coding-standards-check/SKILL.md

## Name

`$coding-standards-check`

## Purpose

Review code for consistency with repo rules, style, and maintainability expectations.

## When to use

Invoke when any apply:

- user requests a standards check
- a PR needs a lightweight quality pass
- a change touches multiple files or layers

## Inputs

- Target scope (files or feature)
- Constraints (no refactors, docs-only, etc.)

## Procedure

1. Identify the scope and affected areas.
2. Review for:
   - naming consistency and clarity
   - file placement (see `KB_REPOSITORY_LAYOUT`)
   - boundary rules (`KB_REPOSITORY_RULES`)
   - input validation at boundaries
   - config layering and no hardcoded env values
   - reuse of shared types/validation where required
3. List issues with file paths and fixes.
4. If no issues, say so and list strengths.

## Output format

For each issue:

- **Issue**: `<summary>`
- **Location**: `<file:line>`
- **Rule**: `<rule or guideline>`
- **Recommendation**: `<fix>`

If clean:

- Confirm no blocking issues
- List 2-4 strengths

## Quick reference

| Do | Do not |
| --- | --- |
| Cite repo rules | Rewrite code beyond scope |
| Give concrete fixes | Give vague advice |

## Example

Issue: "API input not validated"
Location: `backend/api/create.ts:12`
Rule: "Validate external input before use"
Recommendation: "Add Zod schema at boundary"

## Rationalization table

| Excuse | Reality |
| --- | --- |
| "It looks fine" | Cite rules and point to evidence. |
| "Minor issues can be skipped" | Standards checks must be explicit. |

## Red flags

- "I will skip file locations"
- "I will not reference rules"

## Common mistakes

- Missing file paths
- Ignoring boundary rules

## Acceptance checks

- Issues include location and rule
- Recommendations are actionable
