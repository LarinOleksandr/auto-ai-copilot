# PRD Interview Guide (for the agent)

Goal: create a high-quality PRD with minimal user effort.

Principle: the agent does the heavy work (drafts, options, tradeoffs, risks). The user provides direction, clarifications, and approvals.

## Proactive interview loop (use for every section)

For each section below:

1. Draft the section content yourself (make reasonable assumptions when needed).
2. Propose 2-3 options when there is a real choice (with short tradeoffs).
3. Recommend one option and explain why (briefly).
4. Ask one confirmation question: "Approve as-is, or what should change?"
5. If critical info is missing:
   - record it as `ASSUMPTION` or `OPEN QUESTION` (with validate-by plan)
   - do not block progress unless it changes direction or makes the PRD invalid

Do not ask the user to invent the structure, lists, or analyses. Ask only for direction and corrections.

## Step 0: Choose PRD type (required)

Ask:
- Are we writing a **Product PRD** (whole application / big initiative) or a **Feature PRD** (one feature)?

## Product PRD flow (whole application / big initiative)

Output target: `ROOT_AGENTS_ARTIFACTS/prds/YYYY-MM-DD-<topic>-prd.md` using `ROOT_SKILLS/brainstorming/templates/product-prd.template.md`.

### 1) Summary

Agent does:
- Draft problem, proposed solution, why now, primary metric (baseline -> target), biggest risk.
- Propose safe metric defaults if missing (and mark as assumptions).

Ask user:
- Confirm the primary metric and target (or give a different direction).

### 2) Optional sections proposal (agent proposes; user decides direction)

Agent does:
- Recommend whether to include these sections now, based on context:
  - Market opportunity
  - Strategic alignment
  - Value proposition and messaging
  - Competitive advantage
  - Go-to-market
- If not included, mark them as "Not needed now" (do not leave them half-written).

Ask user:
- Approve the proposed set of optional sections (yes/no and changes).

### 3) Market opportunity (optional)

Agent does:
- Draft evidence-style bullets (what we know, what we assume).
- Call out weak evidence and propose how to validate it (survey/interviews/analytics/research).

Ask user:
- Confirm the market framing and any must-have evidence.

### 4) Strategic alignment (optional)

Agent does:
- Draft alignment to company/product goals and "why this team can win".
- Draft tradeoffs (speed vs quality, breadth vs depth) and recommend.

Ask user:
- Confirm the intended tradeoffs.

### 5) Customer and user needs

Agent does:
- Draft segments/personas at a simple level.
- Draft the primary job-to-be-done and top pains.
- Note unknowns and record assumptions (without blocking unless direction depends on it).

Ask user:
- Confirm the primary segment and the top pain to optimize for.

### 5.1) Primary user profile (required)

Agent does:
- Draft a complete primary user profile:
  - role, context, goals, needs
  - time constraints, habits, tools
  - competencies, technical skills
  - frustrations, expectations
- If multiple profiles are plausible, propose 2-3 and recommend one primary profile to optimize for.

Ask user:
- Confirm the primary profile (and any secondary profiles worth supporting in v1).

### 5.2) Jobs-to-be-done (required)

Agent does:
- Draft a complete JTBD set:
  - primary job (When..., I want..., so I can...)
  - functional jobs (concrete tasks)
  - emotional jobs
  - social jobs
  - related jobs
  - job triggers
  - desired outcomes (measurable)
  - current alternatives
  - constraints
- Identify what this implies:
  - likely v1 capabilities
  - likely NFR baselines (speed/reliability/simplicity)
  - likely scope exclusions (to protect simplicity)
- If multiple primary jobs are plausible, propose 2-3 and recommend one to optimize for in v1.

Ask user:
- Confirm the primary job (and whether any job is out of scope for v1).

### 6) Product rules and baselines (required)

Agent does:
- Draft global product decisions that features must not re-decide:
  - scope boundaries
  - success metrics (north star + guardrails)
  - baseline non-functional targets (performance, reliability, security/privacy, accessibility, observability)
  - AI rules (only if AI exists): grounding, safety limits, evaluation cadence
  - data policy (retention/export/deletion), if applicable
- Propose concrete baselines with assumptions if needed.

Ask user:
- Approve the product baselines (or adjust).

### 7) Value story (narrative)

Agent does:
- Draft a short story: moment of value + walkthrough.
- Propose 2-3 versions if there are multiple plausible primary flows.
- Recommend the simplest story that reaches value fastest.

Ask user:
- Confirm the primary walkthrough.

### 8) Product scope and backlog outline

Agent does:
- Draft high-level capabilities with capability-level acceptance criteria (short, outcome-focused; no test-level detail).
- Draft key use cases.
- Draft a backlog outline of features that will each need a Feature PRD.
- Identify the smallest viable v1 and recommend.

Ask user:
- Confirm v1 scope boundaries and the first 3-10 backlog items.

### 9) Non-functional requirements and AI quality requirements

Agent does:
- Draft measurable NFR targets (only what matters).
- If AI exists, draft measurable AI quality plan (evaluation + drift monitoring).
- List top risks and mitigations (security, abuse, cost, reliability) as part of "biggest risk" and/or "assumptions/open questions".

Ask user:
- Confirm which NFR/AI targets are hard requirements vs best-effort.

### 10) Milestones, dependencies, resourcing

Agent does:
- Draft a simple phased plan (MVP/beta/GA if relevant).
- Identify likely dependencies and the biggest schedule risk.

Ask user:
- Confirm milestones and any immovable constraints.

### 11) Assumptions and open questions

Agent does:
- Convert uncertainty into explicit `ASSUMPTION` / `OPEN QUESTION` entries.
- Provide validate-by plans (what, how, when).

Ask user:
- Confirm which open questions are blockers.

## Feature PRD flow (one feature)

Output target: `ROOT_AGENTS_ARTIFACTS/prds/YYYY-MM-DD-<topic>-prd.md` using `ROOT_SKILLS/brainstorming/templates/feature-prd.template.md`.

### 1) Product PRD reference (required)

Agent does:
- Ask for the Product PRD reference file.
- If unknown, propose a temporary placeholder and mark it as an open question.

Stop rule:
- If this feature changes any product-level decision, stop and update the Product PRD first.

Ask user:
- Confirm the Product PRD reference and whether this feature changes product baselines (yes/no).

### 1.1) Impacted user profile(s) (required)

Agent does:
- Identify which Product PRD user profile(s) this feature is for.
- If unclear, propose the most likely impacted profile(s) and recommend a primary one.

Ask user:
- Confirm the primary impacted profile.

### 1.2) Supported jobs-to-be-done (required)

Agent does:
- Identify which product JTBD items this feature supports:
  - primary job supported
  - functional jobs supported
  - triggers supported
  - desired outcomes impacted (pick 1-3)
  - constraints that must be respected
- Recommend the smallest set of supported jobs/outcomes needed for v1 of the feature.

Ask user:
- Confirm the supported jobs/outcomes for this feature.

### 2) Goal, problem, success signal

Agent does:
- Draft the goal (1 sentence), problem (1-3 sentences), and success signal (one measurable outcome).
- Propose 2-3 success signal options if needed (time, quality, cost/support).
- Recommend one.

Ask user:
- Confirm the success signal.

### 3) User flow (detailed)

Agent does:
- Draft the detailed flow (3-10 steps) including entry points, empty states, and error states.
- Propose a simpler v1 flow if the draft is too complex.

Ask user:
- Confirm the flow and the error behavior.

### 4) Scope and acceptance criteria

Agent does:
- Draft in-scope/out-of-scope.
- Confirm which Product PRD capability this feature delivers (or record as Unknown).
- Draft acceptance criteria as pass/fail with inputs/outputs/limits and failure behavior.
- Identify missing details that block testability and propose defaults.

Ask user:
- Approve scope and acceptance criteria (or list changes).

### 5) Edge cases and failure behavior

Agent does:
- List likely edge cases and failure modes.
- Propose user-safe failure behavior and recovery.

Ask user:
- Confirm any "must handle in v1" edge cases.

### 6) Non-functional deltas and AI quality deltas

Agent does:
- State only deltas from Product PRD baselines.
- If AI exists, state only feature-specific evaluation needs.

Ask user:
- Confirm any required deltas.

### 7) Validation plan

Agent does:
- Draft a minimal test set (happy path + failure path) and a smoke path.
- If validation is unclear, propose `$test-plan`.

Ask user:
- Confirm the validation plan.

### 8) Assumptions and open questions

Agent does:
- Record remaining uncertainty with validate-by plans.

Ask user:
- Confirm blockers and owners.
