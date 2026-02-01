# Repository Rules

## Agent summary

- Canonical repository constraints and practices.
- Rule priorities determine how strictly to follow each rule.
- For placement (“where should this go?”), consult `KB_REPOSITORY_LAYOUT`.

---

## Rule priorities

- must: Hard constraint. Do not propose or implement changes that violate a must rule.
- should: Strong recommendation. Deviations require explicit justification.
- may: Optional preference. Follow when convenient and aligned with higher priorities.

---

## Rules

### priority-interpretation (must)

Respect rule priorities when generating or modifying code.

- When applying these conventions, treat must rules as inviolable constraints.
- Treat should rules as strong preferences that require justification when ignored.
- Treat may rules as optional guidance.
- If a requested change conflicts with a must rule, explain the conflict instead of silently ignoring the rule.

### service-boundary (must)

One runtime boundary per service folder.

If a component scales, deploys, or runs independently, it must live in its own service folder (for example `frontend/web`, `backend/api`, `ai/orchestrator`, `ai/embeddings`). Shared code goes into `shared/`; do not cross-import code directly between services.

### docs-human-only (should)

Treat `docs/` as human-facing documentation only.

- Agent-oriented knowledge and prompts belong under `docs-ai/`.
- Keep `docs/` focused on onboarding and developer documentation.

### routed-aliases-over-absolute-paths (must)

In agent instructions (AGENTS, routed docs, skills, templates), prefer `KB_ROOTS` aliases and repo-relative paths.

- Use `ROOT_*`, `KB_*`, and `DOC_*` routes instead of absolute OS paths (like `<absolute-os-path>`).
- Rationale: absolute paths are machine-specific and cause broken links and inconsistent behavior.
- Exception: in scripts and commands, use relative paths from the repo root when possible (for example `scripts/...`).

### scoped-agents-only-when-needed (should)

Add scoped `AGENTS.md` only when local constraints differ from root.

- Keep scoped `AGENTS.md` smaller than the root.
- Avoid restating global rules; reference routed docs instead.

### scripts-not-raw-commands (must)

Expose common workflows via scripts, not ad-hoc commands.

For recurring workflows (dev server, tests, builds, migrations, seeding), add or reuse scripts in `scripts/` or in a service-local scripts folder instead of writing long shell commands in docs or comments. Prefer wiring new commands into existing package.json scripts or helper shell scripts.

### git-prerequisite-gate (must)

Git is a required prerequisite for this frameworkâ€™s normal workflow.

Before any workflow that expects Git (branching, committing, pushing, PRs, worktrees), the agent must verify that `git` is installed and available on PATH.

If `git` is not available:

- Stop and explain that Git must be installed before continuing.
- Do not propose `$commit-push-create-pr`.
- Propose `$repo-bootstrap` as the next step to re-check and continue once Git is installed.

### dependencies-require-approval (must)

No new external dependencies without explicit approval.

Before adding a new external dependency (npm/pnpm package, pip package, Docker image, etc.), get explicit approval in the thread. When requesting approval, include:

- why it is needed (what it enables)
- alternatives considered (including "use what we already have")
- cost/risk notes (bundle size, perf, security/maintenance)

### configs-layered (must)

Use layered configuration per environment.

Global defaults live under `config/runtime/`. Service-specific runtime configuration lives next to each service (for example `backend/config`, `ai/orchestrator/config`, `frontend/web/config`). Do not hardcode environment-specific values (like production URLs, API keys, or feature flags) directly in code.

### secrets-outside-git (must)

Never commit secrets to the repository.

Do not add real API keys, passwords, tokens, or other secrets to code, config files, or tests. Only `.env.example` templates and documented variable names are allowed in Git. Real secrets are passed via environment variables, secret managers, or local `.env` files that are ignored by `.gitignore`.

### shared-types-source-of-truth (must)

Use `shared/types` as the central contract for core entities.

Types for core entities like Project, Document, and AgentRun must be defined and updated in `shared/types`. Reference these shared types instead of redefining shapes ad hoc in frontend, backend, or AI services. When changing a core entity, update `shared/types` first and then propagate as needed.

### shared-validation (should)

Reuse `shared/validation` schemas across services.

Where possible, define validation schemas in `shared/validation` (for example Zod schemas) and reuse them in frontend, backend, and AI orchestrator. This reduces drift between validation and type definitions. Local one-off validation is acceptable only for clearly local concerns.

### data-discipline (must)

Do not store large datasets or binary artifacts in the repo.

Do not add large datasets, model binaries, or generated files to source control. Only tiny sample data sets needed for tests and examples are allowed. Large artifacts belong in external storage or data/versioning tools and should be referenced, not committed.

### readmes-everywhere (should)

Provide short README files for important folders.

For key folders (root, `frontend/web`, `backend`, `ai/orchestrator`, `ai/embeddings`, `shared`, `infra`, `supabase`), ensure a brief README exists explaining purpose, how to run, and key configuration. When adding a new major folder, also add a minimal README.

### scripts-dev-all (must)

Keep dev-all entry point working and up to date.

Whenever you add or remove core services that are expected in local development, update `scripts/dev-all.sh` (or the equivalent entry point) and related package.json scripts so that a single command still starts the full local stack reliably.

### infra-compose-single-source (should)

Use a single docker-compose definition with profiles.

Treat the `infra/docker/docker-compose.yml` as the main description of the local stack. New services that need to run locally should be added there, and profiles (for example dev, ci) should be used instead of creating multiple unrelated compose files.



