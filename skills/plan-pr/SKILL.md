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
    - **Existing-helper sweep (DRY).** Before planning any new shared utility, component, or helper, invoke `determine-patterns` step 5 — grep for verbs and nouns from the task to enforce DRY. Reusing or extending existing code is required; never add parallel implementations without proof.
    - **Domain glossary.** If custom domain terms appear, invoke `build-domain-context`.
    - **Doc verification.** If using a library feature in a non-trivial way, check the official docs.

4. **Plan the test strategy functionally (user flows & stability).**
   Define:
   - **Functional tests**: primary user flows, state transitions, and error recovery.
   - **Integration tests**: cross-boundary interactions and external collaborator contracts.
   - **Unit tests**: reserve strictly for isolated, high-branch algorithmic logic.
   - **Exclude test bloat**: explicitly rule out fluff, tests for trivial getters/setters/framework plumbing, and mock-only checks.
   - Prefer test-first for functional and integration behaviors.

5. **Check for observability needs.**
   Define logging/alerting for new error states or features.

6. **Consider performance and complexity (YAGNI).**
   - **Complexity & YAGNI**: Weigh drawbacks and benefits of the approach. Strip speculative abstractions, unnecessary wrapper layers, and premature generalizations.
   - **Performance**: Flag re-renders, N+1 query patterns, expensive operations, memory leaks, or unnecessary network calls.

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

## Test Strategy (Functional & Lean)
- **User flows & stability**: <key functional flows and failure modes covered>
- **Integration tests**: <cross-boundary interactions covered>
- **Unit tests**: <strictly pure algorithmic logic covered — or "none required">
- **Excluded bloat**: <explicitly excluded trivial/mock-only tests>

## Observability
<new logging or alerting needed — or "none">

## Performance & Complexity (YAGNI)
- **Tradeoffs**: <benefits vs drawbacks of chosen approach>
- **YAGNI check**: <confirm no speculative abstractions or unneeded wrappers>
- **Performance**: <any foreseeable rendering, query (N+1), or memory concerns — or "none flagged">

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
