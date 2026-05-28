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
# 1. SKILLS — Symlink from all tool-specific paths to ~/.agents/skills/
# ============================================================================

echo ""
info "Setting up global skills symlinks..."
echo ""

# Claude Code: ~/.claude/skills/ → ~/.agents/skills/
symlink_dir "$SKILLS_DIR" "$HOME/.claude/skills" \
  "Claude Code  ~/.claude/skills/"

# OpenCode: ~/.config/opencode/skills/ → ~/.agents/skills/
symlink_dir "$SKILLS_DIR" "$HOME/.config/opencode/skills" \
  "OpenCode     ~/.config/opencode/skills/"

# Goose (portable): ~/.config/agents/skills/ → ~/.agents/skills/
symlink_dir "$SKILLS_DIR" "$HOME/.config/agents/skills" \
  "Goose        ~/.config/agents/skills/"

# Goose (native): ~/.config/goose/skills/ → ~/.agents/skills/
symlink_dir "$SKILLS_DIR" "$HOME/.config/goose/skills" \
  "Goose        ~/.config/goose/skills/"

# Codex CLI reads from ~/.agents/skills/ natively (USER scope) — no symlink needed
ok "Codex CLI    ~/.agents/skills/ (native, no symlink needed)"

# ============================================================================
# 2. INSTRUCTIONS — Symlink global instruction files
# ============================================================================

echo ""
info "Setting up global instructions symlinks..."
echo ""

# Codex CLI: ~/.codex/AGENTS.md
symlink_file "$INSTRUCTIONS_DIR/AGENTS.md" "$HOME/.codex/AGENTS.md" \
  "Codex CLI    ~/.codex/AGENTS.md"

# Claude Code: ~/.claude/CLAUDE.md
symlink_file "$INSTRUCTIONS_DIR/CLAUDE.md" "$HOME/.claude/CLAUDE.md" \
  "Claude Code  ~/.claude/CLAUDE.md"

# OpenCode: ~/.config/opencode/AGENTS.md
symlink_file "$INSTRUCTIONS_DIR/AGENTS.md" "$HOME/.config/opencode/AGENTS.md" \
  "OpenCode     ~/.config/opencode/AGENTS.md"

# Goose: ~/.config/goose/.goosehints
symlink_file "$INSTRUCTIONS_DIR/AGENTS.md" "$HOME/.config/goose/.goosehints" \
  "Goose        ~/.config/goose/.goosehints"

# ============================================================================
# 3. AGENTS — Symlink global agent definitions
# ============================================================================

echo ""
info "Setting up global agents symlinks..."
echo ""

# Claude Code agents (markdown format)
if [ -d "$AGENTS_DIR/claude" ]; then
  symlink_dir "$AGENTS_DIR/claude" "$HOME/.claude/agents" \
    "Claude Code  ~/.claude/agents/"
fi

# OpenCode agents (markdown format — same as Claude Code)
if [ -d "$AGENTS_DIR/claude" ]; then
  symlink_dir "$AGENTS_DIR/claude" "$HOME/.config/opencode/agents" \
    "OpenCode     ~/.config/opencode/agents/"
fi

# Codex agents (toml format — separate directory)
if [ -d "$AGENTS_DIR/codex" ]; then
  symlink_dir "$AGENTS_DIR/codex" "$HOME/.codex/agents" \
    "Codex CLI    ~/.codex/agents/"
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
info "Global skills available: $skill_count"

if [ -f "$INSTRUCTIONS_DIR/AGENTS.md" ]; then
  ok "Global instructions: AGENTS.md found"
else
  warn "Global instructions: AGENTS.md not found — create $INSTRUCTIONS_DIR/AGENTS.md"
fi

if [ -f "$INSTRUCTIONS_DIR/CLAUDE.md" ]; then
  ok "Global instructions: CLAUDE.md found"
else
  warn "Global instructions: CLAUDE.md not found — create $INSTRUCTIONS_DIR/CLAUDE.md"
fi

echo ""
info "Skills in: $SKILLS_DIR"
info "To add a skill: mkdir ~/.agents/skills/<name> && edit SKILL.md"
info "To install community skills: npx skills@latest add <org>/<repo>/<skill>"
echo ""
