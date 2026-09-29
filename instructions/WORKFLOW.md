# Development Workflow: Ticket to PR Review

A chronological guide for taking a feature request or ticket through planning, implementation, and review using the skills and agents in `~/.agents/`.

Every prompt below is meant to be run in an AI agent (Claude Code, Codex, Windsurf, etc.). Copy-paste and fill in the `<placeholders>`.

---

## Prerequisites

- The `.agents/` skills and agents are symlinked (run `~/.agents/setup.sh` if not).
- The target repo has `.ai/` in its `.gitignore`.

---

## Phase 1: Decompose the Ticket

**Where**: Any agent, in the primary repo.

```
Break this down into PRs:

<paste ticket text or feature request here>
```

**What happens**: The agent runs `decompose-ticket` — explores the repos, groups changes into PRs, defines scope/acceptance criteria, and saves the plan to `.ai/<task-slug>/ticket-plan.md`.

**You're done when**: The agent has written `.ai/<task-slug>/ticket-plan.md` and `.ai/<task-slug>/progress.md`.

---

## Phase 2: Stress-Test the Plan

**Where**: Same agent or new session, same repo. (*Model*: Switch to your reasoning/architecture model, e.g. `/model opus` or Tab to `plan`).

```
Grill me on the plan in .ai/<task-slug>/ticket-plan.md
```

**What happens**: The agent runs `grill-me` — asks one architectural/scoping question at a time, explores the codebase to validate assumptions, and forces you to resolve ambiguities. After the session it saves decisions to `.ai/<task-slug>/decisions.md`.

**You're done when**: All branches of the decision tree are resolved and `.ai/<task-slug>/decisions.md` exists.

**Skip if**: The task is small, single-repo, and unambiguous.

---

## Phase 3: Plan the First PR

**Where**: Any agent, in the repo where the PR will land.

```
Read .ai/<task-slug>/ticket-plan.md and .ai/<task-slug>/decisions.md. Plan PR <N>.
```

**What happens**: The agent runs `plan-pr` — traces code paths, verifies existing helpers to ensure DRYness, applies YAGNI and evaluates complexity tradeoffs, assesses performance, plans lean functional tests for user flows and stability (ruling out test bloat), lists every file to create/modify/delete, estimates size, and saves the plan to `.ai/<task-slug>/pr-<N>-plan.md`.

**You're done when**: `.ai/<task-slug>/pr-<N>-plan.md` exists with a file-level plan and implementation order.

---

## Phase 4: Implement the PR

**Where**: Any agent, in the repo where the PR will land. (*Model*: Switch back to your implementation model, e.g. `/model sonnet` or Tab to `build`).

```
Read .ai/<task-slug>/pr-<N>-plan.md, .ai/<task-slug>/decisions.md, and .ai/<task-slug>/ticket-plan.md. Implement the plan step by step, following the implementation order. Follow project conventions and existing patterns. Do not touch code outside the PR scope.
```

**What happens**: The agent writes code following the plan. It reuses existing utilities (DRY), keeps implementations performant and simple (YAGNI), and writes high-signal functional tests covering real user flows and failure stability without adding test bloat. It should follow the implementation order, use the project's conventions, and stay within scope.

**Course-correct if needed**:

```
Check .ai/<task-slug>/decisions.md — the decision was <X>. Follow the plan.
```

**You're done when**: All implementation steps from the plan are complete and tests pass.

---

## Phase 5: Review Your Commit(s)

**Where**: Same agent, same repo. Run before or after staging.

```
Review my staged changes for commit quality
```

**What happens**: The agent runs `review-commit` — checks for clean code, atomic scope, debug artifacts, and generates a conventional commit message.

**You're done when**: Changes are committed with a clean message.

---

## Phase 6: Prepare the PR

**Where**: Same agent, same repo. Run after all commits are ready.

```
Prepare this PR for review
```

**What happens**: The agent runs `prepare-pr` — verifies branch state, checks PR size (warns >400, blocks >600 lines), runs quality checks (`check-code-cleanup`, `check-types`, `check-component-quality`, `check-styling`), runs tests, and generates a PR title + description. Updates `.ai/<task-slug>/progress.md`.

**You're done when**: PR title and description are generated, all checks pass.

---

## Phase 7: Review the PR

**Where**: Same agent, same repo.

```
Review this PR
```

**What happens**: The agent runs `review-pr` — intensive review covering correctness, architecture, test coverage, type safety, DS compliance, security, accessibility, and performance.

**You're done when**: All findings are addressed or explicitly accepted. Open the PR.

---

## If the Ticket Has Multiple PRs

After the current PR merges, repeat Phases 3–7 for the next PR in the dependency chain:

1. Switch to the repo where the next PR lands.
2. If the next PR depends on a package published in the previous PR, update the dependency first.
3. Run Phase 3 (plan), Phase 4 (implement), Phase 5 (commit review), Phase 6 (prepare), Phase 7 (PR review).

The `.ai/<task-slug>/` files in each repo carry forward the full context — ticket plan, decisions, and progress — so any agent in any session can pick up where you left off.

---

## Quick Reference

| Phase | Prompt | Skill | Output |
|---|---|---|---|
| 1 | `Break this down into PRs: <ticket>` | `decompose-ticket` | `ticket-plan.md`, `progress.md` |
| 2 | `Grill me on the plan in .ai/<slug>/ticket-plan.md` | `grill-me` | `decisions.md` |
| 3 | `Read .ai/<slug>/... Plan PR <N>` | `plan-pr` | `pr-<N>-plan.md` |
| 4 | `Read .ai/<slug>/... Implement the plan` | *(implementation)* | Code changes |
| 5 | `Review my staged changes for commit quality` | `review-commit` | Clean commits |
| 6 | `Prepare this PR for review` | `prepare-pr` | PR title + description |
| 7 | `Review this PR` | `review-pr` | Review findings |

---

## Context Persistence

All planning artifacts live in `.ai/<task-slug>/` in each repo (gitignored). This enables:

- **Resuming across sessions**: Agent reads `.ai/` files to restore context.
- **Switching agents**: Any agent can read the same files on disk.
- **Parallel tasks**: Each task gets its own subfolder (e.g., `.ai/export-identify-entity/`, `.ai/fix-thread-focus/`).
- **Cross-repo tickets**: Each repo has its own `.ai/<task-slug>/` with the relevant subset of context.
