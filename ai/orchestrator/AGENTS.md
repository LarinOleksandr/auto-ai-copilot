# ai/orchestrator/AGENTS.md

## Scope

Applies to `ai/orchestrator/**`.

---

## Local rules (extend root)

- Orchestrator owns workflow coordination only.
- Use **LangGraph** for all workflows; graph structure is explicit and deterministic.
- Every node declares input/output schemas; outputs validate per `KB_SCHEMAS_OUTPUTS`.
- Prompts are version-controlled and colocated with their workflows/nodes.
- State persistence is explicit; no globals or module-level caches.
- LLM calls are treated as untrusted; handle invalid output via retry/repair/controlled failure.

---

## Testing

- Test full workflows, not only nodes.
- Cover happy path, schema failure, and dependency/LLM failure.



