# docs-ai/agents-core-knowledge/tools.md

## Agent summary

- Tool selection and canonical commands
- Stack-specific choices live in scoped AGENTS

---

## Canonical commands

- Install deps: `pnpm install`
- Start dev: `pnpm dev` (or `pnpm --filter web dev`)
- Test: `pnpm test`
- Lint: `pnpm run lint`
- Dev status (if present): `./scripts/dev-status.sh`
- Start stack (if present): `./scripts/dev-up.sh`
- Stop stack (if present): `./scripts/dev-down.sh`
- Start a work branch from thread name: `powershell -NoProfile -ExecutionPolicy Bypass -File scripts/git-task-start.ps1 -ThreadName "<thread name>"`
- Start a worktree (parallel threads) from thread name: `powershell -NoProfile -ExecutionPolicy Bypass -File scripts/git-worktree-start.ps1 -ThreadName "<thread name>"`
- Remove a worktree (cleanup): `powershell -NoProfile -ExecutionPolicy Bypass -File scripts/git-worktree-remove.ps1 -WorktreePath ".worktrees/<branch-path>"`
- Push branch + create PR (if possible): `powershell -NoProfile -ExecutionPolicy Bypass -File scripts/git-pr-create.ps1`
- Merge current branch into main: `powershell -NoProfile -ExecutionPolicy Bypass -File scripts/git-merge-main.ps1`

## UI testing (Playwright, on demand)

- Ensure Playwright + browsers (on demand): `powershell -NoProfile -ExecutionPolicy Bypass -File scripts/ensure-playwright.ps1`
- Quick headless screenshot (optional): `powershell -NoProfile -ExecutionPolicy Bypass -File scripts/playwright-screenshot.ps1 -Url "<url>" -OutFile "docs-ai/agents-artifacts/screenshots/<task-slug>/page.png"`

## Cross-platform fallbacks

- If `pnpm` is unavailable, use `npm run dev` or `yarn dev` for UI start.
- If `./scripts/dev-up.sh` is not usable on Windows, look for a PowerShell equivalent (e.g., `./scripts/dev-up.ps1`) or run the underlying services directly.

---

## Tool selection

- **pnpm** for dependency management and workspace scripts.
- **Project scripts (`./scripts/*`)** for canonical workflows.
- **Docker / Docker Compose** for local runtime (Supabase, orchestrator, embeddings).
- **Supabase CLI** for DB/auth/storage/migrations/Edge Functions.
- **LangGraph (JS)** for workflow graphs.
- **LangChain.js** for LLM calls inside orchestrator nodes.
- **Ollama** as the local LLM runtime.
- **Context7** for authoritative framework/library/platform specs.

---

## Stack sources

- Tech stack baseline: `docs-ai/agents-core-knowledge/tech-stack-baseline.md` (project stack in `DOC_PROJECT_CONTEXT`)
- Do not introduce new tools without updating the stack source of truth.

See stack rules in scoped instructions:

- `frontend/AGENTS.md` for UI stack rules
- `ai/orchestrator/AGENTS.md` for orchestration rules
- `ai/embeddings/AGENTS.md` for embeddings rules

---

## Usage rules

- Choose the narrowest tool that solves the task.
- Do not introduce new tools without a clear gap.





