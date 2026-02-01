# Project Insights Log

## 2026-02-01 - Initial product decisions

- Product: a voice-first Android app to control the real ChatGPT Projects/Chats (read lists, open by number/name, resume, continue).
- Constraint: free to run (no paid app/services/APIs), except an existing ChatGPT Plus subscription.
- Constraint: voice-only interaction, with interruption at any time.
- Saving: save requested outputs to Google Drive as `.md` files into one configured folder; save immediately (no approval) but ask short clarifying questions if unclear.
- Approach: Android Accessibility reads and taps the ChatGPT Android app UI; if it fails, the app gives voice feedback and asks what to do next.
