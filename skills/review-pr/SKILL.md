---
name: review-pr
description: Thorough review of a PR or branch diff against its ticket. Use for "review this PR", "code review before merge", pre-merge gating.
---

# Review a Pull Request

A PR review is a quality gate to catch bugs, maintainability problems, and performance issues. Verify every claim against the actual code — assume nothing, confirm everything. When in doubt, request changes.

## Procedure

1. **Get the ticket.**
   Obtain the ticket or acceptance criteria the PR claims to satisfy. **If the user did not paste one in, ask for it (or a link) before reviewing** — a review without the intended behaviour can only catch mechanics, not whether the change is correct or complete. If the user confirms there is no ticket, proceed but note it in the output.

2. **Gather the diff.**
   ```bash
   git diff $(git merge-base origin/HEAD HEAD)...HEAD
   ```

3. **Verify locally** for changes to shared contracts or complex logic. Read the surrounding files and the referenced source of truth (upstream repo, spec, docs) rather than trusting the PR description. Treat any "confirmed/verified by testing" claim in the PR description or a linked plan/memory doc as a claim, not a fact, until it traces to a quoted observation or a repro you can perform yourself.

4. **Size gate.**
   - Over the PR size limit (400): ❌ Blocker. Recommend `split-pr`.

5. **Research gates** (global Always rules: full-stack scope, infra, docs, glossary).
   - **Stack scope.** Check boundaries for cross-repo impact.
   - **Infra impact.** New config, secret, permission, datastore, or service without matching infra/env-repo changes (all envs incl. DR) → finding. See `plan-infra-changes`.
   - **Domain glossary.** Verify custom terms in `.ai/domain-glossary.md`.
   - **Doc verification.** Verify library usage against official docs.

6. **Requirements coverage.**
   - Does the diff satisfy every acceptance criterion in the ticket?
   - Flag anything required but missing, and anything present but outside the ticket's scope.

7. **Scope coherence.**
   Flag unrelated changes or drive-by refactors.

8. **Correctness.**
   - Logic errors, off-by-one bugs, unhandled edge cases?
   - Types correct and specific?
   - **Validate claims against the whole codebase**, not just the diff. Grep for symbols; confirm identifiers, config keys, and paths match character-for-character.

9. **Architecture and patterns.**
   - Follow existing repo patterns? For each new file, find the existing code doing the same job (run `determine-patterns` if unsure) and compare — including how sibling layers call each other and which test suite/harness covers this behavior type. A new convention is a finding unless the PR justifies it.
   - **YAGNI / DRY.** Speculative abstractions or wrappers? Reinvented helpers that already exist?
   - Solved at the right boundary?
   - **Proportionality.** Does the solution's blast radius (new published API, cross-repo change, infra/DB work) match the bug's actual size? If a narrower same-repo fix — especially copying an already-working sibling pattern — looks possible, flag the oversized solution and ask whether it was considered.

10. **Test coverage.**
    - Judge new tests against `write-tests`: user flows, error recovery, no bloat.
    - **Missing tests on new behaviour = ❌ Request Changes.**
    - **Verification discipline.** User-visible fixes need evidence of a fresh-state check in the running app (global "verify user-visible fixes live" rule).

11. **Performance.**
    Flag re-renders, N+1 query patterns, memory leaks, unneeded allocations, or expensive computations on hot paths.

12. **Code quality.**
    Invoke `check-code-quality`, plus `check-java-quality` for Java.

13. **Observability.**
    Logging for new error states or async operations?

14. **Security.**
    No secrets, user input validated.

15. **Cross-cutting.**
    Accessibility (aria labels), i18n (no hardcoded strings).

16. **Verify fix suggestions.**
    Grep-confirm existence and signatures before recommending. Label unverified fixes as **🟠 Speculative**.

## Output

Use `references/output.md`.
