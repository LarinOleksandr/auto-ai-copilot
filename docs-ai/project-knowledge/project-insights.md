# Project Insights Log

## 2026-02-01 - Initial product decisions

- Product: a voice-first Android app to control the real ChatGPT Projects/Chats (read lists, open by number/name, resume, continue).
- Constraint: free to run (no paid app/services/APIs), except an existing ChatGPT Plus subscription.
- Constraint: voice-only interaction, with interruption at any time.
- Saving: save requested outputs to Google Drive as `.md` files into one configured folder; save immediately (no approval) but ask short clarifying questions if unclear.
- Approach: Android Accessibility reads and taps the ChatGPT Android app UI; if it fails, the app gives voice feedback and asks what to do next.

## 2026-02-02 - E-01 feasibility spike results (real device)

- Result: Accessibility can detect Projects/Chats, read visible titles, scroll to end, and open an item (confirmed on one real Android phone).
- Emulator note: ChatGPT login can fail or be unstable on emulators due to Play Integrity / Google Play Services issues; treat real-phone testing as the baseline.
- Android note: to detect/launch ChatGPT reliably on-device, the app needs package visibility (`<queries>` for `com.openai.chatgpt`).
- Accessibility note: some devices need "interactive windows" retrieval; using `rootInActiveWindow` plus `windows` is more reliable than only `rootInActiveWindow`.
