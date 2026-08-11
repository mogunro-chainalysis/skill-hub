---
description: Orchestrate a feature from idea to reviewed PRs across six phases (research, grill, plan, split, implement, review), delegating background work to Task-tool subagents and keeping decision points with the human. opencode port of the Claude Code `feature-workflow` skill.
agent: build
---

# Feature Workflow (opencode)

Conductor for multi-phase feature delivery, ported from the Claude Code `feature-workflow` skill. Same
six phases and human gates; the delegation and model-pinning mechanics differ because opencode's
architecture is command + agent + skill rather than skill-as-orchestrator. Skills here (`grill-me`,
`tech-design`, `plan-pr`, `split-pr`, `review-pr`, `prepare-pr`) are auto-loaded reference material — you
can't invoke them directly, but this command's phases reference them so the active agent picks them up.

## Core principles

- **Delegate breadth, keep judgment.** Fan read-heavy, parallelizable work out to Task-tool subagents
  (`@researcher`, `@code-reviewer`, `@general`, `@explorer`); keep interactive and decision work in this
  session.
- **Persist state.** Write durable artifacts to `.ai/<task-slug>/` so work survives context
  compaction. One folder per task.
- **Gate on the human.** Never auto-advance past a decision point (grill answers, plan approval, split
  decision, commit/push).
- **Subagents execute, not narrate.** Instruct every subagent to call tools and cite `file:line`, never
  to describe what it is about to do.
- **Model is pinned per agent in config, not switched at runtime.** Subagents spawned via the Task tool
  do not reliably inherit the parent session's active model (open opencode bug — subagent model
  inheritance falls back to the global default instead of the caller's model). Each agent's model is set
  in `opencode.jsonc`'s `agent` block instead: `build`→sonnet, `plan`→opus, `researcher`→sonnet,
  `code-reviewer`→opus, `explore`→haiku, `general`→sonnet. Don't rely on switching mid-session to change
  a subagent's model — switch the *primary* agent (Tab) at phase boundaries instead, since that's the
  one axis opencode does apply live.

## Procedure

0. **Set up state.** Choose a `<task-slug>`. Create `.ai/<task-slug>/` and a `progress.md` tracking the
   six phases. Read any existing `.ai/` context first.

1. **Research (subagents, parallel).** *Runs on: researcher/general → sonnet; explore → haiku for a
   single narrow lookup.* Identify the independent questions. Invoke `@researcher` (or `@general`) once
   per question — for git/gh/grep/build-heavy digging — or `@explore`/`@explorer` for a pure "where is
   X" lookup. Each must run tools and report file paths + key lines, not summaries. Record findings in
   `.ai/<task-slug>/research.md`.

2. **Grill (this session).** *Switch to the `plan` primary agent now (Tab) — pinned to opus in config,
   and edit-restricted, which suits an interview phase.* Seed the interview with the research findings.
   Ask the human every open decision branch — trust model, authz, config shape, versions, test strategy,
   scope. Write resolved decisions to `.ai/<task-slug>/decisions.md`. Re-reconcile whenever the human
   changes their mind.

3. **Plan.** *Stay on the `plan` primary agent.* Work out approach tradeoffs and a file-by-file plan.
   Get explicit approval from the human. Persist to `.ai/<task-slug>/pr-<N>-plan.md`.

4. **Split (gate).** If the work exceeds ~400 lines / 8 hours or spans independent concerns, break it
   into sequential, independently reviewable PRs. Confirm the split with the human before implementing.
   Small changes skip this — say so and move on.

5. **Implement.** *Switch back to the `build` primary agent (Tab) — pinned to sonnet.* One `@general`
   subagent per split PR / independent task. Subagents follow the plan and repo conventions, run the
   formatter and tests, and report changes + deviations. Do serial/same-file work in this session.
   Update `progress.md` as steps complete.

6. **Review.** *`@code-reviewer` is pinned to opus in config, independent of the active primary agent.*
   Invoke `@code-reviewer` against the diff. Address findings, then package the PR description.
   **Do not commit or push without an explicit request**; if on the default branch or a mismatched
   branch, branch first and confirm the target.

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
