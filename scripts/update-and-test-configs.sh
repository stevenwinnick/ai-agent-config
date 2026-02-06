#!/bin/bash
# Update all agent configurations, then run functional tests
# Convenience wrapper that runs configure-all.sh followed by test-configs.sh

set -e

SCRIPT_DIR="$(dirname "$0")"
CONFIG_DIR="$HOME/.ai-agent-config"

echo "1. Updating configurations..."
"$CONFIG_DIR/scripts/configure-all.sh"
echo ""

echo "2. Running functional tests..."
"$SCRIPT_DIR/test-configs.sh"
