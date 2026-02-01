---
name: new-agent-development
description: Add or modify an orchestrator agent/node/workflow with schema-first outputs, explicit state, and test coverage.
---

# .codex/skills/new-agent-development/SKILL.md

## Name

`$new-agent-development`

## Purpose

Add or modify an orchestrator agent/node/workflow with schema-first outputs, explicit state, and test coverage.

## When to use

Invoke when any apply:

- new agent, node, or LangGraph workflow
- prompt changes that affect output structure/meaning
- schema/contract changes for agent outputs
- new tool integration inside orchestrator

## Inputs

- Agent/node name + responsibility (one sentence)
- Expected inputs (source + shape)
- Expected outputs (schema name/version)
- Failure modes (LLM invalid output, dependency down, timeout)

## Procedure

1. Define contract first
   - create/extend schema (Zod/JSON Schema) for output
   - define minimal input contract
2. Place code at correct boundary
   - workflow wiring in graph layer
   - node logic isolated and side-effect free
   - adapters used for external calls
3. Implement prompt and context rules
   - prompt version-controlled and colocated
   - context minimal and derived from canonical state
4. Implement validation and normalization
   - validate LLM output before any use
   - keep raw output + normalized/validated output
   - on failure: retry -> repair/normalize -> controlled failure
5. Persist or emit outputs explicitly
   - persistence is explicit, not implicit side effect
   - stored outputs include schema version + metadata
6. Observability
   - log workflow start/end, node failures, validation errors (no PII/secrets)
7. Tests
   - workflow test (happy path)
   - schema failure test
   - dependency failure test
   - smoke path: trigger -> run -> validated output

## Acceptance checks

- Node has explicit input/output schemas
- Output validates; invalid outputs handled without schema weakening
- Raw + normalized outputs preserved
- Persistence is explicit
- Prompt and workflow changes versioned together
- Tests cover happy + schema-fail + dependency-fail

