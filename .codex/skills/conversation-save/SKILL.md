---
name: conversation-save
description: Save a conversation summary as a searchable artifact, and optionally link it from project insights.
---

# .codex/skills/conversation-save/SKILL.md

## Name

`$conversation-save`

## Purpose

Create a short, searchable conversation summary under `ROOT_AGENTS_ARTIFACTS/conversations/`.

## When to use

Invoke when any apply:

- user says: "save this conversation", "save this discussion", "capture this decision", "write a conversation summary"
- user confirms "Yes" when asked during `$commit-push-create-pr`

## Inputs

- Thread name (preferred; `KB_THREADS` format)
- Short slug (2-5 words)
- Optional: tags (comma-separated)
- Optional: "Also add to insights?" (Yes/No)

## Procedure

1. Determine the file name:
   - Date: today in `YYYY-MM-DD`.
   - Thread code: extract `P-###`, `F-###`, `B-###`, etc. If missing, use `misc`.
   - Slug: lowercase, hyphen-separated.
   - Summary file:
     - `ROOT_AGENTS_ARTIFACTS/conversations/YYYY-MM-DD__<thread-code>__<slug>.summary.md`
2. Write the summary using:
   - `ROOT_SKILLS/conversation-save/templates/conversation-summary.template.md`
3. Append a link entry to:
   - `ROOT_AGENTS_ARTIFACTS/conversations/index.md`
4. If the user said "Also add to insights: Yes" and the summary contains a durable decision:
   - Append a short entry to `DOC_PROJECT_INSIGHTS` and link the summary.
5. If the user explicitly asks to store a transcript, write:
   - `ROOT_AGENTS_ARTIFACTS/conversations/YYYY-MM-DD__<thread-code>__<slug>.transcript.md`
6. Never delete or edit existing files under `ROOT_AGENTS_ARTIFACTS/conversations/` unless the user explicitly asks.

## Outputs

- Summary file path
- Index updated (Yes/No)
- Insights updated (Yes/No)

## Acceptance checks

- Summary exists and is short (fits on one screen)
- Index contains a working relative link
- Insights updated only if needed (durable decision)
