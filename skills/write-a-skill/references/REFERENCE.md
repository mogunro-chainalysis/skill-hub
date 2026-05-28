# Write-a-Skill Reference

Frontmatter fields, platform-specific extensions, and directory structure for skills and agents.

## SKILL.md Frontmatter (agentskills.io standard)

| Field | Required | Constraints |
|---|---|---|
| `name` | Yes | 1-64 chars, lowercase a-z + hyphens, no leading/trailing/consecutive hyphens, must match directory name |
| `description` | Yes | 1-1024 chars, describes what the skill does AND when to use it, include realistic trigger phrases |
| `license` | No | Short license identifier or reference to LICENSE file |
| `compatibility` | No | 1-500 chars, environment requirements (tools, platforms) |
| `metadata` | No | Map of string→string key-value pairs for custom properties |
| `allowed-tools` | No | Space-delimited list of pre-approved tools |

## Claude Code Extensions (also supported by OpenCode)

| Field | Purpose |
|---|---|
| `context: fork` | Run in a subagent with isolated context |
| `disable-model-invocation: true` | Only user can invoke (not auto-triggered) |
| `user-invocable: false` | Only agent can invoke (background knowledge) |
| `agent: Explore` | Which subagent type to use with `context: fork` |
| `hooks` | Lifecycle hooks for pre/post processing |
| `paths` | File path filters for skill activation |
| `shell` | Shell environment for script execution |

## Codex CLI: Optional `agents/openai.yaml`

```yaml
interface:
  display_name: "User-facing name"
  short_description: "User-facing description"
  icon_small: "./assets/small-logo.svg"
  brand_color: "#3B82F6"
  default_prompt: "Surrounding prompt for skill invocation"

policy:
  allow_implicit_invocation: false

dependencies:
  tools:
    - type: "mcp"
      value: "serverName"
      description: "MCP server description"
      transport: "streamable_http"
      url: "https://example.com/mcp"
```

## Skill Directory Structure

```
skill-name/
├── SKILL.md              # Required: metadata + instructions
├── scripts/              # Optional: executable code
├── references/           # Optional: detailed docs loaded on demand
│   └── REFERENCE.md
└── assets/               # Optional: templates, resources
```

## Agent File Formats

### Claude Code / OpenCode (`.md`)

```markdown
---
name: agent-name
description: What this agent does and when to use it.
tools: Read, Grep, Glob, Bash
memory: user
skills:
  - skill-a
  - skill-b
---

Agent instructions here. Procedural, not descriptive.
```

No `model:` field — let the tool pick.

### Codex CLI (`.toml`)

```toml
name = "agent_name"
description = "What this agent does and when to use it."
sandbox_mode = "read-only"

developer_instructions = """
Agent instructions here. Procedural, not descriptive.
"""

nickname_candidates = ["Name A", "Name B", "Name C"]
```

No `model` or `model_reasoning_effort` — let the tool pick.

## Global vs Project Paths

| Scope | Path | Platforms |
|---|---|---|
| Global skill | `~/.agents/skills/<name>/` | All (via symlinks) |
| Global agent | `~/.agents/agents/claude/<name>.md` | Claude Code, OpenCode |
| Global agent | `~/.agents/agents/codex/<name>.toml` | Codex CLI |
| Global instructions | `~/.agents/instructions/AGENTS.md` | Codex, OpenCode, Goose |
| Global instructions | `~/.agents/instructions/CLAUDE.md` | Claude Code |
| Project skill | `.claude/skills/<name>/` | Claude Code, OpenCode, Goose |
| Project skill | `.agents/skills/<name>/` | Codex, OpenCode, Goose |
