---
name: determine-patterns
description: Discover coding and testing patterns from live repo code before planning or implementing.
---

# Determine Patterns from Live Code

Gather the minimum conventions needed for the current task by reading real code in the repo — not by guessing or importing patterns from other repos.

## Procedure

1. Determine what patterns are needed:
   - Read the task description or PR plan to identify the types of code to be written (components, hooks, API calls, tests, routing, state management, etc.).
   - Gather only patterns relevant to the task — do not audit the entire repo.

2. Check for existing AI guidance first:
   - Look for repo skills (`.agents/skills/`, `.claude/skills/`), `AGENTS.md`, `CLAUDE.md`, `CONTRIBUTING.md`, `.editorconfig`, linter configs.
   - Read it, then verify it against live code in step 3 (guidance can be stale). When they conflict, flag it and follow the live code.

3. Find exemplar files for each pattern needed:
   - Search for 2–3 recent, well-structured examples of the same type of code. Prefer recently modified files (check git log) close to the area being modified.
   - When the task changes a shared or reusable unit, find where the repo wires that unit's prerequisites at integration boundaries (entrypoints, wrappers, host setup, initialization layers, DI, registration points) before designing a local fix.
   - **Search by behavior, not by name or location.** Describe what the new code *does* ("tests an HTTP endpoint end-to-end", "exposes a write operation over two transports", "validates a request body") and find the closest existing code doing that job anywhere in the repo — including other source sets and modules (e.g. `src/integration-test`, `src/it`, `e2e/`). An exemplar in an unexpected place still defines the pattern.
   - **Map cross-layer wiring.** When adding a peer of an existing layered flow (a new endpoint beside an existing one, a REST route beside a GraphQL/RPC resolver, a consumer beside a producer), trace how existing peers call each other and copy that call chain — don't wire the new piece directly to lower layers if peers go through a shared entry point.
   - **Prove absence before inventing.** "No existing example of X" is a claim — list the behavioral searches performed and what each returned. Never introduce a new test style, layering, or file-placement convention on an unproven absence; put the proposed pattern to the user as an explicit decision.
   - See references/categories.md for what to gather per category (components, hooks, API, tests, routing).

4. Extract only the patterns the task needs:
   - Work one repo at a time — if the task spans repos, run this skill separately per repo and never carry patterns across.
   - If the repo is inconsistent, note the inconsistency and pick the most recent/common approach rather than inventing one.

5. **Existing-helper sweep — required before writing any new shared code.**
   Before recommending or writing a new utility, helper, hook, formatter, transformer, or component:
   - Grep for verbs that match the proposed behavior: `get*`, `is*`, `has*`, `to*`, `format*`, `parse*`, `build*`, `from*`, `with*`.
   - Grep for nouns from the task: the entity types involved (e.g. `User`, `Account`, `Order`) and adjacent module names.
   - Search the same directory level + one up + one down for files with similar names.
   - Cross-reference `.ai/domain-glossary.md` if it exists — domain terms in scope may already point to canonical helpers.
   - If a partial helper covers some of the behavior, **extend it** rather than creating a parallel implementation; note it in the output and explain the reuse.
   - If nothing exists, state it explicitly: "Searched for X, Y, Z — no existing helper found."
   - This sweep is non-skippable: skipping it is a known recurring source of DRY violations.

6. Summarize findings as actionable rules:
   - Write short, imperative statements to follow during implementation, each citing its exemplar files.
   - Flag conflicts between existing AI guidance and live code.
   - If the repo consistently solves a concern at an integration boundary rather than inside leaf units, state that explicitly so the implementation does not drift into hidden workarounds.

7. Apply the patterns:
   - Use them for planning (in `plan-pr`) and implementation.
   - When verifying existing code, compare it against the discovered patterns and report discrepancies.

## Output Format

```markdown
# Patterns: <repo-name> — <task context>

## <Pattern Category> (e.g., Components, Hooks)
- **<Rule>**: <imperative statement>
  - Evidence: `path/to/exemplar.ts:10-25`

## Conflicts with Existing Guidance
- <AI guidance says X, but live code does Y> → Follow Y for this task.

## Absences (verified)
- <pattern needed> — searched: <behavioral queries + locations>; found nothing → <proposed new pattern, pending user decision>.

## Not Investigated
- <pattern types not relevant to this task>
```
