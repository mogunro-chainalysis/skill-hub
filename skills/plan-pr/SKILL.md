---
name: plan-pr
description: File-level implementation plan for one PR. Use for "plan PR N", "how should I implement this", before coding.
---

# Plan a Pull Request

## Procedure

0. **Check for existing context.**
   List `.ai/` subdirectories. Identify the task folder. Read `ticket-plan.md`, `tech-design.md`, and `decisions.md` if they exist. Look for `pr-<N>-plan.md`. Read `progress.md`.

1. **Read the PR scope.**
   Confirm: what repo, what's in scope, what's explicitly out.

2. **Determine patterns (always).**
   Read `AGENTS.md`, `CLAUDE.md`, or `CONTRIBUTING.md` if present, then invoke `determine-patterns` for
   every kind of code the PR adds — **service logic and tests alike**. Repo guidance rarely covers test
   placement or cross-layer wiring, so don't skip this when guidance exists.

3. **Explore the codebase.**
   Trace the code paths the PR will touch. Find existing patterns. Identify every file that will be created, modified, or deleted.

   **Research gates** (global Always rules): helper sweep (`determine-patterns` step 5), both ends of any contract, proportionality, domain terms, docs.
   - **Infra impact.** Invoke `plan-infra-changes`; record its verdict (none, or the infra PRs this PR depends on).

4. **Plan the test strategy** per `write-tests`: behaviors to prove, level for each, and explicitly excluded bloat.

5. **Check for observability needs.**
   Define logging/alerting for new error states or features.

6. **YAGNI and performance check.** Name the tradeoff accepted and any foreseeable perf risk (global YAGNI and performance rules).

7. **List every file change.**
   - **Create**: new files with purpose and the **exemplar file it mirrors** (`file:line`). No exemplar = a
     new pattern → flag it as a decision for the user, with the searches that found nothing.
   - **Modify**: existing files with description.
   - **Delete**: files being removed.
   - Group by logical step. Tests are a step.

8. **Identify risks and unknowns.**
   Clarify ambiguous contracts.

9. **Estimate size and hours.** Over the PR size limit or 8 hours → recommend `split-pr`.

10. **Define the implementation order.**
    Types → logic → tests → UI → integration → review.

11. **Present the plan for user approval.**

12. **Persist the approved plan.**
    Write to `.ai/<task-slug>/pr-<N>-plan.md`. Update `progress.md`.

## Output Format

```markdown
# PR Plan: <branch-name>

## Scope
<what this PR delivers>

## Not in Scope
<explicit exclusions>

## Infra Impact
<none (triggers checked) | infra PRs + order>

## Test Strategy
- <behavior> — <level> (mirrors `path/to/existing.test.ts:NN`)
- Excluded: <bloat explicitly not written>

## Observability
<new logging or alerting needed — or "none">

## Tradeoffs & Performance
<tradeoff accepted; perf risks or "none flagged">

## File Changes

### Step 1: <logical group>
- **Create** `path/to/file.ts` — <purpose> (mirrors `path/to/exemplar.ts:NN`)
- **Modify** `path/to/existing.ts` — <what changes>

### Step 2: Tests
- **Create** `path/to/file.test.ts` — <what is tested> (mirrors `path/to/existing.test.ts:NN`)

## Risks & Unknowns
- <risk or open question>

## Size Estimate
~<N> lines | S/M/L | ~<N> coding hours

## Implementation Order
1. <types first>
2. <logic>
3. <tests>
4. <UI / wiring>
```
