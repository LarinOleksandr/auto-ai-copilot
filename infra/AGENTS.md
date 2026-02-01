# infra/AGENTS.md

## Scope

Applies to `infra/**` (Docker, compose files, deployment configs, runtime infrastructure).

---

## Local rules (extend root)

- Infra defines runtime topology only; no application or business logic.
- Changes must preserve the ability to run the full local stack.
- Service boundaries are explicit (names, ports, networks).
- Avoid cross-service coupling via shared volumes unless required.
- Configuration via environment variables; update `.env.example` when variables change.
- Multi-service infra changes require planning.
- Prefer a single `infra/docker/docker-compose.yml` with profiles over multiple compose files.

---

## Testing

- Verify `dev-up` and `dev-down` scripts after changes.
- Confirm required services start and are reachable.



