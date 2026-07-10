---
name: write-tests
description: Design and write useful, maintainable tests that prove behavior — biased toward functional tests. Use for "write tests", "add tests", "test this", or auditing a suite for useless tests.
---

# Write Tests

Goal: tests that prove behavior and survive refactors — not coverage theater. AI tends to emit many tests that assert nothing real; every test here must earn its place.

## Choose the right level (bias to functional)

Pick the **highest level that pins the behavior AND fails for exactly one reason.** When a functional test covers the same ground as a cluster of unit tests, write the functional test.

- **Functional** (default) — black-box: drive inputs, assert observable outputs/effects against the requirement. Most behavior proven per test; survives internal refactors.
- **Unit** — one module in isolation (may need stubs/drivers). Use for pure logic with many branches (parsers, money math, algorithms) where a functional test can't cheaply pin the exact case.
- **Integration** — real collaborators and wiring (db, HTTP, queues). Use when the risk lives in the seams between modules, not the logic inside one.
- **Acceptance** — end-to-end against user/client criteria. Use sparingly, for critical user journeys.

Rule of thumb: unit proves a unit is correct; functional proves a requirement is met; integration proves modules cooperate; acceptance proves the client's need is satisfied. Prefer the fewest, highest-level tests that still fail for one clear reason.

## Procedure

1. **Learn the repo.** Invoke `determine-patterns` and read 2–3 existing test files to match framework, fixtures, naming, and assertion style. For Java/Spring/Mockito/JPA specifics, defer to `java-engineering`.
2. **List behaviors, not methods.** Enumerate the user-visible behaviors and requirements to cover, including error and edge paths. Skip anything with no observable behavior.
3. **Assign a level** per the guide above — one behavior at a time, biased to functional.
4. **Write** — arrange/act/assert; assert outcomes, not implementation calls; each test fails for exactly one reason.
5. **Apply the useless-test gate** (below) to every test before finishing.
6. **Prove it works.** Confirm each test fails on broken behavior and passes on correct behavior — a test never seen red proves nothing.

## Useless-test gate — flag, don't delete

Flag a test (with rationale) — never delete it without explicit human OK, per the standing "never delete tests without direction" rule — when it:

- Asserts on mocks/stubs instead of real behavior (mock-everything tests that only verify the mock).
- Exercises the framework, library, generated code, or trivial getters/setters.
- Restates the implementation, so it breaks on every refactor and catches no bug (change-detector).
- Is tautological — asserts a constant, `assertTrue(true)`, or has no meaningful assertion.
- Snapshots large blobs no one reviews or intentionally updates.
- Duplicates coverage already pinned by a higher-level test.

When auditing an existing suite, report flagged tests grouped by reason (`file:line`, reason, suggested action) and require explicit confirmation before removing any.

## Output

- New/updated tests matching repo conventions, each pinning one behavior at the right level.
- For audits: a list of flagged tests with reasons and suggested actions — no deletions without sign-off.
