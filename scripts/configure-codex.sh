#!/bin/bash
# Configure Codex CLI
# Codex loads team config (including skills) from CODEX_HOME (defaults to ~/.codex)
# Personal instructions live in AGENTS.md

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
CODEX_HOME="${CODEX_HOME:-$HOME/.codex}"

echo "Configuring Codex CLI..."

mkdir -p "$CODEX_HOME"

# Symlink AGENTS.md as Codex personal instructions
rm -f "$CODEX_HOME/AGENTS.md"
ln -s "$BASE_CONFIG_DIR/AGENTS.md" "$CODEX_HOME/AGENTS.md"
echo "Symlinked $CODEX_HOME/AGENTS.md -> base-config/AGENTS.md"

# Link shared skills while preserving any existing non-symlink skills (e.g., .system)
mkdir -p "$CODEX_HOME/skills"
for skill_dir in "$BASE_CONFIG_DIR/skills"/*; do
  skill_name="$(basename "$skill_dir")"
  target="$CODEX_HOME/skills/$skill_name"

  if [ -e "$target" ] && [ ! -L "$target" ]; then
    echo "Skipping $target (exists and is not a symlink)"
    continue
  fi

  rm -f "$target"
  ln -s "$skill_dir" "$target"
  echo "Symlinked $target -> base-config/skills/$skill_name"
done

echo "Codex CLI configuration complete."
