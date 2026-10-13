---
name: rewrite-application
description: Audit and rewrite a codebase to fulfill user goals while improving code quality and agentic maintainability. Use for "rewrite app", "modernize repo".
---

# Rewrite an Application

Execute an application rewrite that achieves user-defined goals while systematically eliminating spaghetti code, dead weight, and architectural friction. Target architecture must maximize maintainability for AI agents and human engineers alike. Reference: `references/audit-checklist.md`.

## Procedure

1. **Clarify rewrite goals & scope.**
   Prompt the user to confirm the core rewrite drivers (e.g. stack migration, modularization, decoupling monolith). Define non-negotiable behaviors, performance constraints, and external contracts. Persist in `.ai/<task-slug>/rewrite-goal.md`.

2. **Audit current repo & baseline debt.**
   Inspect the existing repo using `determine-patterns`. Catalog friction using `references/audit-checklist.md`:
   - Tight coupling, circular dependencies, God classes, and spaghetti control flows.
   - AI agent friction: untyped boundaries, deep indirection, scattered files, hidden global state.
   - Dead code, unused dependencies, and unmaintained shims.
   Record findings and baseline metrics in `.ai/<task-slug>/audit.md`.

3. **Establish the safety net.**
   Verify existing tests pass. For any critical user journey or integration boundary lacking test coverage, write high-signal functional tests per `write-tests` before editing production code.

4. **Design agentic target architecture.**
   Formulate the target architecture via `tech-design`:
   - Enforce high cohesion and colocation (feature-based organization over layered silos).
   - Minimize indirection: prefer explicit parameters and shallow call trees over deep abstraction layers.
   - Enforce strict typing and input schemas at all boundary edges.
   - Ensure deterministic, fast build/test/lint commands for agent self-verification.
   Confirm design and open questions with the user before writing implementation code.

5. **Decompose into strangler phases.**
   Never perform a big-bang rewrite. Break the migration into ordered, compilable phases using `decompose-ticket` and `split-pr` (<300 lines changed per step). Order: foundation/types → core logic → boundary migrations → consumer cutover.

6. **Execute iteratively & purge debt.**
   For each phase:
   - Implement new modules with clean boundaries and tests.
   - Reroute existing callers to the new implementation.
   - Immediately delete obsolete code, unused utilities, and dead dependencies in the same PR.
   - Run quality audits via `check-code-quality` or `check-java-quality`.
   - Track new domain concepts in `.ai/domain-glossary.md` via `build-domain-context`.

7. **Verify & compare against baseline audit.**
   - Run full test suite, linter, and type checker.
   - Exercise the application live with a fresh end-to-end user action.
   - Review `.ai/<task-slug>/audit.md` to prove all identified debt is resolved and the codebase is measurably cleaner than it started.
