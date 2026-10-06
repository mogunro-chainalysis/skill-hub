---
name: maintain-skills-hub
description: Audit, update, and maintain the global skills hub (~/.agents). Use for "audit my skills", "clean up the hub", after adding skills.
---

# Maintain the Global Agent Skills Hub

Keep `~/.agents/` healthy, current, and compact. The hub remote is **public**.

## Procedure

1. **Inventory** skills, agents (`claude/`, `opencode/`, `codex/`), commands, and instructions.
2. **Symlinks**: run `bash ~/.agents/setup.sh` and report any WARN lines or broken links.
3. **Audit** each artifact with `write-a-skill` (Audit section). Smoke-test agents: `opencode run --agent <name> "say ok"`.
4. **Scrub**: `grep -rniE` for company names, internal hosts, account IDs, ticket prefixes, personal stories, and model names. Move team-specific content to gitignored `.ai/` or the owning repo.
5. **De-duplicate and condense**: one home per rule. Global rules live in `instructions/AGENTS.md`; skills point to them. Keep descriptions ≤ ~150 chars.
6. **Cross-references**: after any rename or merge, grep for the old names and old rule numbers.
7. **Log** to `references/CHANGELOG.md` (gitignored).
