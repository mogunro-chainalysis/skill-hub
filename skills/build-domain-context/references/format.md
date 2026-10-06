# Glossary Formats

New glossary files start from `glossary-template.md` in this directory.

## Entry format

Sort entries alphabetically by term. Definitions, not explanations; anchors, not narratives.

```markdown
### <Term>
<One- to two-sentence definition. State what the term IS in this repo's domain — not what it does in general.>
Canonical: [file.ts:42](src/path/file.ts#L42)
Related: <Term>, <Term>
```

## Report format (returned to the user or invoking skill)

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
