---
name: tech-design
description: Write a technical design document before coding begins.
---

# Write a Technical Design Document

No code is written before this document exists and is reviewed. The goal is to surface unknowns and agree on an approach before implementation begins.

## Procedure

1. **Confirm requirements are complete.**
   Verify the ticket has:
   - A clear problem statement.
   - Measurable success criteria.
   - Known constraints.

2. **Read the codebase.**
   Use `determine-patterns` to map relevant areas.

   **Research gates:**
   - **Stack scope.** Check boundaries and cross-repo impact.
   - **Proportionality check.** Look for an already-working sibling feature that handles the analogous case — its pattern is often the cheapest correct option and anchors the option space below.
    - **Existing-helper sweep (DRY).** Sweep the codebase to verify whether helpers, utilities, or abstractions already exist for the proposed behavior before introducing new ones.
    - **Domain glossary.** Verify custom terms in `.ai/domain-glossary.md`.
    - **Doc verification.** Verify library behavior against official docs.

3. **Identify the option space (tradeoffs & YAGNI).**
   List at least two plausible approaches with detailed tradeoffs (benefits and drawbacks of each). Apply YAGNI: reject speculative abstractions, over-engineering, and unnecessary layers. If the leading option requires cross-repo, published-API, or infra/DB changes, explicitly note whether a narrower same-repo option (e.g. mirroring an existing working sibling) was considered and why it was ruled out — don't skip straight to the heavier option.

4. **Recommend an approach.**
   Choose one and explain rationale based on simplicity, maintainability, and performance.

5. **Map the impact.**
   Identify changed modules, affected consumers, schema changes, and migration needs.

6. **Define the test strategy (functional & stability).**
   Plan high-signal functional tests covering core user flows and stability under failure. Exclude test fluff or redundant micro-tests.

7. **Define observability and performance.**
   Plan logging/alerting for new error states and evaluate performance implications (runtime complexity, render costs, N+1 queries, memory footprint).

8. **Surface open questions.**
   List unresolved threads needing input.

9. **Present for review.**
   Must be reviewed by at least one senior engineer.

10. **Persist the document.**
    Write to `.ai/<task-slug>/tech-design.md`.

## Output Format

```markdown
# Technical Design: <title>

## Problem Statement
<Summary of what is broken/missing and why it matters.>

## Success Criteria
- [ ] <measurable outcome>

## Recommended Approach
<Chosen option and rationale.>

## Impact Map
- **Files/modules changed**: <list>
- **Consumers affected**: <list>
- **Contract changes**: <yes/no>

## Test Strategy
- **Unit/Integration/Manual**: <details>

## Open Questions
- [ ] <question>
```

