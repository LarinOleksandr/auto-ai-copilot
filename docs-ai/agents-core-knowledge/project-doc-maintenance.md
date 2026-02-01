# docs-ai/agents-core-knowledge/project-doc-maintenance.md

## Agent summary

- Rules for required project documentation files
- When and how to update project context, roadmap, and insights

---

## Core Project Documentation Rules

1. The `/docs-ai/project-knowledge` folder **must always have** four Markdown files:

   - `DOC_PROJECT_CONTEXT`
   - `DOC_PROJECT_ROADMAP`
   - `DOC_PROJECT_INSIGHTS`
   - `DOC_PROJECT_PROTECTED_CONTRACTS`

If the project is starting from an idea/PRD and these docs are missing, empty, or clearly outdated, run `$project-setup` to draft them before any feature work.

2. **Before any substantial work**, memory compaction, refactor, or feature development:

   - Review `DOC_PROJECT_CONTEXT`, `DOC_PROJECT_INSIGHTS`, `DOC_PROJECT_ROADMAP`, and `DOC_PROJECT_PROTECTED_CONTRACTS` to ensure alignment with how we work and the latest project state.

---

## Project Documents Usage and Update

Update documentation immediately when any of the following occur:

1. A work item (foundation/capability/feature/release task) is developed or completed
2. An essential code or architectural change is made
3. A significant decision is made or approved
4. The user explicitly requests an update

If the change also affects the repository shape (new/renamed top-level folders, new runtime boundary, new artifact category), update `KB_REPOSITORY_LAYOUT` via `$context-maintenance`.

In normal feature work, doc updates are part of finishing the change: update the docs automatically before proposing a commit.

For each event, determine which files require updates and modify them to reflect:

- Updated context
- Roadmap changes (including progress/status)
- New insights or lessons learned (only when durable; avoid routine progress notes)

Files to consider:

- `DOC_PROJECT_CONTEXT`
- `DOC_PROJECT_ROADMAP`
- `DOC_PROJECT_INSIGHTS`
- `DOC_PROJECT_PROTECTED_CONTRACTS` (when stable contracts are added/updated or when an approved breaking change changes what must be protected)

---

## File Specifications

### project-context.md

**Purpose:** Canonical project overview.

**Must include:**

- Project name
- Current project description
- High-level technical and architectural information (stack, core features)
- Current, confirmed project goals

---

### project-roadmap.md

**Purpose:** Full-scope project roadmap and progress tracking.

**Rules:**

- The roadmap may contain multiple sections (foundations, capabilities, features, release, etc.) and must remain extensible.
- Every tracked item must include a status:
  - `Not Started`
  - `In Progress`
  - `Completed`
- Keep **Feature Development** tracked feature-by-feature (feature threads remain consistent).
- Decompose items further as clarity increases.

---

### project-insights.md

**Purpose:** Durable "lessons learned" log.

Use this file to capture decisions, constraints, and debugging learnings that will prevent repeat mistakes. Do **not** use it for routine progress, task completion, or status updates (those belong in `DOC_PROJECT_ROADMAP`).

**Rules:**

- Append-only; ordered from oldest to newest
- Add an entry only when it includes at least one:
  - Decision (architecture/tooling/process) that future work must follow
  - Lesson learned (root cause, constraint, gotcha) likely to recur
  - Guardrail (test/validation/check) added to prevent regression
- Each entry must reference either:
  - related feature/subfeature identifier (preferred), or
  - thread name / short identifier when not tied to a feature
- Keep each entry short (3-6 bullets). If details are long, write a separate artifact and link it.

**Suggested entry template (keep it simple):**

- Why it matters (one line)
- Root cause / constraint (one line)
- Fix / decision (one line)
- Prevention (test/validation/guardrail) (one line)

---

### project-protected-contracts.md

**Purpose:** The “must not break” contracts for this project.

**Rules:**

- Only add or change a contract with explicit user approval.
- Keep contracts short, clear, and testable.

---

## Required Markdown Structure

### project-context.md

<pre>
# Project Context

## Overview
Brief description of the application and its purpose.

## Goals
- List current project goals.

## Essential Information
- Technical stack
- Core features
- Other critical high-level details
</pre>

### project-roadmap.md

<pre>
# Project Roadmap

## Roadmap

### Foundations
- [In Progress] Work item
  - [Completed] Sub-item

### Feature Development
- 1. [Not Started] Feature name
</pre>

### project-insights.md

<pre>
# Project Insights Log

## [1]
- Why it matters: <one line>
- Root cause / constraint: <one line>
- Fix / decision: <one line>
- Prevention: <test/guardrail/check>
</pre>

---

### project-protected-contracts.md

<pre>
# Project Protected Contracts

## Current protected contracts
- (bullets)
</pre>

---

## Writing Standards

- Be concise and factual
- Avoid redundancy
- Prefer clarity over completeness
- Follow the specified Markdown structure







