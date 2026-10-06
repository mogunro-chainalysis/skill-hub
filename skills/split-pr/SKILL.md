---
name: split-pr
description: Split an oversized branch/PR into stacked, reviewable PRs. Owns the PR size limit. Use for "PR too big", "split this branch".
---

# Split a Pull Request

**Size limit (canonical):** target under 300 changed lines per PR; over 400 must be split. Generated files and lockfiles don't count. For a ticket that hasn't been built yet, use `decompose-ticket` instead.

## Procedure

1. **Measure.** Run `git diff --stat $(git merge-base origin/HEAD HEAD)...HEAD`. Group the files by logical concern: types/contracts, logic, wiring, tests, infra/config.
2. **Plan the stack.** Order the PRs so each one builds, passes tests, and leaves main deployable. Contracts go before consumers, and infra before the code that needs it. Tests ship with the code they cover. Show the plan (branch names, files, line counts) and get approval.
3. **Execute without losing work.**
   - Create the first branch from the base: `git switch -c <name>-1 <base>`.
   - Bring in whole files with `git checkout <orig> -- <paths>`, or parts of files with `git checkout -p <orig> -- <path>`.
   - Commit, then branch the next PR from the previous one.
   - Keep the original branch untouched until every split is verified.
4. **Verify each branch.** Build, type-check and test. Confirm the stack's combined diff equals the original: `git diff <orig> <last-split>` should be empty.
5. **Open PRs only on request.** When asked, open each PR against the previous branch, and retarget each to main as the one below it merges.
