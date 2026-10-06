---
name: feature-workflow
description: Run feature end-to-end through research, grill, plan, split, implement, and review with human gates. Use for feature workflow, multi-PR features.
---

# Feature Workflow

You are the conductor: delegate parallel, read-heavy work to subagents that return conclusions citing `file:line`. Keep decisions and gates in the main session. Global rules (DRY, YAGNI, performance, functional tests, infra) apply in every phase; they are not restated here.

## Procedure

0. **State.** Pick a `<task-slug>`, read any existing `.ai/<task-slug>/`, and create `progress.md` listing the six phases.

1. **Research (parallel subagents).** In one message, spawn independent questions:
   - existing helpers and patterns (`determine-patterns`)
   - consumer/backend boundaries
   - infra impact (`plan-infra-changes`)
   Record the results in `research.md`.

> 🛑 **GATE — switch to reasoning model.** An agent can't change its own model. Stop and say: *"Research is complete. Switch to your strongest reasoning model or planning agent (e.g. `/model`, or Tab to `plan` in OpenCode), then reply to start the Grill phase."* Wait for confirmation.

2. **Grill.** Run `grill-me` seeded with the research. Cover:
   - the minimal sufficient solution
   - tradeoffs between approaches
   - performance constraints
   - which user flows the tests must prove
   Persist the answers to `decisions.md`.

3. **Plan.** Run `tech-design` for approach tradeoffs, then `plan-pr` for the file-level plan. Get explicit approval, then persist to `pr-<N>-plan.md`.

4. **Split (gate).** If the work exceeds the PR size limit or mixes independent concerns, run `split-pr` and confirm the split with the human. Otherwise say "no split" and move on.

> 🛑 **GATE — switch to implementation model.** Stop and say: *"Planning is approved. Switch back to your default implementation model or build agent (e.g. `/model`, or Tab to `build`), then reply to begin implementation."* Wait for confirmation.

5. **Implement.** Use one subagent per split PR or independent task.
   - Follow the plan and `write-tests`.
   - Run formatters, linters, type checks and tests.
   - Update `progress.md`.

6. **Review.** Run the `code-reviewer` agent and/or `review-pr` on the diff, then `prepare-pr`. **Never commit or push without an explicit request.**

## Notes

- Trivial changes may skip phases. Name the ones you skip.
- If a subagent narrates instead of calling tools, resend with "call the tools now", or do the task in the main session.
- Never gate-skip: model switches, grill answers, plan approval, split decision, commit/push.
