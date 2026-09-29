---
name: feature-workflow
description: Orchestrate end-to-end feature delivery across research, grill, plan, split, implement, and review phases.
---

# Feature Workflow

Conductor for multi-phase feature delivery in a fully agentic software engineering flow. This skill
sequences phases, enforces human gates, and directs sub-agents while keeping the main context lean.

## Core principles

- **Fully agentic execution, human-steered gates.** Delegate parallel research, implementation, and
  code review to autonomous sub-agents; retain critical decisions, tradeoff evaluations, and phase gates
  in the main session with the human.
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
- **Delegate breadth, keep judgment.** Fan read-heavy, parallelizable work out to sub-agents. A
  sub-agent returns a verified conclusion citing `file:line`, not a raw file dump.
- **Persist state.** Write durable artifacts to `.ai/<task-slug>/` so work survives context
  compaction. One folder per task.
- **Gate on the human.** Never auto-advance past a decision point (model switches, grill answers,
  plan approval, split decision, commit/push).
- **Mandatory model switch gates.** Because CLI agents cannot programmatically switch their own active
  session model, the AI MUST explicitly stop and instruct the user to switch models at phase boundaries
  and await confirmation before proceeding.

## Procedure

0. **Set up state.** Choose a `<task-slug>`. Create `.ai/<task-slug>/` and a `progress.md` tracking
   the six phases. Read any existing `.ai/` context first.

1. **Research (sub-agents, parallel).** *Model: sonnet default; haiku for a single narrow lookup.*
   Spawn independent research sub-agents in a single message:
   - **DRY codebase sweep**: Search the repo for existing utilities, helpers, shared components, or
     partially matching implementations.
   - **Architecture & boundaries**: Check consumer/backend expectations and performance constraints.
   - Consolidate patterns with `determine-patterns`. Each sub-agent reports file paths + key lines.
     Record findings in `.ai/<task-slug>/research.md`.

---
### 🛑 GATE: Switch to Architecture Model (Mandatory Pause)
**Do NOT proceed to Phase 2 automatically.** An AI cannot change its own active session model. You MUST
stop and output an explicit prompt to the human:
> *"Research is complete. Please switch to your architecture/reasoning model now (e.g. run `/model opus` in Claude Code, or press `Tab` to select the `plan` agent in OpenCode). Reply when ready to begin the Grill phase."*
Wait for the user's explicit confirmation before starting Phase 2.
---

2. **Grill (main session).** *Active model: opus / reasoning agent.*
   Invoke `grill-me` seeded with research findings. Interview the human on:
   - **Complexity & YAGNI**: What is the minimal sufficient solution? Can any speculative layer be cut?
   - **Approach tradeoffs**: Explicitly weigh drawbacks and benefits of alternative designs.
   - **Performance constraints**: Latency, scale, memory, and hot paths.
   - **Test strategy**: Which user flows and stability guarantees matter? Explicitly rule out fluff/bloat.
   - Persist resolved decisions to `.ai/<task-slug>/decisions.md`.

3. **Plan.** *Active model: opus / reasoning agent.* Run `tech-design` for tradeoff analysis and `plan-pr` for a
   file-by-file plan:
   - Apply YAGNI: reject speculative abstractions or extra wrapper layers.
   - Guarantee DRY: confirm planned code reuses discovered utilities.
   - Address performance: evaluate computational complexity, query efficiency, and state management.
   - Design functional tests: focus on user journeys and error stability; forbid useless unit test bloat.
   - Get explicit human approval. Persist to `.ai/<task-slug>/pr-<N>-plan.md`.

4. **Split (gate).** If the work exceeds ~400 lines / 8 hours or spans independent concerns, run
   `split-pr` to create sequential, independently reviewable PRs. Confirm split with the human. Small
   changes skip this — note and proceed.

---
### 🛑 GATE: Switch to Implementation Model (Mandatory Pause)
**Do NOT begin implementation on the reasoning model.** After planning and splitting are approved, you
MUST stop and output an explicit prompt to the human:
> *"Architecture and planning are approved. Please switch back to your faster/implementation model now (e.g. run `/model sonnet` in Claude Code, or press `Tab` to select the `build` agent in OpenCode). Reply when ready to begin implementation."*
Wait for the user's explicit confirmation before starting Phase 5.
---

5. **Implement.** *Active model: sonnet / build agent.*
   One sub-agent per split PR / task. Sub-agents follow the plan:
   - Reuse existing helpers (DRY) and follow repo patterns.
   - Implement performant, maintainable logic without speculative complexity.
   - Write functional tests proving user flows and stability. Stop when behavior is proven; do NOT add
     filler tests for trivial getters, framework wiring, or mock verifications.
   - Run formatters, linters, type checks, and tests. Report changes and update `progress.md`.

6. **Review.** *Model: opus for high-stakes/architectural diffs; sonnet for routine PRs.*
   Run review sub-agent (`code-reviewer`) and/or `review-pr` against the diff:
   - Audit for YAGNI, complexity, and unnecessary abstractions.
   - Audit for DRYness: flag duplicate logic that could use existing helpers.
   - Audit for performance: flag unnecessary renders, N+1 queries, memory leaks.
   - Audit tests: flag test fluff, mock-only assertions, or bloat that doesn't test real user flows/stability.
   - Run `prepare-pr` to package. **Do not commit or push without explicit user request.**

## Notes

- Not every phase is mandatory — trivial changes may go research → implement. Name the phases you skip.
- If a sub-agent stalls (narrates without calling tools), resend with an explicit "call the tools now"
  instruction or take the task into the main session.
- Keep `.ai/<task-slug>/` planning docs out of commits (they are working artifacts).
