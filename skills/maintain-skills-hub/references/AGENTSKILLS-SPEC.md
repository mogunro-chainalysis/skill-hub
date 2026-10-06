# agentskills.io Specification Summary

Source: https://agentskills.io/specification
Last verified: 2026-03-26

## Directory Structure

```
skill-name/
├── SKILL.md          # Required: metadata + instructions
├── scripts/          # Optional: executable code
├── references/       # Optional: documentation (REFERENCE.md, domain files)
├── assets/           # Optional: templates, images, data files
└── ...               # Any additional files or directories
```

## SKILL.md Format

### Frontmatter (YAML between `---` delimiters)

| Field | Required | Constraints |
|---|---|---|
| `name` | Yes | 1-64 chars, lowercase a-z + hyphens only, no leading/trailing/consecutive hyphens, must match directory name |
| `description` | Yes | 1-1024 chars, describes what the skill does AND when to use it |
| `license` | No | Short license identifier or reference to LICENSE file |
| `compatibility` | No | 1-500 chars, environment requirements (tools, platforms, etc.) |
| `metadata` | No | Map of string→string key-value pairs for custom properties |
| `allowed-tools` | No | Space-delimited list of pre-approved tools |

### Body Content

- Step-by-step instructions
- Examples of inputs and outputs
- Common edge cases
- References to files in `scripts/`, `references/`, `assets/`

## Progressive Disclosure (3 tiers)

1. **Metadata (~100 tokens)**: `name` and `description` loaded at startup for all skills
2. **Instructions (<5000 tokens recommended)**: Full SKILL.md body loaded when skill is activated
3. **Resources (as needed)**: Files in scripts/, references/, assets/ loaded only when required

## Validation

```bash
skills-ref validate ./my-skill
```

## Name Rules

- Valid: `pdf-processing`, `data-analysis`, `code-review`
- Invalid: `PDF-Processing` (uppercase), `-pdf` (leading hyphen), `pdf--processing` (consecutive hyphens)

## Platform-Specific Extensions

### Claude Code additions
- `context: fork` — run in subagent
- `disable-model-invocation: true` — user-only invocation
- `user-invocable: false` — agent-only (background knowledge)
- `agent: Explore` — subagent type
- `model:`, `effort:`, `hooks:`, `paths:`, `shell:` — advanced config

### Codex CLI additions
- `agents/openai.yaml` — UI metadata, invocation policy, tool dependencies
- `allow_implicit_invocation: false` — disable auto-matching
