---
name: review-pr
description: Thorough, intensive review of a pull request.
---

# Review a Pull Request

A PR review is a quality gate to catch bugs, maintainability problems, and performance issues. When in doubt, request changes.

## Procedure

1. **Gather the diff.**
   ```bash
   git diff main...HEAD
   ```

2. **Verify locally** for changes to shared contracts or complex logic.

3. **Size gate.**
   - **Over 400 lines**: ❌ Blocker. Recommend splitting before review.

3a. **Research gates.**
   - **Stack scope.** Check boundaries for cross-repo impact.
   - **Domain glossary.** Verify custom terms in `.ai/domain-glossary.md`.
   - **Doc verification.** Verify library usage against official docs.

4. **Scope coherence.**
   Flag unrelated changes or drive-by refactors.

5. **Correctness.**
   - Logic errors, off-by-one bugs, unhandled edge cases?
   - Types correct and specific?
   - **Validate claims against the whole codebase**, not just the diff. Grep for symbols.

6. **Architecture and patterns.**
   - Follow existing repo patterns?
   - Appropriate abstraction level?
   - Solved at the right boundary?

7. **Test coverage.**
   - New features covered?
   - Edge cases tested?
   - **Missing tests on new behaviour = ❌ Request Changes.**

8. **Performance.**
   Flag re-renders, N+1 patterns, memory leaks, or expensive computations in render.

9. **Code quality.**
   Invoke `check-code-cleanup`, `check-types`, `check-component-quality`, and `check-java-quality`.

10. **Observability.**
    Logging for new error states or async operations?

11. **Security.**
    No secrets, user input validated.

12. **Cross-cutting.**
    Accessibility (aria labels), i18n (no hardcoded strings).

13. **Verify fix suggestions.**
    Grep-confirm existence and signatures before recommending. Label unverified fixes as **🟠 Speculative**.

## Output Format

```markdown
## PR Review: <branch-name>

### Size: ✅ <N> lines / ❌ <N> lines (must split)
### Scope: ✅ Focused / ❌ Multiple concerns

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
