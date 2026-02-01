---
name: commit-push-create-pr
description: Use when work is complete and you want to commit it, push it to GitHub, and optionally create a PR.
---

# .codex/skills/commit-push-create-pr/SKILL.md

## Name

`$commit-push-create-pr`

## Purpose

Commit current work, publish it to GitHub, update documentation, then ask whether to merge into `main`.

## When to use

Invoke when any apply:

- work is complete and ready to commit (feature, bug fix, refactor, or docs change)
- user requests a commit
- user says they want to finish, wrap up, or save the work

## Inputs

- Current thread name (for branch naming)

## Procedure

1. Ensure work is on a branch (not `main`/`master`).
   - If on `main` or `master`, create/switch to a branch derived from the current thread name (`KB_THREADS`).
2. Check for changes (tracked or untracked).
3. If changes exist, run a quick verification gate.
   - Pick the first proof command that exists and run it now:
     - If `scripts/verify.ps1` exists: run it.
     - If `frontend/web/package.json` exists: run the frontend checks (for example `npm test` or `npm run build`).
     - If `ai/orchestrator` has a test runner configured: run its tests.
     - Otherwise: verification is `Skipped` (no proof command found).
   - If the proof command fails, stop. Do not commit or push.
4. If changes exist:
   - Update project docs (minimal edits, only when needed):
     - `DOC_PROJECT_CONTEXT`
     - `DOC_PROJECT_ROADMAP`
     - `DOC_PROJECT_INSIGHTS`
     - `DOC_PROJECT_PROTECTED_CONTRACTS` (only if a contract was added/changed)
   - Rules for doc updates:
     - Roadmap: update status lines for what you just finished.
     - Insights: add only durable decisions/lessons (not routine progress).
     - Context: update only if product goals, constraints, or tech stack changed.
   - Stage everything.
   - Generate a commit message based on branch type:
     - `feature/*` -> `feat: ...`
     - `bugfix/*` -> `fix: ...`
     - `refactor/*` -> `refactor: ...`
     - `docs/*` -> `docs: ...`
     - otherwise -> `chore: ...`
   - Create the commit.
5. If a commit was created, publish it to GitHub (push).
   - Default behavior: push and attempt to create a PR automatically.
6. Show the overall roadmap from `DOC_PROJECT_ROADMAP` with statuses.
7. Propose saving a short conversation summary (optional).
   - Ask: “Do you want me to save a short summary of this discussion to `ROOT_AGENTS_ARTIFACTS/conversations/`? (Yes/No)”
   - If Yes: invoke `$conversation-save`.
8. Ask one simple question:
   - “Do you want me to merge this into `main` now? (Yes/No)”
9. Handle the answer:
   - If Yes:
     - Merge the current branch into `main` and report the outcome.
     - After a successful merge:
       - If this work was done in a worktree under `.worktrees/`, remove that worktree folder.
       - Delete the work branch locally and on `origin` (when possible). Do not ask.
   - If No:
     - Leave the branch, PR (if created), and worktree as-is so the user can continue later.
10. Next-step handoff (PRD bootstrap only)
   - If this work included a Product PRD artifact update (any file under `ROOT_AGENTS_ARTIFACTS/prds/`):
     - Propose exactly one next thread: `$project-setup`.
     - Provide:
       - suggested thread name (compliant with `KB_THREADS`), and
       - a copy/paste first message that:
         - references the PRD artifact path, and
         - invokes `$project-setup`.
   - Otherwise: do not propose follow-up work from this skill (leave next work to the roadmap/thread intent).

## Commands

- `git rev-parse --abbrev-ref HEAD`
- `git status --porcelain`
- (optional) `powershell -NoProfile -ExecutionPolicy Bypass -File scripts/verify.ps1` (only if it exists)
- `powershell -NoProfile -ExecutionPolicy Bypass -File scripts/git-task-start.ps1 -ThreadName "<current thread name>"` (only if on main/master)
- `git add .`
- `git commit -m "<type>: <AUTO_SUMMARY_OF_COMPLETED_WORK>"`
- Push + create PR (best effort): `powershell -NoProfile -ExecutionPolicy Bypass -File scripts/git-pr-create.ps1` (only if a commit was created)
- Merge into main: `powershell -NoProfile -ExecutionPolicy Bypass -File scripts/git-merge-main.ps1`
- Remove worktree (only if this work was done under `.worktrees/`): `powershell -NoProfile -ExecutionPolicy Bypass -File scripts/git-worktree-remove.ps1 -WorktreePath ".worktrees/<branch-path>"`

## User-facing output (keep it non-technical)

When reporting results to the user, prefer outcomes over commands.

Path rule (must): when referencing files, use `KB_ROOTS` aliases (`DOC_*`, `KB_*`, `ROOT_*`) or repo-relative paths. Do not use absolute OS paths.

Say:

- whether verification was run and the result (Pass/Fail/Skipped)
- overall status (Success/Stopped)
- branch name
- whether a commit was created (Yes/No)
- whether the branch was pushed (Yes/No)
- whether a PR was created (Yes/No)
- whether merge into main happened (Yes/No)
- if merge happened: whether the work branch was deleted (local/origin) (Yes/No/Skipped)
- if merge happened: whether the worktree was cleaned up (Yes/No/Skipped)

Avoid:

- printing the full commit message
- printing script names or command lines

## Rules

- Do not ask the user anything before the commit step.
- Do not create tags.
- If `git commit` fails because there is nothing to commit, output `nothing to commit` and continue to step 6.

## Quick reference

| Do                               | Do not                 |
| -------------------------------- | ---------------------- |
| Update docs before commit        | Skip doc updates       |
| Use branch-based commit prefixes | Use arbitrary prefixes |

## Example

User: "Commit the feature."

You:

- Ensure branch
- Update docs
- Commit, push, and create PR (best effort)
- Show roadmap
- Ask: merge into main? (Yes/No)

## Acceptance checks

- Branch confirmed
- Verification status reported (Pass/Fail/Skipped)
- Docs updated
- Commit created or explicitly noted as nothing to commit
- Branch pushed (when a commit exists)
- Roadmap shown with statuses
- Merge question asked and handled (Yes/No)
