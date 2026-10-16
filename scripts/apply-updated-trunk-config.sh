#!/bin/bash
# Pull latest trunk and apply its configuration to all agents
# Run this after merging changes to trunk, or after switching back to trunk from testing a branch

set -e

REPO_DIR="$(cd "$(dirname "$0")/.." && pwd -P)"
DEFAULT_BRANCH="$(git -C "$REPO_DIR" symbolic-ref --quiet --short refs/remotes/origin/HEAD 2>/dev/null || true)"
DEFAULT_BRANCH="${DEFAULT_BRANCH#origin/}"
DEFAULT_BRANCH="${DEFAULT_BRANCH:-trunk}"

if [ "$(git -C "$REPO_DIR" branch --show-current)" != "$DEFAULT_BRANCH" ]; then
  echo "Error: $REPO_DIR is not on $DEFAULT_BRANCH. Switch to $DEFAULT_BRANCH first." >&2
  exit 1
fi

echo "Pulling latest $DEFAULT_BRANCH in $REPO_DIR..."
git -C "$REPO_DIR" pull --ff-only

echo ""
echo "Applying $DEFAULT_BRANCH configuration..."
"$REPO_DIR/scripts/configure-all.sh"
