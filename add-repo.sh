#!/usr/bin/env bash
set -euo pipefail

# ============================================================================
# Per-Repo Agent Compatibility Setup
# Run inside any git repo to make project-level skills work across all agents.
#
# What it does:
#   - If .claude/skills/ exists, creates .agents/skills → .claude/skills
#     so Codex CLI can read the same project skills
#   - Creates AGENTS.md → CLAUDE.md symlink if CLAUDE.md exists (for Codex/OpenCode/Goose)
#   - Creates .goosehints → CLAUDE.md symlink if CLAUDE.md exists (for Goose)
# ============================================================================

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

info()  { echo -e "${BLUE}[INFO]${NC}  $1"; }
ok()    { echo -e "${GREEN}[OK]${NC}    $1"; }
warn()  { echo -e "${YELLOW}[WARN]${NC}  $1"; }

# Find git root
if ! git rev-parse --show-toplevel &>/dev/null; then
  echo "Error: Not inside a git repository."
  exit 1
fi

REPO_ROOT=$(git rev-parse --show-toplevel)
cd "$REPO_ROOT"

echo ""
echo "============================================"
echo "  Per-Repo Agent Compatibility — $(basename "$REPO_ROOT")"
echo "============================================"
echo ""

# --- Skills: .agents/skills → .claude/skills (for Codex CLI) ---
if [ -d ".claude/skills" ]; then
  if [ -L ".agents/skills" ]; then
    ok ".agents/skills/ symlink already exists"
  elif [ -d ".agents/skills" ]; then
    warn ".agents/skills/ is a real directory — skipping (merge manually)"
  else
    mkdir -p .agents
    ln -s "../.claude/skills" ".agents/skills"
    ok "Created .agents/skills/ → .claude/skills/ (Codex CLI compatibility)"
  fi
else
  info "No .claude/skills/ found — skipping skills symlink"
fi

# --- Instructions: AGENTS.md → CLAUDE.md (for Codex/OpenCode/Goose) ---
if [ -f "CLAUDE.md" ]; then
  if [ -L "AGENTS.md" ]; then
    ok "AGENTS.md symlink already exists"
  elif [ -f "AGENTS.md" ]; then
    warn "AGENTS.md already exists as a real file — skipping"
  else
    ln -s "CLAUDE.md" "AGENTS.md"
    ok "Created AGENTS.md → CLAUDE.md (Codex/OpenCode/Goose compatibility)"
  fi
elif [ -f "AGENTS.md" ]; then
  info "AGENTS.md exists — no symlink needed"
fi

# --- Goose hints: .goosehints → CLAUDE.md or AGENTS.md ---
HINTS_TARGET=""
if [ -f "CLAUDE.md" ]; then
  HINTS_TARGET="CLAUDE.md"
elif [ -f "AGENTS.md" ] && [ ! -L "AGENTS.md" ]; then
  HINTS_TARGET="AGENTS.md"
fi

if [ -n "$HINTS_TARGET" ]; then
  if [ -L ".goosehints" ]; then
    ok ".goosehints symlink already exists"
  elif [ -f ".goosehints" ]; then
    warn ".goosehints already exists as a real file — skipping"
  else
    ln -s "$HINTS_TARGET" ".goosehints"
    ok "Created .goosehints → $HINTS_TARGET (Goose compatibility)"
  fi
fi

# --- .gitignore additions ---
echo ""
info "Checking .gitignore..."

IGNORE_ENTRIES=()

# Only suggest ignoring symlinks, not source files
[ -L "AGENTS.md" ] && IGNORE_ENTRIES+=("AGENTS.md")
[ -L ".goosehints" ] && IGNORE_ENTRIES+=(".goosehints")
[ -L ".agents/skills" ] && IGNORE_ENTRIES+=(".agents/")

if [ ${#IGNORE_ENTRIES[@]} -gt 0 ]; then
  for entry in "${IGNORE_ENTRIES[@]}"; do
    if grep -qxF "$entry" .gitignore 2>/dev/null; then
      ok "$entry already in .gitignore"
    else
      echo "$entry" >> .gitignore
      ok "Added $entry to .gitignore"
    fi
  done
fi

echo ""
echo "============================================"
echo "  Done! Repo is now cross-agent compatible."
echo "============================================"
echo ""
