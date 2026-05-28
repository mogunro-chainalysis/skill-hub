---
name: decompose-ticket
description: Break a ticket into ordered, scope-bounded pull requests across one or more repos.
---

# Decompose a Ticket into Pull Requests

## Capacity Constraint

Every PR must be sized so it is completable in **one to two coding sessions** (4–8 hours). PRs that would take longer must be split further.

Tickets have already been scoped to a maximum of 12 coding hours. If the ticket arriving here is larger than that, flag it before proceeding.

## Context Persistence

All lifecycle skills use a `.ai/<task-slug>/` directory in each repo. Structure:

```
.ai/
├── feature-slug/
│   ├── ticket.md           ← from write-ticket
│   ├── tech-design.md      ← from tech-design
│   ├── ticket-plan.md      ← this skill's output
│   ├── decisions.md        ← from grill-me
│   ├── pr-<N>-plan.md      ← from plan-pr
│   └── progress.md
```

The `.ai/` directory must be gitignored. Confirm this before writing any files.

## Gates — Do Not Proceed Without These

Before decomposing, confirm:

1. **Requirements are complete.** The ticket has a problem statement, success criteria, and defined scope.
2. **Technical design exists** for anything non-trivial.
3. **The ticket scope is realistic.** Total implementation work must not exceed 12 coding hours.

## Procedure

0. **Check for existing context.**
   List `.ai/` subdirectories. If a matching task folder exists, read its files — you may be resuming.

1. **Parse the ticket.**
   Read from `.ai/<task-slug>/ticket.md`, $ARGUMENTS, or the conversation. Identify each discrete deliverable.

2. **Explore the repos involved.**
   Search and read to understand integration points. If the repo lacks AI guidance, invoke `determine-patterns` to gather minimum context.

3. **Group changes into PRs.**
   - One PR per repo per logical boundary.
   - Each PR must be independently reviewable.
   - Target **under 300 lines changed** per PR. Over 400 lines: mandatory split.
   - Tests, observability, and type coverage are part of each PR's scope.
   - If a PR changes the runtime contract of a shared unit, include consumer migrations in the same PR unless a staged rollout is planned.

4. **Estimate each PR in coding hours.**
   - S: under 2 hours
   - M: 2–4 hours (one session)
   - L: 4–8 hours (two sessions — maximum)
   - XL: over 8 hours → must be split

5. **Determine dependency order.**
   Which PRs must merge first? Which can be worked in parallel?

6. **Define each PR:**
   - **Repo** and **branch name**
   - **Scope**: what is in, what is explicitly out
   - **Acceptance criteria**: binary, verifiable checklist
   - **Test strategy**: what tests will be written and what they cover
   - **Observability**: does this PR need new logging or alerting?
   - **Size estimate**: lines and coding hours
   - **Dependencies**: which PRs must be done first
   - **Risks/unknowns**

7. **Stress-test the plan.**
   - Are PR boundaries clean?
   - Can any PR be parallelized?
   - Realistically fit within 8 coding hours?
   - Present the plan for confirmation.

8. **Determine the task slug.**
   Kebab-case from the ticket title.

9. **Persist the approved plan.**
   Write to `.ai/<task-slug>/ticket-plan.md` in the primary repo. Create `.ai/<task-slug>/progress.md` with all PRs listed as "not started".

## Output Format

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
```

.ai/
├── export-identify-entity/
│   ├── ticket.md           ← from write-ticket
│   ├── tech-design.md      ← from tech-design
│   ├── ticket-plan.md      ← this skill's output
│   ├── decisions.md        ← from grill-me
│   ├── pr-<N>-plan.md      ← from plan-pr
│   └── progress.md
```

The `.ai/` directory must be gitignored. Confirm this before writing any files.

## Gates — Do Not Proceed Without These

Before decomposing, confirm:

1. **Requirements are complete.** The ticket has a problem statement, success criteria, and defined scope. If not, invoke `write-ticket` first.
2. **Technical design exists** for anything non-trivial. If the approach is not yet agreed, invoke `tech-design` first.
3. **The ticket scope is realistic.** Total implementation work must not exceed 12 coding hours. If it does, split the ticket before splitting into PRs.

## Procedure

0. **Check for existing context.**
   List `.ai/` subdirectories. If a matching task folder exists, read its files — you may be resuming. Summarize what exists and ask whether to continue or start fresh.

1. **Parse the ticket.**
   Read from `.ai/<task-slug>/ticket.md`, $ARGUMENTS, or the conversation. Identify each discrete deliverable.

2. **Explore the repos involved.**
   Search and read to understand integration points. If the repo lacks AI guidance, invoke `determine-patterns` to gather minimum context needed for planning.

3. **Group changes into PRs.**
   - One PR per repo per logical boundary.
   - Each PR must be independently reviewable.
   - Target **under 300 lines changed** per PR. This is the norm — not a ceiling.
   - Over 300 lines: split. Over 400 lines: mandatory split.
   - Tests, observability, and type coverage are **part of each PR's scope** — not a separate phase at the end.
   - If a PR changes the runtime contract of a shared unit, include consumer migrations in the same PR unless a staged rollout is explicitly planned.

4. **Estimate each PR in coding hours.**
   - S: under 2 hours
   - M: 2–4 hours (one session)
   - L: 4–8 hours (two sessions — maximum for a single PR)
   - XL: over 8 hours → must be split

   If any PR is XL, identify the split point before continuing.

5. **Determine dependency order.**
   Which PRs must merge first? Which can be worked in parallel? Note publish/link steps between repos.

6. **Define each PR:**
   - **Repo** and **branch name**
   - **Scope**: what is in, what is explicitly out
   - **Acceptance criteria**: binary, verifiable checklist — includes tests passing, types clean, no regressions
   - **Test strategy**: what tests will be written and what they cover
   - **Observability**: does this PR need new logging or alerting? (yes/no, brief note)
   - **Size estimate**: lines and coding hours
   - **Dependencies**: which PRs must be done first
   - **Risks/unknowns**

7. **Stress-test the plan.**
   - Are PR boundaries clean? No PR should leave the codebase broken.
   - Can any PR be parallelized?
   - Are there hidden coupling points?
   - Does any PR realistically fit within 8 coding hours?
   - Present the plan and ask the user to confirm or adjust.

8. **Determine the task slug.**
   Kebab-case from the ticket title. Confirm if ambiguous.

9. **Persist the approved plan.**
   Write to `.ai/<task-slug>/ticket-plan.md` in the primary repo. For multi-repo tickets, write the dependency graph and that repo's scope to each additional repo. Create `.ai/<task-slug>/progress.md` with all PRs listed as "not started".

## Output Format

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
