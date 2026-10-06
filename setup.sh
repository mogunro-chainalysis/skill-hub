#!/usr/bin/env bash
set -euo pipefail

# ============================================================================
# Global Agent Skills Hub — Setup Script
# Creates symlinks so all agentic coding tools read from ~/.agents/
# Supports: Claude Code, OpenCode, Codex CLI, Goose
# ============================================================================

AGENTS_HOME="$HOME/.agents"
SKILLS_DIR="$AGENTS_HOME/skills"
INSTRUCTIONS_DIR="$AGENTS_HOME/instructions"
AGENTS_DIR="$AGENTS_HOME/agents"
COMMANDS_DIR="$AGENTS_HOME/commands"
WORK_HOME="${AGENTS_WORK_HOME:-$HOME/.agents-work}"
WORK_SKILLS_DIR="$WORK_HOME/skills"
WORK_AGENTS_DIR="$WORK_HOME/agents"

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

info()  { echo -e "${BLUE}[INFO]${NC}  $1"; }
ok()    { echo -e "${GREEN}[OK]${NC}    $1"; }
warn()  { echo -e "${YELLOW}[WARN]${NC}  $1"; }

symlink_dir() {
  local target="$1"
  local link="$2"
  local label="$3"

  if [ -L "$link" ]; then
    local current_target
    current_target=$(readlink "$link")
    if [ "$current_target" = "$target" ]; then
      ok "$label — already linked"
      return
    else
      warn "$label — repointing symlink from $current_target"
      rm "$link"
    fi
  elif [ -d "$link" ]; then
    if [ -z "$(ls -A "$link" 2>/dev/null)" ]; then
      rmdir "$link"
    else
      warn "$label — directory exists and is not empty: $link"
      warn "  Skipping. Merge contents manually, then replace with symlink."
      return
    fi
  fi

  mkdir -p "$(dirname "$link")"
  ln -s "$target" "$link"
  ok "$label"
}

symlink_file() {
  local target="$1"
  local link="$2"
  local label="$3"

  if [ -L "$link" ]; then
    local current_target
    current_target=$(readlink "$link")
    if [ "$current_target" = "$target" ]; then
      ok "$label — already linked"
      return
    else
      warn "$label — repointing symlink from $current_target"
      rm "$link"
    fi
  elif [ -f "$link" ]; then
    warn "$label — file already exists: $link"
    warn "  Backing up to ${link}.bak"
    mv "$link" "${link}.bak"
  fi

  mkdir -p "$(dirname "$link")"
  ln -s "$target" "$link"
  ok "$label"
}

populate_skills_dir() {
  local target_dir="$1"
  local label="$2"

  if [ -L "$target_dir" ]; then
    rm "$target_dir"
  fi
  mkdir -p "$target_dir"

  local count=0
  for s in "$SKILLS_DIR"/*; do
    if [ -d "$s" ] && [ -f "$s/SKILL.md" ]; then
      local name
      name=$(basename "$s")
      ln -sfn "$s" "$target_dir/$name"
      count=$((count + 1))
    fi
  done

  local work_count=0
  if [ -d "$WORK_SKILLS_DIR" ]; then
    for s in "$WORK_SKILLS_DIR"/*; do
      if [ -d "$s" ] && [ -f "$s/SKILL.md" ]; then
        local name
        name=$(basename "$s")
        ln -sfn "$s" "$target_dir/$name"
        work_count=$((work_count + 1))
      fi
    done
  fi

  for link in "$target_dir"/*; do
    if [ -L "$link" ] && [ ! -e "$link" ]; then
      rm "$link"
    fi
  done

  if [ "$work_count" -gt 0 ]; then
    ok "$label ($count public + $work_count work overlay)"
  else
    ok "$label ($count skills)"
  fi
}

populate_agents_dir() {
  local target_dir="$1"
  local agent_sub="$2"
  local ext="$3"
  local label="$4"

  if [ -L "$target_dir" ]; then
    rm "$target_dir"
  fi
  mkdir -p "$target_dir"

  local src="$AGENTS_DIR/$agent_sub"
  local work_src="$WORK_AGENTS_DIR/$agent_sub"
  local count=0

  if [ -d "$src" ]; then
    for f in "$src"/*."$ext"; do
      if [ -f "$f" ]; then
        local name
        name=$(basename "$f")
        ln -sfn "$f" "$target_dir/$name"
        count=$((count + 1))
      fi
    done
  fi

  local work_count=0
  if [ -d "$work_src" ]; then
    for f in "$work_src"/*."$ext"; do
      if [ -f "$f" ]; then
        local name
        name=$(basename "$f")
        ln -sfn "$f" "$target_dir/$name"
        work_count=$((work_count + 1))
      fi
    done
  fi

  for link in "$target_dir"/*."$ext"; do
    if [ -L "$link" ] && [ ! -e "$link" ]; then
      rm "$link"
    fi
  done

  if [ "$work_count" -gt 0 ]; then
    ok "$label ($count public + $work_count work overlay)"
  else
    ok "$label ($count agents)"
  fi
}

echo ""
echo "============================================"
echo "  Global Agent Skills Hub — Setup"
echo "============================================"
echo ""

# --- Validate source directories exist ---
if [ ! -d "$SKILLS_DIR" ]; then
  warn "Skills directory not found: $SKILLS_DIR"
  warn "Creating empty skills directory..."
  mkdir -p "$SKILLS_DIR"
fi

if [ ! -d "$INSTRUCTIONS_DIR" ]; then
  warn "Instructions directory not found: $INSTRUCTIONS_DIR"
  mkdir -p "$INSTRUCTIONS_DIR"
fi

# ============================================================================
# 1. SKILLS — Link skills from ~/.agents/skills/ and ~/.agents-work/skills/
# ============================================================================

echo ""
info "Setting up skills symlinks..."
echo ""

# Claude Code: ~/.claude/skills/
populate_skills_dir "$HOME/.claude/skills" "Claude Code  ~/.claude/skills/"

# OpenCode: ~/.config/opencode/skills/
populate_skills_dir "$HOME/.config/opencode/skills" "OpenCode     ~/.config/opencode/skills/"

# Goose (portable): ~/.config/agents/skills/
populate_skills_dir "$HOME/.config/agents/skills" "Goose        ~/.config/agents/skills/"

# Goose (native): ~/.config/goose/skills/
populate_skills_dir "$HOME/.config/goose/skills" "Goose        ~/.config/goose/skills/"

# Codex CLI: reads from ~/.agents/skills/ natively; also sync ~/.codex/skills if present
if [ -d "$HOME/.codex" ]; then
  populate_skills_dir "$HOME/.codex/skills" "Codex CLI    ~/.codex/skills/"
fi
ok "Codex CLI    ~/.agents/skills/ (native USER scope)"

# ============================================================================
# 2. INSTRUCTIONS — Symlink global instruction files
# ============================================================================

echo ""
info "Setting up global instructions symlinks..."
echo ""

# Codex CLI: ~/.codex/AGENTS.md
symlink_file "$INSTRUCTIONS_DIR/AGENTS.md" "$HOME/.codex/AGENTS.md" \
  "Codex CLI    ~/.codex/AGENTS.md"

# Claude Code: ~/.claude/CLAUDE.md (same rules as AGENTS.md)
symlink_file "$INSTRUCTIONS_DIR/AGENTS.md" "$HOME/.claude/CLAUDE.md" \
  "Claude Code  ~/.claude/CLAUDE.md"

# OpenCode: ~/.config/opencode/AGENTS.md
symlink_file "$INSTRUCTIONS_DIR/AGENTS.md" "$HOME/.config/opencode/AGENTS.md" \
  "OpenCode     ~/.config/opencode/AGENTS.md"

# Goose: ~/.config/goose/.goosehints
symlink_file "$INSTRUCTIONS_DIR/AGENTS.md" "$HOME/.config/goose/.goosehints" \
  "Goose        ~/.config/goose/.goosehints"

# ============================================================================
# 3. AGENTS — Symlink agent definitions (public + work overlay)
# ============================================================================

echo ""
info "Setting up agent symlinks..."
echo ""

# Claude Code agents (markdown format)
populate_agents_dir "$HOME/.claude/agents" "claude" "md" "Claude Code  ~/.claude/agents/"

# OpenCode agents (OpenCode-native frontmatter)
populate_agents_dir "$HOME/.config/opencode/agents" "opencode" "md" "OpenCode     ~/.config/opencode/agents/"

# Codex agents (toml format)
populate_agents_dir "$HOME/.codex/agents" "codex" "toml" "Codex CLI    ~/.codex/agents/"

# ============================================================================
# 4. COMMANDS — Symlink global command definitions (opencode only)
# ============================================================================

echo ""
info "Setting up global commands symlinks..."
echo ""

# OpenCode commands: ~/.config/opencode/commands/ → ~/.agents/commands/
# Claude Code slash-command frontmatter differs and isn't wired here — commands
# are opencode-specific for now (Task tool / @mention / Tab primary-agent mechanics).
if [ -d "$COMMANDS_DIR" ]; then
  symlink_dir "$COMMANDS_DIR" "$HOME/.config/opencode/commands" \
    "OpenCode     ~/.config/opencode/commands/"
fi

# ============================================================================
# Summary
# ============================================================================

echo ""
echo "============================================"
echo "  Setup complete!"
echo "============================================"
echo ""

skill_count=$(find "$SKILLS_DIR" -name "SKILL.md" 2>/dev/null | wc -l | tr -d ' ')
info "Global public skills available: $skill_count"

if [ -d "$WORK_SKILLS_DIR" ]; then
  work_skill_count=$(find "$WORK_SKILLS_DIR" -name "SKILL.md" 2>/dev/null | wc -l | tr -d ' ')
  info "Work overlay skills available:   $work_skill_count (from $WORK_SKILLS_DIR)"
fi

if [ -f "$INSTRUCTIONS_DIR/AGENTS.md" ]; then
  ok "Global instructions: AGENTS.md found"
else
  warn "Global instructions: AGENTS.md not found — create $INSTRUCTIONS_DIR/AGENTS.md"
fi

echo ""
info "Skills in: $SKILLS_DIR"
info "To add a skill: mkdir ~/.agents/skills/<name> && edit SKILL.md"
info "To install community skills: npx skills@latest add <org>/<repo>/<skill>"
echo ""
