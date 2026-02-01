---
name: repo-bootstrap
description: Ensure the current project folder is a real git repository with a configured remote `origin`, so work can be committed and pushed safely.
---

# .codex/skills/repo-bootstrap/SKILL.md

## Name

`$repo-bootstrap`

## Purpose

Initialize or connect a repository so the project is safely saved and shareable.

This is the strict gate used after a new PRD is created, before any planning or implementation.

## When to use

Invoke when any apply:

- you just created a PRD in a new folder
- `git rev-parse --show-toplevel` fails (not a git repo)
- `git remote get-url origin` fails (no remote set)

## Procedure

1. Verify prerequisites
   - Ensure `git` is available.
   - If `git` is not available: stop and ask the user to install Git, then rerun `$repo-bootstrap`.
2. Ensure a git repository exists
   - If not in a git repo: run `git init`.
3. Ensure worktree safety defaults
   - Ensure `.worktrees/` is ignored by git:
     - If `.gitignore` is missing, create it.
     - If `.gitignore` does not include `.worktrees/` (or `.worktrees`), add `.worktrees/`.
4. Ensure the repo has at least one commit (bootstrap only)
   - If the repo has no commits yet:
     - Stage everything.
     - Create an initial commit (`chore: initial commit`).
5. Ensure a remote `origin` exists
   - If `origin` exists: keep it.
   - If `origin` is missing:
     - Best effort: if GitHub CLI `gh` is available and authenticated, create a remote repo and set `origin`.
     - Otherwise: ask once for the remote URL and set it as `origin`.
6. Push the base branch
   - Detect base branch (`main` if it exists, otherwise `master`; otherwise use the current branch).
   - Push to `origin` with upstream tracking.
7. Handoff (strict next step)
   - Provide a suggested next thread name (compliant with `KB_THREADS`) and a copy/paste first message that invokes `$project-setup`.

## Commands

- Check repo: `git rev-parse --show-toplevel`
- Check commits exist: `git rev-parse --verify HEAD`
- Check origin: `git remote get-url origin`
- Init: `git init`
- Add ignore: edit `.gitignore` to include `.worktrees/`
- Stage: `git add .`
- Initial commit (bootstrap only): `git commit -m "chore: initial commit"`
- Push base: `git push -u origin <base>`

## Acceptance checks

- Git repository exists
- `.worktrees/` is ignored by git
- Remote `origin` exists
- Base branch is pushed to `origin`
- Next thread name + copy/paste `$project-setup` prompt provided

