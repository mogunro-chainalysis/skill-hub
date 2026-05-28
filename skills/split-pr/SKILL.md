---
name: split-pr
description: Split a large pull request into smaller PRs.
---

# Split a Pull Request

Split a large PR into smaller, sequential, independently reviewable PRs.

## Procedure

1. **Analyze**: Identify logical boundaries and dependencies.
2. **Plan**: Generate a sequence of branches and merge order.
3. **Execute**: Use git commands to cherry-pick or move changes.
4. **Verify**: Ensure each intermediate PR passes tests and compiles.

