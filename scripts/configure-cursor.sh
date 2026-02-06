#!/bin/bash
# Symlink Cursor configuration
# Cursor reads skills from ~/.cursor/skills/ (global) and ~/.claude/skills/ (Claude compatibility)
# See: https://cursor.com/docs/context/skills

set -e

BASE_CONFIG_DIR="$HOME/.ai-agent-config/base-config"

echo "Configuring Cursor..."

# Symlink skills directory (Cursor reads from ~/.cursor/skills/ globally)
mkdir -p ~/.cursor
rm -rf ~/.cursor/skills
ln -s "$BASE_CONFIG_DIR/skills" ~/.cursor/skills
echo "Symlinked ~/.cursor/skills/ -> base-config/skills/"

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
