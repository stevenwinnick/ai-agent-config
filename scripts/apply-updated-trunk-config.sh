#!/bin/bash
# Pull latest trunk and apply its configuration to all agents
# Run this after merging changes to trunk, or after testing from a branch worktree

set -e

REPO_DIR="$(cd "$(dirname "$0")/.." && pwd -P)"
GIT_COMMON_DIR="$(git -C "$REPO_DIR" rev-parse --path-format=absolute --git-common-dir)"
DEFAULT_BRANCH="$(git -C "$REPO_DIR" symbolic-ref --quiet --short refs/remotes/origin/HEAD 2>/dev/null || true)"
DEFAULT_BRANCH="${DEFAULT_BRANCH#origin/}"
DEFAULT_BRANCH="${DEFAULT_BRANCH:-trunk}"
TRUNK_DIR="$(cd "$GIT_COMMON_DIR/.." && pwd -P)"

# This repo keeps the primary worktree on the default branch.
if [ "$(git -C "$TRUNK_DIR" branch --show-current)" != "$DEFAULT_BRANCH" ]; then
  echo "Error: primary worktree at $TRUNK_DIR is not on $DEFAULT_BRANCH." >&2
  exit 1
fi

echo "Pulling latest $DEFAULT_BRANCH from $TRUNK_DIR..."
git -C "$TRUNK_DIR" pull --ff-only

echo ""
echo "Applying $DEFAULT_BRANCH configuration..."
"$TRUNK_DIR/scripts/configure-all.sh"
