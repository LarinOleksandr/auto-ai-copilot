# docs-ai/agents-core-knowledge/deployment-and-cicd.md

## Agent summary

- Defines DNA-level deployment and CI/CD rules for this repo, before concrete services exist.
- Supports both Netlify and Vercel for frontend hosting with explicit selection rules.
- Keeps CI mandatory and CD incremental per runtime boundary.

---

## Goals

- Keep releases safe and repeatable with minimal process.
- Avoid premature provider lock-in while the repo is still evolving.
- Respect repo constraints: service boundaries, layered config, no new deps without approval.

---

## Branch policy (default)

- Use trunk-based development.
- `main` is the default production branch.
- Require PRs into `main` (no direct pushes).
- Derive branch names from the thread name (see `KB_THREADS`) and delete merged branches.
- Protect `main` with required status checks:
  - lint
  - typecheck (for TS services)
  - unit tests
  - build
- Use preview deployments on PRs for the frontend.

Add a separate `staging` branch/environment only when you have a concrete need (compliance, risky migrations, multi-tenant rollout), and document that decision in `DOC_PROJECT_INSIGHTS`.

---

## CI (required)

Implement CI as GitHub Actions when code is present:

- Run on PRs and pushes.
- Execute per runtime boundary (frontend / AI services / Supabase) and do not cross-import.
- Prefer repo scripts over ad-hoc commands (see `KB_REPOSITORY_RULES`).
- Use stack-defined test frameworks from the current project stack (`DOC_PROJECT_CONTEXT`); fall back to the baseline in `KB_TECH_STACK`. Do not add new test deps without explicit approval (see `KB_REPOSITORY_RULES`).

---

## CD (incremental, per boundary)

Do not force a single "deploy everything" pipeline across independent runtimes.

- **Frontend**: can be auto-deployed on merge to `main` once it exists.
- **Supabase**: migrations and RLS require explicit safety gates; start manual/protected, then automate once migrations/tests exist.
- **AI services**: start manual (documented steps) then automate after runtime stabilizes.

Track deploy/go-live work in a dedicated deploy thread (see `KB_THREADS`), so release activities do not pollute feature/bug/refactor threads.

---

## Frontend hosting: Netlify vs Vercel (keep both)

### Default choice

- Default to **Netlify** for a Vite SPA (baseline in `KB_TECH_STACK`; confirm in `DOC_PROJECT_CONTEXT`).

### Choose Vercel when

- The frontend becomes **Next.js**-based, or
- You need Vercel-specific capabilities (edge/runtime features, org-standard tooling), or
- Preview/deploy requirements cannot be met cleanly with Netlify for this project.

### Choose Netlify when

- The frontend remains a **static SPA** (Vite/React Router), and
- You want a simpler "build + static hosting" path with predictable behavior.

### Keeping both variants without confusion

- Store provider-specific templates under `infra/deploy/<provider>/` (templates only).
- Only one provider is "active" for production at a time:
  - record the active provider in `DOC_PROJECT_INSIGHTS` when selected/changed
  - keep the inactive provider's template intact, but do not maintain two live deploy integrations for `main`
- Any provider switch must include:
  - updated env var template (`.env.example` variable names only)
  - updated build/deploy instructions
  - a smoke checklist for `main` deploy

---

## Environment variables (policy)

- All environment-specific config comes from env vars and layered config (see `KB_REPOSITORY_RULES`).
- Keep `.env.example` as the canonical template of required vars (names only; never secrets).
- Any deployment work must include:
  - list of required vars per runtime boundary
  - which system sets them (Netlify/Vercel/Supabase/VM)




