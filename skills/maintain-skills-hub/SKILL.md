---
name: maintain-skills-hub
description: Audit, update, and maintain the global skills hub.
---

# Maintain the Global Agent Skills Hub

Keep `~/.agents/` healthy, current, and maximally effective.

## Procedure

1. **Inventory**: Catalog skills, agents, and instructions.
2. **Symlink Check**: Report broken links. Fix with `bash ~/.agents/setup.sh`.
3. **Quality Audit**: Run `review-skill` on each artifact.
4. **Scrub**: Ensure no company-specific data or personal stories exist.
5. **Optimize**: Shorten descriptions to reduce token usage.
6. **Log**: Update `references/CHANGELOG.md` (if not gitignored).
