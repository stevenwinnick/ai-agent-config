#!/bin/bash
# Ensure ~/.ai-agent-config points to this repo checkout.

set -e

REPO_DIR="$(cd "$(dirname "$0")/.." && pwd)"
AI_AGENT_CONFIG_HOME="$HOME/.ai-agent-config"

if [ -e "$AI_AGENT_CONFIG_HOME" ] && [ ! -L "$AI_AGENT_CONFIG_HOME" ]; then
  echo "Error: $AI_AGENT_CONFIG_HOME exists and is not a symlink." >&2
  echo "Move it aside before running configure scripts." >&2
  exit 1
fi

# Skip if already pointing to the right place.
if [ -L "$AI_AGENT_CONFIG_HOME" ] && [ "$(readlink "$AI_AGENT_CONFIG_HOME")" = "$REPO_DIR" ]; then
  exit 0
fi

# Keep a stable path so generated symlinks don't point at transient worktrees.
rm -f "$AI_AGENT_CONFIG_HOME"
ln -s "$REPO_DIR" "$AI_AGENT_CONFIG_HOME"
