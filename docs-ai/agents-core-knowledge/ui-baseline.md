# UI Baseline (framework-level)

## Agent summary

- Defines non-negotiable UI rules and practical guidelines for any `frontend/**` work.
- Framework-level only: **no hardcoded token values** (no brand colors, no spacing numbers, no app-specific typography rules).
- Product-specific tokens live in the actual frontend codebase (Tailwind theme + CSS variables) once `frontend/<app>` exists.
- Default UI system: **shadcn/ui + Tailwind** (baseline in `KB_TECH_STACK`; confirm in `DOC_PROJECT_CONTEXT` and `frontend/AGENTS.md`).

---

## Purpose

This document defines how UI is built in this repo.
If something is forbidden here, it is forbidden in `frontend/**` code unless an explicit exception is recorded.

---

## Scope

This document governs:

- What we build UI *from* (approved building blocks)
- What styling approaches are allowed vs forbidden
- Baseline expectations for layout/responsiveness and consistency

This document does not govern:

- Brand identity and concrete token values
- App-specific page layouts, flows, and copy (those belong in product docs and feature briefs)

---

## Source of truth (priority)

1. Implemented components (the code; Storybook/docs site if present)
2. Theme tokens (Tailwind theme + CSS variables)
3. Design references (Figma / screenshots) as supporting material

---

## Allowed building blocks

- shadcn/ui components
- Project UI components built on top of shadcn/ui
- Tailwind utility classes, **but only when they resolve to the theme/tokens**

---

## Non-negotiables (must)

### 1) Single UI system

- Use shadcn/ui as the default base component set.
- Do not introduce a parallel component library or styling system.

### 2) Token-driven styling (no one-off values)

- Do not hardcode arbitrary colors, spacing, typography, radius, or shadow values in components.
- If a value does not exist, add/extend tokens first, then use it.

### 3) No arbitrary Tailwind values

Forbidden examples:

- `p-[13px]`
- `text-[#111]`
- `rounded-[7px]`
- `shadow-[...]`

### 4) Component boundaries stay clean

- â€œBase UI primitivesâ€ (Button, Input, Dialog, etc.) are centralized and reused.
- App/page-specific components compose primitives; they do not redefine primitives.

### 5) Accessible by default

- Interactive elements must have visible focus styles.
- Forms must show clear inline validation feedback close to the input.

### 6) Mobile-first responsiveness

- Design and implement for small screens first, then enhance with breakpoints.

### 7) Icon consistency

- Prefer a single icon set across the UI.
- Use only predefined icon sizes and stroke widths (from the theme/utility scale); do not mix arbitrary-looking icon weights/sizes within the same surface.

---

## Theme usage rules (must)

- Colors: use semantic tokens (e.g. â€œforegroundâ€, â€œmutedâ€, â€œdestructiveâ€), not raw color literals.
- Spacing / typography / radius / shadows: use predefined scales only.
- If a value is missing: add it to tokens first (Tailwind theme / CSS variables), then use it.

---

## Component contract (React) (must)

For reusable UI components (especially primitives):

- Accept `className`
- Support composition (avoid hard assumptions about layout/containers)
- Use variants for visual differences (size, tone, state)
- Be reusable in more than one context

---

## Required component states (must)

Every interactive component must support:

- default
- hover
- focus
- disabled

If applicable, also define:

- error/invalid
- loading
- empty

---

## Forbidden patterns (must not)

- Inline styles for visual styling (e.g. `style={{ ... }}`)
- One-off visual hacks to â€œmake it look rightâ€ without adding/using tokens
- Copy-pasted variants (if itâ€™s a variant, it must be expressed as a real variant)

---

## Guidelines (should)

- Prefer composition over duplication: build app UI by combining primitives rather than copying markup/styles.
- Prefer consistent density: keep spacing and type rhythm uniform across screens.
- Prefer predictable patterns:
  - dialogs for confirmation and blocking decisions
  - sheets/drawers for secondary workflows on mobile
  - toasts for transient feedback

---

## Component organization (recommended)

When `frontend/<app>` exists, keep a clear distinction:

- `components/ui/*`: reusable primitives (shadcn-based, token-driven, low business meaning)
- `components/*`: composed components with product meaning (forms, panels, sections)

---

## Exceptions

If you must violate a â€œmustâ€ rule:

- Record an exception under **Exception log**.
- Include a plan to remove the exception (or upstream it into tokens/components).

### Exception log

**Date â€” Component/Area â€” Rule violated â€” Reason â€” Plan to remove â€” Target date**

---

## UI Definition of Done (checklist)

- Uses existing components or adds a justified new one.
- Uses tokens/theme values only (no arbitrary values).
- Supports required states.
- Does not introduce visual inconsistency.
- Icons follow consistent size and stroke rules.
- Has clear loading/empty/error states (see `KB_UX_BASELINE` + `KB_ERROR_HANDLING`).
- Works on mobile and keyboard.




