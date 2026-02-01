# docs-ai/agents-core-knowledge/schemas-and-outputs.md

## Agent summary

- How structured outputs are specified, validated, normalized, and versioned
- Canonical rules for agent JSON and document generation

---

## Output contract

- Every agent output has an explicit schema (Zod/JSON Schema).
- Schema is required before implementing or altering generation.
- Schema is the contract between: UI <-> orchestrator <-> storage <-> export.

---

## Validation rules

- Validate all outputs before storing, rendering, or exporting.
- On validation failure: retry -> repair/normalize -> controlled failure.
- Never weaken schemas to make validation pass.

---

## Canonical data

- Keep raw model output and normalized/validated output.
- Normalization is explicit and deterministic.
- Canonical output is the normalized/validated form only.

---

## Versioning

- Schema changes are versioned.
- Stored outputs reference the schema version used.
- Prefer backward-compatible evolution (add/optional fields).

---

## Context discipline

- Use canonical stored state as context source.
- Do not accumulate prompts implicitly between steps.
- Iterative workflows consolidate state explicitly.

---

## LLM generation package

- Treat the LLM as stateless; externalize document state in the app.
- Send: doc-state, rolling summary, minimal excerpts, and a section brief.
- Enforce a strict output schema and run validation + repair.
- Require explicit assumptions and open questions when uncertainty remains.
- Maintain separate traceability memory (full logs) and working memory (curated context).
- Do not pass full conversation history; only include what is required for the next step.

---

## Storage metadata

- Persist schema version, model identifier/config, and timestamps.
- Do not persist sensitive raw inputs unless explicitly required.

---

## Export rules

- Exports are derived from canonical validated output.
- Exports must be reproducible from stored canonical data.
- Export artifacts are stored via product flow, not committed.

---

## Change checklist

- Schema updated first (or created).
- Validators/normalizers updated.
- Storage versioning considered.
- UI rendering updated to consume canonical output.
- Smoke path: generate -> validate -> store -> render -> export (if applicable).



