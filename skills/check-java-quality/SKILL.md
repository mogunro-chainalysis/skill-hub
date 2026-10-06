---
name: check-java-quality
description: Scan Java diffs for quality issues (Mockito, Reactor, Spring, Sonar rules). Use before committing or reviewing Java changes.
---

# Check Java Quality

## Procedure

1. Determine scope: $ARGUMENTS (default: changed `.java` files from `git diff --name-only main...HEAD`).
2. Read each file and run every check below with Read and Grep. Leave generic issues (commented-out code, TODOs, non-Mockito unused imports, console statements) to `check-code-quality`.
3. For each finding, record file path, line number, offending snippet, and the recommended fix.
4. Report using the Output section.

See references/checks.md for grep hints, rationale, and bad/good examples per check.

## Checks

1. **Sonar S135** — loop has more than one `break`/`continue`; extract a guard method with early returns or filter upstream.
2. **Sonar S1845** — method name clashes with a field/constant (e.g. `status()` vs `STATUS`); rename the method.
3. **FQN instead of import** — inline `com.example.Foo` with no name collision; import it.
4. **Unused Mockito matchers/stubs** — unreferenced static matcher imports, or `when(...)` stubs no test hits (watch for `lenient()` hiding them).
5. **Multi-purpose helper, single-purpose Javadoc** — private helper does N things but doc names one; split or rewrite the doc.
6. **`log.info` on transient external failures** — timeouts/retries/fallbacks go to `log.warn`; `log.error` only for action-required.
7. **Orphaned config after constant rename** — grep the OLD value across YAML/properties, tests, Docker, Helm/k8s manifests.
8. **Unenforced parameter contract** — method takes a value and its derivable source (`category` + `Item`); derive it or use a value type.
9. **Buried behavioral change** — rate-limiter swaps, cache TTL, log levels, YAML defaults, `@Transactional` propagation, `@Async`/`@Cacheable`/`@RateLimiter` changes in an unrelated PR.
10. **Sonar S5122** — bare `@CrossOrigin` on a new controller; rely on central CORS config if present, else set explicit `origins`.
11. **Sonar S1123 / S6355** — `@Deprecated` needs a `@deprecated` Javadoc naming the replacement plus `forRemoval`/`since`.

## Output

Group findings by check number. End with a count per check and a verdict:

- ✅ No Java-specific issues found.
- ⚠️ N issues — review and fix before merging.
- ❌ N issues including blockers (#7 orphaned config, #9 buried behavioral changes) — request changes.
