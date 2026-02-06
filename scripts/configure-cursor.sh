#!/bin/bash
# Configure Cursor skills
# Cursor reads skills from ~/.cursor/skills/ (global) and ~/.claude/skills/ (Claude compatibility)
# See: https://cursor.com/docs/context/skills
# NOTE: Cursor does not reliably discover skills in symlinked directories, so we copy instead
# See: https://forum.cursor.com/t/global-symlinked-skills-are-not-discovered-by-cursor/150028

set -e

BASE_CONFIG_DIR="$HOME/.ai-agent-config/base-config"

echo "Configuring Cursor..."

# Copy skills directory (Cursor doesn't reliably follow symlinks)
mkdir -p ~/.cursor
if [ -d ~/.cursor/skills ]; then
    rm -rf ~/.cursor/skills
fi
rsync -av --delete "$BASE_CONFIG_DIR/skills/" ~/.cursor/skills/
echo "Copied base-config/skills/ -> ~/.cursor/skills/"

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