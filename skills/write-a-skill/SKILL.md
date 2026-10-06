---
name: write-a-skill
description: Create, refine, or audit a skill, agent, or instruction file against hub standards. Use for "write a skill", "review this skill", "audit agents".
---

# Write or Audit Skills, Agents, and Instructions

Standards: `references/standards.md`. Frontmatter and paths per tool: `references/REFERENCE.md`.

## Write

1. **Classify**: skill (procedure), agent (role/tool limits), instruction (always-on rule), or `references/` (long material).
2. **Overlap check**: search `~/.agents/` and the repo's `.agents/skills`, `.claude/skills`. Extend an existing artifact before adding one.
3. **Draft**: numbered imperative steps; tribal knowledge only; `description` ≤ ~150 chars with "Use when/for" triggers; body ≤ ~80 lines; point to other skills and global rules instead of restating them.
4. **Scope**: global artifacts are repo-agnostic and contain no company data (the hub remote is public). Team- or repo-specific knowledge goes in the repo, or in gitignored `~/.agents/.ai/`.
5. **Agents**: write per-tool frontmatter: Claude `agents/claude/*.md`, OpenCode `agents/opencode/*.md`, Codex `agents/codex/*.toml`. Unknown frontmatter keys break OpenCode.
6. Run **Audit** on the result.

## Audit

1. Check against `references/standards.md`. Look for duplicated content, stale cross-references (renamed skills, rule numbers), hardcoded model names, and leaks (company names, internal hosts, account IDs, personal stories).
2. Verify every file path, skill name, and command the artifact cites actually exists.
3. Report **Blocker** (fix now) or **Suggestion**, one line each with `file:line`.
