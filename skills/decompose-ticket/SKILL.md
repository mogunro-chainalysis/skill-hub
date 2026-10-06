---
name: decompose-ticket
description: "Break a ticket into ordered, right-sized PRs across one or more repos (incl. infra). Use for 'break this down into PRs', 'plan this ticket'."
---

# Decompose a Ticket into Pull Requests

Persist to `.ai/<task-slug>/` (must be gitignored — confirm before writing).

## Procedure

1. **Check for existing context.** List `.ai/` subdirectories. If a matching task folder exists, read its files, summarize what exists, and ask whether to resume or start fresh.

2. **Check the gates.**
   - Requirements complete (problem statement, success criteria, scope)? If not, invoke `write-ticket`.
   - Non-trivial approach agreed? If not, invoke `tech-design`.
   - Total work fits the **12 coding-hour ticket cap**? If not, flag it and split the ticket before splitting into PRs.

3. **Parse the ticket.** Read `.ai/<task-slug>/ticket.md`, $ARGUMENTS, or the conversation. List each discrete deliverable.

4. **Explore the repos involved.** Read integration points. If the repo lacks AI guidance, invoke `determine-patterns` for the minimum planning context. Invoke `plan-infra-changes`; any infra/env-repo PRs it lists (including DR) join the plan, ordered provision → consume.

5. **Group changes into PRs.**
   - One PR per repo per logical boundary; each independently reviewable and leaving the codebase unbroken.
   - Size per `split-pr` (target <300 lines changed, hard limit 400).
   - Tests, observability, and type coverage belong in each PR — never a trailing "cleanup" PR.
   - A PR that changes a shared unit's runtime contract includes its consumer migrations, unless a staged rollout is explicitly planned.
   - Surface any "this isn't scope creep" inclusion to the user as an explicit yes/no.

6. **Estimate each PR in coding hours.** S <2h · M 2–4h (one session) · L 4–8h (two sessions, the per-PR maximum) · XL >8h → find the split point before continuing.

7. **Order dependencies.** Mark what must merge first, what can run in parallel, and any publish/link steps between repos.

8. **Define each PR:** repo and branch, scope in/out, binary acceptance criteria (tests passing, types clean, no regressions), test strategy, observability need (yes/no + note), size (lines + hours), dependencies, risks.

9. **Stress-test and confirm.** Check for hidden coupling points and parallelization opportunities, then present the plan and ask the user to confirm or adjust.

10. **Pick the task slug.** Kebab-case from the ticket title; confirm if ambiguous.

11. **Persist the approved plan.** Write `.ai/<task-slug>/ticket-plan.md` in the primary repo using `references/template.md`. For multi-repo tickets, write the dependency graph plus that repo's scope into each additional repo. Create `.ai/<task-slug>/progress.md` listing every PR as "not started".
