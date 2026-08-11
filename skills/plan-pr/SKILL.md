---
name: plan-pr
description: Create a file-level implementation plan for a single pull request.
---

# Plan a Pull Request

## Procedure

0. **Check for existing context.**
   List `.ai/` subdirectories. Identify the task folder. Read `ticket-plan.md`, `tech-design.md`, and `decisions.md` if they exist. Look for `pr-<N>-plan.md`. Read `progress.md`.

1. **Read the PR scope.**
   Confirm: what repo, what's in scope, what's explicitly out.

2. **Check for repo guidance.**
   Look for `AGENTS.md`, `CLAUDE.md`, or `CONTRIBUTING.md`. If the repo lacks guidance, invoke `determine-patterns`.

3. **Explore the codebase.**
   Trace the code paths the PR will touch. Find existing patterns. Identify every file that will be created, modified, or deleted.

   **Research gates — run before listing file changes:**
   - **Stack scope.** If this PR touches a published interface or API contract, read both ends (consumer + provider) before planning.
   - **Proportionality check.** Before scoping cross-repo or infra-level work, check whether an already-working sibling component or pattern in this repo solves the equivalent case — copying it may eliminate the need to expand scope at all.
   - **Existing-helper sweep.** Before planning any new shared utility, invoke `determine-patterns` step 5 — grep for verbs and nouns from the task.
   - **Domain glossary.** If custom domain terms appear, invoke `build-domain-context`.
   - **Doc verification.** If using a library feature in a non-trivial way, check the official docs.

4. **Plan the test strategy explicitly.**
   Define:
   - **Unit tests**: isolate functions/hooks.
   - **Integration tests**: verify cross-boundary behaviour.
   - **Component tests**: verify rendered output/interaction.
   - **Edge cases**: explicit test coverage.
   - Prefer test-first for unit and integration work.

5. **Check for observability needs.**
   Define logging/alerting for new error states or features.

6. **Consider performance.**
   Flag re-renders, N+1 patterns, expensive operations, memory leaks, or unnecessary network calls.

7. **List every file change.**
   - **Create**: new files with purpose/pattern.
   - **Modify**: existing files with description.
   - **Delete**: files being removed.
   - Group by logical step. Tests are a step.

8. **Identify risks and unknowns.**
   Clarify ambiguous contracts.

9. **Estimate size and hours.**
   Count approximate lines and coding hours.
   - Over 400 lines or 8 hours: recommend splitting.

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

## Test Strategy
- **Unit tests**: <what is covered>
- **Integration tests**: <what is covered>
- **Component tests**: <what is covered>
- **Edge cases**: <explicit coverage>

## Observability
<new logging or alerting needed — or "none">

## Performance Considerations
<any foreseeable rendering, network, or memory issues — or "none flagged">

## File Changes

### Step 1: <logical group>
- **Create** `path/to/file.ts` — <purpose, pattern followed>
- **Modify** `path/to/existing.ts` — <what changes>

### Step 2: Tests
- **Create** `path/to/file.test.ts` — <what is tested>

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
