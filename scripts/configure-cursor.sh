#!/bin/bash
# Configure Cursor skills
# Cursor reads skills from ~/.cursor/skills/ (global) and ~/.claude/skills/ (Claude compatibility)
# See: https://cursor.com/docs/context/skills
# NOTE: As of February 2026, Cursor does not reliably discover skills in symlinked directories, so we copy instead
# See: https://forum.cursor.com/t/global-symlinked-skills-are-not-discovered-by-cursor/150028
# This workaround can be removed if Cursor fixes the underlying issue in the future

set -e

REPO_DIR="$(cd "$(dirname "$0")/.." && pwd)"
AI_AGENT_CONFIG_HOME="${AI_AGENT_CONFIG_HOME:-$HOME/.ai-agent-config}"

if [ -e "$AI_AGENT_CONFIG_HOME" ] && [ ! -L "$AI_AGENT_CONFIG_HOME" ]; then
  echo "Error: $AI_AGENT_CONFIG_HOME exists and is not a symlink." >&2
  echo "Move it aside or set AI_AGENT_CONFIG_HOME to a symlink path." >&2
  exit 1
fi

# Keep a stable path so generated symlinks don't point at transient worktrees.
rm -f "$AI_AGENT_CONFIG_HOME"
ln -s "$REPO_DIR" "$AI_AGENT_CONFIG_HOME"

BASE_CONFIG_DIR="$AI_AGENT_CONFIG_HOME/base-config"

echo "Configuring Cursor..."

# Copy skills directory (Cursor doesn't reliably follow symlinks)
mkdir -p ~/.cursor
# Remove existing skills directory/symlink to ensure we start fresh
# This is necessary to handle the case where ~/.cursor/skills might be a symlink
if [ -d ~/.cursor/skills ]; then
    rm -rf ~/.cursor/skills
fi
# Sync skills from base-config to Cursor's expected location
# -a: archive mode (preserves permissions, timestamps, etc.)
# -v: verbose output
# --delete: remove files in destination that don't exist in source (ensures exact sync)
rsync -av --delete "$BASE_CONFIG_DIR/skills/" ~/.cursor/skills/
echo "Copied base-config/skills/ -> ~/.cursor/skills/"

# Note: Cursor also reads ~/.claude/skills/ via Claude compatibility
# If configure-claude.sh has run, skills are available from there too
if cat "$BASE_CONFIG_DIR/AGENTS.md" | pbcopy 2>/dev/null; then
  echo "Copied AGENTS.md to clipboard."
else
  echo "Could not copy to clipboard. Run: cat $BASE_CONFIG_DIR/AGENTS.md | pbcopy"
fi
echo "Cursor configuration complete."
echo "=== MANUAL STEP REQUIRED ==="
echo "Paste AGENTS.md (copied to clipboard above) into Cursor User Rules:"
echo "1. Open Cursor Settings (Cmd+Shift+J)"
echo "2. Navigate to: Rules and Commands > User Rules"
echo "3. Paste from clipboard (Cmd+V)"
