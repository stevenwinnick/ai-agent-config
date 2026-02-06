#!/bin/bash
# Symlink Claude Code configuration
# Claude can read AGENTS.md and skills directly from base-config

set -e

BASE_CONFIG_DIR="$HOME/.ai-agent-config/base-config"

echo "Configuring Claude Code..."

mkdir -p ~/.claude

# Symlink AGENTS.md as CLAUDE.md (Claude reads this file name)
rm -f ~/.claude/CLAUDE.md
ln -s "$BASE_CONFIG_DIR/AGENTS.md" ~/.claude/CLAUDE.md
echo "Symlinked ~/.claude/CLAUDE.md -> base-config/AGENTS.md"

# Symlink skills directory directly
rm -rf ~/.claude/skills
ln -s "$BASE_CONFIG_DIR/skills" ~/.claude/skills
echo "Symlinked ~/.claude/skills/ -> base-config/skills/"

echo "Claude Code configuration complete."
