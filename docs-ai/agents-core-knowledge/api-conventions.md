# docs-ai/agents-core-knowledge/api-conventions.md

---

## Resource conventions

- Use plural, noun-based resources: `/projects`, `/documents`, `/agent-runs`.
- Identify a resource by id: `/projects/{projectId}`.
- Avoid deep nesting; at most one level when it clarifies ownership: `/projects/{projectId}/documents`.

---

## Method conventions

- `GET` reads; must not mutate.
- `POST` creates or triggers non-idempotent actions.
- `PATCH` partially updates.
- `DELETE` removes.

Avoid custom verb paths when a resource works; if an action is truly non-resource-like, use a clear action subresource: `/projects/{id}/export`.

---

## Status codes (minimum set)

This section defines the canonical HTTP mapping for error codes defined in `KB_ERROR_HANDLING`.

- `200` success (read/update)
- `201` created
- `204` success with no body (optional; use consistently if used)
- `400` request invalid (`validation_failed`)
- `401` unauthenticated (`unauthenticated`)
- `403` forbidden (`forbidden`)
- `404` not found (`not_found`)
- `409` conflict (`conflict`)
- `429` rate limited (`rate_limited`)
- `502` upstream unavailable (`upstream_unavailable`)
- `504` timeout (`timeout`)
- `500` internal error (`internal_error`)

---

## Error response contract

For non-2xx responses, return this envelope.

- The `error` object follows `NormalizedError` from `KB_ERROR_HANDLING`.
- Include `requestId` when available (see `KB_ERROR_HANDLING` for correlation rules).
- Error-message safety rules and what can go into `details` live in `KB_ERROR_HANDLING`.

```json
{
  "error": {
    "code": "validation_failed",
    "message": "Invalid request.",
    "details": { "field": "name" }
  },
  "requestId": "..."
}
```

---

## Pagination (default)

If a list endpoint can grow beyond a small, bounded set, it must paginate.

Default contract:

- Request: `?limit=50&cursor=...`
- Response:
  - `data`: array of items
  - `nextCursor`: string or `null`

Avoid mixing cursor and offset pagination in the same API surface.

---

## Versioning (when needed)

If you expect external clients or long-lived stored integrations, prefer path versioning:

- `/api/v1/...`

If the API is internal-only and changes in lockstep with the UI, versioning may be omitted, but must remain consistent within that surface.

---

## Validation and contracts

Do not redefine request/response shapes ad hoc per caller.

- Use explicit request/response schemas (see `$api-endpoint-development` and `KB_SCHEMAS_OUTPUTS` for schema discipline).
- Keep changes additive where possible; breaking changes require an explicit versioning decision.

---
