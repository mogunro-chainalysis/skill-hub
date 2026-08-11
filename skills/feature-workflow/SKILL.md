---
name: feature-workflow
description: Orchestrate a feature from idea to reviewed PRs across six phases (research, grill, plan, split, implement, review), delegating background work to sub-agents and keeping decision points with the human. Use when taking on a non-trivial feature, migration, or cross-cutting change and you want a repeatable, context-efficient flow. Triggers: "run the full workflow", "research to review", "use the feature workflow", "orchestrate this feature".
---

# Feature Workflow

Conductor for multi-phase feature delivery. This skill does **not** replace the phase skills — it
sequences them, enforces the human gates, and encodes the sub-agent delegation discipline that keeps
the main context small.

## Core principles

- **Delegate breadth, keep judgment.** Fan read-heavy, parallelizable work out to sub-agents; keep
  interactive and decision work in the main session. A sub-agent returns a conclusion, not a file dump.
- **Parallelize research.** Launch independent research sub-agents in a single message so they run
  concurrently.
- **Persist state.** Write durable artifacts to `.ai/<task-slug>/` so work survives context
  compaction. One folder per task.
- **Gate on the human.** Never auto-advance past a decision point (grill answers, plan approval,
  split decision, commit/push).
- **Sub-agents execute, not narrate.** Instruct every sub-agent to call tools and cite `file:line`,
  never to describe what it is about to do. Prefer the `researcher` agent (or `general-purpose`) for
  research that needs `git`/`gh`/grep/build; a purely read-only explorer can stall on shell tasks.
- **Match model to phase.** Sub-agents (`Agent` tool `model` param) default to sonnet; use opus for
  judgment-heavy work and haiku for narrow lookups — see the per-phase notes below. Switching the
  *main session's* model mid-workflow (`/model <name>`) needs no re-reading: Claude Code carries the
  full transcript to whichever model is active, so switch at the phase boundary and switch back after.

## Procedure

0. **Set up state.** Choose a `<task-slug>`. Create `.ai/<task-slug>/` and a `progress.md` tracking
   the six phases. Read any existing `.ai/` context first.

1. **Research (sub-agents, parallel).** *Model: sonnet default; haiku for a single narrow lookup.*
   Identify the independent questions (e.g. "how is X done in this repo", "how does a reference PR do
   it", "what does the upstream/consumer repo expect"). Spawn one sub-agent per question in a single
   message. Each must run tools and report file paths + key lines, not summaries. Consolidate with
   `determine-patterns`. Record findings.

2. **Grill (main session).** *Model: switch to opus here for architecturally significant decisions
   (`/model opus`) — no need to re-read anything, the transcript carries over.* Invoke `grill-me`
   seeded with the research. Interview the human on every open decision branch — trust model, authz,
   config shape, versions, test strategy, scope. Do this in the main session; never background it.
   Write resolved decisions to `.ai/<task-slug>/decisions.md`. Re-reconcile the whole set whenever the
   human changes their mind.

3. **Plan.** *Model: stay on opus.* Optionally run `tech-design` for approach tradeoffs and
   `decompose-ticket` for subtasks, then `plan-pr` for a file-by-file plan. Keep it in the main session
   and get explicit approval. Persist to `.ai/<task-slug>/pr-<N>-plan.md`.

4. **Split (gate).** If the work exceeds ~400 lines / 8 hours or spans independent concerns, run
   `split-pr` to break it into sequential, independently reviewable PRs. Confirm the split with the
   human before implementing. Small changes skip this — say so and move on.

5. **Implement.** *Model: switch back to sonnet before spawning implement sub-agents (`/model sonnet`).*
   One sub-agent per split PR / independent task. Sub-agents follow the plan and repo conventions, run
   the formatter and tests, and report changes + deviations. Use worktree isolation when parallel
   agents would touch the same files. Do serial/same-file work in the main session. Update
   `progress.md` as steps complete.

6. **Review.** *Model: opus for high-stakes diffs (security, architecture-changing); sonnet for
   routine PRs.* Run a review sub-agent (`code-reviewer` or `general-purpose`) and/or `review-pr`
   against the reference. Then `prepare-pr` to package. **Do not commit or push without an explicit
   request**; if on the default branch or a mismatched branch, branch first and confirm the target.

## Notes

- Not every phase is mandatory — trivial changes may go research → implement. Name the phases you skip.
- If a sub-agent stalls (narrates without calling tools), resend with an explicit "call the tools now"
  instruction or take the task into the main session.
- Keep `.ai/<task-slug>/` planning docs out of commits (they are working artifacts).
