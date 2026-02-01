# supabase/AGENTS.md

## Scope

Applies to `supabase/**`.

---

## Local rules (extend root)

- This folder contains schema, policies, Edge Functions, and local Supabase config only.
- All schema changes are migration-driven; no direct edits.
- When working with Supabase, the agent must use Supabase CLI plus repo scripts (when present) to create/apply migrations and to capture changes as migration files.
- Do not ask the user to “do it in Supabase/Studio manually” as a workaround; if the repo is missing scripts/CLI scaffolding needed to proceed, add the missing pieces in-repo instead.
- Edge Functions are adapters only; no domain logic.
- Review `KB_SUPABASE` before changes.
- Data model changes or destructive migrations require `$plan-creation`.



