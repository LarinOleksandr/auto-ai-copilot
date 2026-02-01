# .codex/skills/skills.md

## Agent summary

- Canonical list of procedural skills
- Use this file to understand when to invoke each skill

---

## Skills

- `$api-endpoint-development` - Add or change an API/Edge Function endpoint. Use when the work is "add endpoint" or "change request/response". Trigger words: endpoint, API, Edge Function.
- `$architecture-review` - Check a proposed change for architecture fit. Use when the change crosses big boundaries or feels risky. Trigger words: architecture, boundaries, service split, new service.
- `$brainstorming` - Turn a vague idea into a PRD. Use when the user has an idea but no clear requirements. Trigger words: idea, MVP, PRD, brainstorm.
- `$bug-fix` - Find the root cause and fix broken behavior. Use when something is wrong or failing. Trigger words: bug, broken, error, failing test, regression.
- `$code-refactoring` - Change structure without changing behavior. Use when the user says "refactor" or "cleanup" with "no behavior change". Trigger words: refactor, cleanup, restructure.
- `$code-review` - Review a diff/change set and report issues. Use when the user asks for a review. Trigger words: review, PR review, code review.
- `$coding-standards-check` - Check code style and basic maintainability. Use when the user asks for standards or consistency checks. Trigger words: standards, style, consistency.
- `$commit-push-create-pr` - Finish work: verify, update docs, commit, push, and optional PR/merge. Use when the user says they are done. Trigger words: commit, push, PR, merge, finish, wrap up.
- `$conversation-save` - Save a short conversation summary as an artifact. Use when the user asks to save the discussion. Trigger words: save conversation, save discussion, conversation summary, capture decisions.
- `$context-load` - Load a quick project snapshot. Use when we need the current rules/routes/where things are. Trigger words: context, summary, where is, routes.
- `$context-maintenance` - Update and clean the framework docs/skills/routing. Use when rules, routes, or skills changed. Trigger words: update docs, routing, maintain, framework.
- `$critical-review` - Provide a brutally honest critique of an idea or pitch to surface weak points early. Use when asked to critique a concept, product, startup, feature, or business plan. Trigger words: critique, harsh review, devil's advocate, red team, brutal feedback.
- `$db-migration` - Change Supabase schema/RLS/migrations safely. Use when schema or policies change. Trigger words: migration, RLS, schema, table, SQL.
- `$design-review` - Review UX/flow choices (artifact-based). Use when the user asks "is this UX good?" or "review the flow". Trigger words: UX, flow, design review.
- `$documents-export` - Export agent outputs to user documents (PDF/DOCX/MD/JSON). Use when the user asks for export formats. Trigger words: export, PDF, DOCX, document.
- `$feature-development` - Turn a feature request into a confirmed feature brief. Use when a new feature or behavior change is requested. Trigger words: add feature, change behavior, implement.
- `$feature-research` - Do a short research brief before planning. Use when the feature touches risky areas (uploads, permissions, PII, integrations). Trigger words: upload, permissions, auth, PII, integration.
- `$feature-start` - Start a feature thread using current context/roadmap/insights. Use when the user says "start feature" or picks a roadmap item. Trigger words: start feature, next feature, roadmap item.
- `$frontend-design` - Initialize/update the `frontend/web` design system preset. Use when touching UI design system setup. Trigger words: shadcn, preset, design system.
- `$new-agent-development` - Add or change an orchestrator agent/node/workflow. Use when changing agent graphs, nodes, or outputs. Trigger words: agent, node, workflow, LangGraph.
- `$optimize-performance` - Find and fix performance bottlenecks. Use when the user asks to speed things up. Trigger words: performance, slow, optimize, latency.
- `$plan-creation` - Write a concrete plan for a large/risky change. Use when the work spans many areas or has risk. Trigger words: plan, roadmap, big change.
- `$project-setup` - Create/update project foundation docs from an idea or PRD. Use when starting a new product in this repo. Trigger words: project setup, initialize, foundation, PRD.
- `$repo-bootstrap` - Initialize/connect a git repository and configure `origin` so work can be pushed safely. Use when a folder is not a repo or `origin` is missing. Trigger words: repo, git init, origin missing, remote, repository setup.
- `$security-check` - Review for security risks in auth/data/input. Use when the change touches secrets, auth, permissions, or untrusted input. Trigger words: security, auth, permissions, secrets.
- `$test-plan` - Create a repo-consistent test plan. Use when validation is unclear or needs structure. Trigger words: test plan, validation, how to test.
- `$testing-in-browser` - Run UI checks with browser tooling. Use when UI changes need real browser verification. Trigger words: browser test, UI test, devtools.
- `$ui-consistency-check` - Check UI against baseline rules. Use when the user asks for UI consistency. Trigger words: UI consistency, baseline, UX baseline.


