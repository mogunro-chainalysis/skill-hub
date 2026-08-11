---
name: trace-cross-repo-bug
description: Scaffold structured investigation for bugs spanning multiple repos.
---

# Trace a Cross-Repo Bug

When a bug symptom appears in one repo but the code path crosses repo boundaries, ad-hoc investigation tends to drift, lose track of repo state, and exhaust the context window. This skill enforces structure.

## When to invoke

- A bug report names symptoms in repo A, but the data/control flow clearly originates in repo B.
- An investigation in one repo has stalled and the next file is in another repo.
- The user mentions multiple repos in the same problem description.
- You catch yourself about to `cd` to another repo to investigate.
- Per global instruction #10 ("Detect full-stack scope"), you've identified a consumer/provider boundary in scope.

## Procedure

1. **Check for a same-repo sibling first.** Before confirming cross-repo scope, check whether an existing sibling feature in the *same* repo already handles the analogous case correctly. A working analog is often the fix — finding it first can eliminate the need to cross repo boundaries at all. Only proceed to cross-repo investigation if no such analog exists or it doesn't cover this case.

2. **Confirm cross-repo scope with the user before drifting.**
   State explicitly: "This bug appears to span <repo A> and <repo B>. I'd like to investigate both. Confirm before I expand scope."

2. **Establish a working set.**
   Create `.ai/cross-repo-trace.md` in the primary repo (where the bug was reported). This file persists across context compaction.

    Initial structure:
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

    ## Findings
    <append as you discover things>

    ## Open questions
    <unresolved threads>
    ```

4. **Use `git -C <path>` instead of `cd`.**
   `cd`-ing across repos loses your working-directory anchor. Always use:
   ```bash
   git -C /path/to/repo log --oneline -10
   ```
   For Read/Grep/Glob, use absolute paths.

5. **Map the data/control flow before diving into code.**
   Before reading line-level code, sketch the flow at the module/file granularity:
   - Where is the data **produced**? (backend service, API endpoint, factory)
   - Where is it **transformed**? (adapter, resolver, hook, middleware)
   - Where is it **consumed**? (component, render path, side effect)
   - Where is the **contract defined**? (shared type, OpenAPI spec)
   
   Update `.ai/cross-repo-trace.md` with this sketch.

6. **Invoke `build-domain-context` for cross-boundary terms.**
   Cross-repo bugs often involve domain terms that mean subtly different things in each repo (e.g. `Reference`, `Context`, `Identity`). Run `build-domain-context` per repo and note any divergence in the trace file.

7. **Identify which repo owns the bug.**
   Based on the flow map, narrow down to the responsible repo. If multiple repos need coordinated changes, name them and the order of fixes.

8. **Confirm fix scope before proposing changes.**
   Ask the user: "Fix appears to require changes in <repos>. Confirm before I plan the work." This is when to invoke `plan-pr` or `decompose-ticket`.

9. **Update `.ai/cross-repo-trace.md` continuously.**
   Every meaningful finding goes here. The file is your context-window backup.

## Critical rules

- **Check for a working same-repo sibling first.** Don't assume cross-repo scope — an existing analog may already be the fix.
- **Confirm scope before drifting.** Never silently expand into another repo.
- **`git -C`, not `cd`.** Working-directory drift causes errors.
- **Map the flow before reading code.** Targeted investigation saves time.
- **Persist findings to `.ai/cross-repo-trace.md`.** Survival across context compaction.
- **Run `build-domain-context` per repo.** Same word, different meaning across repos is a classic source of bugs.

## Output format (handoff to plan-pr or user)

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
