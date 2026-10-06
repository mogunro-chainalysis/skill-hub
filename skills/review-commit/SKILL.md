---
name: review-commit
description: Review staged changes and write a commit message. Use for "review my staged changes", "ready to commit?".
---

# Review a Commit

Audit staged changes to ensure each commit is clean, focused, and production-ready.

## Procedure

1. **Gather staged changes.**
   ```bash
   git diff --staged
   ```

2. **Check commit scope.**
   A commit should represent one logical change. Flag multiple unrelated concerns.

3. **Apply defensibility standard.**
   Flag code that doesn't fit patterns, overly generic abstractions, or logic that is clever but not obviously correct.

4. **Run quality checks.**
   Invoke `check-code-quality` (plus `check-java-quality` for Java).

5. **Check for common mistakes.**
   - Incomplete changes: missing tests, un-updated barrel files.
   - Sensitive data: API keys, tokens, credential files.

6. **Review readability.**
   Clear naming, complex paths explained (why, not what).

7. **Check commit message.**
   Conventional format: `type(scope): description`. Imperative mood, under 72 characters.

## Output Format

```
## Commit Review

### Scope: ✅ Atomic / ❌ Incomplete
### Code Quality
- check-code-quality: ✅ / ❌

### Commit Hygiene
- Debug artifacts: ✅ / ❌
- Sensitive data: ✅ / ❌

### Suggested Commit Message
<message>

### Verdict: READY TO COMMIT / NEEDS FIXES
```
