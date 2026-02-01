# docs-ai/agents-core-knowledge/architecture-principles.md

## Purpose

- Defines layer boundaries and dependency direction
- Keeps contracts stable and frameworks isolated

---

## Layering and direction

- **UI** -> adapters only
- **Orchestrator** -> application/workflow coordination
- **Services** (embeddings, infra) -> infrastructure adapters
- **Data** (Supabase) -> system of record
- Dependencies point inward only.

---

## Clean Architecture layers

- **Domain**: business rules and invariants only.
- **Application**: use-case orchestration, no business rules.
- **Interface adapters**: controllers, DTOs, mappers, repository implementations.
- **Frameworks/infra**: runtime wiring, persistence, IO, external APIs.

---

## Boundaries

- No cross-layer shortcuts (UI -> DB/infra, services -> UI).
- Shared code lives only in `shared/`.
- Framework, infra, and DB types do not leak into shared/core contracts.

---

## Contracts and change discipline

- Cross-boundary communication uses explicit contracts.
- Contracts are defined once and reused.
- Prefer additive, backward-compatible changes.
- If a small change forces edits across many layers, redesign.
- Multi-boundary changes require planning.

---

## Domain modeling (DDD cues)

- Identify aggregates and value objects for core domain concepts.
- Keep domain rules in domain entities/services, not in adapters or UI.
- Use domain events for significant state changes.
- For deeper Clean Architecture + DDD rules, consult `docs-ai/agents-core-knowledge/clean-architecture-ddd-guidelines.md` only when the change touches domain models, value objects, or layered contracts that need detailed invariants and dependency rules. Keep this summary as your first pass; dive into the linked guide when you need explicit DDD best practices, testing expectations, or commentary discipline beyond the quick checklist.

---

## Cross-cutting concerns

- Logging and observability live in adapters or infrastructure only.
- Translate errors at boundaries; do not leak infra errors inward (see `KB_ERROR_HANDLING`).
- Enforce security at use cases or adapters, not in domain.
- Configuration is supplied from outer layers only.

---

## Deviation policy

- Deviations must be explicit, localized, and documented.
- Temporary deviations must be removed or formalized.
- When multiple compliant approaches exist, present at least two options with tradeoffs and a recommendation, and state the assumptions each option depends on.

---

## Architecture review trigger

- If a request may violate architecture boundaries, invoke `$architecture-review` before implementation.

---

## Prohibitions

- No business logic in UI, Edge Functions, or infra.
- No hidden global state or implicit side effects.

---

## Checklist

- Dependency direction respected.
- Contracts updated at the source of truth.
- Boundary violations fixed in code, not documented away.
