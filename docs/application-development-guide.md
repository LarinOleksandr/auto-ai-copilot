# Application Development Guide (with Codex + this Framework)

This guide is a practical, step-by-step way to build and publish a digital product using the project's commands and collaboration rules.

---

## 1) Getting Started (Idea -> Project Setup)

### 1.1 Inputs you can start with

Provide any of the following (more detail helps, but keep it simple):

- **Idea**: 5-15 lines describing what the product does and who it is for
- **Notes**: bullet points of requirements, problems, and constraints
- **PRD**: a structured requirements doc (paste sections if needed)

If your input is vague or short, start with `$brainstorming` to build a PRD.  
The PRD is saved to `docs-ai/agents-artifacts/prds/`.

Recommended minimum (copy/paste and fill):

- **Product**: `<one sentence>`
- **Users**: `<who uses it>`
- **Problem**: `<what pain it solves>`
- **Success**: `<3-7 measurable outcomes>`
- **Constraints**: `<deadline, budget, privacy, must-use tech>`
- **Out of scope**: `<what we will not build now>`

### 1.2 First action: align with the framework

Strict order (most reliable for new projects):

1) If you just completed `$brainstorming`, first make sure the PRD is safely saved to a real repo:

- `$repo-bootstrap` (only if the folder is not a git repo or `origin` is missing)
- `$commit-push-create-pr` (commit + push the PRD)

2) Then run:

- `$project-setup` (use the PRD as input)

What you should expect from the agent:

- If the agent detects the project foundation is still uninitialized (project docs are empty/generic), it will first ask for the minimal product inputs (Product, Users, Problem, Success, Constraints, Out of scope) and then proceed with `$project-setup`.
- The agent turns your idea/PRD into a first draft of the project foundation docs
- The agent asks you to confirm only key foundations (scope, success criteria, initial roadmap)
- After confirmation, the agent proposes the next roadmap item and suggests a correct thread name for it

### 1.3 Project "foundation" outputs (what gets drafted/updated)

During `$project-setup`, the agent drafts/updates:

- `docs-ai/project-knowledge/project-context.md` (what the product is)
- `docs-ai/project-knowledge/project-roadmap.md` (what we'll do next, ordered)
- `docs-ai/project-knowledge/project-insights.md` (key decisions and why)

Use `$context-load` later when you want a quick "where are we and what are the rules?" snapshot without changing any docs.

### 1.4 Confirmation gates (what you must approve)

You must explicitly confirm:

- **Scope**: what is included and excluded (for now)
- **Success criteria**: what "done" looks like for the near term
- **Initial roadmap**: a first-pass ordered roadmap (foundations/capabilities first, then Feature Development)

When you confirm, the next work can start.

---

## 2) Thread rule (how to avoid chaos)

One thread = one task.

Examples of tasks (thread types):

- project planning
- feature development
- bug fix
- code refactor
- experiment / spike
- architecture review & decision
- documentation update
- code review
- design review
- deploy & publish

If the task changes materially, start a new thread.

If you don't know how to name the thread, ask the agent to propose a compliant thread name and follow it.

### 2.3 Git setup (agent does this automatically)

You should not think about Git commands.

What you should expect when you start a thread that changes files (feature/bug/refactor/docs/deploy):

- If `git` is not installed, the agent stops and asks you to install it before continuing.
- If the folder is not a git repo yet (or `origin` is missing), the agent runs `$repo-bootstrap` first.
- The agent creates a branch from the thread name.
- The agent creates an isolated work folder (Git worktree) under `.worktrees/...` so parallel threads do not overwrite each other.
- The agent works only inside that worktree folder for the rest of the thread.

If you want to keep work in the main repo folder for a simple one-off change, say so explicitly (â€œno worktree for this threadâ€).


### 2.1 Thread naming (required)

- Start every thread with its name on the first line.
- Use: `<project> | <code>: <short-goal>`
- If no code exists: `<project> | <short-goal>`

Thread codes (use what matches the task):

- Project planning: `P-###`
- Feature development: `F-###`
- Bug fix: `B-###`
- Code refactor: `RF-###`
- Experiment / spike: `E-###`
- Architecture review & decision: `A-###`
- Docs update: `D-###`
- Code review: `CR-###`
- Design review: `DR-###`
- Deploy & publish: `DP-###`

### 2.2 Protected contracts (safety defaults)

Protected contracts are parts of the product that should not change by accident.

Examples:

- stored data shape (database tables/columns)
- API shape (a URL path and what it accepts/returns)
- login/session behavior

Single source of truth:

- `docs-ai/project-knowledge/project-protected-contracts.md`

How it works:

1. The agent reads this list before work.
2. When the agent sees a likely â€œcontract momentâ€, it proposes updates in simple words.
3. You answer: Approve / Reject / Approve with changes.
4. If you approve a breaking change, the agent must also write a short migration plan and rollback plan.

---

## 3) Project Planning Workflow (Choose what to build next)

Use this workflow when:

- you finished `$project-setup` and want to confirm priorities
- you want to reorder, split, merge, or clarify items in `docs-ai/project-knowledge/project-roadmap.md`
- you learned something and need to adjust the roadmap before building

Start a project planning thread:

- `<project name> | P-###: <short-goal>`

Do this:

1. Open `docs-ai/project-knowledge/project-roadmap.md`
2. Confirm which roadmap item is next (topmost **[Not Started]** item)
3. If the roadmap needs changes (reorder/split/merge), tell the agent what to change and why
4. Proceed with the next item:
   - If it is a foundation/capability item: stay in the planning thread or start a new `P-###` thread for that work
   - If it is under **Feature Development**: start a feature thread and run `$feature-start`

What you should expect:

- A clear "next item" choice
- A thread name suggestion that matches the item type (`P-###` for non-features; `F-###` for features)

---

## 4) Discovery Workflows (Use when uncertainty is high)

These workflows are optional, but very useful when the best approach is unclear.
The agent may propose them proactively; you can also request them directly.

### 4.1 Experiment / Spike Workflow (E-###)

Use when:

- you need a quick feasibility check
- you want to compare approaches (before committing to one)
- you want a timeboxed prototype to learn, not to ship

Start an experiment/spike thread:

- `<project name> | E-###: <short-goal>`

What you should expect:

- A timebox (so the spike does not turn into a feature)
- A recommendation and concrete next steps (what to build next, and what not to do)
- A short update in `docs-ai/project-knowledge/project-insights.md` if a decision was made

### 4.2 Architecture Review & Decision Workflow (A-###)

Use when:

- a change spans multiple systems (frontend + Supabase + AI), or
- a new runtime/service/workflow/agent is being introduced, or
- schemas/contracts/shared types may change, or
- placement/ownership is unclear

Start an architecture review & decision thread:

- `<project name> | A-###: <short-goal>`

What you should expect:

- A short decision/review note: options, risks, and a recommendation
- Clear follow-up steps that feed back into feature/bug/refactor work
- An artifact saved to: `docs-ai/agents-artifacts/architectural-reviews/<task-slug>.arch-review.md`

### 4.3 Design Review Workflow (DR-###)

Use when:

- the UX/flow is unclear and you want to validate it before building
- you want feedback on states (empty/loading/error), copy, layout, and interactions
- user feedback suggests confusion and you need improvements

Start a design review thread:

- `<project name> | DR-###: <short-goal>`

Then run:

- `$design-review`

What you should expect:

- A short, actionable list of recommendations
- An artifact saved to: `docs-ai/agents-artifacts/design-reviews/<task-slug>.design-review.md`

---

## 5) Feature Development

### 5.1 Start the feature

1. Start a new feature thread named like: `<project name> | F-###: <feature name>`.
   Exact feature number and name can be found in `docs-ai/project-knowledge/project-roadmap.md` (Feature Development section).
2. Run:
   - `$feature-start`

What you should expect:

- The agent loads current project context/plan/insights and asks for confirmation to proceed.

### 5.2 Agent produces the feature brief (with research when needed)

After you run `$feature-start`, the agent returns a **feature brief draft**.

- For low-risk features: the brief is short (scope + acceptance criteria).
- For riskier features (uploads, permissions, external integrations, data retention/privacy): the agent includes the needed research outcomes directly in the draft (recommended limits/defaults + blocking questions).
- If you want a separate, deeper research brief artifact, run `$feature-research`.

### 5.3 Confirm the feature brief (required)

You confirm:

- **Scope / Out of scope**
- **Acceptance criteria** (observable conditions)
- Any proposed limits/defaults (if the agent included research outcomes)

If something is unknown, the agent marks it as Unknown and asks you to confirm.

### 5.4 Feature Development Planning step (agent-triggered when required)

The agent will trigger a plan when the change is large or risky (multi-area, new workflow/service, contract/schema changes).

What you should expect:

- A plan artifact under `docs-ai/agents-artifacts/plans/`
- Clear steps with a validation/checkpoint per step

Your job:

- Confirm the plan steps and the validation approach before the agent proceeds.

### 5.5 Build and iterate

What you do:

- Answer the agent's questions that block progress (short answers)
- Correct scope if the agent drifts (say "out of scope" and restate acceptance criteria)

What you should expect:

- Small, incremental code changes
- The agent telling you which files changed and why

### 5.6 Validate

When the agent believes the feature scope is implemented (or you are close to "done"), the agent should ask:

- "Should I create a test plan now?"

If you approve, the agent produces it by running `$test-plan`. You can also ask for it directly in plain language ("create a test plan") without typing the command.

If you are not prompted, run:

- `$test-plan`

What you should expect:

- A minimal test suite proposal that includes:
  - positive cases (happy path)
  - negative cases (validation/auth/dependency failures where relevant)

If the feature affects the UI, also run:

- `$testing-in-browser`

For UI-related tasks, the agent should run `$testing-in-browser` by default and capture screenshots as proof (unless you explicitly ask to skip UI validation).

What you should expect during UI validation:

- Playwright â€œappearsâ€ only at validation time (it is installed on demand when needed).
- DevTools is used to debug (console errors, failed network requests, DOM snapshots).
- Playwright is used to prove the UI works (repeat the user action + screenshots).
- Screenshots are saved under `docs-ai\agents-artifacts\screenshots\`.

If login is required, the agent may reuse `auth.json` if it exists.

If you want to skip UI validation, you must say so explicitly (example: â€œskip UI validation for this changeâ€).

### 5.6.1 Design system (frontend/web)

When work involves `frontend/web` UI design (initial setup or a style change), the agent should run `$frontend-design`.

What happens during `$frontend-design`:

- The agent asks whether to keep the current design preset (default) or switch to a new one.
- If switching, the agent points you to `https://ui.shadcn.com/create` and asks you to return the generated `https://ui.shadcn.com/init?...` URL (and template if needed).
- The agent updates `frontend/web/config/app-design-preset.json` (single source of truth) and applies it.

You can switch the design preset again at any time by rerunning `$frontend-design`.

### 5.7 Finish the feature (always do these)

When the agent believes the feature scope is complete and validation was successful, it should propose finishing the feature.

What the agent will do:

- The agent runs the finish workflow (`$commit-push-create-pr`) automatically when you say â€œwrap up / we are done / close the threadâ€.
- It verifies, updates project docs, commits, pushes, and attempts to create a PR automatically.
- Then it asks one simple question: â€œMerge into `main` now? (Yes/No)â€
- If you say Yes and the merge succeeds, it cleans up the thread automatically (remove worktree + delete branch).

What you do:

- Reply with â€œYesâ€ or â€œNoâ€ to the merge question.
- If there are merge conflicts, answer in plain words (example: â€œprefer the docs versionâ€).

This is how you keep the repo "memory" correct and avoid repeating decisions.

---

## 6) Interrupt Rules (When to stop feature work and switch)

Stop feature development and switch workflows when any of the following happen.

### 6.1 Switch to Bug Fix workflow when

The bug is unrelated to the feature you are implementing: **start a new bug thread immediately**.

### 6.2 Switch to Code Refactor workflow when

- You finished a feature and want cleanup/restructure with "must not change behavior" constraints.

### 6.3 Switch to Architecture Review & Decision workflow when

- The change crosses major boundaries (frontend + Supabase + AI services), or
- It adds a new service/workflow/agent, or
- It changes schemas/contracts/shared types, or
- You and the agent can't confidently say where the change belongs.

### 6.4 Switch to Experiment / Spike workflow when

- You are blocked by uncertainty (feasibility, approach choice, unclear constraints).

### 6.5 Switch to Deploy & Publish workflow when

- Your goal is that external users can access the app from the internet.

---

## 7) Code Review Workflow (CR-###)

Use when you want feedback on an implementation/change set before you commit or merge.

Start a code review thread:

- `<project name> | CR-###: <short-goal>`

Then run:

- `$code-review`

What you should expect:

- A diff-focused review (blockers, important issues, suggestions)
- Clear next actions ("fix X", "add Y test", "ready for PR")

---

## 8) Deploy & Publish (Go live)

Use this workflow when:

- You want the app to be accessible to external users over the internet.

Start a dedicated deploy thread:

- `<project name> | DP-###: <short-goal>`

### 8.1 Default branch policy

- Work happens on branches via PRs (no direct pushes to `main`)
- Branch names are derived from the active thread name (see `KB_THREADS`)
- The agent uses `scripts/git-task-start.ps1` to create/switch branches and `scripts/git-pr-create.ps1` to push/open PRs when possible
- If you run multiple threads in parallel, use Git worktrees so each thread has its own folder (see `KB_GIT_WORKTREES` and `scripts/git-worktree-start.ps1`)
- After you merge a PR from a worktree branch, clean up the worktree folder using `scripts/git-worktree-remove.ps1` (see `KB_GIT_WORKTREES`)
- Publishing happens from `main` after required checks pass

### 8.2 Choose Netlify vs Vercel (rule-based)

Use the project's deployment rules:

- `KB_DEPLOYMENT_CICD` (see `docs-ai/agents-core-knowledge/deployment-and-cicd.md`)

### 8.3 Minimum go-live checklist

- Required environment variables are documented (names only) in `.env.example`
- Deployment target is configured (Netlify or Vercel)
- A minimal smoke check passes (app loads and core flow works)
- The decision and any operational notes are recorded in project docs during `$commit-push-create-pr`

---

## 9) Bug Fix Workflow

Start a bug fix thread:

- `<project name> | B-###: <short-goal>`

### 9.1 Bug discovered during feature development

Fix inside the same feature thread only if:

- The bug is clearly caused by the current feature changes, and
- Fixing it does not expand scope beyond the feature acceptance criteria

Otherwise:

- Start a new bug thread.

### 9.2 Bug discovered after publishing

Always:

- Start a new bug thread.

### 9.3 What to provide (minimum)

- **Expected**: what should happen
- **Actual**: what happens now
- **Steps**: how to reproduce (3-10 steps)
- **Impact**: how bad it is (blocks users? minor?)

### 9.4 Validate and finish

If validation is unclear, the agent should propose running `$test-plan` and ask for your approval. You can also request it directly.

Run:

- `$test-plan`

Then:

- Agent fixes the bug
- Run `$commit-push-create-pr`

---

## 10) Code Refactor Workflow (No behavior change)

Start a code refactor thread:

- `<project name> | RF-###: <short-goal>`

### 10.1 When to use

Use a code refactor thread when:

- The goal is structure/cleanup, and
- Behavior must remain the same (UI, API shape, outputs)

### 10.2 Required input from you

State the constraints clearly:

- "Code refactor `<area>`; must not change `<behavior constraints>`."

### 10.3 Validate and finish

- If validation is unclear or multiple areas are touched, the agent should propose running `$test-plan` and ask for your approval (you can also request it directly).
- Run `$commit-push-create-pr`
- Project docs updates (if needed) happen during `$commit-push-create-pr`

---

## 11) Documentation Maintenance (Part of finishing work)

If you need to update docs outside the current task thread, start a docs update thread:

- `<project name> | D-###: <short-goal>`

### 11.1 Standard update (after completing a task)

After any completed feature/bug/refactor that changes behavior or decisions, run:

- `$commit-push-create-pr`

Note: docs updates are part of finishing the change during `$commit-push-create-pr`.

### 11.2 Framework maintenance (only when framework itself changes)

If you change rules, routes, skills, or commands, run:

- `$context-maintenance`

---

## 12) Working With the Agent (What to expect, how to respond)

### 12.1 Decisions the agent will ask you to make

The agent should ask you to confirm only high-impact decisions:

- Scope and acceptance criteria
- Constraints/defaults uncovered during `$feature-research`
- Plan steps and validation approach (when planning is required)
- Approval for any new external dependency

### 12.2 How to respond efficiently

- Answer only what blocks progress.
- Prefer short confirmations: "Yes", "No", "Out of scope", "Do option B".
- If you want speed: explicitly say which trade-off you accept (fast vs safe vs minimal scope).








