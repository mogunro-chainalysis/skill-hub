---
name: determine-patterns
description: Discover coding patterns from live repo code before implementing.
---

# Determine Patterns from Live Code

Gather the minimum conventions needed for the current task by reading real code in the repo — not by guessing or importing patterns from other repos.

## Procedure

1. Determine what patterns are needed for the task:
   - Read the task description or PR plan to identify what types of code will be written (components, hooks, API calls, tests, routing, state management, etc.).
   - Only gather patterns relevant to the task — do not audit the entire repo.

2. Check for existing AI guidance first:
   - Look for `project-conventions` skill, `AGENTS.md`, `CLAUDE.md`, `CONTRIBUTING.md`, `.editorconfig`, linter configs.
   - If guidance exists, read it — but verify it against live code in step 3 (guidance can be stale).

3. Find exemplar files for each pattern needed:
   - Search for 2–3 recent, well-structured examples of the same type of code the task requires.
   - Prefer files that were recently modified (check git log).
   - Prefer files that are close to the area being modified (same feature, same directory level).
   - When the task changes a shared or reusable unit, explicitly look for where the repo wires that unit's prerequisites at integration boundaries (entrypoints, wrappers, host setup, initialization layers, dependency injection, or registration points) before designing a local fix.

   For each pattern type, gather:

   **Components:**
   - File naming and directory structure (flat vs nested, index files, co-located tests)
   - Function style (arrow vs declaration, default vs named export)
   - Props pattern (type vs interface, destructuring, readonly)
   - State management approach (local state, context, external store)
   - Styling approach (CSS modules, styled-components, Tailwind, design system components)

   **Hooks:**
   - Naming conventions (use-prefix, file location)
   - Return type patterns (tuple vs object)
   - Error handling approach
   - How data fetching hooks are structured (React Query, SWR, custom)

   **API/Data layer:**
   - Client structure (REST, GraphQL, RPC)
   - Type definitions (shared types, generated types, co-located)
   - Adapter/transform patterns
   - Error handling and loading states

   **Tests:**
   - Framework (Jest, Vitest, Cypress, Playwright)
   - File naming and location (co-located, `__tests__/`, `.test.ts`, `.spec.ts`)
   - Mocking approach (MSW, jest.mock, manual mocks)
   - Assertion style and common utilities
   - How shared prerequisites are provided in tests (test wrappers, fixtures, bootstrap helpers, harnesses)

   **Routing:**
   - Router library and version
   - Route definition pattern (file-based, config-based)
   - How new routes/pages are added

4. Extract only the patterns the task needs:
   - Do NOT gather every convention in the repo.
   - Do NOT mix patterns from different repos — if working across repos, run this skill separately per repo.
   - Do NOT invent patterns — if the repo is inconsistent, note the inconsistency and pick the most recent/common approach.

5. **Existing-helper sweep — required before writing any new shared code.**
   Before recommending or writing a new utility, helper, hook, formatter, transformer, or component:
   - Grep for verbs that match the proposed behavior: `get*`, `is*`, `has*`, `to*`, `format*`, `parse*`, `build*`, `from*`, `with*`.
   - Grep for nouns from the task: the entity types involved (e.g. `User`, `Account`, `Order`, `Transaction`), and adjacent module names.
   - Search the same directory level + one up + one down for files with similar names.
   - Cross-reference `.ai/domain-glossary.md` if it exists — domain terms in scope may already point to canonical helpers.
   - If a partial helper exists that covers some of the proposed behavior, **extend it** rather than creating a parallel implementation. Note the existing helper in your output and explain how the new code reuses or extends it.
   - If nothing exists, state that explicitly: "Searched for X, Y, Z — no existing helper found." This makes the absence verifiable.
   - DRY violations introduced by skipping this sweep are a known recurring failure mode. The sweep is non-skippable.

6. Summarize findings as actionable rules:
   - Write short, imperative statements the agent can follow during implementation.
   - Cite the exemplar files as evidence for each rule.
   - Flag any conflicts between existing AI guidance and live code.
   - If the repo consistently solves a concern at an integration boundary rather than inside leaf units, state that explicitly so the implementation does not drift into hidden workarounds.

7. Apply the patterns:
   - Use the discovered patterns for planning (in `plan-pr`) and implementation.
   - When verifying existing code, compare the written code against the discovered patterns and report discrepancies.

## Critical Rules

- **One repo at a time.** Never apply patterns from repo A to repo B.
- **Live code is the source of truth.** When AI guidance conflicts with what the code actually does, flag the conflict and follow the live code for implementation.
- **Minimum viable discovery.** Only gather what the task requires.
- **Cite your sources.** Every pattern rule must reference the file(s) it was derived from.
- **Recency matters.** Prefer patterns from recently modified files over old ones.

## Output Format

```markdown
# Patterns: <repo-name> — <task context>

## <Pattern Category> (e.g., Components, Hooks)

- **<Rule>**: <imperative statement>
  - Evidence: `path/to/exemplar.ts:10-25`
  - Evidence: `path/to/another.ts:5-15`

## Conflicts with Existing Guidance
- <AI guidance says X, but live code does Y> → Follow Y for this task.

## Not Investigated
- <pattern types not relevant to this task>
```

