---
name: write-a-skill
description: Create or refine a skill, agent, or instruction file.
---

# Write or Refine Skills, Agents, and Instructions

## Procedure

1. **Classify**: Skill (procedure), Agent (role), or Instruction (always-on rule).
2. **Overlap check**: Scan `~/.agents/` and `.claude/` for existing artifacts.
3. **Inputs**: Define purpose, triggers, output, safety, and scope.
4. **Draft Rules**:
   - Write procedures (numbered steps, imperative verbs).
   - Encode tribal knowledge only.
   - Use `description` as the main trigger surface.
   - Keep compact (body < 5000 tokens).
   - Global skills must be repo-agnostic.
5. **Pathing**:
   - Global skill: `~/.agents/skills/<name>/SKILL.md`.
   - Global agent: `.md` (Claude) + `.toml` (Codex).
6. **Review**: Run `review-skill` gate.
