# UI Testing (Playwright + MCP DevTools)

## Agent summary

- For UI-related tasks, validate in a real browser and capture screenshots as proof.
- Use MCP DevTools to debug (console/network/DOM).
- Use Playwright to prove user-visible behavior (repeat actions + screenshots).
- Install Playwright only when needed (on demand).

---

## When this applies

Use this for any task that changes UI behavior or UI layout in:

- `frontend\`

---

## On-demand install (required for UI validation)

Run:

- `powershell -NoProfile -ExecutionPolicy Bypass -File scripts\ensure-playwright.ps1`

This fetches Playwright via `npm exec` only when needed and installs browser binaries.

---

## What to capture (required)

- Save screenshots under:
  - `docs-ai\agents-artifacts\screenshots\`
- Prefer a per-task folder:
  - `docs-ai\agents-artifacts\screenshots\<task-slug>\`

Do not mark a UI task as done without screenshots.

---

## Auth state (`auth.json`)

If the UI requires login:

- If `auth.json` exists, treat it as a Playwright `storageState` file.
- If possible, apply auth (localStorage + cookies) before navigating.
- If auth still fails, log in through the UI and continue validation.

Never commit `auth.json`.

