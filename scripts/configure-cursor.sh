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
echo "Cursor configuration complete."
echo "=== MANUAL STEP REQUIRED ==="
echo "Copy the contents of AGENTS.md into Cursor User Rules:"
echo "  1. Open Cursor Settings (Cmd+Shift+J)"
echo "  2. Navigate to: Rules and Commands > User Rules"
echo "  3. Paste the contents of: $BASE_CONFIG_DIR/AGENTS.md"
echo "To copy AGENTS.md to clipboard, run:"
echo "cat $BASE_CONFIG_DIR/AGENTS.md | pbcopy"