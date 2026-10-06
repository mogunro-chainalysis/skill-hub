---
name: trace-cross-repo-bug
description: "Investigate a bug whose symptom and cause are in different repos (frontend/backend, library/consumer, app/infra). Use when a bug spans repos."
---

# Trace a Cross-Repo Bug

Ad-hoc cross-repo investigation drifts, loses track of repo state, and exhausts the context window. Invoke this as soon as the next file you need is in another repo — before `cd`-ing anywhere. Templates live in `references/template.md`.

## Procedure

1. **Rule out a same-repo sibling.** Check whether a sibling feature in the same repo already handles the analogous case correctly; if it does, that is likely the fix and no cross-repo trace is needed.

2. **Confirm cross-repo scope.** Tell the user: "This bug appears to span <repo A> and <repo B>. Confirm before I expand scope." Wait for a yes.

3. **Create the trace file.** Write `.ai/cross-repo-trace.md` in the primary repo (where the bug was reported) from the template. It survives context compaction.

4. **Anchor to absolute paths.** Run git as `git -C /abs/path/to/repo …` and pass absolute paths to Read/Grep/Glob. Leave the working directory unchanged — `cd` drift causes wrong-repo commands.

5. **Map the flow before reading line-level code.** At module/file granularity, record in the trace file where the data is:
   - **produced** (service, endpoint, factory)
   - **transformed** (adapter, resolver, hook, middleware)
   - **consumed** (component, render path, side effect)
   - **contracted** (shared type, OpenAPI spec)

6. **Compare domain terms across repos.** Run `build-domain-context` in each repo. The same word (`Reference`, `Context`, `Identity`) often means subtly different things on each side — a classic root cause. Log divergences in the trace file.

7. **Identify the owning repo.** Narrow to the responsible repo from the flow map. If several need coordinated changes, name them and the fix order.

8. **Confirm fix scope.** Ask: "Fix appears to require changes in <repos>. Confirm before I plan the work." Then hand off to `plan-pr` (single repo) or `decompose-ticket` (multi-PR) using the handoff summary template.

Append every meaningful finding to the trace file throughout.
