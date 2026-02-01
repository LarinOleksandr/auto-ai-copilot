---
name: db-migration
description: Evolve Supabase schema and data without breaking contracts or RLS.
---

# .codex/skills/db-migration/SKILL.md

## Name

`$db-migration`

## Purpose

Evolve Supabase schema and data without breaking contracts or RLS.

## When to use

Invoke when any apply:

- create/alter/drop tables, columns, indexes, constraints
- modify RLS policies
- add/modify Edge Function DB behavior
- data backfill or transformation required

## Inputs

- Change goal (one sentence)
- Affected tables/entities
- Compatibility requirement (backward-compatible? breaking?)
- Data backfill required? (yes/no)

## Procedure

1. Classify change
   - additive/backward-compatible preferred
   - breaking or destructive -> require `$plan-creation`
2. Ensure the agent can operate Supabase locally
   - Use Supabase CLI and migration files (and repo scripts when present).
   - Do not ask the user to perform manual DB changes in Supabase/Studio.
   - If the repo lacks Supabase CLI scaffolding or migration scripts needed to proceed, add them in-repo before attempting the migration.
3. Update contracts first (if core entities)
   - `shared/types/` (source of truth)
   - `shared/validation/` schemas for structured payloads
4. Write migration
   - explicit and reviewable
   - prefer additive steps (new columns/tables, nullable fields)
5. RLS update (if applicable)
   - follow `KB_SUPABASE`
6. Edge Functions update (if applicable)
   - validate inputs
   - return typed responses
7. Local apply and verification
   - apply migrations locally
   - verify schema state
   - verify RLS allow/deny paths
8. Backfill (if required)
   - explicit, testable step
   - verify counts and invariants
9. Tests
   - RLS allow/deny
   - function behavior
   - schema validation failure paths

## Acceptance checks

- Migration applies cleanly in local environment
- RLS enforced and tested for allowed + denied access
- Contracts and validators updated and consistent
- Backfill completed and verified (if applicable)
- Breaking changes have an explicit plan and rollout notes

