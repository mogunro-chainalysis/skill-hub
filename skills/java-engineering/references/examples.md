# java-engineering — Examples

Code samples referenced from `SKILL.md`.

## 1a. Null-guarded default `thenAnswer` in a shared base test class

Mockito invokes the stubbed method with `null` matchers while recording a *later* `when(...)` call. Without a guard, every test that overrides the stub crashes with an NPE inside Mockito internals.

```java
when(externalApi.fetch(any(), any())).thenAnswer(inv -> {
  List<Item> items = inv.getArgument(0);
  if (items == null) return Flux.empty();   // guard for Mockito's internal recording
  return Flux.fromIterable(items.stream().map(this::asResponse).toList());
});
```

## 1b. `@Spy` for concrete dependencies under `@InjectMocks`

```java
// Ignored by @InjectMocks — production code receives null:
private final SimpleMeterRegistry meterRegistry = new SimpleMeterRegistry();

// Injected:
@Spy private SimpleMeterRegistry meterRegistry = new SimpleMeterRegistry();
```

## 2a. Documenting a blocking convenience method

```java
/**
 * Processes items synchronously. <b>Threading:</b> blocks the caller's thread on
 * {@code .block()}. Do not call from a Reactor event-loop thread — use
 * {@link #processItemsReactive(Collection)} from reactive code paths.
 */
public Map<Input, Output> processItems(Collection<Input> inputs) { ... }
```

## 2c. Rate limiter on the upstream publisher

```java
// Good: limit applies per upstream API call
Mono<Response> call = client.fetch(req)
    .transformDeferred(RateLimiterOperator.of(rateLimiter));
```

Applying it to the outermost composed pipeline limits the wrong granularity.

## 5a. Fail loud on null list elements

```java
Objects.requireNonNull(input, "processItems: null input not allowed at index " + i);
```
