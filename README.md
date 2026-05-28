# Global Agent Skills Hub

A centralized system for sharing skills, agents, and instructions across all agentic
coding tools: **Claude Code**, **OpenCode**, **Codex CLI**, and **Goose**.

## Architecture

```
~/.agents/                          ← This directory (source of truth)
├── skills/                         ← Global SKILL.md skills (agentskills.io format)
│   ├── check-code-cleanup/
│   ├── check-types/
│   ├── check-component-quality/
│   └── ...
├── agents/                         ← Global agent definitions
│   ├── claude/                     ← Claude Code + OpenCode (.md format)
│   └── codex/                      ← Codex CLI (.toml format)
├── instructions/
│   ├── AGENTS.md                   ← Global rules (Codex, OpenCode, Goose)
│   └── CLAUDE.md                   ← Global rules (Claude Code)
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

All symlink to `~/.agents/instructions/AGENTS.md` (except Claude Code which
symlinks to `CLAUDE.md`).

## How Each Tool Discovers Global Agents

| Path                               | Tool          | Format |
|------------------------------------|---------------|--------|
| `~/.claude/agents/`               | Claude Code   | `.md` (YAML frontmatter) |
| `~/.config/opencode/agents/`      | OpenCode      | `.md` (YAML frontmatter) |
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

## Global vs Project-Specific Skills

- **Global skills** (`~/.agents/skills/`): Universal workflows usable in any repo
  (code cleanup, type checking, TDD, planning, etc.)
- **Project skills** (`.claude/skills/` or `.agents/skills/` in repo): Repo-specific
  patterns (scaffolding, naming, styling rules tied to a specific design system)
