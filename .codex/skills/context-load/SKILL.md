---
name: context-load
description: Load a baseline project context snapshot and routing map.
---

# .codex/skills/context-load/SKILL.md

## Purpose

Provide a fast, consistent snapshot of cross-cutting repo context and where to look next.

## Inputs

- None (use the baseline file list below)

## Procedure

Read the baseline files only, in this order:

Project Knowledge and Artifacts

- `DOC_PROJECT_CONTEXT`
- `DOC_PROJECT_ROADMAP`
- `DOC_PROJECT_INSIGHTS`
- `DOC_PROJECT_PROTECTED_CONTRACTS`

Knowledge routes

- `KB_BEHAVIOUR_ARCHITECTURE`
- `KB_CONTEXT_MAINTENANCE`
- `KB_PROJECT_DOC_MAINTENANCE`
- `KB_REPOSITORY_LAYOUT`
- `KB_REPOSITORY_RULES`
- `KB_RUNTIME`
- `KB_THREADS`
- `KB_TOOLS`
- `KB_TECH_STACK`

## Where To Look Next (routing map)

Assume the most relevant routes and when to consult them (do not read them now):

- `KB_REPOSITORY_LAYOUT`: when deciding where to find/place files and services
- `KB_FEATURE_TEMPLATE`: when defining/confirming a feature brief
- `KB_FEATURE_RESEARCH`: when surfacing risks/constraints before planning
- `KB_DEPLOYMENT_CICD`: when deciding CI/CD or deployment policy
- `KB_TESTING`: when validation plan is unclear or behavior changes
- `KB_SCHEMAS_OUTPUTS`: when adding/changing structured outputs or schemas
- `KB_API_CONVENTIONS`: when adding/changing HTTP APIs or Edge Functions
- `KB_ERROR_HANDLING`: when designing error codes, envelopes, or user-safe messages
- `KB_SUPABASE`: when touching DB schema, RLS, policies, or Edge Functions
- `KB_ARCHITECTURE_PRINCIPLES`: when changes span layers or risk boundary violations
- `KB_RUNTIME`: when changing services, ports, or dependencies
- `KB_UI_BASELINE`: when building consistent UI components and styling rules
- `KB_UX_BASELINE`: when defining UI behavior for loading/empty/error states and feedback
- `KB_TOOLS`: when choosing canonical commands and scripts
- `KB_THREADS`: when starting a new thread or naming one
- `KB_CONTEXT_MAINTENANCE`: when modifying rules/routes/skills/slash commands or detecting duplication/conflicts
