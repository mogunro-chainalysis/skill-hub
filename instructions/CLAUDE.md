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
9. **Research before writing.** Before writing non-trivial code, search the repo (and consumer/backend repos when relevant) for existing helpers, partial implementations, and adjacent patterns. Prefer extending existing code over adding parallel implementations. Skipping this is the most common cause of architectural rework.
10. **Detect full-stack scope.** When a task touches a layer with consumers (published library, shared API, route resolver, host application) or depends on a backend, read both ends before proposing changes. Confirm scope with the user before drifting into other repos. Symptoms reported in one repo often originate in another.
11. **Verify assumptions against authoritative sources.** When using a library, framework, or API in a non-trivial way (version-specific behavior, edge cases, recently-changed APIs), check the official docs (WebFetch is fine) before assuming. Never invent contracts. Skip verification only for stable, basic usage.
12. **Track domain understanding.** When custom domain terms appear (project-specific concepts, not language/framework primitives), consult and update `.ai/domain-glossary.md` via `build-domain-context`. Verify glossary entries against current code before relying on them — entries can go stale.

## Never

1. Commit markdown planning files or scratch notes to repos.
2. Run tests in watch mode.
3. Push to GitHub without explicit permission.
4. Run `rm` commands without confirmation.
5. Hardcode API keys, secrets, or credentials.
6. Delete or weaken existing tests without explicit direction.
7. Invent API contracts — ask if the endpoint shape is unknown.

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
