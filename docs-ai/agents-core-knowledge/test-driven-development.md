# docs-ai/agents-core-knowledge/test-driven-development.md

## Agent summary

- Explains test-driven development (test-first) in simple steps.
- Helps avoid false-confidence tests (tests that pass but prove nothing).
- Complements `KB_TESTING` (this is a deeper "how to do it" guide).

---

## What "test-driven development" means

Test-driven development means:

1. Write a small test for one behavior.
2. Run it and **watch it fail** for the right reason.
3. Change the code with the smallest fix.
4. Run tests again and watch them pass.
5. Clean up (refactor) while keeping tests green.

If you never saw the test fail, you do not know if the test is real.

---

## When to use it

Use it for:

- New features (new behavior)
- Bug fixes
- Refactoring (when behavior must stay the same)
- Any behavior change

---

## When it may not fit (exceptions)

Test-first may be a poor fit for:

- UI styling/layout-only changes
- Configuration-only changes
- Throwaway exploration (you plan to delete it)

If you skip test-first, say why, and still run the most relevant checks you have.

---

## The loop (Red -> Green -> Refactor)

### 1) RED: write one failing test

Write the smallest test that shows what should happen.

Rules:

- One behavior per test.
- Name the test clearly (no vague names like "works").
- Prefer real behavior over mocks (fake objects).

### 2) Verify RED: run the test and watch it fail

This is required.

Confirm:

- The test fails (not a crash from a typo).
- The failure message makes sense.
- It fails because the behavior is missing or wrong.

If the test passes immediately, the test is not proving the new change.

### 3) GREEN: implement the smallest change to pass

Rules:

- Fix the behavior the test asks for.
- Do not add extra features "while you're here".
- Keep the change small and safe.

### 4) Verify GREEN: run tests and watch them pass

Confirm:

- The new test passes.
- Other relevant tests still pass.

### 5) REFACTOR: clean up with tests staying green

After everything is green:

- Remove duplication.
- Improve names.
- Extract helpers.

Keep running tests while refactoring.

---

## Testing anti-patterns to avoid

These are common ways to get "green tests" that do not prove anything.

### 1) Testing mock behavior

Bad sign: the test mainly checks that a mock was called or rendered.

Better: test the real behavior the user cares about.

Quick question:
"Am I testing the product behavior, or the fake I created?"

### 2) Adding test-only methods to production code

Do not add a production method only to make tests easier.

If it is test-only, put it in test helpers (test utilities), not in production code.

### 3) Mocking without understanding what you are mocking

Do not "mock to be safe".

First, understand what the real code does and what side effects it has.
Then mock only the slow or external part you truly need to isolate.

### 4) Incomplete mocks (partial fake data)

If you mock a response or object, make it match the real shape.

Partial mocks often pass unit tests but fail in real integration.

---

## Quick checklist (before calling work "done")

- [ ] A test exists for each new/changed behavior.
- [ ] The test failed first for the expected reason.
- [ ] The smallest fix was made to pass the test.
- [ ] Tests are green after refactor.
- [ ] Mocks are minimal and only where unavoidable.

---

## Related routes

- `KB_TESTING` (test levels, required coverage, "definition of done")
- `KB_REPOSITORY_RULES` (do not add new dependencies without approval)
