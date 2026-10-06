---
name: grill-me
description: Interview the user to stress-test a plan or design. Use for "grill me", "poke holes in this", "challenge my design".
---

# Grill Me

Relentlessly interview the user about a plan or design until shared understanding is reached on every decision branch.

## Procedure

1. **Check context**. Read `.ai/` context files if they exist.
2. **Interview**. Ask one question at a time about tradeoffs, edge cases, scope, and infra/DR impact. Explore the codebase to answer what you can yourself; ask the user only what code can't answer. Start from `tech-design` open questions if they exist.
3. **Persist**. Write resolved decisions to `.ai/<task-slug>/decisions.md`.
