---
name: frontend-design
description: Initialize or update the `frontend/web` design system using a shadcn preset, in a consistent, automated way.
---

# .codex/skills/frontend-design/SKILL.md

## Name

`$frontend-design`

## Purpose

Keep `frontend/web` visually consistent by applying a shadcn preset in a repeatable way, while enforcing `KB_UI_BASELINE` and `KB_UX_BASELINE`.

## When to use

Invoke when any apply:

- creating `frontend/web` for the first time
- starting design work (design system/theme) for `frontend/web`
- changing the design preset mid-stream

## Inputs

- Current preset config file: `frontend/web/config/app-design-preset.json` (single source of truth)
- Optional new preset input from the user (only when changing):
  - preferred: the `https://ui.shadcn.com/init?...` URL
  - acceptable: the full `pnpm dlx shadcn@latest create ...` command

## Procedure

1. Confirm design intent (keep vs change)
   - Read `frontend/web/config/app-design-preset.json`.
   - Ask the user:
     - Use the current preset as-is? (default), or
     - Switch to a new preset?
2. If switching presets, guide the user to provide the expected input
   - Send the user to: `https://ui.shadcn.com/create`
   - Ask the user to return:
     - the generated `https://ui.shadcn.com/init?...` URL, and
     - the target template (`next` or `vite`) if it is not obvious from context
   - Update `frontend/web/config/app-design-preset.json` with the new preset (no duplication elsewhere).
  - Record the durable decision in `DOC_PROJECT_INSIGHTS` (do not paste huge token values; reference the config path).
3. Enforce the approval gate (repo rule)
   - If applying the preset will add new npm dependencies, obtain explicit approval once for the design system dependency bundle.
   - After approval, write `frontend/web/config/deps-approved.json` so the agent does not re-ask for the same bundle.
4. Apply the preset (automated)
   - Run `frontend/web/scripts/app-design-init.ps1` (or the platform-equivalent script if added later).
5. Verify baseline UX expectations (high-signal only)
   - Confirm: focus styles are visible, forms show actionable validation messages, and loading disables relevant actions.
6. Keep docs consistent
   - If the workflow/commands/skills changed, update relevant indexes and docs in the same change set.

## Acceptance checks

- `frontend/web/config/app-design-preset.json` is the only place containing the preset URL.
- The design preset can be updated by re-running `$frontend-design` with a new shadcn `init` URL.
- UI follows `KB_UI_BASELINE` and UX follows `KB_UX_BASELINE`.
- If deps were added, a one-time approval marker exists at `frontend/web/config/deps-approved.json`.






