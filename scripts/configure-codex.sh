#!/bin/bash
# Configure Codex CLI
# Codex loads team config (including skills) from CODEX_HOME (defaults to ~/.codex)
# Personal instructions live in AGENTS.md

set -e

BASE_CONFIG_DIR="$HOME/.ai-agent-config/base-config"
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
