# docs-ai/agents-artifacts/readme.md

This folder stores agent-generated artifacts.

## Structure

- `plans/` contains planning files created by `$plan-creation`
- `architectural-reviews/` contains architecture review artifacts from `$architecture-review`
- `design-reviews/` contains design review artifacts from `$design-review`
- `prds/` contains PRDs created by `$brainstorming`
- `research-briefs/` contains research briefs created by `$feature-research`
- `screenshots/` stores UI validation screenshots (not committed; README only)
- `traces/` stores Playwright traces (not committed; README only)
- `videos/` stores Playwright videos (not committed; README only)
- `playwright-report/` stores generated Playwright reports (not committed; README only)
- `conversations/` contains conversation summaries created by `$conversation-save`

## Rules

- One artifact per task.
- Use standardized names:
  - plans: `<task-slug>.plan.md`
  - architectural reviews: `<task-slug>.arch-review.md`
  - design reviews: `<task-slug>.design-review.md`
  - prds: `YYYY-MM-DD-<topic>-prd.md`
  - research briefs: `<task-slug>.research.md`
  - conversation summaries: `YYYY-MM-DD__<thread-code>__<slug>.summary.md`
- Do not delete or overwrite old artifacts.




