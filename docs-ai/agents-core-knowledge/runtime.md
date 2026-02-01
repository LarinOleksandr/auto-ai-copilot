# docs-ai/agents-core-knowledge/runtime.md

## Agent summary

- Local runtime topology and service connectivity
- Source of truth for URLs, ports, and health checks

---

## Services (local)

- **Frontend (Vite)** -> `http://localhost:5173`
- **AI Orchestrator** -> `http://localhost:8002`
- **Embeddings** -> `http://localhost:8001/health`
- **LLM Runtime (Ollama)** -> `http://localhost:11434`
- **Supabase** -> `http://127.0.0.1:54321`
- **Edge Functions** -> `http://127.0.0.1:54321/functions/v1/<fn>`

---

## Dependencies

- Frontend -> Orchestrator
- Orchestrator -> Embeddings, LLM runtime, Supabase
- Embeddings -> LLM runtime

---

## Startup order

1. LLM runtime
2. Docker services (Supabase, Orchestrator, Embeddings)
3. Frontend

---

## Health checks

- Orchestrator reachable on `:8002`
- Embeddings `/health` returns 200
- Supabase Studio reachable
- Frontend loads without errors

---

## Environment rules

- Env vars only; no hardcoded values.
- `.env.example` defines required variables.

---

## Change checklist

- Preserve full local stack startup.
- Update this file on port/service/dependency changes.
- Multi-service runtime changes require planning.



