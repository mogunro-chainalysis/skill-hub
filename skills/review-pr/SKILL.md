---
name: review-pr
description: Thorough, intensive review of a pull request or branch diff against its ticket. Use for "review this PR", "code review before merge", or pre-merge quality gating.
---

# Review a Pull Request

A PR review is a quality gate to catch bugs, maintainability problems, and performance issues. Verify every claim against the actual code — assume nothing, confirm everything. When in doubt, request changes.

## Procedure

1. **Get the ticket.**
   Obtain the ticket or acceptance criteria the PR claims to satisfy. **If the user did not paste one in, ask for it (or a link) before reviewing** — a review without the intended behaviour can only catch mechanics, not whether the change is correct or complete. If the user confirms there is no ticket, proceed but note it in the output.

2. **Gather the diff.**
   ```bash
   git diff main...HEAD
   ```

3. **Verify locally** for changes to shared contracts or complex logic. Read the surrounding files and the referenced source of truth (upstream repo, spec, docs) rather than trusting the PR description. Treat any "confirmed/verified by testing" claim in the PR description or a linked plan/memory doc as a claim, not a fact, until it traces to a quoted observation or a repro you can perform yourself.

4. **Size gate.**
   - **Over 400 lines**: ❌ Blocker. Recommend splitting before review.

5. **Research gates.**
   - **Stack scope.** Check boundaries for cross-repo impact.
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
   - Follow existing repo patterns?
   - **Complexity & YAGNI.** Did the PR introduce speculative abstractions, unnecessary interfaces, or extra wrapper layers? Enforce simplest maintainable design.
   - **DRYness.** Did the PR reinvent utilities, helpers, or components that already exist elsewhere in the codebase?
   - Solved at the right boundary?
   - **Proportionality.** Does the solution's blast radius (new published API, cross-repo change, infra/DB work) match the bug's actual size? If a narrower same-repo fix — especially copying an already-working sibling pattern — looks possible, flag the oversized solution and ask whether it was considered.

10. **Test coverage.**
    - User flows and system stability covered?
    - Edge cases and error recovery tested?
    - **Useful, not just present?** Judge new tests against `write-tests` — flag test fluff, mock-only verifications, or tests that restate the implementation.
    - **Missing tests on new behaviour = ❌ Request Changes.**
    - **Verification discipline.** For bug fixes affecting user-visible/UI behavior, confirm the fix was exercised with fresh state in the running app — not just pre-existing data, which may predate the fix and pass or fail for the wrong reason. Unit/type checks alone are not sufficient evidence.

11. **Performance.**
    Flag re-renders, N+1 query patterns, memory leaks, unneeded allocations, or expensive computations on hot paths.

12. **Code quality.**
    Invoke `check-code-cleanup`, `check-types`, `check-component-quality`, and `check-java-quality`.

13. **Observability.**
    Logging for new error states or async operations?

14. **Security.**
    No secrets, user input validated.

15. **Cross-cutting.**
    Accessibility (aria labels), i18n (no hardcoded strings).

16. **Verify fix suggestions.**
    Grep-confirm existence and signatures before recommending. Label unverified fixes as **🟠 Speculative**.

## Output Format

```markdown
## PR Review: <branch-name>

### Ticket: <id/link, or ⚠️ none provided>
### Size: ✅ <N> lines / ❌ <N> lines (must split)
### Scope: ✅ Focused / ❌ Multiple concerns

### Requirements Coverage
- <criterion met ✅ / missing ❌ / out-of-scope ⚠️>

### Correctness
- <finding or ✅>

### Architecture & Patterns
- <finding or ✅>

### Test Coverage
- <finding or ✅>
- Suite: ✅ passing / ❌ failing

### Code Quality
- check-code-cleanup: ✅ / ❌
- check-types: ✅ / ❌
- check-component-quality: ✅ / ❌
- check-java-quality: ✅ / ❌

---

### Summary
- 🔴 Must Fix: <count>
- 🟡 Should Fix: <count>
- 🟠 Speculative: <count>

### Verdict: ✅ APPROVE / ❌ REQUEST CHANGES
```
