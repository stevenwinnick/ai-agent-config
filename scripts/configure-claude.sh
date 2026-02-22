#!/bin/bash
# Symlink Claude Code configuration
# Claude can read AGENTS.md and skills directly from base-config

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
