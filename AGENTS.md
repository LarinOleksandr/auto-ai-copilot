# AGENTS.md

## Routes to essential knowledge and instructions

Read `docs-ai/agents-core-knowledge/roots.md` for the routing map.

## Discussion vs action (must)

- Default to discussion (no file edits, no command/tool runs).
- Act only when the user explicitly asks to act (for example: "implement", "perform", "act", "go ahead"). If unclear, ask: "Do you want me to implement this now?"

## Protected contracts (must)

- Before any work that changes behavior (feature, bug fix, refactor), review `DOC_PROJECT_PROTECTED_CONTRACTS` and treat it as hard constraints.
- Be proactive:
  - when you see a likely “contract moment” (stored data shape, API shape, auth flow, shared schema, export format), propose updates to `DOC_PROJECT_PROTECTED_CONTRACTS`
  - explain in simple words and avoid jargon
  - ask for a simple decision: Approve / Reject / Approve with changes
  - if approved, the agent updates the doc and records the decision in `DOC_PROJECT_INSIGHTS`

## Skill routing (must)

Skills live in the repo at `.codex/skills/`.

- When the user asks you to **do work** (implement, fix, investigate, run, test, build, configure, refactor, review, plan, export, migrate, deploy, commit, push, PR, merge), you must:
  1. Consider Worktree rules (including the pre-work branch check) in `KB_GIT_WORKTREES`.
  2. Check `DOC_SKILLS_LIST` and pick the best matching skill.
  3. Open and follow that skill's `ROOT_SKILLS/<skill-name>/SKILL.md` step-by-step.
- Do not answer with generic advice when a matching skill exists.
- If no skill matches, proceed with the simplest safe approach and explain the assumption.

## Verification (must)

- Do not guess. If you are unsure, read the repo files or use tools to verify.
- For external framework/library/platform specs, follow `KB_EXTERNAL_SPECS` (Context7 first; otherwise official docs).
- Follow the git prerequisite gate in `KB_REPOSITORY_RULES` before workflows that expect git (commit/push/PR/worktrees).
- Enforce the path rule from `KB_REPOSITORY_RULES`:
  - In any skill output, docs, PRDs, plans, or artifacts, use `KB_ROOTS` aliases (`ROOT_*`, `KB_*`, `DOC_*`) or repo-relative paths.
  - Do not output absolute OS paths (for example `<absolute-path>`) unless they are required inside a shell command.

## Automatic agentic invocation

Agent may automatically invoke additional steps when risk or complexity is detected:

- `$project-setup` when the user provides an idea/PRD and the project foundation docs are missing, empty, clearly outdated, or still generic placeholders.
  - If the agent detects the project has not been initialized yet (no real product info in `DOC_PROJECT_CONTEXT`, `DOC_PROJECT_ROADMAP`, `DOC_PROJECT_INSIGHTS`), it must first ask for the PRD or minimal product inputs (Product, Users, Problem, Success, Constraints, Out of scope) and then propose `$project-setup`.
- `$feature-development` when the user requests a new feature or behavior change and requirements are unclear.
- `$feature-research` when the feature touches risky areas (uploads, permissions, external integrations, PII, authZ).
- `$plan-creation` for large or complex changes (multiple components, schema/contract changes, new agent/service/workflow, or shared/core refactors). Plans are written to `ROOT_AGENTS_ARTIFACTS/plans/<task-slug>.plan.md`.
- `$architecture-review` for cross-boundary changes, new services/workflows, or likely architecture conflicts.
- `$api-endpoint-development` when adding or changing API/Edge Function endpoints or their contracts.
- `$db-migration` when schema, RLS, or migrations are involved.
- `$new-agent-development` when orchestrator workflows/nodes or output schemas change.
- `$documents-export` when adding or changing export formats or templates.
- `$test-plan <feature>` when validation needs are unclear or when changes touch UI behavior or API endpoints; propose it and ask the user to confirm before generating the plan.
- `$testing-in-browser` when UI behavior changes require manual verification.
  - Default for UI tasks: run it (and capture screenshots) unless the user explicitly asks to skip UI validation.
- `$commit-push-create-pr` when feature scope is complete and validation is acceptable; propose it and ask the user to confirm before committing.
- `$conversation-save` when the user explicitly asks to save the conversation summary, or confirms "Yes" when asked during `$commit-push-create-pr`.
- `$context-maintenance` when changes touch documentation, routed knowledge, skills, or any AGENTS rules/routes; resolve routing and duplication and update project docs when needed.

When auto-invoked, the agent pauses implementation, explains why, and asks for any missing inputs or required approvals before running the skill.
Auto-invocation must still respect **Discussion vs action** rules.
