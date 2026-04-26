#!/bin/bash
# Run all configuration scripts

set -e

echo "Configuring all AI coding agents..."

"$(dirname "$0")/configure-claude.sh"
"$(dirname "$0")/configure-codex.sh"

echo "All configurations complete."
echo "Run ./scripts/test-configs.sh to validate."
