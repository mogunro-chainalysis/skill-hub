---
name: build-domain-context
description: Build and verify a per-repo domain glossary at .ai/domain-glossary.md.
---

# Build Domain Context

Maintain a verifiable knowledge log of custom domain concepts for this repo. Each entry points to canonical code so the definition can be re-confirmed at any time.

This skill is invoked when domain terms appear that aren't language/framework primitives — the kind of words that mean nothing to a new engineer but everything to the codebase. The glossary is per-repo because concepts diverge between projects.

## When to invoke

- Starting work in an unfamiliar domain
- A planning, review, or pattern-discovery skill encounters custom terms
- The user asks "what does X mean here" about a project-specific concept
- Before recommending a fix that relies on a domain term
- Before writing new shared code that uses domain entities

Never invoke proactively at session start — overhead without trigger. Run only when a real domain term is in scope.

## Procedure

1. **Locate the glossary.**
   - Path: `.ai/domain-glossary.md` in the current repo root.
   - Confirm `.ai/` is gitignored. If `.gitignore` doesn't include `.ai/`, prompt the user to add it before writing.
   - If the file doesn't exist, create it from the template in `references/glossary-template.md`.

2. **Verify existing entries — required before trusting any of them.**
   For each entry already in the glossary:
   - Grep for the canonical type/function/file the entry points to.
   - If the canonical anchor is missing or has changed shape (renamed, signature changed, moved to a different module), mark the entry as **🟠 stale** in your output and prompt the user to update or remove.
   - Do not silently rely on a stale entry. Surface the conflict.

3. **Identify new terms in current scope.**
   Sources to scan:
   - PR diff or changed files (if reviewing/planning a PR)
   - Ticket text or task description
   - Files the current task touches
   
   Look for domain terms that:
   - Are capitalized custom nouns (e.g. `OrderBook`, `TradeEngine`, `AccountManager`)
   - Appear as type names, class names, or core function names
   - Are referenced repeatedly across files
   - Would not be obvious to a new engineer

   Ignore: language primitives, framework concepts, library types, standard patterns.

4. **For each new term, build a draft entry.**
   - Search the repo for the canonical definition: `type X`, `class X`, `interface X`, `const X`, primary factory or constructor.
   - Read the surrounding code to understand the term's role.
   - Check related modules — terms often travel in clusters (e.g. if `Order` is a concept, `OrderRequest`, `OrderResponse` likely are too).
   - Draft a 1–2 sentence definition. Anchor it to the canonical file with `file:line`.
   - List 1–3 related terms if obvious.

5. **Confirm with user before adding.**
   Present each draft entry. Ask whether the definition is correct. The user owns the domain — your job is to draft, theirs is to ratify. Never add a term silently.

6. **Write to glossary.**
   Use the entry format below. Sort entries alphabetically by term. Keep entries minimal — this is a glossary, not documentation.

7. **Surface to invoking skill.**
   When invoked indirectly, return the verified glossary content (or relevant subset) so the calling skill can use it. Note any stale entries.

## Entry format

```markdown
### <Term>
<One- to two-sentence definition. State what the term IS in this repo's domain — not what it does in general.>
Canonical: [file.ts:42](src/path/file.ts#L42)
Related: <Term>, <Term>
```

## Critical rules

- **One repo at a time.** Glossaries do not cross repos.
- **Anchor every entry to code.** No anchor = no entry. The whole point is verifiability.
- **Verify before relying.** A 6-month-old glossary is a liability if entries point to renamed/moved code.
- **User confirms additions.** Drafts are yours; ratification is theirs.
- **Glossary stays minimal.** Definitions, not explanations. Anchors, not narratives.
- **Never commit `.ai/`.** It's per-developer working state, not team documentation.

## Output format (when reporting back)

```markdown
# Domain Glossary: <repo-name>

## Verified entries (✅)
- <count> entries confirmed against current code

## Stale entries (🟠)
- **<Term>** — Canonical anchor missing/changed. Suggested action: <update to new location | remove>.

## New entries proposed
### <Term>
<draft definition>
Canonical: [file:line]
Related: <Term>

## Awaiting user confirmation: <count> proposed entries
```
