# Review Output Template

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

### Infra Impact
- <matching infra/env-repo changes for all envs incl. DR ✅ / missing ❌ / n/a>

### Test Coverage
- <finding or ✅>
- Suite: ✅ passing / ❌ failing

### Code Quality
- check-code-quality: ✅ / ❌
- check-java-quality: ✅ / ❌ / n/a

---

### Summary
- 🔴 Must Fix: <count>
- 🟡 Should Fix: <count>
- 🟠 Speculative: <count>

### Verdict: ✅ APPROVE / ❌ REQUEST CHANGES
```
