# Conversation Summary

- Date: 2026-02-01
- Thread: `auto-ai-copilot | P-00: product brainstorming`
- Slug: `voice-android-prd-bootstrap`
- Tags: `prd, framework, git, android, voice`

## Context

- Defined a personal Android product to use ChatGPT by voice while driving and anywhere on the phone.
- Clarified that the app must work with the *existing* ChatGPT Projects/Chats and be voice-only.
- Captured a v1 PRD and a v1 build plan as repo artifacts.
- Aligned next steps with the repo framework (PRD -> repo bootstrap -> project setup -> planning).

## Decisions (only if any)

- Decision: v1 uses Android Accessibility to read/tap the ChatGPT Android app UI (Projects list, Chats list, open by number/name).
  - Why: there is no official way for an app to list ChatGPT Projects/Chats directly; this preserves the “use my real Projects/Chats” requirement.
- Decision: v1 must be free to run (no paid app/services/APIs) except an existing ChatGPT Plus subscription and free Google Drive.
  - Why: explicit constraint from the user.
- Decision: store GitHub tokens outside Git using a local `.env` file (ignored), and keep `.env.example` committed.
  - Why: framework rule “secrets outside git”, plus convenience for automation.

## Key points

- Voice UX requirements:
  - Read *all* items in lists, speak as `N: <name>`, and allow interruption at any time with any phrase.
  - Search by fuzzy match; ask only when unclear; confirm actions (opened project/chat, saved file, uploaded, etc.).
  - “Where did we stop?” gives a short summary, then offers to read last messages.
  - “Save …” is LLM-interpreted and can save any requested scope; if unclear, ask 1–2 questions; no approval step for saving.
- Workflow alignment:
  - Follow “strict order” in the framework: repo bootstrap when not a git repo -> project setup docs -> plan creation -> implementation.
- Repo automation:
  - Added `.env.example`, ignored `.env`, updated PR tooling so PR creation can use GitHub API token when `gh` is missing.

## Open questions / follow-ups

- Start the next thread and run `$plan-creation` for the next roadmap item (Accessibility feasibility spike, then v1 execution plan).
- Decide whether to keep using GitHub API token automation or install/configure `gh` for PRs.

## Links

- PRD: `docs-ai/agents-artifacts/prds/2026-02-01-auto-ai-copilot-voice-android-prd.md`
- Plan (draft): `docs-ai/agents-artifacts/plans/voice-android-chatgpt-projects-drive-v1.plan.md`
- Framework “strict order”: `docs/application-development-guide.md`

