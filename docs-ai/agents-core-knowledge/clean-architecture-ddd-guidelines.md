# Clean Architecture & DDD Guidelines

## Purpose

- Use this doc after the quick `architecture-principles.md` summary when a change touches domain modeling, layered contracts, or invariants that must survive long-lived systems.
- Refer here for naming, aggregates, testing, and runtime expectations that go beyond the high-level checklist.

---

## Domain Modeling Practice

- **Ubiquitous language**: Agree on shared terminology before encoding it; name modules, entities, value objects, and services with the same domain words.
- **Aggregates**: Keep aggregates small, mutate them only through their roots, and reference other aggregates by ID.
- **Value objects**: Capture concepts defined by value, keep them immutable, and validate invariants at creation.
- **Domain services**: Limit domain services to stateless operations that don't belong on entities or value objects.
- **Events & contexts**: Emit domain events when invariants change, map bounded contexts explicitly, and use Anti-Corruption Layers for legacy or external systems.

---

## Layering & Dependencies

- Boundaries: Entities → Use Cases/Interactors → Interface Adapters → Frameworks & Drivers.
- Direction: Dependencies must point inward; inner layers never depend on outer layers except through explicit ports/adapters.
- Violations: Document temporary deviations, keep them localized, and plan to refactor them out.
- Builders: Prefer builders when constructing aggregates with optional data; enforce mandatory parameters and validate business rules before finalization.

---

## Testing & Quality

- **Test types**: Cover units, integrations, end-to-end flows, and load when behavior may degrade under stress.
- **Principles**: Follow Arrange-Act-Assert, keep tests deterministic, and include boundary/edge cases.
- **DDD testing**: Mock external dependencies, avoid mocking the system under test, and let tests describe business rules.
- **Comments**: Favor self-documenting code. Add brief comments for complex, non-obvious business logic (intent, invariants, edge cases) when clarity would otherwise suffer. Keep comments current; avoid TODOs and remove outdated comments proactively.

---

## Operational Discipline

- **File changes**: Review existing files, change the minimum required lines, and keep structure/imports intact unless refactoring.
- **Cross-cutting**: Log in adapters/infrastructure, translate infra errors before they cross boundaries, handle security at boundaries, and centralize configuration in outer layers.
- **Deployment**: Treat deployables as disposable, aim for stateless services, and maintain environment parity (dev/staging/prod).
- **Evolution**: Prefer additive changes, version APIs/contracts when incompatible, keep migrations testable, and plan for routine data evolution.

---

## Constraints

- No mixing domain logic with framework, persistence, transport, or UI concerns.
- Enforce explicit contracts before exposing behaviors; version schemas when you change them.
- Anti-pattern guardrails: Do not entangle domain rules with infrastructure or UI, and avoid leaking logging or formatting into core logic.



