---
name: project-setup
description: Use when a project foundation must be created or updated from a PRD or idea before any feature work.
---

# .codex/skills/project-setup/SKILL.md

## Name

`$project-setup`

## Purpose

Turn a user idea or PRD into confirmed foundation docs: context, roadmap, and insights.

## When to use

Invoke when any apply:

- project docs are missing, empty, or generic
- user provides a new idea or PRD
- you need a foundation before feature work

## Inputs

- Product (one sentence)
- Users (who it is for)
- Problem (what pain it solves)
- Success (3-7 measurable outcomes)
- Constraints (deadline, budget, privacy, must-use tech)
- Out of scope (what will not be built now)

## Procedure

1. Read the baseline project context, in order:
   - `ROOT_AGENTS`
   - `KB_ROOTS`
   - `KB_REPOSITORY_RULES`
   - `KB_REPOSITORY_LAYOUT`
   - `KB_TECH_STACK`
   - `KB_RUNTIME`
   - `KB_TOOLS`
   - `KB_THREADS`
   - `DOC_SKILLS_LIST`
   - `DOC_PROJECT_CONTEXT`
   - `DOC_PROJECT_ROADMAP`
   - `DOC_PROJECT_INSIGHTS`
   - `DOC_PROJECT_PROTECTED_CONTRACTS`
2. If inputs are missing, ask once for the minimum list and stop.
3. Restate the product input in 3-7 bullets (what it is, who it is for, why it matters).
4. Draft or update foundation docs:
   - `DOC_PROJECT_CONTEXT`
   - `DOC_PROJECT_ROADMAP`
   - `DOC_PROJECT_INSIGHTS`
   - `DOC_PROJECT_PROTECTED_CONTRACTS`
5. Ask for confirmations (single pass):
   - scope in/out
   - success criteria
   - first 3-10 roadmap items (ordered, with a clear next item)
6. After confirmation:
   - Propose the next roadmap item.
   - Strict next step (no choices): create a comprehensive implementation plan for the next roadmap item.
   - Suggest a compliant **project-planning** thread name and provide a copy/paste first message that invokes `$plan-creation`.
   - Stop.

## Output format

Path rule (must): use `KB_ROOTS` aliases (`DOC_*`, `KB_*`, `ROOT_*`) or repo-relative paths. Do not use absolute OS paths.

### Summary

- Product: `<one sentence>`
- Users: `<who it is for>`
- Success (draft): `<3-7 bullets>`
- Proposed next roadmap item: `<item name>`

### Confirmations Needed (single pass)

- Scope in: `<bullets>`
- Scope out: `<bullets>`
- Success criteria: `<bullets>`
- Roadmap order: `<bullets>`

### Next Step (after confirmation)

- Next roadmap item: `<item name>`
- Suggested thread name: `<project> | P-###: <short-goal>`
- Do next:
  - Start a new thread with the suggested name
  - Invoke `$plan-creation`

## Quick reference

| Do | Do not |
| --- | --- |
| Ask for missing inputs once | Start features before foundation is confirmed |
| Keep docs simple and editable | Add deep technical detail |
| Stop after confirmations | Continue into implementation |

## Example

User: "We want a lightweight doc editor for designers."

You:
- Ask for missing inputs
- Draft project context, roadmap, and insights
- Ask for single-pass confirmations
- Propose the next roadmap item

## Rationalization table

| Excuse | Reality |
| --- | --- |
| "We can start coding first" | Foundation docs are required before features. |
| "I need more inputs later" | Ask once now and stop until confirmed. |

## Red flags

- "I will implement a small feature first"
- "I will skip the roadmap to save time"

## Common mistakes

- Skipping the baseline reads
- Asking multiple rounds of questions
- Writing features before confirmation

## Acceptance checks

- Foundation docs updated
- Confirmations collected in a single pass
- Next item and thread name proposed
- No feature code written
