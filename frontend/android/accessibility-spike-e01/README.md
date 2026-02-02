# Android Accessibility Spike (E-01)

This is a spike app to test whether Android Accessibility can reliably control the ChatGPT Android app:

- detect “Projects” vs “Chats” screens
- read visible titles
- auto-scroll lists to the end
- tap an item to open it

Plan: `docs-ai/agents-artifacts/plans/e-01-accessibility-feasibility-spike.plan.md`

## Build (requires Android toolchain)

From `frontend/android/accessibility-spike-e01/`:

- `.\gradlew.bat assembleDebug`

## Run (on device)

1. Install the debug APK.
2. Enable the Accessibility Service:
   - App -> “Open Accessibility Settings” button, then enable “Auto AI Accessibility Spike”.
3. Open the ChatGPT app and navigate to either “Chats” or “Projects”.
4. Return to the spike app and use:
   - Detect Screen
   - Read Titles
   - Scroll To End
   - Open First Title

## Test checklist (quick)

- Chats screen: Detect -> `Chats`, Read Titles returns non-empty, Scroll To End stops safely, Open First Title navigates.
- Projects screen: Detect -> `Projects`, Read Titles returns non-empty, Scroll To End stops safely, Open First Title navigates.
- Repeat 10 times and record the success rate + top failure reasons.

## Notes

- This spike targets the ChatGPT package name: `com.openai.chatgpt`.
- Logs are shown locally in the app UI. Do not copy sensitive titles into shared logs.
