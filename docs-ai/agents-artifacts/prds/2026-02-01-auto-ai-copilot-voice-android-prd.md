# auto-ai-copilot - Voice-first ChatGPT on Android (PRD v1)

Date: 2026-02-01  
Thread: `auto-ai-copilot | P-00: product brainstorming`

## 1) Goal

Build an Android app that lets me use my existing ChatGPT account **by voice only**, including while driving.

I must be able to:

- Hear the list of my **ChatGPT Projects**, select one by number, and enter it.
- Hear the list of **Chats** inside a Project, select one by number, and enter it.
- Continue talking in that chat from where we stopped.
- Search Projects/Chats by voice (best-guess match; ask only when unclear).
- Save any requested info to Google Drive as a Markdown file.
- Interrupt the assistant at any time with any phrase.

## 2) Problem

When driving or when my hands are busy, using ChatGPT is hard and unsafe.

I want a voice-first layer that:

- reads lists out loud,
- navigates to what I asked for,
- confirms what it did,
- and can save useful outputs (ideas, plans, summaries, results) to Google Drive.

## 3) Solution approach (required)

Use the **real ChatGPT Android app** and control it via Android **Accessibility**:

- read visible text on screen (Projects/Chats),
- scroll lists to read everything,
- tap items to open the selected Project/Chat.

The app should keep unrelated activity hidden when possible, but it may briefly show ChatGPT if Android makes it unavoidable.

## 4) Scope (v1)

### In scope

- **Voice-only** interaction (input + spoken output).
- Always allow **interrupt** with any phrase (stop talking, open item by number, new command, etc.).
- **Projects list**: “Read my projects” reads *all* projects as `1: <name>`, `2: <name>`… while auto-scrolling to the end.
- **Open project**: “Open project 3” opens it and confirms.
- **Chats list in a project**: “Read chats” reads *all* chats with numbers while auto-scrolling.
- **Open chat**: “Open chat 5” opens it and confirms.
- **Search**:
  - “Find project <name>” (global)
  - “Find chat <name>” (within the current project)
  - best-guess fuzzy match; if unclear, ask a short confirmation question.
- **Resume context**: “Where did we stop?” gives a short summary (a few sentences), then offers to read last messages.
- **Save to Google Drive**:
  - One default folder set once in settings.
  - File type: `.md`.
  - New file each time.
  - Filename includes: date + time + (project name if any) + subject.
  - “Save …” is interpreted by the LLM; it decides what to include.
  - If the save request is unclear, ask **1–2 short questions**, then save (no approval step).
  - Always confirm success by voice: “Saved to Google Drive: <filename>.”
- **Offline fallback**:
  - If no internet: save locally on the phone.
  - When internet returns: upload automatically in background.
  - Voice confirmation after upload: “Uploaded to Google Drive: <filename>.”
- **Failure handling**:
  - If it cannot read/control ChatGPT UI (UI changed, error, no internet), it must say what failed and ask what to do next (retry / go back / stop).

### Out of scope

- Deleting, renaming, or otherwise managing ChatGPT Projects/Chats.
- A native Android Auto app shown on the car screen (v1 can run on the phone while connected to Android Auto).
- A local searchable database/index of history (beyond ChatGPT itself and Google Drive).

## 5) Constraints (hard)

- **Free to run**: no paid app, no paid services, no paid APIs.
  - Allowed: existing ChatGPT Plus subscription (already owned).
  - Allowed: free Google account / Google Drive.
- **One-time setup only** (permissions + Drive folder). No prompts during use, except short clarifying questions when a request is unclear.
- Language: **English**.

## 6) Acceptance criteria (v1)

- Voice-only works on phone and in-car use.
- Can interrupt at any time with any phrase.
- Can complete:
  - Read Projects (full list) → open project by number
  - Read Chats (full list) → open chat by number
  - Ask “Where did we stop?” → hear summary → optionally hear last messages
  - Continue conversation in the opened chat
- Search Projects/Chats by voice with best-guess matching and confirmation when unclear.
- “Save …” creates a Drive `.md` file with the required filename format and voice confirmation.
- Offline save works and uploads automatically later with voice confirmation.

## 7) Risks

- ChatGPT app UI changes can break screen reading/tapping.
- Android may require bringing ChatGPT to foreground to read/tap.
- Reading *all* items in long lists can take time; interruption must remain reliable.

## 8) Validation (v1)

- Car-like hands-free test: Projects → Project → Chats → Chat → Summary → Continue.
- Long list test: confirm it scrolls and reads everything; confirm interruption works.
- Save test (online): save an answer + save “our dialogue” and verify Drive files exist and are readable.
- Save test (offline): save while offline, then restore internet and confirm automatic upload.
