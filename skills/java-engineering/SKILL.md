---
name: java-engineering
description: Java/Spring lessons (Mockito, Reactor, caching, Micrometer, JPA tests). Use when writing or planning Java services or tests.
---

# Java Engineering

Hard-won lessons from real Java services. Apply them while writing or planning. For PR-time scanning use `check-java-quality`; for repo-specific conventions (logger, builders, fixtures) use `determine-patterns`; for domain terms use `build-domain-context`.

See references/examples.md for code samples.

## Procedure

1. **Mockito tests**
   - Null-guard argument access in default `thenAnswer` stubs in shared base test classes — Mockito calls them with `null` while recording a later `when(...)`, causing NPEs inside Mockito internals.
   - Annotate concrete collaborators (e.g. `SimpleMeterRegistry`) with `@Spy`; `@InjectMocks` only injects `@Mock`/`@Spy` fields, so a plain initialized field leaves production code with `null`.
   - Override a permissive base `thenAnswer` with a later `when(...).thenReturn(...)` using the same matchers — the later stub wins.
   - Use `eq(value)` for literal positions whenever any argument uses a matcher.

2. **Reactor**
   - Keep `.block()` off Reactor event-loop threads. When a sync convenience method blocks, document the threading constraint in its Javadoc and point to the reactive variant.
   - Expose the reactive variant alongside any sync convenience on reusable units.
   - Apply `transformDeferred(RateLimiterOperator.of(...))` to the publisher returned by the upstream API call, not the outermost composed pipeline.

3. **Resilience4j and caching**
   - Persist only authoritative successes to the cache. On fallback paths (identity/placeholder after a remote failure), populate the in-memory result but skip the persistent write — otherwise the cache stays poisoned long after upstream recovers.
   - Reuse the existing rate limiter for an external API; parallel limiters let one service starve another with no central tuning point.
   - Build cache keys with a separator that cannot occur in components (`|`) or an explicit namespace (`domain-entity:<category>:<id>`); `a + ":" + b` collides when IDs contain `:`.

4. **Micrometer**
   - Keep tag cardinality bounded: enum values, status codes, names. Never raw user/request IDs or free text.
   - Increment paired counters (hit/miss, success/error) at the same granularity — both per-call or both per-batch — or ratio dashboards become meaningless.
   - Log levels for transient failures: see `check-java-quality` #6.

5. **API contracts**
   - Fail loud at the boundary: reject `null` elements in collection parameters with `Objects.requireNonNull` and an indexed message.
   - Return `Optional<T>` when a method must distinguish "unknown" from "fell back to input/identity".
   - Drop derivable parameters: see `check-java-quality` #8.

6. **JPA test data**
   - Seed both sides of every JOIN the query under test performs. A join query returns `0` silently when mapping rows are missing, so tests pass on the empty path and fail opaquely on the populated one.

7. **Spring Boot integration tests**
   - Put shared mocks in a `BaseIntegrationTest` using `@MockitoBean` with `@BeforeEach` defaults.
   - Make defaults permissive (succeed, identity transform) so only failure-path tests override them.
   - Reset all mutable state in `@AfterEach`: database, cache (e.g. Redis flush), in-memory singletons. Suite-only failures usually mean a missing reset.
   - Override base defaults per test with `when(...).thenReturn(...)` rather than building test-side mock factories.
