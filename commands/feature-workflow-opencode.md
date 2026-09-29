---
description: Orchestrate end-to-end feature delivery across research, grill, plan, split, implement, and review phases.
agent: build
---

# Feature Workflow (opencode)

Conductor for multi-phase feature delivery in a fully agentic software engineering flow, ported from the
Claude Code `feature-workflow` skill. Same six phases and human gates; the delegation mechanics leverage
Task-tool subagents (`@researcher`, `@code-reviewer`, `@general`, `@explorer`) while keeping critical
decisions in the primary session. Auto-loaded reference skills (`grill-me`, `tech-design`, `plan-pr`,
`split-pr`, `review-pr`, `prepare-pr`) provide deep guidance across phases.

## Core principles

- **Fully agentic execution, human-steered gates.** Delegate parallel research, implementation, and
  code review to Task-tool subagents; retain critical decisions, tradeoff evaluations, and phase gates
  in this session with the human.
- **DRY via codebase research.** Always research existing codebase helpers, utilities, hooks, and
  components before proposing or writing code. Reuse and extend existing patterns — never write parallel
  implementations without proof that existing code cannot be reused.
- **Complexity & YAGNI.** Weigh the benefits and drawbacks of different approaches before coding.
  Reject speculative abstractions, premature generalization, and unnecessary wrapper layers. Choose the
  simplest maintainable design that satisfies current requirements.
- **Performance by design.** Proactively evaluate performance implications: render cycles, query
  patterns (prevent N+1 queries), memory footprint, network roundtrips, and hot-path execution.
- **Functional testing over bloat.** Prioritize high-signal functional tests that prove real user
  flows and system stability under failure. Eliminate test fluff, coverage chasing, mock-only
  verifications, and fragile micro-tests that merely restate implementation details.
- **Delegate breadth, cite evidence.** Fan read-heavy, parallelizable work out to Task-tool subagents.
  Instruct every subagent to call tools and cite `file:line`, returning conclusions rather than file dumps.
- **Persist state.** Write durable artifacts to `.ai/<task-slug>/` so work survives context compaction.
- **Gate on the human.** Never auto-advance past a decision point (model switches, grill answers,
  plan approval, split decision, commit/push).
- **Mandatory model switch gates.** CLI agents cannot switch their own active model. The command enforces
  hard pauses at phase boundaries where the agent prompts the user to switch active agent/model (via Tab
  or `/model`) and waits for user confirmation before proceeding.
- **Model is pinned per agent in config, not switched at runtime.** Subagents spawned via the Task tool
  do not reliably inherit the parent session's active model (open opencode bug — subagent model
  inheritance falls back to the global default instead of the caller's model). Each agent's model is set
  in `opencode.jsonc`'s `agent` block instead: `build`→sonnet, `plan`→opus, `researcher`→sonnet,
  `code-reviewer`→opus, `explore`→haiku, `general`→sonnet. Switch the *primary* agent (Tab) at phase
  boundaries where needed.

## Procedure

0. **Set up state.** Choose a `<task-slug>`. Create `.ai/<task-slug>/` and a `progress.md` tracking the
   six phases. Read any existing `.ai/` context first.

1. **Research (subagents, parallel).** *Runs on: researcher/general → sonnet; explore → haiku for a
   single narrow lookup.* Spawn subagents concurrently for independent questions:
   - **DRY codebase sweep**: Search the repo for existing utilities, helpers, shared components, or
     partially matching implementations (`@researcher`).
   - **Architecture & boundaries**: Check consumer/backend expectations and performance constraints.
   - Consolidate patterns with `determine-patterns`. Each subagent reports file paths + key lines.
     Record findings in `.ai/<task-slug>/research.md`.

---
### 🛑 GATE: Switch to Architecture Model (Mandatory Pause)
**Do NOT proceed to Phase 2 automatically.** An AI cannot change its own active session model. You MUST
stop and output an explicit prompt to the human:
> *"Research is complete. Please switch to the architecture/reasoning agent now (press `Tab` to switch to `plan`, or run `/model opus` if in single-agent mode). Reply when ready to begin the Grill phase."*
Wait for the user's explicit confirmation before starting Phase 2.
---

2. **Grill (this session).** *Active primary agent: `plan` (opus).* Seed the interview with the research findings.
   Interview the human on:
   - **Complexity & YAGNI**: What is the minimal sufficient solution? Can any speculative layer be cut?
   - **Approach tradeoffs**: Explicitly weigh drawbacks and benefits of alternative designs.
   - **Performance constraints**: Latency, scale, memory, and hot paths.
   - **Test strategy**: Which user flows and stability guarantees matter? Explicitly rule out fluff/bloat.
   - Persist resolved decisions to `.ai/<task-slug>/decisions.md`.

3. **Plan.** *Active primary agent: `plan` (opus).* Work out approach tradeoffs (via `tech-design`) and a
   file-by-file plan (via `plan-pr`):
   - Apply YAGNI: reject speculative abstractions or extra wrapper layers.
   - Guarantee DRY: confirm planned code reuses discovered utilities.
   - Address performance: evaluate computational complexity, query efficiency, and state management.
   - Design functional tests: focus on user journeys and error stability; forbid useless unit test bloat.
   - Get explicit approval from the human. Persist to `.ai/<task-slug>/pr-<N>-plan.md`.

4. **Split (gate).** If the work exceeds ~400 lines / 8 hours or spans independent concerns, break it
   into sequential, independently reviewable PRs via `split-pr`. Confirm the split with the human before
   implementing. Small changes skip this — say so and move on.

---
### 🛑 GATE: Switch to Implementation Model (Mandatory Pause)
**Do NOT begin implementation on the reasoning model.** After planning and splitting are approved, you
MUST stop and output an explicit prompt to the human:
> *"Architecture and planning are approved. Please switch back to the implementation agent now (press `Tab` to switch to `build`, or run `/model sonnet` if in single-agent mode). Reply when ready to begin implementation."*
Wait for the user's explicit confirmation before starting Phase 5.
---

5. **Implement.** *Active primary agent: `build` (sonnet).* One `@general`
   subagent per split PR / independent task. Subagents follow the plan:
   - Reuse existing helpers (DRY) and follow repo patterns.
   - Implement performant, maintainable logic without speculative complexity.
   - Write functional tests proving user flows and stability. Stop when behavior is proven; do NOT add
     filler tests for trivial getters, framework wiring, or mock verifications.
   - Run formatters, linters, type checks, and tests. Report changes and update `progress.md`.

6. **Review.** *`@code-reviewer` is pinned to opus in config, independent of the active primary agent.*
   Invoke `@code-reviewer` against the diff:
   - Audit for YAGNI, complexity, and unnecessary abstractions.
   - Audit for DRYness: flag duplicate logic that could use existing helpers.
   - Audit for performance: flag unnecessary renders, N+1 queries, memory leaks.
   - Audit tests: flag test fluff, mock-only assertions, or bloat that doesn't test real user flows/stability.
   - Package with `prepare-pr`. **Do not commit or push without an explicit request.**

## Notes

- Not every phase is mandatory — trivial changes may go research → implement. Name the phases you skip.
- If a subagent stalls (narrates without calling tools), resend with an explicit "call the tools now"
  instruction or take the task into this session.
- Keep `.ai/<task-slug>/` planning docs out of commits (they are working artifacts).
- The `researcher` and `code-reviewer` model pins in `opencode.jsonc` are agent-config overrides applied
  on top of markdown-defined agents; this precedence isn't documented upstream. If either agent shows up
  missing its tools/skills/prompt after the pin is applied, that's the config override clobbering the
  markdown definition rather than layering on it — remove the override for that agent and let it inherit
  the primary agent's model instead.
- This is a port of the Claude Code `feature-workflow` skill — see
  `~/.agents/skills/feature-workflow/SKILL.md` for the original. Keep both in sync if the phase structure
  changes.
