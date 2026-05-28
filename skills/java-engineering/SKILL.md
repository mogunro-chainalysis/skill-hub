---
name: java-engineering
description: Java/Spring Boot engineering principles.
---

# Java Engineering

These rules encode hard-won lessons from real Java services. Apply them while writing or planning — not as a checklist after the fact. Each rule has a one-line principle; a snippet appears only where the principle is otherwise opaque.

For PR-time scanning, use `check-java-quality` instead. For repo-specific patterns (which logger, which builder library, which test fixtures), defer to `determine-patterns`. For domain terms, defer to `build-domain-context`.

---

## 1. Mockito discipline

**1a. Default `thenAnswer` stubs in shared base test classes MUST guard null arguments.**
Mockito invokes the stubbed method with `null` matchers during the recording of a *later* `when(...)` call. If the lambda dereferences arguments without a guard, every test that overrides the stub crashes with NPE inside Mockito internals — a debug nightmare.

```java
when(externalApi.fetch(any(), any())).thenAnswer(inv -> {
  List<Item> items = inv.getArgument(0);
  if (items == null) return Flux.empty();   // guard for Mockito's internal recording
  return Flux.fromIterable(items.stream().map(this::asResponse).toList());
});
```

**1b. `@Spy`, not a plain field, is required for `@InjectMocks` to populate concrete dependencies.** Mockito only auto-injects fields annotated `@Mock` or `@Spy`. A bare `private final SimpleMeterRegistry meterRegistry = new SimpleMeterRegistry();` will be ignored by `@InjectMocks` and the production code will receive `null`.

**1c. Later `when(...).thenReturn(...)` with the same matcher set wins** over an earlier `thenAnswer`. Use this deliberately when overriding a permissive `BaseIntegrationTest` default in a single test.

**1d. Argument matchers are positional and all-or-nothing.** Mixing raw values with `any()` in the same call throws. Use `eq(value)` for the literal positions.

---

## 2. Reactor pitfalls

**2a. Never call `.block()` on a Reactor event-loop thread.** It deadlocks or stalls. If a service exposes a sync convenience method that blocks, document the constraint at the public surface so callers from reactive contexts use the reactive variant instead.

```java
/**
 * Processes items synchronously. <b>Threading:</b> blocks the caller's thread on
 * {@code .block()}. Do not call from a Reactor event-loop thread — use
 * {@link #processItemsReactive(Collection)} from reactive code paths.
 */
public Map<Input, Output> processItems(Collection<Input> inputs) { ... }
```

**2b. When a unit is reusable, expose the reactive variant alongside any sync convenience.** Don't force every caller to choose between blocking or duplicating your logic.

**2c. `RateLimiterOperator` placement matters.** `transformDeferred(RateLimiterOperator.of(rateLimiter))` belongs on the publisher returned by the upstream API call, not on the outermost composed pipeline — otherwise rate limits apply to the wrong granularity.

---

## 3. Resilience4j and cache integration

**3a. Cache only authoritative success, never transient failures.** A common bug: a service falls back to "identity" or a placeholder on remote-call failure, and that fallback is then cached for hours or days. The next outage can keep the cache poisoned long after the upstream recovers. Populate the in-memory result map on failure if you need fallback behavior, but skip the persistent cache write on the failure path.

**3b. Reuse existing rate limiters; don't introduce parallel ones.** Two services that both call the same external API should share a single rate-limiter budget. Splitting them appears safer but lets one service starve the other when traffic spikes, with no central place to tune.

**3c. Cache key separators must be unambiguous.** `category + ":" + id` collides if any ID ever contains `:`. Use a separator that cannot appear in either component (`|` is conventional) or namespace explicitly: `domain-entity:<category>:<id>`.

---

## 4. Micrometer observability

**4a. Tag cardinality must be bounded.** Names, status codes, and enum values are fine. Raw user IDs, request IDs, and free-text are not — they explode the metric backend.

**4b. Counter granularity must match across paired counters.** If a dashboard divides `errors / (success + errors)`, both counters must increment at the same level (per-call, or per-batch — not mixed). A `cache_hit` counter that fires per-input and a `cache_miss` counter that fires per-unique-key produces nonsense rate calculations.

**4c. `log.warn` for transient external failures, not `log.info`.** On-call engineers scan for `WARN+`. A timeout against a third-party API logged at `INFO` is invisible during incident response.

---

## 5. API contracts

**5a. Fail loud at the boundary; don't silently drop bad inputs.** A `null` element in a `List<T>` parameter is almost always a bug at the call site — surface it.

```java
Objects.requireNonNull(input, "processItems: null input not allowed at index " + i);
```

**5b. Use `Optional<T>` to distinguish "unknown" from "identity" or "empty".** A method that returns `T` for both "found the real answer" and "fell back to the input" forces every caller to know the contract by hearsay. `Optional<T>` makes the distinction explicit and grep-able.

**5c. Return immutable views from public methods.** `Map.copyOf(...)`, `List.copyOf(...)`. Callers cannot accidentally mutate internal state, and your method's contract becomes a guarantee.

**5d. Eliminate redundant parameters that are unenforced contracts.** If a method takes both `category` and `Item` (which already contains a category), the two can drift, and the compiler will not catch it. Take only what is needed; derive the rest.

**5e. Constructor injection over field injection.** `@RequiredArgsConstructor` on the class plus `private final` on each dependency keeps wiring testable and explicit. Avoid `@Autowired` on fields.

---

## 6. JPA test data discipline

**6a. When a query JOINs, the test must seed both sides of the join.** A `getCountsByCategory` query that joins `items` to `category_mappings` returns zero if no mapping rows exist, even when the items do — silently. Tests that save only the main entity will pass on the empty path and fail on the populated path with an opaque count of `0`.

**6b. `@DataJpaTest` rolls back per test by default.** Don't rely on inter-test data accidentally surviving; if you need shared fixtures, set them up explicitly per test or use `@Sql`.

**6c. Prefer JPA Specifications or Criteria for dynamic where-clauses.** Concatenated JPQL strings are a SQL-injection waiting room and resist refactoring.

---

## 7. Spring Boot integration testing

**7a. Place shared mocks in a `BaseIntegrationTest` with `@MockitoBean` and `@BeforeEach` defaults.** Each subclass inherits a "service available, identity transformation" baseline so individual tests only override what's specific to them.

**7b. Defaults should be permissive (succeed by default).** A default mock that returns errors forces every test to override the mock for the happy path. A default mock that returns success forces only failure-path tests to override — fewer overrides, less noise.

**7c. Reset all mutable test state in `@AfterEach`.** Database (truncate or rollback), cache (Redis flush), and any in-memory singletons. Tests that pass in isolation but fail in a suite are almost always missing a reset.

**7d. Per-test `when(...).thenReturn(...)` overrides the base default** when matchers match. Lean on this rather than building elaborate test-side mock factories.

---

## When in doubt

- For repo-specific conventions (which logger framework, which builder, which test util library), invoke `determine-patterns` rather than guessing.
- For domain terms (custom entities, identifiers), check or update `.ai/domain-glossary.md` via `build-domain-context`.
- Do not add features, error handling, or abstractions beyond what the task asks for. YAGNI applies.
