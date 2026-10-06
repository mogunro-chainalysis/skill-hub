---
name: update-frontend-dependencies
description: Update frontend dependencies incrementally and safely. Use for "update deps", "bump packages", Renovate/Dependabot backlogs.
---

# Update Frontend Dependencies

## Procedure

1. **Analysis**: Identify package manager via lockfiles. Run audit/list to identify stale packages.
2. **Planning**: Create incremental update batches. Plan intermediate steps for 3+ major versions.
3. **Execution**: Use specified Node version. Update in logical batches (Core → Build → Deps → DevDeps). Run tests/lint/build after each batch.
4. **Safety**: Consult changelogs. Never use `--force`. Never use `--legacy-peer-deps`.
5. **Tracking**: Maintain progress at `.ai/dependency-update/update-progress.md`.
