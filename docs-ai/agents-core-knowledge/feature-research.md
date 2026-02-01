# docs-ai/agents-core-knowledge/feature-research.md

## Agent summary

- Defines a timeboxed feature research step to surface risks, constraints, and opportunities before planning.
- Produces a persisted research brief artifact that feeds `KB_FEATURE_TEMPLATE` and `$plan-creation`.

---

## When to run feature research

Run feature research before planning when any apply:

- The feature touches untrusted input (uploads, forms, webhooks, imports).
- The feature introduces or changes API surface (new/changed endpoint, Edge Function).
- The feature stores or processes user data (especially PII) or introduces retention/deletion needs.
- The feature adds auth/permissions, access control, or cross-tenant data paths.
- The feature is cost/performance sensitive (large payloads, streaming, background processing).
- The feature introduces external dependencies or integrations.

Timebox guidance:

- Small: 15-30 minutes
- Medium: 30-90 minutes
- Large: 60-120 minutes (and consider `$architecture-review`)

---

## Output (required)

Write exactly one artifact per task:

- Path: `docs-ai/agents-artifacts/research-briefs/<task-slug>.research.md`
- Do not overwrite existing briefs; create a new slug if needed.

The brief must be concise and decision-oriented, and should update the feature brief by:

- adding missing constraints/defaults
- adding failure modes and abuse cases
- clarifying open questions that block planning
- refining acceptance criteria (only when necessary)

---

## Research lenses (use only what applies)

- Security & abuse: threat surfaces, malware/content risks, rate limits, quotas, authZ.
- Validation & limits: size/type/shape constraints, input sanitization, schema validation.
- Data & privacy: PII classification, retention/deletion, encryption, access control, audit logs.
- UX & failure modes: retries, timeouts, partial success, user-safe errors (see `KB_ERROR_HANDLING`).
- Operations: observability, alerting, idempotency, backpressure, job queues.
- Cost & performance: storage/bandwidth, cold starts, concurrency limits, scaling risks.
- Compliance: any relevant policy or regulatory constraints.

---

## Research brief template

### 1) Scope

- Feature: `<short name>`
- Timebox: `<e.g. 45 min>`
- Boundaries touched: `<e.g. Frontend UI, API, Supabase Storage>`
- Assumptions: `<list or "None">`

### 2) Key risks and abuse cases

- `<risk/abuse case 1>`
- `<risk/abuse case 2>`

### 3) Constraints and recommended defaults

- `<limit/default>`: `<recommended value>` -> `<why>`

### 4) Data handling

- Data types: `<PII/non-PII, files, metadata>`
- Retention/deletion: `<policy or "Unknown">`
- Access model: `<who can read/write>`

### 5) UX and failure modes

- `<failure mode>`: `<expected behavior + user-safe message>`

### 6) Operations and observability

- Logging: `<what to log>`
- Metrics/alerts: `<what to track>`

### 7) Decisions to confirm

- `<decision 1>`: `<default or options>`
- `<decision 2>`: `<default or options>`




