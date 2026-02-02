# E-01: Android Accessibility feasibility spike (ChatGPT Projects/Chats)

## Update (2026-02-02): Spike implemented + on-device results

We implemented the spike app and tested it on a real Android phone.

Result: **GO (technical feasibility confirmed on one real device)**.

Notes:
- Emulator testing was not reliable for ChatGPT login (Play Integrity / Play Services issues).
- On-device testing is the right baseline for this feature.

## 1) Scope

- Feature: Use an Android Accessibility Service to (1) detect ChatGPT “Projects” vs “Chats” screens, (2) read visible titles, (3) auto-scroll lists to the end, (4) tap an item to open it.
- Timebox (original): 90 minutes (research-only; no code). This brief is now updated with spike results.
- Boundaries touched:
  - Android (new runtime boundary under `frontend/` is likely)
  - Docs (`ROOT_AGENTS_ARTIFACTS` artifacts)
- Assumptions:
  - Target app is the ChatGPT Android app (package likely `com.openai.chatgpt`).
  - Spike targets one device + one language (English) first.
  - We accept that “reliable” cannot be proven without running on-device tests.

## 2) Key risks and abuse cases

- **Accessibility tree may be insufficient**: ChatGPT UI may not expose stable/complete accessibility nodes (missing text, missing click/scroll actions, unstable structure).
- **Brittle selectors**: Relying on visible text (“Projects”, “Chats”) breaks on localization and UI copy changes.
- **Scrolling may fail**: Lists may not report “scrollable”, or may virtualize content in ways that make “end reached” ambiguous.
- **Tap may be blocked**: Items may not be “clickable” in the accessibility tree; tapping may require gesture injection, which is more fragile.
- **Policy/compliance risk (high)**: Google Play restricts Accessibility API usage to assistive purposes; “automation” use cases can be rejected unless clearly aligned with user-disability support and policy requirements.
- **Privacy risk**: Reading screen content may capture sensitive user data (chat titles can include PII).

## 3) Constraints and recommended defaults

- Detect app/window:
  - Default: filter by package name (e.g., `com.openai.chatgpt`) -> reduces accidental automation in other apps.
- Screen detection approach:
  - Default: detect “Projects” vs “Chats” using a _small_ set of heuristics, in this order:
    1. stable view id/resource name (if present)
    2. top app bar title text
    3. presence of specific navigation labels (fallback)
- Title extraction:
  - Default: only read **visible** list items from the current accessibility tree; do not attempt OCR in this spike.
- Scrolling:
  - Default: use accessibility scroll actions when available (`ACTION_SCROLL_FORWARD` / `ACTION_SCROLL_BACKWARD`).
  - Fallback: use `dispatchGesture` swipe if no scroll action is available.
  - Safety: cap scroll loop (e.g., max 50 scrolls) and stop when “last visible title” stops changing across N consecutive scrolls.
- Tapping:
  - Default: `ACTION_CLICK` on the list item node (or its closest clickable parent).
  - Fallback: gesture tap on the node bounds if click action is missing.
- Logging/data:
  - Default: keep logs local on-device; avoid sending titles off-device in the spike.

## 4) Data handling

- Data types:
  - On-screen text (chat/project titles) -> potentially sensitive user content (may include PII).
  - UI metadata (package name, screen type, node counts) -> non-PII.
- Retention/deletion:
  - Default: no persistent storage unless explicitly enabled; provide “clear logs” in the spike UI.
- Access model:
  - Only the device user (local) can enable the Accessibility Service and run the spike.

## 5) UX and failure modes

- “ChatGPT app not detected”:
  - Behavior: stop; prompt user to open ChatGPT app.
- “Screen not recognized (Projects vs Chats)”:
  - Behavior: stop; show what was detected (top bar text, package, a small debug snapshot).
- “No readable titles found”:
  - Behavior: stop; report whether nodes exist but have empty text.
- “Scroll does nothing”:
  - Behavior: try fallback gesture; if still no change, stop with a clear error.
- “Tap did not navigate”:
  - Behavior: retry once (different node/parent); then stop and report.

## 6) Operations and observability

- Logging:
  - Screen detection decision + reason (which heuristic matched)
  - For each scroll step: last visible title before/after + whether UI changed
  - For taps: target node text + bounds + whether window content changed
- Metrics/alerts:
  - Not needed for the spike (manual evaluation only).

## 7) Decisions to confirm

- Distribution: Will this ship via Google Play, or is this for internal/sideload use only?
  - Default for spike: internal/sideload (to avoid Play policy risk while validating feasibility).
- Languages/locales:
  - Default for spike: English only.
- Target devices/OS versions:
  - Default for spike: one “real” device (not only emulator), Android 13+ if possible.

## Test checklist (on-device)

### Setup

- Enable the spike’s Accessibility Service in Android Settings.
- Confirm the service receives events when ChatGPT is opened (package name matches).

### (1) Detect Projects/Chats screens

- From ChatGPT “Chats” screen: spike reports `Chats`.
- From ChatGPT “Projects” screen: spike reports `Projects`.
- Navigate between the two: spike updates state correctly.

### (2) Read visible titles

- On “Chats”: spike lists the visible chat titles (top N items).
- On “Projects”: spike lists the visible project titles (top N items).
- Empty-state screen (no chats/projects): spike returns empty list and a clear reason.

### (3) Auto-scroll to the end

- On a long list: spike scrolls down until it detects the end (or hits the safety cap).
- End detection: last visible title becomes stable for N scrolls and spike stops.
- “Load more” behavior (if present): spike handles dynamic loading without infinite loops.

### (4) Tap an item to open it

- Tap first visible item: ChatGPT navigates into the chat/project.
- Back navigation: return to list; spike can tap a different item.

### Robustness

- Run the full flow 10 times: record success rate and main failure modes.
- Rotate device / change font size: confirm detection still works (or document breakage).

## GO / NO-GO (for the feasibility spike)

### GO criteria

- In at least one device configuration, the Accessibility tree exposes enough information to:
  - distinguish “Projects” vs “Chats” reliably during a session
  - read visible titles as text nodes
  - scroll to the end with either scroll actions or gesture fallback
  - open an item via click or tap gesture

### NO-GO criteria

- Titles are not accessible as text nodes (only rendered visuals), and scrolling/clicking cannot be driven reliably without OCR or fragile coordinate hacks.
- Policy requirement is “must ship on Google Play for non-assistive automation use” (high chance of rejection).

### Decision (now)

- **GO for the spike implementation**, because the only responsible way to answer “reliable?” is to test on-device against the real ChatGPT app UI.
- **NO-GO for any production commitment** (especially Google Play distribution) until the spike validates technical feasibility _and_ we confirm policy constraints.

## Results (2026-02-02)

### Environment

- Target app: ChatGPT Android app (package `com.openai.chatgpt`)
- Validation: real Android phone (manual testing)

### What worked (meets the 4 spike goals)

1) Detect screen (Projects vs Chats)
- Works when ChatGPT is open and is the active app.

2) Read visible titles
- Works: we can read the visible list item titles from the accessibility tree.

3) Auto-scroll lists to the end
- Works: prefers Accessibility scroll actions; falls back to gesture swipe; stops when the tail is stable.

4) Tap an item to open it
- Works: we can open an item.
- Fix applied: "open first title" is tied to the last read list and uses the title text position for stable ordering.

### Important constraints (still true)

- This can be brittle across UI updates and languages (labels like "Projects" / "Chats" can change).
- Google Play policy risk remains high if this is positioned as "automation" instead of assistive use.

## References (external)

- Android developer docs: Accessibility overview and services
- Android developer docs: `AccessibilityNodeInfo` actions and `performAction(...)`
- Android developer docs: `AccessibilityService#dispatchGesture(...)`
- Google Play policy/help: Accessibility API / “Is your app using the Accessibility API appropriately?”
