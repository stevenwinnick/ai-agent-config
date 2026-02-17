#!/bin/bash
# Update all agent configurations, then run functional tests
# Convenience wrapper that runs configure-all.sh followed by test-configs.sh

set -e

SCRIPT_DIR="$(dirname "$0")"

echo "1. Updating configurations..."
"$SCRIPT_DIR/configure-all.sh"
echo ""

echo "2. Running functional tests..."
"$SCRIPT_DIR/test-configs.sh"
