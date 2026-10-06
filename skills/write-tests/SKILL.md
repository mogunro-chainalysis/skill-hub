---
name: write-tests
description: Design and write high-signal functional tests that prove user flows and system stability without test bloat.
---

# Write Tests

Goal: tests that prove behavior and system stability under real user flows and failure conditions — not
coverage theater or test bloat. AI tends to emit dozens of low-value micro-tests that assert nothing
real; every test must earn its place.

## Choose the right level (bias to functional)

Pick the **highest level that pins the behavior AND fails for exactly one reason.** When a functional
test covers the same ground as a cluster of unit tests, write the functional test.

- **Functional** (default) — black-box: drive inputs, assert observable user flows, state transitions,
  and stability under error conditions against the requirement. Most behavior proven per test; survives
  internal refactors.
- **Unit** — one module in isolation (may need stubs/drivers). Use strictly for pure logic with many
  branches (parsers, money math, algorithms) where a functional test cannot cheaply pin the exact case.
- **Integration** — real collaborators and wiring (db, HTTP, queues). Use when the risk lives in the
  seams between modules, not the logic inside one.
- **Acceptance** — end-to-end against user/client criteria. Use sparingly, for critical user journeys.

Rule of thumb: unit proves pure algorithmic logic; functional proves a user flow or requirement is met;
integration proves modules cooperate; acceptance proves the client's journey succeeds. Prefer the
fewest, highest-level tests that prove user flows and stability. Reject fluff that merely pads test count.

## Procedure

1. **Learn the repo.** Invoke `determine-patterns` and read 2–3 existing tests **of the same behavior
   type** (e.g. an endpoint test for an endpoint) — check every test source set, not just the default one.
   Match their suite, harness, fixtures, naming, and assertion style. Never introduce a new test harness or
   suite placement without proving no existing test covers that behavior type and getting user sign-off.
   For Java/Spring/Mockito/JPA specifics, defer to `java-engineering`.
2. **List behaviors, not methods.** Enumerate user flows, observable requirements, and stability under
   error paths. Skip anything with no observable behavior.
3. **Assign a level** per the guide above — one behavior at a time, biased to functional.
4. **Write** — arrange/act/assert; assert real outcomes and stability, not implementation calls or mock
   interactions; each test fails for exactly one reason.
5. **Apply the useless-test gate** (below) to every test before finishing.
6. **Prove it works.** Confirm each test fails on broken behavior and passes on correct behavior — a
   test never seen red proves nothing.

## Useless-test gate — flag, don't delete

Flag a test (with rationale) — never delete it without explicit human OK, per the standing "never delete
tests without direction" rule — when it:

- Is test fluff or bloat — trivial tests created just to inflate test counts, tests asserting language or
  framework defaults, or mock-verification checks that test no real behavioral outcome.
- Asserts on mocks/stubs instead of real behavior (mock-everything tests that only verify the mock).
- Exercises the framework, library, generated code, or trivial getters/setters.
- Restates the implementation, so it breaks on every refactor and catches no bug (change-detector).
- Is tautological — asserts a constant, `assertTrue(true)`, or has no meaningful assertion.
- Snapshots large blobs no one reviews or intentionally updates.
- Duplicates coverage already pinned by a functional flow test.

When auditing an existing suite, report flagged tests grouped by reason (`file:line`, reason, suggested
action) and require explicit confirmation before removing any.

## Output

- Lean, high-signal tests matching repo conventions, each pinning a user flow or stability property.
- For audits: a list of flagged tests with reasons and suggested actions — no deletions without sign-off.
