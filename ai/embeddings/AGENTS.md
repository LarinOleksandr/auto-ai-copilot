# ai/embeddings/AGENTS.md

## Scope

Applies to `ai/embeddings/**`.

---

## Local rules (extend root)

- Pure infrastructure adapter: embedding generation and preprocessing only.
- Expose a narrow, stable API; validate inputs at the boundary.
- Outputs must be deterministic for the same input + model.
- Model choice and parameters are env-configured; no hardcoding.
- No persistence unless explicitly designed with schemas and versioning.
- Errors are typed; log metadata and failures only.

---

## Testing

- Validate vector shape and type.
- Include a smoke test for the public API endpoint.



