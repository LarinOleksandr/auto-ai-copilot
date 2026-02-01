# frontend/AGENTS.md

## Scope

Applies to `frontend/**`.

---

## Local rules (extend root)

- React + TypeScript strict; no implicit `any` or unsafe casts.
- Use functional React components + hooks; avoid class components.
- Keep components small and focused; prefer composition over large multipurpose components.
- Keep business logic out of UI components; place it in hooks, services, and shared modules.
- Routing maps wizard steps to URLs (React Router).
- Server/async state via TanStack Query only.
- Validate user input and agent outputs with Zod before render.
- Prefer shadcn/ui + Tailwind; avoid parallel UI systems.
- UI baseline invariants + guidelines: consult `KB_UI_BASELINE`.
- UX baseline invariants + guidelines: consult `KB_UX_BASELINE`.
- Application design preset (shadcn):
  - Preset source of truth: `frontend/web/config/app-design-preset.json`.
  - Apply/update preset via: `frontend/web/scripts/app-design-init.ps1`.
  - Plans that create or modify `frontend/web` must include an early step: "Initialize design system (preset)", executed by the agent via `$frontend-design`.
- Mobile-first responsive design by default; use Tailwind breakpoints to progressively enhance for larger screens.
- Rich text editing via TipTap; workflow/agent graphs via React Flow.
- Reuse shared contracts:
  - Core entity types from `shared/types/`
  - Schemas from `shared/validation/` when applicable

---

## Testing

- Update tests for behavior changes.
- For flow changes, include at least one UI-level smoke path when available.
- For any UI-related task, do not consider the task complete until `$testing-in-browser` is run and screenshots are captured (see `KB_UI_TESTING_PLAYWRIGHT`), unless the user explicitly asks to skip UI validation.



