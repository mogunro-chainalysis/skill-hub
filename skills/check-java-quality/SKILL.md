---
name: check-java-quality
description: Scan Java diffs for quality issues.
---

## Scope

Scan: $ARGUMENTS (default: changed `.java` files from `git diff --name-only main...HEAD`)

Check for the following Java-specific issues. Use Read and Grep. Report file path, line number, current code, and the recommended fix. Generic issues (commented-out code, TODOs, unused imports of non-Mockito kind, console statements) belong in `check-code-cleanup` — do not flag them here.

---

### 1. Sonar S135 — multiple `break` / `continue` in one loop

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

---

### 2. Sonar S1845 — method name shadows or clashes with a field

A method named `status()` in a class with a constant `STATUS` (or a Lombok-generated `getStatus`) is ambiguous to readers. Rename the method to disambiguate (`statusTag(...)`, `currentStatus()`).

Pattern: grep for `public .* (\w+)\s*\(` and cross-check against fields with the same name (case-insensitive) in the same class.

---

### 3. Fully-qualified type names instead of imports

Pattern: a fully-qualified class name (`com.example.foo.Bar`) used inline in code where no name collision exists in the file's import list.

Bad:

```java
List<com.example.api.EntityA> chunk = invocation.getArgument(0);
com.example.api.EntityA normalized = com.example.api.EntityA.of(...);
```

Good: add `import com.example.api.EntityA;` once and use `EntityA` in the body. Only keep the FQN when there is a real name collision in the file.

---

### 4. Unused Mockito argument matchers and stubs

Pattern: `import static org.mockito.ArgumentMatchers.*;` style import where only some matchers are used, OR an explicit `import static ...anySet;` (or similar) that is never referenced in the file.

Also flag `when(...)` stubs that are never invoked by any test in the file (Mockito strictness usually catches these, but `Mockito.lenient()` suppresses the warning silently).

---

### 5. Helper methods doing more than one thing whose Javadoc covers only one

Read each new or modified `private` helper. If the body does N distinct things (e.g., dedup AND emit metrics AND build a result map) but the Javadoc only mentions one, the helper is misnamed or the doc is stale. Either split the method or rewrite the doc to match the body.

This is a high-leverage Java code-review finding — it catches misleading abstractions before they propagate.

---

### 6. `log.info` for transient external-system failures

Pattern: `log.info(...)` lines that include words like "timeout", "failed", "error", "could not", "retry", "fallback", "unavailable".

Transient failures of upstream services should be `log.warn` so the on-call dashboard catches them. `log.error` is for unrecoverable, action-required failures. `log.info` is invisible during incident response.

---

### 7. Orphaned config after a constant rename

When a `public static final String FOO = "fooName";` is renamed (or its value changes), grep the entire repo for the OLD value in:

- `application.yml` / `application.properties` and any profile variants
- Other Java files (especially `*Test.java` that construct their own registries / configs)
- `Dockerfile` / `docker-compose.yml`
- Helm / k8s manifests under `charts/`, `deploy/`, `k8s/`

A renamed rate-limiter, feature flag, cache name, or queue name with stale references in YAML or test setup will silently break in one environment while passing in another.

---

### 8. Unenforced parameter contracts

Pattern: a method that takes both a derivable value AND its source (e.g., `category` *and* `Item` where `Item.getCategory()` returns the same thing).

Bad: `void recordResolved(Category cat, Item requestItem, ...)` — caller can pass mismatched values; compiler cannot catch it.
Good: derive `category` inside the method from `requestItem`, or wrap the pair in a value type that enforces consistency at construction.

---

### 9. Behavioral changes buried in unrelated PRs

Read the diff. If you see any of the following inside a PR whose stated purpose is something else, flag it as a separate concern that belongs in its own commit (or at least the PR description):

- Rate-limiter name swaps (often a significant capacity change)
- Cache TTL changes
- Log level changes (`log.error` ↔ `log.warn` ↔ `log.info`)
- Default-value changes in `application.yml`
- Switching between `@Transactional` propagation modes
- Adding or removing `@Async` / `@Cacheable` / `@RateLimiter` annotations

These are often production-impactful and easy to miss when bundled with feature work.

---

## Output

Group findings by category. For each finding: file path, line number, the offending snippet, and the recommended fix.

End with a summary count per category and an overall verdict:

- ✅ No Java-specific issues found.
- ⚠️ N issues — review and fix before merging.
- ❌ N issues including blockers (#7 orphaned config, #9 buried behavioral changes) — request changes.
