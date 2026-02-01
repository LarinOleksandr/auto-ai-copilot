# docs-ai/agents-core-knowledge/external-specs.md

## Agent summary

- Use Context7 as the default, authoritative source for external specs
- Avoid guessing APIs, defaults, or versions

---

## Primary rule

- Use Context7 for framework, library, and platform specifications.
- Treat Context7 outputs as authoritative over model memory.
- Do not rely on undocumented or inferred behavior.

---

## Fallback policy

Use official documentation only when Context7 is unavailable or incomplete.
If sources conflict, surface the conflict explicitly.

---

## Approved domains (Context7)

- React
- TypeScript
- Vite
- Tailwind CSS
- TanStack Query
- React Router
- Zod
- TipTap
- React Flow
- Node.js
- Supabase
- PostgreSQL
- pgvector
- LangGraph
- LangChain.js
- FastAPI
- Ollama
- Docker
- Docker Compose
- GitHub Actions
- Netlify

---

## Prohibited behavior

- Guessing API shapes or defaults
- Using outdated syntax
- Mixing versions without confirmation



