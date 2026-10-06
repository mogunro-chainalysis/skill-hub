---
name: build-domain-context
description: Build and verify a per-repo domain glossary (.ai/domain-glossary.md). Use when project-specific terms appear or for "what does X mean here".
---

# Build Domain Context

Maintain a per-repo glossary of custom domain concepts, each anchored to canonical code so it can be re-verified. Glossaries never cross repos — concepts diverge between projects.

Run only when a real domain term is in scope (unfamiliar domain, a calling skill hits custom terms, a fix or new shared code relies on a domain entity) — not proactively at session start. Formats live in `references/format.md`.

## Procedure

1. **Locate the glossary.** Path: `.ai/domain-glossary.md` at the repo root. Confirm `.ai/` is gitignored (it is per-developer working state, never committed); if not, ask the user to add it before writing. If the file is missing, create it from `references/glossary-template.md`.

2. **Verify every existing entry before trusting it.** Entries go stale as code moves. For each entry, grep for its canonical anchor. If the anchor is missing, renamed, moved, or its shape changed, mark it **🟠 stale** and ask the user to update or remove it. Surface the conflict instead of relying on the entry.

3. **Find new terms in scope.** Scan the PR diff/changed files, ticket text, and files the task touches. Look for custom nouns that appear as type, class, or core function names, recur across files, and would puzzle a new engineer (e.g. `OrderBook`, `TradeEngine`). Skip language, framework, and library concepts.

4. **Draft an entry per term.**
   - Find the canonical definition (`type X`, `class X`, `interface X`, `const X`, primary factory/constructor) and read the surrounding code.
   - Check for clusters — `Order` usually brings `OrderRequest`, `OrderResponse`.
   - Write a 1–2 sentence definition anchored with `file:line`; list 1–3 related terms. No anchor, no entry.

5. **Get user ratification.** Present each draft and ask whether it is correct. The user owns the domain; add only confirmed entries.

6. **Write the glossary.** Use the entry format, sorted alphabetically, kept minimal.

7. **Report back.** Return the verified glossary (or the relevant subset) to the user or invoking skill using the report format, flagging any stale entries.
