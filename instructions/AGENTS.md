# Global Agent Instructions

These rules apply to every repository and every session.

## Always

1. Use the project's package manager (check for pnpm-lock.yaml, yarn.lock, or package-lock.json).
2. Prefer explicit integration boundaries over hidden self-healing fallbacks. If a clean architectural fix and a local workaround are both possible, choose the clean fix unless the user explicitly wants a temporary stopgap or the cleaner option would materially expand scope. Wire shared setup at the integration boundary instead of making leaf units silently create or recover their own prerequisites.
3. **Research before writing (DRY).** Before non-trivial code, search the repo (and consumer/backend repos when relevant) for existing helpers, partial implementations, and adjacent patterns; extend them instead of adding parallel implementations. Procedure: `determine-patterns` step 5.
4. **Determine patterns before planning — for service logic *and* tests.** Run `determine-patterns`: mirror existing code that does the *same job* (search by behavior, across all source sets). "No existing pattern" needs cited searches; put any new convention to the user first.
5. **Detect full-stack scope.** When a task touches a layer with consumers (published library, shared API, route resolver, host app) or depends on a backend, read both ends before proposing changes. Confirm scope with the user before drifting into other repos.
6. **Plan infra with code.** For any change that adds or alters config, secrets, permissions, datastores, routes, or services, run `plan-infra-changes` — including every environment and DR.
7. **Verify assumptions against authoritative sources.** For non-trivial library/framework/API usage (version-specific behavior, edge cases, recent changes), check official docs before assuming. Never invent contracts.
8. **Track domain understanding.** For project-specific terms, consult and update `.ai/domain-glossary.md` via `build-domain-context`; verify entries against current code.
9. **Evidence-gate persistent claims.** Before writing "confirmed", "verified", "tested", or "final" into memory, a plan doc, or a PR description, point to exact evidence — a quotable user observation or a check you ran. A revision that reverses a prior conclusion cites its new evidence inline; re-reading your own cached research is not a fresh test.
10. **Trust direct observation over relayed feedback.** When paraphrased feedback (Slack, email, summarized comments) conflicts with verified research, re-verify directly before revising a working conclusion.
11. **Verify user-visible fixes live, with a fresh action.** Unit tests and type checks are necessary but not sufficient; exercise the behavior in the running app with new input or state.
12. **Check proportionality before scaling scope.** Before a cross-repo, cross-service, or infra-level fix, look for an already-working sibling pattern in the same codebase — copying it is often the whole fix.
13. **YAGNI.** Weigh tradeoffs; choose the simplest maintainable design. No speculative abstractions, premature generalizations, unused utilities, or wrapper layers.
14. **Consider performance proactively.** Runtime complexity, render cycles, query patterns (N+1), hot-path allocations, memory.
15. **Test functionally, without bloat.** Prove observable user flows and stability under failure; no mock-only, trivial-getter, or implementation-restating tests. Procedure: `write-tests`.
16. **Persist task context in `.ai/<task-slug>/`** (ticket, tech-design, ticket-plan, decisions, pr-N-plan, progress). `.ai/` must be gitignored.

## Never

1. Commit planning files or scratch notes (`.ai/`, markdown plans) to repos.
2. Run tests in watch mode.
3. Push to GitHub without explicit permission.
4. Run `rm` commands without confirmation.
5. Hardcode API keys, secrets, or credentials.
6. Delete or weaken existing tests without explicit direction.
7. Self-approve a "why this isn't scope creep" justification — put the expansion to the user as an explicit decision.

## PR Size

One limit everywhere: target under 300 changed lines; over 400 must be split (`split-pr`).

## Git

- Conventional commit messages; atomic commits.
- Never force-push to shared branches.
