# Platform Documentation Links

Last verified: 2026-03-26

## agentskills.io (Open Standard)

- **Specification**: https://agentskills.io/specification
- **Overview**: https://agentskills.io/home
- **Quickstart**: https://agentskills.io/skill-creation/quickstart
- **GitHub**: https://github.com/agentskills/agentskills
- **Validator CLI**: `skills-ref validate ./my-skill`

## Claude Code

- **Skills docs**: https://docs.anthropic.com/en/docs/claude-code/skills
- **Agents/subagents**: https://docs.anthropic.com/en/docs/claude-code/sub-agents
- **CLAUDE.md**: https://docs.anthropic.com/en/docs/claude-code/memory
- **Global paths**: `~/.claude/skills/`, `~/.claude/agents/`, `~/.claude/CLAUDE.md`
- **Project paths**: `.claude/skills/`, `.claude/agents/`, `CLAUDE.md`
- **Skill frontmatter fields**: name, description, context, disable-model-invocation, user-invocable, allowed-tools, model, effort, hooks, paths, shell, agent
- **Dynamic context**: `!`command`` syntax injects command output

## OpenCode CLI

- **Documentation**: https://opencode.ai/docs
- **GitHub**: https://github.com/nicholasgriffintn/opencode
- **Global paths**: `~/.config/opencode/skills/`, `~/.config/opencode/agents/`, `~/.agents/skills/`, `~/.claude/skills/` (fallback)
- **Project paths**: `.opencode/skills/`, `.claude/skills/`, `.agents/skills/`
- **Agent format**: Markdown (.md) with YAML frontmatter, or JSON in `opencode.json`
- **Instructions**: `AGENTS.md` (global: `~/.config/opencode/AGENTS.md`, fallback: `~/.claude/CLAUDE.md`)
- **Compatibility**: Reads Claude Code skill/agent format natively

## Codex CLI (OpenAI)

- **Skills docs**: https://developers.openai.com/codex/skills
- **Subagents docs**: https://developers.openai.com/codex/subagents
- **Configuration**: https://developers.openai.com/codex/config-basic
- **Global paths**: `~/.agents/skills/` (USER scope), `~/.codex/agents/`, `~/.codex/AGENTS.md`
- **Project paths**: `.agents/skills/` (scanned from CWD up to repo root)
- **Agent format**: TOML (.toml) — requires `name`, `description`, `developer_instructions`
- **Optional agent fields**: `sandbox_mode`, `mcp_servers`, `skills.config`, `nickname_candidates`
- **Skill installer**: `$skill-installer <source>` or `npx skills@latest add <org>/<repo>/<skill>`
- **Optional metadata**: `agents/openai.yaml` for UI customization and invocation policy
- **Progressive disclosure**: Metadata loaded at startup, full SKILL.md loaded on activation

## Goose (Block)

- **Skills guide**: https://block.github.io/goose/docs/guides/context-engineering/using-skills/
- **Skills extension**: https://block.github.io/goose/docs/mcp/skills-mcp/
- **Goosehints guide**: https://block.github.io/goose/docs/guides/context-engineering/using-goosehints/
- **Recipes**: https://block.github.io/goose/docs/guides/recipes/session-recipes
- **GitHub**: https://github.com/block/goose
- **Global paths**: `~/.claude/skills/`, `~/.config/agents/skills/`, `~/.config/goose/skills/`
- **Project paths**: `.claude/skills/`, `.goose/skills/`, `.agents/skills/`
- **Instructions**: `~/.config/goose/.goosehints` (global), `.goosehints` (project)
- **CONTEXT_FILE_NAMES env var**: Makes Goose read `CLAUDE.md`, `AGENTS.md`, etc.
- **Skill priority** (later overrides earlier): `~/.claude/skills/` → `~/.config/agents/skills/` → `~/.config/goose/skills/` → `.claude/skills/` → `.goose/skills/` → `.agents/skills/`

## Community Skill Repositories

- **mattpocock/skills**: https://github.com/mattpocock/skills
  - Planning: write-a-prd, prd-to-plan, prd-to-issues, grill-me, design-an-interface, request-refactor-plan
  - Development: tdd, triage-issue, improve-codebase-architecture
  - Tooling: setup-pre-commit, git-guardrails-claude-code
  - Writing: write-a-skill, edit-article, ubiquitous-language, obsidian-vault
  - Install: `npx skills@latest add mattpocock/skills/<skill-name>`

- **OpenAI official skills**: https://github.com/openai/skills

## Notes

- All platforms converge on the `SKILL.md` format with YAML frontmatter (name + description)
- The `.agents/skills/` path is the emerging portable standard (Codex, OpenCode, Goose)
- The `.claude/skills/` path is the most widely supported fallback (Claude, OpenCode, Goose)
- Never hardcode model names in skills or agents — models are updated and deprecated constantly
