# Plan: Voice-first ChatGPT on Android (Projects + Chats + Drive save) - v1

Date: 2026-02-01  
Thread: `auto-ai-copilot | P-00: product brainstorming`  
PRD: `docs-ai/agents-artifacts/prds/2026-02-01-auto-ai-copilot-voice-android-prd.md`

## Goal

Ship an Android app that lets the user control their existing ChatGPT Projects/Chats by voice (list, open, search, resume) and save requested outputs to Google Drive as Markdown, with offline fallback.

## Scope / Non-scope

### Scope (v1)

- Android app (phone; can be used while connected to Android Auto).
- Voice-only interaction, with barge-in (interrupt any time with any phrase).
- Read *all* ChatGPT Projects/Chats by auto-scrolling and speaking `N: <name>`.
- Open Project/Chat by number.
- Find Project/Chat by fuzzy match, ask only when unclear.
- “Where did we stop?”: short summary + offer last messages.
- “Save …”: LLM-driven content selection (ask 1–2 questions if unclear) and save to Google Drive as `.md`.
- Offline save + background upload on reconnect.

### Non-scope (v1)

- A native Android Auto app UI on the car screen.
- Rename/delete Project/Chat.
- Local searchable history/index (beyond ChatGPT + Drive).

## Affected areas

- New Android client under `frontend/android/` (new runtime boundary under `frontend/`).
- Drive upload integration (Google Sign-In + Drive API) in the Android app.
- No changes to `DOC_PROJECT_PROTECTED_CONTRACTS` (currently none).

## Steps

### 1) Scaffold Android app baseline

- **Deliverable**
  - Create Android app project under `frontend/android/auto-ai-copilot/`.
  - Add minimal screens: Setup, Listening overlay, Status.
- **Integration**
  - Android app is self-contained under `frontend/android/auto-ai-copilot/`.
- **Verify**
  - Build succeeds: run `.\gradlew assembleDebug` from `frontend/android/auto-ai-copilot/`.
  - App launches on device/emulator and shows a simple “Ready” screen.

### 2) Voice loop (speech in + speech out + interruption)

- **Deliverable**
  - Speech-to-text (STT) using Android speech recognition.
  - Text-to-speech (TTS) using Android TTS engine (use best available free voice).
  - “Barge-in”: any detected user speech interrupts TTS immediately.
- **Integration**
  - Central voice controller (single place) used by all flows.
- **Verify**
  - When TTS is speaking, saying anything stops TTS within ~1 second.
  - Spoken text is transcribed and shown in debug UI.

### 3) One-time setup experience (permissions + Drive folder)

- **Deliverable**
  - Guided one-time setup:
    - Enable Accessibility permission for the app.
    - Enable “display over other apps” (overlay).
    - Google Sign-In and selecting one default Drive folder.
- **Integration**
  - Setup state stored locally (private storage) and checked on app start.
- **Verify**
  - After setup, app never prompts for permissions during normal use.
  - If setup is incomplete, it clearly says what’s missing and opens the right settings page.

### 4) ChatGPT UI control (Accessibility): read Projects list

- **Deliverable**
  - Open ChatGPT app from the voice app when needed.
  - Detect the “Projects list” UI and extract visible project names.
  - Auto-scroll until the end; speak as `1: <name>`, `2: <name>`… (stable numbering for that read).
- **Integration**
  - Accessibility service provides:
    - `readProjects(): List<ProjectItem>`
    - `scrollProjectsNextPage(): boolean`
    - a “not supported / not found” error when UI cannot be detected
- **Verify**
  - “Read my projects” reads through multiple pages and stops at the end.
  - If ChatGPT UI cannot be detected, app says the failure and asks: “Retry, go back, or stop?”

### 5) Open project by number + search by name

- **Deliverable**
  - “Open project <N>”: taps the Nth project from the last read list; confirms by voice.
  - “Find project <name>”: fuzzy-match against the last read list; if uncertain, ask “Did you mean …?”.
- **Integration**
  - Command router recognizes:
    - read projects
    - open project number
    - find project name
- **Verify**
  - “Open project 3” opens a project and the app says the project name.
  - “Find project <partial name>” proposes best match; confirms before opening when unclear.

### 6) Inside a project: read chats + open chat + find chat

- **Deliverable**
  - Read chats list with auto-scroll and speak `N: <chat title>`.
  - Open chat by number.
  - Find chat by fuzzy match within the project.
- **Integration**
  - Accessibility service adds:
    - `readChats(): List<ChatItem>`
    - `scrollChatsNextPage(): boolean`
    - `openChatByIndex(index)`
- **Verify**
  - Can open a chosen chat and the app confirms: “Opened chat <N>: <title>.”

### 7) “Where did we stop?” summary + offer last messages

- **Deliverable**
  - When a chat is open:
    - Extract the last messages from the visible chat UI (and scroll back as needed).
    - Produce a short spoken summary (few sentences).
    - Ask: “Want me to read the last messages?”
- **Integration**
  - Add `readChatTranscriptWindow()` helper in Accessibility layer.
- **Verify**
  - The summary is spoken, then the follow-up question is asked.
  - If the user says “Yes”, it reads the last messages; if “No”, it stops.

### 8) “Save …” to Google Drive as Markdown (no approval step)

- **Deliverable**
  - Voice command “Save …” triggers:
    - (If unclear) ask 1–2 short questions.
    - Build a Markdown document using the LLM (via ChatGPT itself).
    - Upload to the default Drive folder as a new `.md` file.
    - Speak: “Saved to Google Drive: <filename>.”
  - Filename format: date + time + (project name if any) + subject.
- **Integration**
  - Keep “save generation” out of the user’s current chat:
    - Use a dedicated “control chat” in ChatGPT (created once) to generate the Markdown content.
    - Copy needed context from the current chat into the control prompt.
- **Verify**
  - “Save our dialogue about X” creates a `.md` file in Drive with the required filename parts.
  - “Save this plan” also works and saves a clean Markdown note.

### 9) Offline save + background upload on reconnect

- **Deliverable**
  - If Drive upload fails due to network:
    - Save the `.md` file locally in private storage.
    - Schedule background upload when internet returns.
    - Speak “Saved offline; I will upload when internet is back.”
  - On reconnect: upload and speak confirmation.
- **Integration**
  - Background worker (WorkManager) for retry uploads.
- **Verify**
  - Turning on airplane mode forces offline path.
  - Turning internet back on uploads automatically without user action.

## Implementation plan (do X, then verify Y)

1. Create `frontend/android/auto-ai-copilot/` Android project, then verify `.\gradlew assembleDebug` succeeds.
2. Implement STT+TTS controller, then verify you can speak and see recognized text.
3. Add “stop speaking on any user speech”, then verify barge-in works.
4. Add Setup flow for Accessibility + overlay + Drive folder, then verify the app never re-prompts during use.
5. Implement Accessibility reading for Projects list, then verify it can read and scroll through all projects.
6. Add command router for “read/open/find project”, then verify voice navigation works.
7. Implement Chats list read/open/find in a project, then verify full navigation to a specific chat.
8. Implement transcript extraction + summary prompt, then verify “Where did we stop?” speaks summary and offers last messages.
9. Implement Drive upload + local fallback + background retries, then verify online and offline save flows.

## Risks

- ChatGPT UI changes can break selectors; plan needs a fast way to adjust UI detection.
- Accessibility actions may require foreground focus; “fully hidden” may not always be possible.
- Continuous listening impacts battery; must run as a foreground service when active.
- “Control chat” approach depends on ChatGPT app allowing stable navigation to a known chat.

## Validation

- Android build: `.\gradlew test` and `.\gradlew assembleDebug` from `frontend/android/auto-ai-copilot/`.
- Smoke path (hands-free):
  - Read projects → open project by number → read chats → open chat by number → “where did we stop?” → ask a follow-up question → save.
- Offline path:
  - Save while offline → reconnect → automatic upload.

## References

- `docs-ai/agents-artifacts/prds/2026-02-01-auto-ai-copilot-voice-android-prd.md`
