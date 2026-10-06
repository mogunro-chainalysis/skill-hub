# Ticket Plan Template

Write to `.ai/<task-slug>/ticket-plan.md`.

```markdown
# Ticket Plan: <ticket title>

## Summary
<1-2 sentence overview>

## Capacity Check
Total estimated coding hours: <N> / 12 maximum
PRs: <count>

## PR Order

### PR 1: <repo> — <short description>
- **Branch**: `<branch-name>`
- **Scope**: <what's included>
- **Not in scope**: <explicit exclusions>
- **Acceptance criteria**:
  - [ ] <criterion>
  - [ ] Tests written and passing
  - [ ] Types clean
  - [ ] No regressions
- **Test strategy**: <what will be tested and how>
- **Observability**: <new logging/alerting needed? yes/no>
- **Size**: <N> lines | S/M/L | ~<N> coding hours
- **Dependencies**: none / PR N
- **Risks**: <unknowns>

### PR 2: ...

## Dependency Graph
PR 1 → PR 2 → PR 3
PR 1 → PR 4 (parallel with PR 2)
```
