# Plan: v1 Execution Plan (Voice-first ChatGPT on Android)

Date: 2026-02-01  
Thread: `auto-ai-copilot | P-02: v1 execution plan`  
PRD: `docs-ai/agents-artifacts/prds/2026-02-01-auto-ai-copilot-voice-android-prd.md`  
Roadmap item: Accessibility feasibility spike (can we reliably read Projects/Chats and tap to open them?)

## Goal

Ship an Android app that lets me use my existing ChatGPT account **by voice only**:

- Read Projects and Chats (numbered, full list via auto-scroll)
- Open Project/Chat by number (and find by name)
- Resume: “Where did we stop?”
- Save requested info to Google Drive as Markdown, with offline fallback
- Interrupt at any time with any phrase

## Scope / Non-scope

### Scope (v1)

- Android phone app (usable while connected to Android Auto, but no Android Auto UI).
- Uses Android Accessibility to read and tap inside the real ChatGPT Android app.
- No backend for v1.
- Free to run (no paid APIs/services). Existing ChatGPT Plus subscription is allowed.

### Non-scope (v1)

- Deleting/renaming Projects/Chats.
- A native Android Auto app UI on the car screen.
- Local searchable history/index (beyond ChatGPT itself and saved Drive files).

## Affected areas

- New Android runtime boundary under `frontend/android/`.
  - Important: `frontend/AGENTS.md` is web/React-focused. Add a scoped `frontend/android/AGENTS.md` so Kotlin/Android rules apply for that subtree.
- New generated artifact from the spike (results + selectors + go/no-go) under `docs-ai/agents-artifacts/research-briefs/`.
- `DOC_PROJECT_PROTECTED_CONTRACTS`: currently none. This plan should not break anything, but it will create new “contract moments” (voice commands, file naming, saved data keys).

## Steps

### 1) Establish Android folder + local agent rules

- **Deliverable**
  - Create `frontend/android/` and a scoped `frontend/android/AGENTS.md` that defines Android/Kotlin rules (and does not inherit web-only constraints).
  - Decide and record Android app root: `frontend/android/auto-ai-copilot/`.
- **Integration**
  - Android code lives only under `frontend/android/auto-ai-copilot/` (self-contained runtime boundary).
- **Verify**
  - Repo tree has the new folder and scoped agent rules in place.

### 2) Accessibility feasibility spike (Projects/Chats read + tap)

- **Deliverable**
  - Build a tiny “spike app” (can become the real app later) that runs an Accessibility Service and can:
    - detect when ChatGPT is on-screen
    - read visible list items (Project/Chat titles)
    - scroll list containers to the end
    - tap a chosen item reliably
  - Document results in `docs-ai/agents-artifacts/research-briefs/accessibility-feasibility-spike.md`:
    - what UI nodes we can read (text content)
    - what node patterns are stable enough to target (class names, view tree shape, content descriptions)
    - what fails (missing text, blocked actions)
    - a clear go/no-go for v1
- **Integration**
  - Accessibility code is in a dedicated package/module area inside `frontend/android/auto-ai-copilot/` (so it is not throwaway).
- **Verify**
  - On a real phone:
    - “Read my projects” can read at least 2 pages (scroll works).
    - “Open project 1” taps and opens something reliably.
    - Inside a project, “Read chats” can read at least 2 pages.
    - “Open chat 1” opens a chat reliably.

### 3) Go / no-go decision gate (based on spike)

- **Deliverable**
  - A short decision note at the end of `docs-ai/agents-artifacts/research-briefs/accessibility-feasibility-spike.md`:
    - **Go**: selectors/actions are reliable enough for v1
    - **No-go**: explain why, and list 1–2 fallback ideas for v1 scope (for example: only “continue current chat” without Projects/Chats navigation)
- **Integration**
  - If “no-go”, stop v1 implementation work and update `DOC_PROJECT_ROADMAP` to reflect the new plan.
- **Verify**
  - Roadmap and plan stay consistent with the decision.

### 4) Voice loop baseline (STT + TTS + interruption)

- **Deliverable**
  - Speech-to-text using Android speech recognition.
  - Text-to-speech using Android TTS.
  - “Interrupt anytime”: any detected user speech stops TTS fast and switches to listening.
- **Integration**
  - Central voice controller used by every command (single place for start/stop/listen/speak).
- **Verify**
  - While TTS is speaking, saying anything stops speech within ~1 second.
  - Spoken text becomes a parsed “command” (even if it’s only logged at first).

### 5) One-time setup (permissions + Drive folder)

- **Deliverable**
  - Setup flow that handles, once:
    - Accessibility enable
    - overlay permission (if needed)
    - Google Sign-In + select one default Drive folder
  - Store setup state locally so it does not prompt during normal use.
- **Integration**
  - App start checks setup state; if incomplete, it speaks what is missing and opens the correct settings screen.
- **Verify**
  - After setup is complete, normal use never triggers permission prompts.

### 6) Command set v1 (voice phrases)

- **Deliverable**
  - Define and implement recognition for the PRD commands:
    - read projects, open project N, find project <name>
    - read chats, open chat N, find chat <name>
    - where did we stop
    - save <request>
    - stop / go back / retry
- **Integration**
  - Command router maps recognized intents to actions in the Accessibility layer and Drive layer.
- **Verify**
  - Saying each command triggers the right action (at least with debug text + voice confirmation).

### 7) “Where did we stop?” summary + optional last messages

- **Deliverable**
  - Extract a window of recent chat messages from the ChatGPT UI (visible + scroll if needed).
  - Produce a short spoken summary and then ask if it should read the last messages.
- **Integration**
  - Summary generation does not pollute the user’s current chat (use a separate “control chat” or a controlled prompt flow).
- **Verify**
  - Summary is spoken, then it asks a yes/no question; both paths behave correctly.

### 8) “Save …” to Google Drive as `.md` (+ offline fallback + auto-upload)

- **Deliverable**
  - Generate Markdown from the user’s request (ask 1–2 short questions only when unclear).
  - Upload to the chosen Drive folder as a new `.md` file with filename format:
    - date + time + (project name if any) + subject
  - Offline fallback: save locally, then upload later automatically and confirm by voice.
- **Integration**
  - Drive integration is isolated behind a small interface so it can be tested and swapped.
- **Verify**
  - Online: saved file exists in Drive and opens correctly.
  - Offline: airplane mode triggers local save; reconnect triggers background upload + voice confirmation.

## Implementation plan (do X, then verify Y)

1. Create `frontend/android/AGENTS.md`, then verify Android subtree rules are explicit and not web-only.
2. Scaffold `frontend/android/auto-ai-copilot/`, then verify `./gradlew assembleDebug` works from that folder.
3. Implement the Accessibility spike flows, then verify “read/open projects/chats” works on a real phone.
4. Write `docs-ai/agents-artifacts/research-briefs/accessibility-feasibility-spike.md`, then verify it contains a clear go/no-go.
5. Implement STT+TTS + interrupt, then verify barge-in works reliably.
6. Implement one-time setup, then verify no prompts appear during normal use.
7. Implement v1 command router, then verify each PRD command triggers correct behavior.
8. Implement “where did we stop”, then verify summary + optional read-last works.
9. Implement Drive save + offline fallback + auto-upload, then verify online/offline flows end-to-end.

## Risks

- ChatGPT UI changes can break Accessibility selectors (highest risk).
- Some UI text may not be exposed to Accessibility (would block Projects/Chats listing).
- Foreground/overlay requirements may make “hidden” operation impossible in some moments.
- Continuous listening impacts battery; must use a foreground service when active.
- Google Drive integration may require adding new Android dependencies (needs explicit approval per `KB_REPOSITORY_RULES`).

## Validation

- Spike validation (must pass before v1 build-out):
  - Read projects (multi-page) -> open project -> read chats (multi-page) -> open chat
- v1 smoke path (hands-free):
  - Read projects -> open project by number -> read chats -> open chat -> “where did we stop?” -> speak a follow-up -> save
- Offline path:
  - Save while offline -> reconnect -> automatic upload + voice confirmation

## References

- `docs-ai/agents-artifacts/prds/2026-02-01-auto-ai-copilot-voice-android-prd.md`
- `docs-ai/project-knowledge/project-roadmap.md`
- Existing plan baseline (older thread): `docs-ai/agents-artifacts/plans/voice-android-chatgpt-projects-drive-v1.plan.md`
