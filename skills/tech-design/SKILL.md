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
   - **Existing-helper sweep.** Confirm if helpers already exist for proposed behavior.
   - **Domain glossary.** Verify custom terms in `.ai/domain-glossary.md`.
   - **Doc verification.** Verify library behavior against official docs.

3. **Identify the option space.**
   List at least two plausible approaches with tradeoffs.

4. **Recommend an approach.**
   Choose one and explain rationale.

5. **Map the impact.**
   Identify changed modules, affected consumers, schema changes, and migration needs.

6. **Define the test strategy.**
   Plan unit, integration, and manual tests.

7. **Define the observability plan.**
   Plan logging and alerting for new error states.

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

