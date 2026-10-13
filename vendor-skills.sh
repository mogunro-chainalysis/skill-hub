#!/usr/bin/env bash
set -euo pipefail

# ============================================================================
# Vendor third-party skills into ~/.agents/skills/ at a pinned commit.
#
# Each entry in SOURCES is "<git url>|<commit>|<path to skills dir>|<skill> <skill> ...".
# Skills are copied verbatim (no local edits — re-running overwrites them) and a
# VENDOR.md is written next to each SKILL.md recording origin, commit, and license.
#
# To update: bump the commit, run this script, review `git diff skills/`, then
# run setup.sh so new skills get linked into every tool.
# ============================================================================

AGENTS_HOME="$HOME/.agents"
SKILLS_DIR="$AGENTS_HOME/skills"

SOURCES=(
  "https://github.com/cypress-io/ai-toolkit.git|da6ea17dfa674a2b68908d823e37f5797d5be238|skills|cypress-author cypress-cloud-cli cypress-docs cypress-explain cypress-tap"
)

GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

info() { echo -e "${BLUE}[INFO]${NC}  $1"; }
ok()   { echo -e "${GREEN}[OK]${NC}    $1"; }

workdir=$(mktemp -d)
trap 'rm -rf "$workdir"' EXIT

for source in "${SOURCES[@]}"; do
  IFS='|' read -r url commit skills_path skills <<<"$source"
  checkout="$workdir/$(basename "$url" .git)"

  info "Fetching $url @ ${commit:0:12}"
  git init -q "$checkout"
  git -C "$checkout" fetch -q --depth 1 "$url" "$commit"
  git -C "$checkout" checkout -q FETCH_HEAD

  license_file=$(find "$checkout" -maxdepth 1 -iname 'LICENSE*' | head -1)
  license=$(head -1 "$license_file" 2>/dev/null | tr -d '\r' || echo "unknown")
  repo_web="${url%.git}"

  for skill in $skills; do
    src="$checkout/$skills_path/$skill"
    dest="$SKILLS_DIR/$skill"

    if [ ! -f "$src/SKILL.md" ]; then
      echo "Missing $skills_path/$skill/SKILL.md in $url @ $commit" >&2
      exit 1
    fi

    rm -rf "$dest"
    cp -R "$src" "$dest"
    [ -n "$license_file" ] && cp "$license_file" "$dest/LICENSE"

    cat >"$dest/VENDOR.md" <<EOF
# Vendored skill — do not edit

- Source: $repo_web/tree/$commit/$skills_path/$skill
- Commit: $commit
- License: $license (see LICENSE)

Managed by \`~/.agents/vendor-skills.sh\`; local edits are overwritten on the next sync.
EOF
    ok "$skill"
  done
done

info "Review with: git -C $AGENTS_HOME diff --stat -- skills/"
info "Then link into every tool with: $AGENTS_HOME/setup.sh"
