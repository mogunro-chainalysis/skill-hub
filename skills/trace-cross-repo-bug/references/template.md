# Cross-Repo Trace Templates

## Working file: `.ai/cross-repo-trace.md`

Create in the primary repo (where the bug was reported). It is the context-window backup — append every meaningful finding.

```markdown
# Cross-Repo Trace: <bug name>

## Symptom
<user-visible behavior, where it appears>

## Hypothesis
<best current guess at root cause and which repo owns it>

## Repos in scope
- **<repo A>** (`/abs/path/to/repo-a`) — <role: consumer | provider | shared>
- **<repo B>** (`/abs/path/to/repo-b`) — <role>

## Data/control flow
<ordered list: where the data is produced → transformed → consumed → rendered>

## Files of interest
<repo>: <file:line> — <why it matters>

## Domain term divergence
<term>: <meaning in repo A> vs <meaning in repo B>

## Findings
<append as you discover things>

## Open questions
<unresolved threads>
```

## Handoff summary (to `plan-pr`, `decompose-ticket`, or the user)

```markdown
# Cross-Repo Trace Summary: <bug name>

## Root cause
<one sentence: which repo, which file, which behavior>

## Affected flow
<repo A>: <file:line> → <repo B>: <file:line> → <repo C>: <file:line>

## Fix scope
- Owning repo: <repo X>
- Coordinated changes needed in: <list, with order>
- Trace file: `.ai/cross-repo-trace.md`

## Recommended next step
- [ ] `plan-pr` for <repo X>
- [ ] `decompose-ticket` if multi-PR coordination needed
```
