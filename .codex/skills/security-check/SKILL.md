---
name: security-check
description: Use when reviewing changes for security risks in auth, data access, and input handling.
---

# .codex/skills/security-check/SKILL.md

## Name

`$security-check`

## Purpose

Identify security risks and required fixes.

## When to use

Invoke when any apply:

- user requests a security review
- changes touch auth, data access, or external inputs
- new endpoints or integrations are introduced

## Inputs

- Target scope (files or feature)
- Known auth model (if any)

## Procedure

1. Restate the scope and any assumptions.
2. Review for:
   - input validation at boundaries
   - authentication and authorization checks
   - RLS and data isolation (`KB_SUPABASE`)
   - secrets handling (`KB_REPOSITORY_RULES`)
   - error message safety (`KB_ERROR_HANDLING`)
   - logging of sensitive data
3. For each issue, provide a fix and risk level.
4. If no issues, state that explicitly.

## Output format

For each issue:

- **Issue**: `<summary>`
- **Location**: `<file:line>`
- **Risk**: `<Critical/High/Medium/Low>`
- **Recommendation**: `<fix>`

If clean:

- Confirm no security blockers
- List any positive controls found

## Quick reference

| Do | Do not |
| --- | --- |
| Require validation at boundaries | Assume inputs are safe |
| Check authZ for every data path | Trust UI-only checks |

## Example

Issue: "Missing auth check before reading project"
Location: `backend/api/project.ts:20`
Risk: High
Recommendation: "Require user session and enforce RLS"

## Rationalization table

| Excuse | Reality |
| --- | --- |
| "It is internal" | Internal endpoints still need validation. |
| "We can add auth later" | Security must be built in now. |

## Red flags

- "I will skip auth review"
- "I will not check input validation"

## Common mistakes

- Missing auth checks
- Exposing secrets in logs

## Acceptance checks

- Issues include location and risk
- Recommendations are concrete
