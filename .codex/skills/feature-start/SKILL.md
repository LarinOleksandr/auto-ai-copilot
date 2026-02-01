---
name: feature-start
description: Use when starting a feature thread and you need the current project context, insights, and roadmap before implementation.
---

# .codex/skills/feature-start/SKILL.md

## Name

`$feature-start`

## Purpose

Provide the right context before feature implementation.

## When to use

Invoke when any apply:

- starting a new feature thread
- you need to confirm the current roadmap item

## Inputs

- Feature name (from roadmap)

## Procedure

1. Read in order:
   - `DOC_PROJECT_CONTEXT`
   - `DOC_PROJECT_INSIGHTS`
   - `DOC_PROJECT_ROADMAP`
   - `DOC_PROJECT_PROTECTED_CONTRACTS`
2. If `DOC_PROJECT_ROADMAP` is missing or malformed, suggest `$project-setup` and stop.
3. If a legacy `DOC_PROJECT_FEATURE_PLAN` exists, read it only if the roadmap is missing.
4. Ask: "Starting feature: [feature name]. Proceed?"
5. If the selected feature has subfeatures, include them in the message.
6. If the feature is already `Completed`, inform the user and ask how to proceed.
7. If using legacy `DOC_PROJECT_FEATURE_PLAN` and `docs/plan.md` is missing or malformed, stop and ask the user to fix it.

## Quick reference

| Do | Do not |
| --- | --- |
| Read context and roadmap first | Start implementation without confirmation |
| Stop if roadmap is missing | Guess the next feature |

## Example

User: "Start feature 1.2"

You:
- Load context, insights, roadmap
- Ask: "Starting feature: [name]. Proceed?"

## Rationalization table

| Excuse | Reality |
| --- | --- |
| "I already know the feature" | Confirm with the roadmap before coding. |
| "Roadmap is optional" | It is the source of truth for features. |

## Red flags

- "I will skip the roadmap check"
- "I will proceed without confirmation"

## Common mistakes

- Starting work without reading the roadmap
- Ignoring a completed status

## Acceptance checks

- Context, insights, and roadmap read
- User confirmation requested
- Legacy fallbacks handled when needed
