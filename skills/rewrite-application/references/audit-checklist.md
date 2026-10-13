# Rewrite & Agentic Maintainability Checklist

Use this reference during the audit (step 2) and verification (step 7) of an application rewrite.

## 1. Spaghetti & Architecture Audit

Identify and flag existing antipatterns:
- **God Modules/Classes**: Files >400 lines handling multiple domain concepts, data fetching, presentation, and state.
- **Circular Dependencies**: Modules that directly or indirectly import each other, complicating tree-shaking and isolation.
- **Deep Indirection**: Call stacks exceeding 4–5 layers of passthrough wrappers, abstract factories, or unnecessary base classes.
- **Shared Mutable State**: Global singletons, module-level mutable variables, or event buses with untraceable listeners.
- **Hidden Side Effects**: Functions that mutate incoming arguments or perform undeclared I/O.
- **Shotgun Surgery**: Changes to one business rule requiring edits across dozens of scattered files.

## 2. Agentic Maintainability Criteria

Code written for human + AI collaboration must adhere to:
- **High Cohesion & Colocation**: Group related code by domain/feature (logic, types, tests, styles), not by technical tier (`/controllers`, `/services`, `/models`). Subagents find everything in one glob without excessive exploratory scans.
- **Shallow Call Hierarchies**: Direct function calls over elaborate inheritance or DI magic. AI agents reason accurately about call paths they can see in one or two file reads.
- **Explicit Type Contracts**: Strict types (e.g. TypeScript `strict`, Python `typeguard`/`mypy`, typed Java DTOs) and runtime boundary schemas (Zod, Pydantic). Compilers must catch hallucinations before tests run.
- **Zero Ambiguity Naming**: Functions and variables named by their exact domain purpose. Never rely on cryptic abbreviations or overloaded terms.
- **Pure Core, Explicit Shell**: Business decisions isolated in pure, deterministic functions; I/O, database access, and network calls kept at the system perimeter.
- **Deterministic Self-Verification**: The repo has straightforward CLI commands (`test`, `lint`, `typecheck`) that produce actionable compiler errors so agents can self-correct independently.

## 3. Dead Weight & Debt Purge

- **Unused Dependencies**: Audit `package.json`, `pom.xml`, `requirements.txt`, etc. Remove unreferenced libraries and replace bloated single-use packages with native standard library solutions.
- **Dead Code Paths**: Remove zombie functions, commented-out blocks, unused exports, and obsolete feature flags.
- **Config Sprawl**: Consolidate scattered configuration files into centralized, typed environment validation.

## 4. Rewrite Audit Report Template

Persist initial audit and final outcomes to `.ai/<task-slug>/audit.md`:

```markdown
# Application Rewrite Audit: <task-slug>

## 1. Human Goal
- **Primary Objective**: <e.g. migrate JS to strict TS, modularize monorepo, decouple legacy API>
- **Non-Negotiables**: <invariants, performance targets, SLA>

## 2. Baseline Architecture Issues
| Location | Category (Spaghetti / Agent Friction / Dead Weight) | Issue Description | Proposed Resolution |
|---|---|---|---|
| `path/to/file.ext:line` | Spaghetti | 800-line God class with circular import | Extract domain modules into `domain/<feature>` |

## 3. Baseline Verification Status
- Tests passing: <count> passing / <count> failing
- Type errors: <count>
- Uncovered critical paths: <list>

## 4. Post-Rewrite Verification
- [ ] All baseline issues resolved or replaced
- [ ] No circular dependencies remaining
- [ ] Zero dead code / unused dependencies left behind
- [ ] Full test suite passing with fresh live verification
- [ ] Measurable improvement: <lines removed, build time reduced, type safety 100%>
```
