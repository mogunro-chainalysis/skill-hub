---
description: Orchestrate end-to-end feature delivery across research, grill, plan, split, implement, and review phases.
agent: build
---

Load and follow the `feature-workflow` skill exactly — it is the single source of truth for phases and gates.

OpenCode specifics:

- Subagents: use `@explore` (read-only search), `@researcher` (evidence with citations), `@general` (implementation), `@code-reviewer` (review). Launch independent subagents in one message.
- Model gates: switch the primary agent with **Tab** (`plan` for grill/plan, `build` for implement) or `/model`. Subagents may not inherit the primary agent's model; if a subagent needs a specific model, pin it in `opencode.json` under `agent.<name>.model`.
- If a custom subagent errors with "Extra inputs are not permitted", its frontmatter has a non-OpenCode key — fix it in `~/.agents/agents/opencode/`.

$ARGUMENTS
