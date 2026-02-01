# frontend/web

This folder is the web application runtime boundary.

Design system:

- Preset configuration: `frontend/web/config/app-design-preset.json`
- Apply/update preset (agent-driven): `frontend/web/scripts/app-design-init.ps1`

## Switching the design later

At any time, you can switch the design preset:

1. Create a new preset at `https://ui.shadcn.com/create`
2. Provide the generated `https://ui.shadcn.com/init?...` URL to the agent when prompted by `$frontend-design`
3. The agent updates `frontend/web/config/app-design-preset.json` and applies it




