# User Story: Building With the Agent (From Scratch)

I open the repo for the first time. I have an idea in my head, but it's still fuzzy.

I remember the rule: one thread = one task. So I start a new thread and name it clearly.

## 1) I turn an idea into a project foundation

I start a project-planning thread:

`vibe-coding | P-001: project foundation`

Before we do anything else, the agent checks the project foundation docs and realizes they still contain generic placeholder content (no real product details yet). It tells me we should start with `$project-setup`, but first it needs the minimal product inputs.

I provide the minimum inputs:

- Product: "A wizard that helps me turn notes into structured documents."
- Users: "Me and a small team."
- Problem: "We lose time aligning on scope and outputs."
- Success: "We can generate consistent docs and iterate quickly."
- Constraints: "Keep the process strict; don't add random dependencies."
- Out of scope: "No public marketing site yet."

Now the agent replies: it will run `$project-setup`.

I run:

`$project-setup`

The agent reads the existing project docs, then drafts/updates the canonical foundation files:

- `docs-ai/project-knowledge/project-context.md`
- `docs-ai/project-knowledge/project-roadmap.md`
- `docs-ai/project-knowledge/project-insights.md`

Then the agent asks me to confirm only the important gates:

- scope vs out-of-scope
- success criteria
- initial roadmap order

I answer with short confirmations and small corrections ("Yes, but move X below Y.").

The agent updates the foundation docs and proposes a correctly named next thread for the next roadmap item.

## 2) I keep myself oriented without loading everything

Later, I feel lost ("what are the rules again?").

Instead of opening random files, I run:

`$context-load`

The agent gives me a concise snapshot:

- what exists in the repo right now
- the non-negotiable rules (like "no new dependencies without explicit approval")
- where to look next depending on what I'm about to do (routing map)

This prevents me from guessing or inventing structure.

## 3) I do roadmap items first (then features)

I pick the topmost **[Not Started]** item in `docs-ai/project-knowledge/project-roadmap.md`.

If it is a foundation/capability item, I start a project planning thread for that item:

`vibe-coding | P-002: web UI foundation`

In that thread, the agent keeps me focused on finishing the next item, then coming back to the roadmap to pick the next one.

Later, when the next item is a feature under **Feature Development**, I start a feature thread and run:

`$feature-start`

The agent reads:

- `docs-ai/project-knowledge/project-context.md`
- `docs-ai/project-knowledge/project-insights.md`
- `docs-ai/project-knowledge/project-roadmap.md`

Then it asks: "Starting feature: web UI foundation. Proceed?"

I say "Proceed."

Before writing code, the agent automatically sets up safe Git isolation for this thread:

- creates a branch from the thread name
- creates a Git worktree folder under `.worktrees\...`
- works only inside that worktree folder so parallel threads do not overwrite each other

## 4) The agent sets the UI rules before building UI screens

When the feature includes UI work under `frontend/web`, the agent routes itself to the existing UI/UX baselines:

- `docs-ai/agents-core-knowledge/ui-baseline.md`
- `docs-ai/agents-core-knowledge/ux-baseline.md`

It explains (briefly) what that means in practice:

- UI must be token-driven (no arbitrary values)
- UX must define loading/empty/error behaviors
- no raw exceptions shown to users

This is where I notice a useful constraint: we're trying to prevent "random CSS decisions" from day one.

## 5) Design setup: keep the current preset or switch

At the start of design work, the agent proposes running:

`$frontend-design`

The agent looks at the single source of truth for the design preset:

- `frontend/web/config/app-design-preset.json`

Then it asks me one simple question:

- "Use the current design preset from `frontend/web/config/app-design-preset.json`?" (Yes/No)

### 5.1 I choose the default path (keep current)

I answer: "Yes."

The agent proceeds to apply it using the script:

- `frontend/web/scripts/app-design-init.ps1`

If applying the preset would introduce new npm dependencies, the agent stops and asks for explicit approval once for the "design system dependency bundle" (because the repo rules require approval before adding dependencies).

I approve (or I ask what it will add, and the agent lists it plainly).

After approval, the agent records a small approval marker file:

- `frontend/web/config/deps-approved.json`

That way, the agent won't re-ask for the same baseline bundle again.

### 5.2 I switch to a new preset (when I want a different look)

Another day, I decide I want a different style.

I rerun:

`$frontend-design`

This time I answer: "No."

The agent gives me the exact link and tells me what to return:

- Go to: `https://ui.shadcn.com/create`
- Return: the generated `https://ui.shadcn.com/init?...` URL (and the template if needed)

I paste the URL back.

The agent updates only one place with that new preset:

- `frontend/web/config/app-design-preset.json`

Then it applies the preset via `frontend/web/scripts/app-design-init.ps1`.

If the preset implies new dependencies beyond what I approved before, the agent asks again (but only for the delta).

Finally, the agent records the durable decision (without duplicating the preset URL all over the repo) in:

- `docs-ai/project-knowledge/project-insights.md`

It references the config path rather than scattering copies of the URL in multiple docs.

## 6) The agent implements UI work in small increments

As we build screens, I notice the agent keeps changes small and keeps asking for missing information only when needed:

- What is the "empty state" for this screen?
- What should the primary action be?
- What should happen on failure?

If requirements are unclear or risky, the agent proposes a research pass using:

`$feature-research`

If I approve, it produces a timeboxed research brief and then folds the conclusions back into the feature's plan.


## 7) Validation happens before "done"

When we're close to done, the agent asks whether to create a test plan.

If I approve, it runs:

`$test-plan`

If the change affects UI behavior, the agent proposes:

`$testing-in-browser`

For UI-related tasks, it runs the browser verification workflow by default:

- DevTools to debug (console errors, failed network requests)
- Playwright to prove it works (repeat actions + screenshots)

It saves screenshots under:

- `docs-ai\agents-artifacts\screenshots\`

If I want to skip UI validation, I must say so explicitly.

## 8) Finish: docs and memory stay correct

When the feature feels complete, the agent updates the project docs automatically during `$commit-push-create-pr`.

It also checks if we created something people will rely on long-term (a â€œprotected contractâ€).
If yes, it proposes additions in simple words and asks me to approve or reject.

If I approve, it updates:

- `docs-ai/project-knowledge/project-protected-contracts.md`

If the work changed the framework itself (skills, commands, routing, AGENTS rules), the agent also performs the required framework maintenance updates in the same change set so the repo stays internally consistent.

Finally, the agent proposes committing and asks for my approval to run:

`$commit-push-create-pr`

I donâ€™t need to remember Git steps. I just say: â€œWrap up / we are done.â€

The agent runs `$commit-push-create-pr` and:

- verifies and updates docs
- commits and pushes
- creates a PR automatically (when possible)
- asks one simple question: â€œMerge into `main` now? (Yes/No)â€

If I say Yes and the merge succeeds, the agent cleans up the thread automatically (remove worktree + delete branch).

If I say No, the PR and worktree stay as-is so we can continue later.

## What I notice (observations)

- The workflow is strong at preventing "random UI decisions," because UI/UX baselines + the preset config enforce consistency early.
- Dependency approval is a required checkpoint; the smooth path is a single approval for the baseline bundle, recorded in `frontend/web/config/deps-approved.json`.
- The smoothest experience is when the agent keeps the preset URL in exactly one place (`frontend/web/config/app-design-preset.json`) and references it everywhere else.








