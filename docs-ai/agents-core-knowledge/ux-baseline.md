# UX Baseline (framework-level)

## Agent summary

- Defines non-negotiable UX rules and practical guidelines for any `frontend/**` work.
- Framework-level only: **no** app-specific user journeys, wizard steps, or screen-by-screen behavior.
- Aligns error UX with `KB_ERROR_HANDLING` (user-safe messages, consistent behavior).

---

## Purpose

This document defines how interfaces behave in this repo.
If behavior is not defined here, default to the simplest predictable option.

---

## Scope

This document governs:

- Behavior for forms, loading, empty, and error states
- Feedback patterns (what users see and when)
- Modal/overlay interaction basics
- Navigation predictability basics
- Microcopy baseline rules (button labels and short UI text)

This document does not govern:

- Product-specific flows and navigation structure (feature briefs and product docs)
- Brand voice guidelines (can be added later as a dedicated routed doc if needed)

---

## Core principles (should)

- Clarity over cleverness
- Predictability over novelty
- Fast feedback over delayed feedback

---

## Non-negotiables (must)

### 1) Forms

- Validation errors appear either:
  - on submit, or
  - on blur after the first interaction
- Error messages are short and actionable.
- Required fields are clearly marked.
- Success is acknowledged (clear visual feedback).

### 2) Loading states

- Every async action must have a loading state.
- Buttons disable during submission/loading.
- No silent waits: users must see that something is happening.

### 3) Empty states

An empty state must include:

- A clear explanation (what is missing)
- A primary action (what the user can do next)

No empty UI without guidance.

### 4) Errors

- Errors are shown near the source when possible (field-level for forms, inline near the failing control otherwise).
- Error text is human-readable and actionable.
- Do not expose technical error messages to users.
- Use normalized error codes to map to user-safe messages (see `KB_ERROR_HANDLING`).

### 5) Modals and overlays

- Can be closed via a close button and the Escape key (unless explicitly unsafe).
- Focus is trapped inside.
- Background interaction is blocked while open.

### 6) Navigation

- Back action is predictable.
- No dead ends: users can always proceed, go back, or cancel.
- Users can always understand where they are (clear page/section heading or equivalent).

### 7) Microcopy baseline

- Buttons use verbs (`Save`, `Continue`, `Delete`).
- Avoid vague labels (`OK`, `Submit`) unless the action is truly generic and unambiguous.
- Do not use placeholder text as instructions; use labels/help text.

---

## Guidelines (should)

- Prefer progressive disclosure: show advanced options only when needed.
- Prefer consistent feedback patterns:
  - inline messages for form validation
  - toasts for short confirmations
  - dialogs for destructive actions
- Prefer “recoverable” UX:
  - confirmations for destructive actions
  - preserve input where possible after failure

---

## Exceptions

If you must violate a “must” rule:

- Record an exception under **Exception log**.
- Include a plan to remove the exception (or to align the underlying behavior with the baseline).

### Exception log

**Date — Screen/Area — Rule violated — Reason — Plan to remove — Target date**

---

## UX Definition of Done (checklist)

- Loading, empty, and error states are handled.
- Forms follow the validation rules and show actionable messages.
- Copy follows the microcopy baseline rules.
- Behavior is consistent across screens.
- Works on mobile and keyboard.




