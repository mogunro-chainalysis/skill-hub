# Global Agent Skills Hub

A centralized system for sharing skills, agents, and instructions across all agentic
coding tools: **Claude Code**, **OpenCode**, **Codex CLI**, and **Goose**.

## Architecture

```
~/.agents/                          ← This directory (source of truth)
├── skills/                         ← Global SKILL.md skills (agentskills.io format)
│   ├── check-code-quality/
│   ├── plan-infra-changes/
│   └── ...
├── agents/                         ← Global agent definitions
│   ├── claude/                     ← Claude Code (.md, Claude frontmatter)
│   ├── opencode/                   ← OpenCode (.md, OpenCode frontmatter)
│   └── codex/                      ← Codex CLI (.toml format)
├── instructions/
│   ├── AGENTS.md                   ← Global rules (all tools)
│   └── WORKFLOW.md                 ← Ticket-to-PR guide (reference, not loaded)
├── setup.sh                        ← Creates all symlinks
├── add-repo.sh                     ← Sets up a repo for cross-agent compatibility
└── README.md                       ← This file
```

## How Each Tool Discovers Skills

| Path                              | Claude Code | OpenCode | Codex CLI | Goose |
|-----------------------------------|:-----------:|:--------:|:---------:|:-----:|
| `~/.claude/skills/`               | ✅ native   | ✅ fallback | —       | ✅     |
| `~/.agents/skills/`               | —           | ✅ native | ✅ USER  | —     |
| `~/.config/opencode/skills/`      | —           | ✅ native | —        | —     |
| `~/.config/agents/skills/`        | —           | —        | —        | ✅ portable |
| `~/.config/goose/skills/`         | —           | —        | —        | ✅ native |

After running `setup.sh`, all paths symlink to `~/.agents/skills/` so every tool
reads from the same source.

## How Each Tool Discovers Global Instructions

| Path                                | Tool        |
|-------------------------------------|-------------|
| `~/.codex/AGENTS.md`               | Codex CLI   |
| `~/.claude/CLAUDE.md`              | Claude Code |
| `~/.config/opencode/AGENTS.md`     | OpenCode    |
| `~/.config/goose/.goosehints`      | Goose       |

All symlink to `~/.agents/instructions/AGENTS.md`.

## How Each Tool Discovers Global Agents

| Path                               | Tool          | Format |
|------------------------------------|---------------|--------|
| `~/.claude/agents/`               | Claude Code   | `.md` (Claude frontmatter: `tools`, `permissionMode`, `skills`) |
| `~/.config/opencode/agents/`      | OpenCode      | `.md` (OpenCode frontmatter: `mode`, `permission`) |
| `~/.codex/agents/`                | Codex CLI     | `.toml` |

## Setup

```bash
# One-time setup — creates all symlinks
chmod +x ~/.agents/setup.sh
~/.agents/setup.sh
```

## Per-Repo Setup (project-level cross-agent compatibility)

```bash
# Run inside any git repo to add .agents/skills symlink
chmod +x ~/.agents/add-repo.sh
~/.agents/add-repo.sh
```

This creates `.agents/skills/` → `.claude/skills/` symlink in the repo so Codex
can read project-level skills that were written for Claude Code.

## Installing Community Skills

```bash
# Via Codex's skill installer
$skill-installer mattpocock/skills/grill-me

# Via npx
npx skills@latest add mattpocock/skills/tdd

# Manual: clone and symlink/copy
git clone https://github.com/mattpocock/skills.git /tmp/mattpocock-skills
cp -r /tmp/mattpocock-skills/grill-me ~/.agents/skills/
```

Skills installed to `~/.agents/skills/` are instantly available in ALL agents.

## Skill Format (agentskills.io standard)

```
skill-name/
├── SKILL.md          # Required: YAML frontmatter + instructions
├── scripts/          # Optional: executable code
├── references/       # Optional: documentation
└── assets/           # Optional: templates, resources
```

SKILL.md must have:
```markdown
---
name: skill-name
description: What this skill does and when to use it.
---

Step-by-step instructions...
```

## Multi-Layer Hub Architecture

```
~/.agents/                          ← Public Base Hub (repo-agnostic skills, instructions, agents)
├── skills/                         ← Universal skills (write-tests, review-pr, java-engineering, etc.)
├── agents/                         ← Global agent definitions (claude/, opencode/, codex/)
├── instructions/AGENTS.md          ← Global rules across all tools
└── setup.sh                        ← Composes public hub + work overlay

~/.agents-work/                     ← Private Work Overlay (optional, private company repo)
├── skills/                         ← Internal skills (company services, internal deployment, etc.)
├── context/                        ← Internal infrastructure maps, configs, and notes
└── agents/                         ← Internal custom subagents

<work-repo>/                        ← In-Repo Skills (service-specific)
├── .agents/skills/                 ← Native for Codex, OpenCode, Goose
└── .claude/skills/                 ← Native for Claude Code, OpenCode
```

When `setup.sh` runs:
1. All public skills from `~/.agents/skills/` are linked into tool directories (`~/.claude/skills/`, `~/.config/opencode/skills/`, `~/.codex/skills/`, etc.).
2. If `~/.agents-work/skills/` is present, private work skills are cleanly overlaid alongside public skills.
3. In-repo skills in any project repository are picked up automatically by all agents when working in that directory.

## Global vs Private vs Project-Specific Skills

- **Global Public skills** (`~/.agents/skills/`): Universal, repo-agnostic workflows usable in any repo by anyone (code quality, test writing, PR reviews, planning).
- **Private Work Overlay** (`~/.agents-work/skills/`): Company-internal workflows, proprietary APIs, and private infrastructure tooling that must never leak publicly.
- **In-Repo skills** (`<repo>/.agents/skills/` or `<repo>/.claude/skills/`): Service-specific conventions (e.g. scaffolding specific components or endpoints for that repo alone).
