#!/bin/bash
# Pull latest trunk and apply its configuration to all agents
# Run this after merging changes to trunk, or after testing from a branch worktree

set -e

TRUNK_DIR="$HOME/.ai-agent-config"

echo "Pulling latest trunk..."
git -C "$TRUNK_DIR" pull

echo ""
echo "Applying trunk configuration..."
"$TRUNK_DIR/scripts/configure-all.sh"
