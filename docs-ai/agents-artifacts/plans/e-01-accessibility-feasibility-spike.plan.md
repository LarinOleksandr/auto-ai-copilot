# Plan: E-01 Android Accessibility feasibility spike (ChatGPT Projects/Chats)

Date: 2026-02-01  
Thread: `auto-ai-copilot | E-01: accessibility feasibility spike`  
Research: `docs-ai/agents-artifacts/research-briefs/e-01-accessibility-feasibility-spike.research.md`
Last update: 2026-02-02  
Status: Completed (GO)  
Results: `docs-ai/agents-artifacts/conversations/2026-02-02__E-01__accessibility-feasibility-spike-results.summary.md`

## Goal

Build a small Android spike that proves (or disproves) that an Accessibility Service can: detect ChatGPT “Projects” vs “Chats”, read visible titles, auto-scroll lists to the end, and open an item by tapping it.

## Scope / Non-scope

### Scope

- New Android spike app that includes:
  - an Accessibility Service (enabled by the user)
  - a simple debug UI to run the 4 actions and show logs/results
  - minimal, documented heuristics for “Projects” vs “Chats” detection
- Manual on-device validation + captured results (success rate + failure notes).

### Non-scope

- Shipping to Google Play (policy decision not made).
- “Reliable across updates/locales/devices” guarantees (this spike only measures).
- OCR-based reading (no screen capture or text recognition in this spike).
- Any changes to `DOC_PROJECT_PROTECTED_CONTRACTS` (currently none).

## Affected areas

- New Android runtime boundary under `frontend/android/accessibility-spike-e01/`.
- Docs artifacts:
  - `docs-ai/agents-artifacts/research-briefs/e-01-accessibility-feasibility-spike.research.md`
  - `docs-ai/agents-artifacts/plans/e-01-accessibility-feasibility-spike.plan.md`

## Steps

### 0) Approval gate: add an Android project to the repo

- **Deliverable**
  - Confirm it is OK to add a new Android Gradle project folder and its dependencies (AndroidX/Gradle) under `frontend/android/accessibility-spike-e01/`.
- **Integration**
  - N/A (decision gate).
- **Verify**
  - Decision recorded in the thread (“Approved” / “Rejected” / “Approved with changes”).

### 1) Scaffold the Android spike app

- **Deliverable**
  - Create a minimal Android app project at `frontend/android/accessibility-spike-e01/`.
  - Add a small README: how to build/install, how to enable the Accessibility Service, how to run tests.
- **Integration**
  - Keep the spike fully self-contained under `frontend/android/accessibility-spike-e01/` (no wiring into `scripts/dev-all.*`).
- **Verify**
  - Build succeeds: run `.\gradlew.bat assembleDebug` from `frontend/android/accessibility-spike-e01/`.
  - APK exists (debug) and can be installed on a device (manual).

### 2) Add Accessibility Service skeleton + debug logging

- **Deliverable**
  - Implement an Accessibility Service that:
    - filters/targets the ChatGPT package (if possible)
    - logs events and can snapshot the current accessibility tree (high-level only)
- **Integration**
  - Wire service via `AndroidManifest.xml` + accessibility service config XML in the same project.
- **Verify**
  - When ChatGPT is opened, logs show events with the expected package name.

### 3) Implement screen detection: Projects vs Chats

- **Deliverable**
  - Implement `detectChatGptScreen(): ScreenType` with a small, documented heuristic set:
    - prefer resource id / view id resource name (if exposed)
    - fallback to top bar text and/or navigation labels
  - Expose detection result in the debug UI.
- **Integration**
  - Debug UI button “Detect screen” calls the detection method and shows the reason (which heuristic matched).
- **Verify**
  - On the “Chats” screen, result is `Chats`.
  - On the “Projects” screen, result is `Projects`.

### 4) Implement “read visible titles” for the active screen

- **Deliverable**
  - Implement `readVisibleTitles(): List<String>` that returns only currently visible list item titles for:
    - Chats list
    - Projects list
  - Show results in the debug UI.
- **Integration**
  - Debug UI button “Read titles” triggers the read and shows the list.
- **Verify**
  - On each screen, the visible titles are displayed (or a clear “no titles found” reason is shown).

### 5) Implement “auto-scroll to end” with safe stop conditions

- **Deliverable**
  - Implement `scrollToEnd(maxScrolls, stableTailRepeats): ScrollResult`:
    - prefer `ACTION_SCROLL_FORWARD` on a scrollable node
    - fallback to `dispatchGesture` swipe if no scroll action exists
    - stop when the “last visible title” stops changing for N scrolls, or when max scrolls is hit
- **Integration**
  - Debug UI button “Scroll to end” runs the scroll loop and logs each step.
- **Verify**
  - For a long list, scrolling progresses and stops (no infinite loop).
  - Result indicates whether it believes it reached the end vs hit the safety cap.

### 6) Implement “tap item to open”

- **Deliverable**
  - Implement `openItemByTitle(title)` and `openItemByIndex(index)`:
    - prefer `ACTION_CLICK` (or closest clickable parent)
    - fallback to gesture tap on bounds when needed
- **Integration**
  - Debug UI allows selecting an extracted title (or index) and triggers “Open”.
- **Verify**
  - Tapping an item navigates into that chat/project at least once on a real device.

### 7) Capture spike results and decide next step

- **Deliverable**
  - Record results as a short note in `docs-ai/agents-artifacts/conversations/` (or another agreed artifact):
    - device model + Android version
    - ChatGPT app version (if visible)
    - success rate for the 4 actions across 10 runs
    - main failure modes + screenshots (if helpful)
  - Produce a final GO/NO-GO recommendation for moving beyond the spike.
- **Integration**
  - Link the results back to `docs-ai/agents-artifacts/research-briefs/e-01-accessibility-feasibility-spike.research.md` (append a short “Results” section).
- **Verify**
  - Results are persisted and the recommendation is explicit.

## Implementation plan (do X, then verify Y)

1. Create `frontend/android/accessibility-spike-e01/`, then verify `.\gradlew.bat assembleDebug` works.
2. Add the Accessibility Service and config, then verify it receives events in ChatGPT.
3. Implement screen detection, then verify it distinguishes “Projects” vs “Chats”.
4. Implement title extraction, then verify visible titles are readable as text nodes.
5. Implement scroll-to-end, then verify it stops safely and does not loop forever.
6. Implement open/tap, then verify it navigates into an item.
7. Run the full checklist 10 times and record outcomes, then decide GO/NO-GO for the next phase.

## Risks

- ChatGPT UI changes or localization breaks selectors and screen detection.
- Some lists may not expose scroll/click actions; gesture fallback may still be unreliable.
- Accessibility usage may be incompatible with Google Play policy unless the app is clearly assistive (policy must be confirmed before any “ship” plan).
- Reading titles can expose sensitive user content; logs must stay local by default.

## Validation

- Build: `.\gradlew.bat assembleDebug` from `frontend/android/accessibility-spike-e01/`.
- Manual smoke path (on device):
  - Open ChatGPT -> go to Chats -> Detect -> Read titles -> Scroll to end -> Open item
  - Go to Projects -> Detect -> Read titles -> Scroll to end -> Open item
- Repeatability:
  - Run the smoke path 10 times and record success/fail reasons.

## References

- `docs-ai/agents-artifacts/research-briefs/e-01-accessibility-feasibility-spike.research.md`
- Android developer docs: `AccessibilityService`, `AccessibilityNodeInfo`, `dispatchGesture(...)`
- Google Play policy/help: Accessibility API usage requirements

## Outcome (2026-02-02)

- ✅ Detect screen (Projects vs Chats): works when ChatGPT is the active app.
- ✅ Read visible titles: works (reads visible list item titles from the accessibility tree).
- ✅ Auto-scroll to end: works (scroll action preferred, gesture fallback, safe stop).
- ✅ Open item: works (click/tap). Fix applied so "open first title" opens item #1 from the last read list.

Notes:
- Emulator login for ChatGPT is not reliable (Play Integrity / Play Services issues). Real phone is the baseline for testing.
