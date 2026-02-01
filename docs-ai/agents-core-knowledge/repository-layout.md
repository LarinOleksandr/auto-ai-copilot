# docs-ai/agents-core-knowledge/repository-layout.md

## Agent summary

- Fast placement index: where to find things and where to put new things.
- This doc answers "where?"; constraints and governance live in `KB_REPOSITORY_RULES`.

---

## Current root layout (what limits search)

| Path | What it contains | Use when you need... |
| --- | --- | --- |
| `AGENTS.md` | Root rules + routing | non-negotiables and which KB doc to consult |
| `scripts/` | Canonical scripts | repeatable repo workflows (git helpers, dev/up/down, etc.) |
| `docs-ai/` | Agent knowledge, prompts, artifacts, and project docs | any agent workflow, prompt, artifact, or project state |
| `.codex/skills/` | Procedural skills | a repeatable multi-step procedure (`$<skill>`) |
| `docs/` | Human-facing docs | application development guidance and collaboration docs |
| `frontend/` | Frontend runtime boundary | the user-facing web/mobile client code (`frontend/web`, when it exists) |
| `frontend/web` | Web application | primary React UI runtime boundary |
| `ai/` | AI runtime boundaries (placeholders) | orchestrator/embeddings services (when they exist) |
| `supabase/` | Supabase boundary (placeholder) | DB migrations, Edge Functions, RLS policies (when adopted) |
| `infra/` | Infrastructure boundary (placeholder) | deploy templates, local stack definitions (when adopted) |

---

## Find index (look here first)

| If you need... | Look in... | Notes |
| --- | --- | --- |
| Repo structure rules / boundaries / config rules | `docs-ai/agents-core-knowledge/repository_rules.md` | canonical constraints |
| Where does X belong? (routing) | `docs-ai/agents-core-knowledge/repository-layout.md` | this document |
| Application workflow guide | `docs/application-development-guide.md` | end-to-end workflow from idea -> deploy |
| Thread naming + codes | `docs-ai/agents-core-knowledge/threads.md` | canonical thread rules |
| Parallel threads (Git worktrees) | `docs-ai/agents-core-knowledge/git-worktrees.md` | one thread = one branch = one worktree |
| UI/UX baseline invariants and guidelines | `docs-ai/agents-core-knowledge/ui-baseline.md`, `docs-ai/agents-core-knowledge/ux-baseline.md` | framework-level defaults for consistent UI behavior |
| Feature brief template | `docs-ai/agents-core-knowledge/feature-template.md` | used by `$feature-start` |
| Feature research expectations | `docs-ai/agents-core-knowledge$feature-research.md` | timeboxed research brief |
| Testing strategy and gates | `docs-ai/agents-core-knowledge/testing.md` | no new deps without approval |
| Deployment/CI "DNA" rules | `docs-ai/agents-core-knowledge/deployment-and-cicd.md` | Netlify/Vercel rules, branch policy |
| Skills list | `.codex/skills/skills.md` | canonical list + when to use |
| A specific skill procedure | `.codex/skills/<skill-name>/SKILL.md` | step-by-step procedure |
| Generated plans | `docs-ai/agents-artifacts/plans/` | created by `$plan-creation` |
| Architecture review artifacts | `docs-ai/agents-artifacts/architectural-reviews/` | created by `$architecture-review` |
| Design review artifacts | `docs-ai/agents-artifacts/design-reviews/` | created by `$design-review` |
| UI validation screenshots | `docs-ai/agents-artifacts/screenshots/` | proof for UI tasks (not committed) |
| PRD artifacts | `docs-ai/agents-artifacts/prds/` | created by `$brainstorming` |
| Research brief artifacts | `docs-ai/agents-artifacts/research-briefs/` | created by `$feature-research` |
| Conversation summaries | `docs-ai/agents-artifacts/conversations/` | created by `$conversation-save` |
| Project context/roadmap/insights/contracts | `docs-ai/project-knowledge/project-context.md`, `docs-ai/project-knowledge/project-roadmap.md`, `docs-ai/project-knowledge/project-insights.md`, `docs-ai/project-knowledge/project-protected-contracts.md` | maintained by `$project-setup` and `$commit-push-create-pr` |
| Archived legacy docs | `docs-ai/old/` | non-canonical reference only |

---

## Placement index (where to put new things)

| If you are adding... | Put it in... | Example name(s) |
| --- | --- | --- |
| A new routed KB doc | `docs-ai/agents-core-knowledge/` | `repository-layout.md`, `deployment-and-cicd.md` |
| A new skill | `.codex/skills/<skill-name>/SKILL.md` | `.codex/skills$design-review/SKILL.md` |
| A new agent artifact type | `docs-ai/agents-artifacts/<category>/` | `design-reviews/`, `research-briefs/`, `prds/` |
| Conversation summaries | `docs-ai/agents-artifacts/conversations/` | `YYYY-MM-DD__D-012__topic.summary.md` |
| A new project "memory" doc | `docs-ai/project-knowledge/` | `project-knowledge/project-context.md`, `project-knowledge/project-roadmap.md` |
| Human-facing guidance | `docs/` | application development guide, user instructions |
| A new deploy template | `infra/deploy/<provider>/` | `infra/deploy/netlify/` |

---

## Adding a new runtime/service (folder placement + naming cues)

This repo grows by adding services. Use these naming cues to keep the tree predictable (constraints are in `KB_REPOSITORY_RULES`):

1. Pick the runtime root by what it is:
   - user-facing app -> `frontend/<app>`
   - AI runtime -> `ai/<service>`
   - DB-adjacent (migrations/functions/policies) -> `supabase/`
   - infra/deploy/local stack -> `infra/`
   - non-AI API/service -> `backend/<service>` (create `backend/` only when it becomes real)
2. Name by role, not technology:
   - prefer: `web`, `api`, `worker`, `orchestrator`, `embeddings`
   - avoid: `react`, `node`, `python`, `express`
3. If a new service is expected to become a permanent runtime boundary, create it under the correct root and keep it self-contained.

---

## Expected next folders as real code appears (not present yet)

These are common additions as the proto-repo becomes a real application:

- `shared/` (contracts and schemas shared across services)
- `backend/` (non-AI API/services)
- `config/` (global defaults/templates, if needed beyond service-local config)
- `tests/` (cross-service test suites, if needed)






