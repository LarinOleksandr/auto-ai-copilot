---
name: testing-in-browser
description: Capture the canonical steps for starting the dev stack, connecting via MCP DevTools, and iteratively resolving browser errors.
---

# .codex/skills/testing-in-browser/SKILL.md

## Name

`$testing-in-browser`

## Purpose

Make the run->inspect->fix cycle explicit so every teammate follows the same scripted interaction with the local stack and DevTools.

For UI-related tasks, this skill is also the place where we capture screenshots as proof.

## When to use

Invoke when:

- the feature or change request involves browser/runtime errors that must be verified manually,
- the user explicitly wants Codex to exercise the dev server and gather DevTools output before coding, or
- you need a structured way to confirm a fix by reloading the app through MCP after editing the code.

## Inputs

- Target entrypoint (e.g., `pnpm dev`, `pnpm --filter web dev`, or `./scripts/dev-up.sh`)
- App URL or route to inspect
- Known symptoms (console/network errors, stack traces, broken UI state)

## Procedure

0. Ensure Playwright is ready (on demand)
   - Run: `powershell -NoProfile -ExecutionPolicy Bypass -File scripts/ensure-playwright.ps1`
1. Start the stack
   - Ensure dependencies are installed (run `pnpm install` if needed).
   - Run the canonical command (`pnpm dev` / `pnpm --filter web dev`) or `./scripts/dev-up.sh` for the full stack.
2. Attach via MCP DevTools
   - Read the dev server output to determine the actual host/port (avoid assuming `localhost:3000`).
   - Open or reload the app URL using `mcp__chrome-devtools__new_page` / `mcp__chrome-devtools__navigate_page`.
   - Call `mcp__chrome-devtools__list_console_messages` and `list_network_requests` to capture existing errors.
   - Use snapshots when DOM structure or state needs inspection.
   - If auth is required and `auth.json` exists, try to apply it before navigating (cookies + localStorage when possible).
3. Diagnose and fix
   - Map console/network errors to their source files.
   - Apply edits (observing AGENTS and scoped instructions) and restart/reload the app as necessary.
   - Repeat the DevTools commands to confirm the error disappears.
4. Verify and document
   - Continue until the targeted route renders without blocking console/network errors.
   - Take screenshots to prove the UI works as expected and save them under:
     - `docs-ai\agents-artifacts\screenshots\`
   - Record any new commands, patterns, or discoveries in `KB_TOOLS`, `KB_THREADS`, or `DOC_PROJECT_INSIGHTS`.

## Acceptance checks

- The documented script starts without fatal errors and remains accessible.
- MCP DevTools show no blocking console/network errors for the inspected route.
- Screenshots exist under `docs-ai\agents-artifacts\screenshots\` proving the requirement.
- Any new workflow notes are captured in the knowledge base or insights log so future work reuses this routine.



