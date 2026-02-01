# Project Context

## Overview

auto-ai-copilot is a voice-first Android app for one user (me).

It lets me control my existing ChatGPT account by voice:

- read my ChatGPT Projects list (numbered)
- open a Project by number or by name
- read Chats inside a Project (numbered)
- open a Chat by number or by name
- ask “where did we stop?” to get a short summary and optionally hear the last messages
- save requested outputs to Google Drive as a Markdown file

It should work while driving (Android Auto connected) and also anywhere on the phone.

## Goals

1. Make ChatGPT usable hands-free in real life (especially driving).
2. Make it fast to resume the right Project/Chat and continue.
3. Make it easy to store ideas/results to Google Drive on command.

## Essential Information

- Human docs live in `docs/`; the primary guide is `docs/application-development-guide.md`.
- Agent knowledge/prompts/artifacts live in `docs-ai/` (routed via `KB_ROOTS`).
- Service boundaries are represented by top-level runtime folders (`frontend/`, `ai/`, `supabase/`, `infra/`) per `KB_REPOSITORY_RULES`.
- Protected contracts (must-not-break defaults) live in `DOC_PROJECT_PROTECTED_CONTRACTS`.

## Current product constraints (hard)

- Free to run (no paid app, no paid services, no paid APIs), except an existing ChatGPT Plus subscription.
- One-time setup only. No permission prompts during use.
- English voice input/output.
- Must allow interruption at any time with any phrase.
- Use the real ChatGPT Android app Projects/Chats (not a separate “project system” inside our app).

## Current approach (v1)

Use Android Accessibility to read and interact with the ChatGPT Android app UI:

- read visible text (Project/Chat names)
- scroll long lists to read everything
- tap items to open a Project/Chat

If the UI cannot be read or controlled (UI changed, errors, no internet), the app gives voice feedback and asks what to do next (retry / go back / stop).

Primary reference PRD:

- `docs-ai/agents-artifacts/prds/2026-02-01-auto-ai-copilot-voice-android-prd.md`

## Project tech stack

Proposed v1 stack (needs confirmation):

- Android app: Kotlin + Android Accessibility Service + Foreground Service (for active listening mode)
- Speech-to-text: Android speech recognition
- Text-to-speech: Android TTS engine (best available free voice)
- Google Drive: Google Sign-In + Drive API (upload `.md` files)
- No backend for v1

If the project stack changes, update this section and get user approval. If the baseline changes, update `KB_TECH_STACK` as well (also requires user approval).
