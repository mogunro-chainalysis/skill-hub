# Global Agent Instructions

These rules apply to every repository and every session.

## Always

1. Prefer searching/exploring the codebase before planning implementations.
2. Read existing code patterns before writing new code — match the style.
3. Run existing tests after making changes to verify nothing broke.
4. Use the project's package manager (check for pnpm-lock.yaml, yarn.lock, or package-lock.json).
5. Prefer minimal, focused edits over large rewrites.
6. Add all necessary imports when writing new code.
7. Use TypeScript strict mode conventions (no `any`, prefer `unknown` + narrowing).
8. Prefer explicit integration boundaries over hidden self-healing fallbacks. If a clean architectural fix and a local workaround are both possible, choose the clean fix unless the user explicitly wants a temporary stopgap or the cleaner option would materially expand scope.
9. **Research before writing (DRY).** Before writing non-trivial code, search the repo (and consumer/backend repos when relevant) for existing helpers, partial implementations, and adjacent patterns. Code must always be DRY and maintainable — reuse and extend existing patterns instead of adding parallel implementations. Skipping this is the most common cause of architectural rework.
10. **Detect full-stack scope.** When a task touches a layer with consumers (published library, shared API, route resolver, host application) or depends on a backend, read both ends before proposing changes. Confirm scope with the user before drifting into other repos. Symptoms reported in one repo often originate in another.
11. **Verify assumptions against authoritative sources.** When using a library, framework, or API in a non-trivial way (version-specific behavior, edge cases, recently-changed APIs), check the official docs (WebFetch is fine) before assuming. Never invent contracts. Skip verification only for stable, basic usage.
12. **Track domain understanding.** When custom domain terms appear (project-specific concepts, not language/framework primitives), consult and update `.ai/domain-glossary.md` via `build-domain-context`. Verify glossary entries against current code before relying on them — entries can go stale.
13. **Evidence-gate persistent claims.** Before writing "confirmed", "verified", "tested", or "final" into memory, a plan doc, or a PR description, be able to point to the exact evidence — a quotable user observation or a verification step you personally executed. A revision that reverses a prior conclusion must cite the new evidence inline; never let re-reading your own cached research stand in for a fresh test.
14. **Trust direct observation over relayed feedback.** When secondhand or paraphrased review feedback (Slack, email, a summarized comment) conflicts with your own verified research or a prior direct observation, re-verify directly — reproduce in the running app, re-read the source — before revising a working conclusion. Direct observation wins ties; a summary of someone else's opinion doesn't.
15. **Verify user-visible fixes live, with a fresh action.** For UI/behavior bugs, passing unit tests and type checks is necessary but not sufficient. Exercise the actual behavior in the running app using new input or new state — pre-existing data may predate the fix and pass or fail for the wrong reason.
16. **Check proportionality before scaling scope.** Before committing to a cross-repo, cross-service, or infrastructure-level fix, look for an already-working sibling pattern in the same codebase that handles the analogous case — copying it is often the whole fix. Re-confirm the fix's size still matches the bug's actual size before investing further.
17. **Enforce YAGNI and evaluate complexity.** Weigh the benefits and drawbacks of different approaches before coding. Choose the simplest maintainable design. Reject speculative abstractions, premature generalizations, and unnecessary wrapper layers — build only what is required now.
18. **Consider performance proactively.** Evaluate runtime complexity, render cycles, network/database query patterns (avoid N+1 queries), hot-path allocations, and memory footprint.
19. **Test functionally (user flows & stability) over fluff.** Write tests that prove observable user flows and system stability under failure. Never add test bloat: avoid low-value unit tests that merely assert on mocks, test trivial getters/setters, or restate implementation details.

## Never

1. Commit markdown planning files or scratch notes to repos.
2. Run tests in watch mode.
3. Push to GitHub without explicit permission.
4. Run `rm` commands without confirmation.
5. Hardcode API keys, secrets, or credentials.
6. Delete or weaken existing tests without explicit direction.
7. Invent API contracts — ask if the endpoint shape is unknown.
8. Self-approve a "why this isn't scope creep" justification. Treat that argument as a stop sign — put the expansion to the user as an explicit decision instead of proceeding on your own say-so.
9. Write filler or bloat tests that assert mocks, test trivial framework wiring, or inflate coverage without testing real user flows or stability.
10. Introduce speculative abstractions, unused utility functions, or extra wrapper layers violating YAGNI.

## Code Style

- Prefer `type` over `interface` for object shapes.
- Use `readonly` on all type properties.
- Use `??` instead of `||` for null/undefined defaults.
- Prefer named exports over default exports.
- Keep functions focused — one responsibility per function.
- Derive values during render instead of syncing with `useState` + `useEffect`.
- Keep dependency requirements explicit. Prefer wiring shared setup at the integration boundary over making leaf units silently create or recover their own missing prerequisites.

## Git

- Write clear, conventional commit messages.
- Keep commits atomic — one logical change per commit.
- Never force-push to shared branches.
