# Git Worktrees

## Agent summary

- Use git worktrees to run multiple threads in parallel without overwriting each other’s files.
- This repo uses a **path-stable** worktree convention: worktrees live under `.worktrees/` in the repo root.
- One thread = one branch = one worktree folder.

---

## Why this exists

You can only safely run “parallel work on the same files” when each agent thread works in its own folder.

Git worktrees give you multiple working folders that share the same git history.

Each worktree:

- has its own files on disk (so two agents do not overwrite each other)
- is attached to one branch (so changes are kept separate until you merge)

---

## Repo rules (must)

1. **Never run parallel threads in the same folder.**
2. **All worktrees must live under** `.worktrees/` **inside the repo root.**
3. **`.worktrees/` must be ignored by git.** (This repo’s `.gitignore` includes it.)
4. **One worktree per branch.** Do not open the same branch in two worktrees.
5. **Pre-work branch check.** Before any task work, check the current branch. If it is `main`, create a new worktree + branch and work only there.

---

## Recommended workflow (parallel threads)

1. Start a new thread with a correct thread name (see `KB_THREADS`).
2. Create a worktree for that thread (this also creates a branch).
3. Let the agent work in that worktree folder only.
4. Push + open a PR.
5. Merge PRs into `main` one-by-one (this is where you make the final judgment if there are conflicts).

---

## Canonical commands (PowerShell)

Create a worktree from a thread name:

- `powershell -NoProfile -ExecutionPolicy Bypass -File scripts/git-worktree-start.ps1 -ThreadName "<thread name>"`

Remove a worktree by path:

- `powershell -NoProfile -ExecutionPolicy Bypass -File scripts/git-worktree-remove.ps1 -WorktreePath ".worktrees/<branch-path>"`

List worktrees:

- `git worktree list`

---

## Common problems

### “My changes disappeared”

Most common cause: work happened in the wrong folder (the main repo folder, not the worktree folder).

Fix:

- Confirm the agent is working inside `.worktrees/...`
- Commit changes on the work branch

### “Git says I have conflicts”

This is normal when two branches changed the same lines.

Fix:

- Resolve conflicts during merge (PR merge or local merge)
- Pick the final version you want (your judgment call)
