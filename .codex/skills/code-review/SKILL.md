---
name: code-review
description: Perform a focused Codex review of the PR diff (token-efficient) and report blockers, important issues, and suggestions.
---

# .codex/skills/code-review/SKILL.md

## Name

`$code-review`

## Purpose

Perform a standard Codex-style code review that is:

- diff-first (review what changed, not the whole repo)
- token-efficient (avoid pulling in long prior thread context)
- aligned with this repo's non-negotiables (secrets, validation, boundaries)

## When to use

Invoke when:

- you are about to open a PR, or
- you want a focused review in a dedicated `CR-###` thread.

## Inputs

- Base branch (optional; infer automatically)
- Target ref (default: `HEAD`)

If base branch is unclear, infer in this order:

1. `origin/main`
2. `origin/master`
3. `main`
4. `master`

## Procedure

1. Gather the PR-style diff
   - Determine `baseRef` (per inference rules).
   - Collect:
     - changed files list
     - diff stat
     - full diff (`baseRef...HEAD`)
2. Review for correctness and maintainability
   - Look for obvious bugs, inconsistent behavior, broken types/contracts, and brittle logic.
3. Enforce repo hard rules (from `AGENTS.md` + scoped AGENTS)
   - Secrets: no keys/tokens; only `.env.example` and variable names.
   - Validation: validate external/client inputs at boundaries.
   - Dependencies: flag any new dependency additions (needs explicit approval).
   - Service boundaries: no cross-service imports; shared code must live in `shared/`.
   - Config layering: no hardcoded env-specific values; config via env + layered config.
   - If changes touch `shared/types` or core entities: ensure contracts remain consistent.
4. Testing expectation (lightweight)
   - If the change clearly requires tests, call out what's missing and the smallest test(s) to add.
5. Output the review using this format
   - **Summary**: 2-4 bullets
   - **Blockers**: must-fix items
   - **Important**: should-fix items
   - **Suggestions**: nice-to-have
   - **Ready for PR**: `yes/no` + one-line rationale

## Commands (canonical)

- Determine base ref candidates:
  - `git rev-parse --verify origin/main`
  - `git rev-parse --verify origin/master`
  - `git rev-parse --verify main`
  - `git rev-parse --verify master`
- Gather diff inputs:
  - `git status --porcelain`
  - `git diff --name-only <baseRef>...HEAD`
  - `git diff --stat <baseRef>...HEAD`
  - `git diff <baseRef>...HEAD`

## Acceptance checks

- Review is based on the PR diff (not general repo speculation).

