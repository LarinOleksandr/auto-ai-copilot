---
name: documents-export
description: Export validated agent outputs into user-facing documents (PDF, DOCX, JSON, MD) in a reproducible and safe way.
---

# .codex/skills/documents-export/SKILL.md

## Name

`$documents-export`

## Purpose

Export validated agent outputs into user-facing documents (PDF, DOCX, JSON, MD) in a reproducible and safe way.

## When to use

Invoke when any apply:

- introducing a new export format
- changing document structure or layout
- modifying export logic or templates
- adding download/bundle functionality

## Inputs

- Source schema/version (canonical output)
- Export format(s): PDF / DOCX / JSON / MD
- Template or layout reference (if applicable)
- Metadata to include (title, version, timestamps)

## Procedure

1. Confirm source of truth
   - use only canonical validated output
   - never export from raw model output
2. Define export contract
   - mapping from schema -> document structure
   - deterministic field ordering and formatting
3. Implement export logic
   - pure transformation from canonical data
   - no business logic or side effects
4. Metadata and reproducibility
   - include schema version and timestamps
   - ensure export can be regenerated identically
5. Storage and delivery
   - store via product storage flow
   - do not commit exported artifacts
6. Error handling
   - explicit failures on missing/invalid data
   - no partial or silently degraded exports
7. Tests
   - export succeeds for valid canonical input
   - export fails for invalid/missing data
   - format-specific smoke check (open/read file)

## Acceptance checks

- Export uses only validated canonical output
- Document structure matches schema mapping
- Exports are reproducible
- No artifacts committed to repo
- Errors are explicit and user-safe
- Tests cover success + failure paths

