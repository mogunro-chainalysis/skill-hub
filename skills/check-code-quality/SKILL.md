---
name: check-code-quality
description: Scan changed files for cleanup, TypeScript, and React quality issues. Use before committing, preparing, or reviewing a PR.
---

# Check Code Quality

Scan only changed files. Repo lint/format config wins over this list; flag anything here the linter could enforce as a suggestion to add the rule.

## Procedure

1. List changed files (`git diff --staged --name-only`, or the branch diff).
2. Apply the **General** checks to every file; **TypeScript** to `.ts/.tsx`; **React** to components. Java → `check-java-quality`.
3. Report each finding as `file:line — check — fix`. Verdict: ✅ clean / ❌ N issues.

## General

1. Debug output (`console.log/warn/info`, `debugger`, print statements) — remove.
2. Commented-out code — delete.
3. TODOs without a ticket reference (`TODO(PROJ-123)`).
4. Comments that restate the code — remove; keep "why" comments.
5. Unused imports/symbols.
6. Duplication or tight coupling a nearby helper already solves (`determine-patterns` step 5).

## TypeScript

1. `any` — use `unknown` + narrowing or a specific type.
2. Object shapes via `interface` — use `type` (unless the repo standardizes on `interface`).
3. Missing `readonly` on type properties.
4. `||` for null/undefined defaults — use `??`.
5. Default exports — prefer named exports.
6. API/transport types leaking into components — map to UI/domain types at the boundary.

## React

1. JSX section comments — extract a sub-component.
2. Undestructured props — destructure in the signature.
3. Derived state via `useState` + `useEffect` — derive during render.
4. Fetching/business logic in presentational components — move to hooks/containers.
5. Inline handlers in large lists — extract a row component or `useCallback`; missing/unstable `key`s.
6. Prop drilling through 3+ layers — lift or use context.
