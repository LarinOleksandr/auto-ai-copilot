# docs-ai/agents-core-knowledge/supabase.md

## Agent summary

- Supabase data rules, migrations, RLS policy design, Edge Functions constraints
- Source of truth for data safety and evolution

---

## Role

- Supabase is the system of record.
- Other layers interact only via explicit adapters.

---

## RLS policy design

- RLS is assumed on all user-scoped tables; treat missing RLS as a violation.
- Supabase RLS must remain enforced; never disable as a workaround.
- Policies must be explicit, minimal, and testable.
- Prefer deny-by-default with explicit allow rules.

---

## Schema and migrations

- All schema changes go through migrations.
- No manual edits to live schemas.
- Prefer additive, backward-compatible changes.
- Destructive changes require planning and verification.

---

## Operational workflow (agent rule)

- The agent operates Supabase through the **Supabase CLI** and migration files (plus repo scripts when present).
- Do not delegate routine DB operations to the user (e.g., â€œclick this in Studioâ€) as a substitute for migrations.
- If required CLI scaffolding or scripts are missing, add them in-repo (per `KB_REPOSITORY_RULES` â€œscripts-not-raw-commandsâ€) instead of asking the user to do manual steps.

---

## Contracts and validation

- Persisted structured data conforms to schemas.
- Schema changes require updates to:
  - migrations
  - `shared/types/` (if core)
  - validators
- DB schema is not the API contract; schemas are.

---

## Edge Functions

- Thin adapters: input validation, authorization, delegation.
- No business logic or domain rules.
- Explicit, typed responses only.

---

## Data evolution

- Prefer append-only or versioned records.
- Backfills and data migrations must be explicit and testable.

---

## Mutable document storage

- Store a canonical snapshot for current state (fast reads, easy overwrite).
- Extract fields only when they must be filtered, sorted, or indexed.
- Keep history in an append-only event log, not inside the snapshot.

---

## Snapshot update and versioning

- Prefer partial updates for small changes; avoid rewriting full snapshots.
- Maintain a version/revision for optimistic concurrency and rollback.
- Do not let snapshots grow without bound; prune or split when needed.

---

## Decision checklist

- Will it be filtered or sorted? -> extract it.
- Will it grow without bound? -> event log.
- Is the structure unstable? -> snapshot.
- Is it historical only? -> event log.
- Is it UI-only state? -> snapshot.

---

## Observability and safety

- Log metadata and failures only.
- Never log secrets, PII, or raw user content.
- Errors must be actionable for callers.

---

## Change checklist

- Migration created and applied locally.
- RLS policies reviewed and tested for allow/deny.
- Contracts and validators updated.
- Backfill/verification plan created (if needed).



