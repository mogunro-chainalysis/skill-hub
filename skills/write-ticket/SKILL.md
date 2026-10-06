---
name: write-ticket
description: Write a well-scoped engineering ticket (problem, success criteria, scope, infra impact). Use for "write a ticket", "turn this into a ticket".
---

# Write an Engineering Ticket

A ticket must be clear enough that the implementer can start without a meeting, and scoped to be finished within 3 coding days (12 hours).

## Procedure

1. **Understand the request.** Identify the problem, beneficiary, and constraints.
2. **Check scope.** Implementation must not exceed 12 hours. If larger, split it.
3. **Write the ticket.** Follow the output format. Every field is required.
4. **Stress-test success criteria.** Each must be binary, verifiable, and specific.
5. **Check conflict risk.** Note overlap with other work.
6. **Infra impact.** Run a quick `plan-infra-changes` trigger check and list any infra/env-repo work (incl. DR) under Infra.
7. **Confirm with user** before persisting.
8. **Persist.** Write to `.ai/<task-slug>/ticket.md`.

## Output Format

```markdown
# Ticket: <short imperative title>

## Problem
<Context and impact summary.>

## Proposed Solution
<Directional summary.>

## Success Criteria
- [ ] <outcome>
- [ ] Tests written/passing

## Infra
<none | infra/env-repo changes, all envs incl. DR>

## Out of Scope
<Explicit exclusions.>

## Size Estimate
S / M / L — <N> hours

## Risks
<Unknowns or blockers.>
```

