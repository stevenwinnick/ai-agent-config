#!/bin/bash
# List all git worktrees and their status
# Usage: list.sh <repo-dir>

set -e

REPO_DIR="$1"

if [[ -z "$REPO_DIR" ]]; then
    echo "Usage: list.sh <repo-dir>"
    exit 1
fi

cd "$REPO_DIR"

git worktree list

# Extract worktree paths from porcelain output (lines starting with "worktree ")
for wt in $(git worktree list --porcelain | grep "^worktree " | cut -d' ' -f2-); do
    echo "$wt:"
    # Run git status in each worktree directory
    git -C "$wt" status --short 2>/dev/null || echo "(not accessible)"
done
