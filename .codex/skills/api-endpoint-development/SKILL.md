---
name: api-endpoint-development
description: Add or modify an API / Edge Function endpoint with explicit contracts, validation, and safe integration.
---

# .codex/skills/api-endpoint-development/SKILL.md

## Name

`$api-endpoint-development`

## Purpose

Add or modify an API / Edge Function endpoint with explicit contracts, validation, and safe integration.

## When to use

Invoke when any apply:

- new API endpoint or Edge Function
- change to request/response shape
- new integration point for UI or orchestrator
- authorization or access-rule changes

## Inputs

- Endpoint name + responsibility (one sentence)
- Caller(s): UI / orchestrator / external
- Request schema
- Response schema
- Auth/RLS expectations

## Procedure

1. Define contracts first
   - request schema (input validation)
   - response schema (output contract)
2. Place logic correctly
   - endpoint acts as adapter only
   - no business/domain rules
3. Implement validation
   - validate request at boundary
   - validate response before return
4. Authorization and access
   - enforce auth checks explicitly
   - follow `KB_SUPABASE` for RLS rules
5. Conventions
   - follow `KB_API_CONVENTIONS` for REST shape, pagination, and error responses
6. Integration
   - wire callers explicitly (UI/orchestrator)
   - no implicit coupling
7. Tests
   - request validation failure
   - auth/authorization failure
   - happy path
   - RLS allow/deny (if DB involved)

## Acceptance checks

- Request and response schemas defined and enforced
- Endpoint contains no domain logic
- Authorization and RLS verified
- Errors are explicit and typed
- API conventions followed (REST + pagination + error shape)
- Callers updated to use canonical contract
- Tests cover happy + failure paths
