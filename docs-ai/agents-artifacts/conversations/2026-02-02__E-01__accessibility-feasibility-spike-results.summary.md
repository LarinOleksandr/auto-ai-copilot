# Conversation Summary

- Date: 2026-02-02
- Thread: `auto-ai-copilot | E-01: accessibility feasibility spike`
- Slug: `accessibility-feasibility-spike-results`
- Tags: `android, accessibility, spike, chatgpt`

## Context

- Goal: verify if Android Accessibility can (1) detect ChatGPT "Projects"/"Chats", (2) read visible titles, (3) scroll to end, (4) open an item.
- Emulator testing was unreliable for ChatGPT login, so validation moved to a real phone.

## Results

- GO (on one real device):
  - Detect screen: works
  - Read titles: works
  - Scroll to end: works (with safe stop)
  - Open item: works

## Key fixes that made it work reliably

- Package visibility: added `AndroidManifest.xml` `<queries>` for `com.openai.chatgpt` so launch detection works on-device.
- Active window access: enabled interactive windows retrieval and searched `rootInActiveWindow` + `windows` for a ChatGPT root.
- "Open first title" correctness: tied "open" to the last read list and used the title text position for stable ordering.

## Follow-ups

- Keep testing on a real phone for any UI changes and for localization (labels may change).
- Confirm Google Play policy position before any production distribution.

