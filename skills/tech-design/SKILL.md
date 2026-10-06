---
name: tech-design
description: Write a design doc comparing approaches before coding. Use for "design doc", "which approach", non-trivial features.
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

   Apply the research gates (global Always rules: DRY, patterns, full-stack scope, docs, glossary, proportionality) and run `plan-infra-changes` for infra/DR impact.

3. **Identify the option space (tradeoffs & YAGNI).**
   List at least two plausible approaches with benefits and drawbacks. If the leading option needs cross-repo, published-API, or infra/DB changes, state why a narrower same-repo option (e.g. mirroring a working sibling) was ruled out.

4. **Recommend an approach.**
   Choose one and explain rationale based on simplicity, maintainability, and performance.

5. **Map the impact.**
   Identify changed modules, affected consumers, schema changes, and migration needs.

6. **Define the test strategy** per `write-tests`.

7. **Define observability and performance.** Logging/alerting for new error states; performance risks.

8. **Surface open questions.** Resolve them with `grill-me` when the user is available.

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
- **Infra changes**: <none | list, incl. DR>

## Test Strategy
- **Unit/Integration/Manual**: <details>

## Open Questions
- [ ] <question>
```

