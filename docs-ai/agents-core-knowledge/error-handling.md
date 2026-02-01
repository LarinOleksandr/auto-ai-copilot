# docs-ai/agents-core-knowledge/error-handling.md

## Agent summary

- Canonical error taxonomy and boundary-translation rules
- Defines what is safe to surface vs log
- Keeps error handling consistent across UI, APIs/Edge Functions, and services

---

## Goals

- **Consistency**: the same failure produces the same error `code` and UX.
- **Safety**: do not leak secrets, tokens, internal URLs, SQL, or stack traces across boundaries.
- **Debuggability**: every error is attributable (request/correlation id) and has high-signal metadata in logs.

---

## Boundary rule (core)

Errors must be translated at boundaries.

- **UI boundary**: do not render raw exceptions; render user-safe messages derived from error codes.
- **API boundary** (HTTP/Edge Functions): do not return raw exceptions; return a normalized error response.
- **Service boundary** (external APIs/LLMs/infra): wrap/translate upstream failures into a stable internal error code.

This extends the architecture rule "Translate errors at boundaries; do not leak infra errors inward" (`KB_ARCHITECTURE_PRINCIPLES`).

---

## Canonical taxonomy (error codes)

Error `code` must be stable, machine-readable, and treated as a contract.

Recommended base set (extend as needed; do not invent ad-hoc strings per endpoint):

- `validation_failed`
- `unauthenticated`
- `forbidden`
- `not_found`
- `conflict`
- `rate_limited`
- `upstream_unavailable`
- `timeout`
- `internal_error`

---

## Normalized error shape

When communicating across boundaries (UI <-> API <-> services), represent errors using a normalized shape:

```ts
type NormalizedError = {
  code: string;
  message: string; // user-safe summary
  details?: unknown; // optional, avoid sensitive payloads
  retryable?: boolean;
};
```

Rules:

- `message` must be safe to show to an end user.
- `details` is optional and should be omitted by default; include only non-sensitive, high-signal context.
- `retryable` is optional and should be derived from `code` (see below).

Transport-specific envelopes (HTTP status codes, response shape) live in `KB_API_CONVENTIONS`.

---

## Correlation ids (`requestId`)

Use `requestId` to correlate a user-visible error with server logs.

- Generate or propagate `requestId` at the API boundary.
- Include `requestId` in API error responses (see `KB_API_CONVENTIONS`).
- Log `requestId` with the normalized error at the boundary where it is produced/translated.
- UI should surface `requestId` for unknown/unexpected failures.

---

## Retryability

Recommended default mapping (override only with explicit justification):

- `retryable=true`: `timeout`, `upstream_unavailable`, `rate_limited`
- `retryable=false`: `validation_failed`, `unauthenticated`, `forbidden`, `not_found`, `conflict`, `internal_error`

---

## Logging rules (minimal but strict)

- Log **once per boundary**: log the normalized error at the boundary where it is produced/translated.
- Log metadata, not secrets: include `code`, `requestId`, boundary name, and safe upstream identifiers; never log tokens or raw personal data.
- Stack traces are server-only; avoid shipping stacks to clients.

---

## UI handling rules

- Prefer handling by `code` rather than string-matching `message`.
- User-visible message should be concise; provide a retry action when `retryable=true`.
- For unknown errors, show a generic message and surface the `requestId` (if present) for support/debugging.

---

## Non-goals

- This document does not define test requirements; see `KB_TESTING`.


