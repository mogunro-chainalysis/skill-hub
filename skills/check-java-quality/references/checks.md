# check-java-quality — Check Details

Expanded rationale, grep hints, and examples for each check in `SKILL.md`.

## 1. Sonar S135 — multiple `break` / `continue` in one loop

A loop with more than one `break` or `continue` is hard to follow. Refactor by extracting the loop body into a method that uses early returns, or restructure with a stream / `Optional.flatMap`.

Bad:

```java
for (Item item : items) {
  if (item == null) continue;
  if (item.isHidden()) continue;
  if (item.isExpired()) break;
  process(item);
}
```

Good: extract a guard helper or filter the stream upstream.

## 2. Sonar S1845 — method name clashes with a field

A method named `status()` in a class with a constant `STATUS` (or a Lombok-generated `getStatus`) is ambiguous. Rename to disambiguate (`statusTag(...)`, `currentStatus()`).

Grep hint: `public .* (\w+)\s*\(` and cross-check against same-named fields (case-insensitive) in the same class.

## 3. Fully-qualified type names instead of imports

Bad:

```java
List<com.example.api.EntityA> chunk = invocation.getArgument(0);
com.example.api.EntityA normalized = com.example.api.EntityA.of(...);
```

Good: add `import com.example.api.EntityA;` once and use `EntityA`. Keep the FQN only for a real name collision in the file.

## 4. Unused Mockito matchers and stubs

- Wildcard `import static org.mockito.ArgumentMatchers.*;` where only some matchers are used, or an explicit `import static ...anySet;` never referenced.
- `when(...)` stubs never invoked by any test in the file. Strict stubs usually catch these, but `Mockito.lenient()` silences the warning.

## 5. Multi-purpose helpers with single-purpose Javadoc

Read each new/modified `private` helper. If the body does N distinct things (e.g., dedup AND emit metrics AND build a result map) but the Javadoc mentions one, the helper is misnamed or the doc is stale. Split the method or rewrite the doc. High-leverage: catches misleading abstractions before they propagate.

## 6. `log.info` for transient external-system failures

Grep `log.info(` lines containing "timeout", "failed", "error", "could not", "retry", "fallback", "unavailable".

- Transient upstream failures → `log.warn` (on-call dashboards scan WARN+).
- Unrecoverable, action-required → `log.error`.
- `log.info` is invisible during incident response.

## 7. Orphaned config after a constant rename

When a `public static final String FOO = "fooName";` is renamed or its value changes, grep the whole repo for the OLD value in:

- `application.yml` / `application.properties` and profile variants
- Other Java files, especially `*Test.java` that build their own registries/configs
- `Dockerfile` / `docker-compose.yml`
- Helm / k8s manifests under `charts/`, `deploy/`, `k8s/`

A renamed rate-limiter, feature flag, cache name, or queue name with stale references silently breaks in one environment while passing in another.

## 8. Unenforced parameter contracts

A method taking both a derivable value AND its source (e.g., `category` and `Item` where `Item.getCategory()` returns the same thing).

Bad: `void recordResolved(Category cat, Item requestItem, ...)` — callers can pass mismatched values; the compiler can't catch it.
Good: derive `category` from `requestItem` inside the method, or wrap the pair in a value type that enforces consistency at construction.

## 9. Behavioral changes buried in unrelated PRs

Flag any of these inside a PR whose stated purpose is something else — they belong in their own commit or at least the PR description:

- Rate-limiter name swaps (often a significant capacity change)
- Cache TTL changes
- Log level changes (`error` ↔ `warn` ↔ `info`)
- Default-value changes in `application.yml`
- `@Transactional` propagation mode changes
- Adding/removing `@Async` / `@Cacheable` / `@RateLimiter`

## 10. Sonar S5122 — bare `@CrossOrigin` on a new controller

Bare `@CrossOrigin` allows every origin (security hotspot). First check for central CORS config: a `CorsConfigurationSource` bean, `WebMvcConfigurer.addCorsMappings`, or `http.cors(...)`. If present, omit the annotation; otherwise restrict with explicit `origins`. Don't copy a bare `@CrossOrigin` from sibling controllers.

## 11. Sonar S1123 / S6355 — incomplete deprecation

Bad: bare `@Deprecated`.
Good:

```java
/** @deprecated Use {@link NewApi#method} instead. */
@Deprecated(since = "2.3", forRemoval = true)
```

`@deprecated` Javadoc must name the replacement; set `forRemoval = true` (and/or `since`) when removal is planned.
