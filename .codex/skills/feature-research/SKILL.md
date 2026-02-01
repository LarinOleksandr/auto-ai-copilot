---
name: feature-research
description: Produce a timeboxed research brief to surface risks, constraints, and decisions before planning a feature.
---

# .codex/skills/feature-research/SKILL.md

## Name

`$feature-research`

## Purpose

Create a concise, decision-oriented research brief for a feature before `$plan-creation`.

## When to use

Invoke when any apply:

- feature touches untrusted input (uploads, imports, webhooks)
- new/changed API surface
- authZ/permissions or cross-tenant data paths
- storing/processing user data (especially PII)
- cost/performance concerns or external integrations

## Inputs

- Short feature name/goal
- Known constraints (optional)
- References (optional)

## Output

- Write: `ROOT_AGENTS_ARTIFACTS/research-briefs/<task-slug>.research.md`
- Use the template from `KB_FEATURE_RESEARCH`
- Do not overwrite an existing brief for the same slug

## Procedure

1. Restate the feature in one sentence.
2. Identify boundaries touched (choose only what applies):
   - Frontend UI
   - API / Edge Functions
   - Orchestrator workflows
   - Embeddings service
   - Supabase (schema/RLS/storage)
3. Timebox the research and apply relevant lenses (per `KB_FEATURE_RESEARCH`).
4. Produce the research brief:
   - constraints + recommended defaults
   - key risks/abuse cases
   - failure modes + user-safe error expectations
   - decisions to confirm
   - open questions (blockers only)
5. If research changes required feature brief sections (constraints/AC/edge cases), explicitly list what should be updated.

## Acceptance checks

- Research brief artifact exists at the required path.
- Decisions/defaults are concrete and testable.
- Open questions are minimal and genuinely blocking.

