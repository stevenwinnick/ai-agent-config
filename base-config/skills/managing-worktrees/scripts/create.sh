#!/bin/bash
# Create a new git worktree
# Usage: create.sh <branch-name>

set -e

BRANCH_NAME="$1"

if [[ -z "$BRANCH_NAME" ]]; then
    echo "Usage: create.sh <branch-name>"
    exit 1
fi

if [[ -z "$CODE_ROOT" ]]; then
    echo "Error: CODE_ROOT environment variable is not set"
    exit 1
fi

# Extract repo name from git root path
REPO_NAME=$(basename "$(git rev-parse --show-toplevel)")

# Get default branch from origin/HEAD symref, stripping "refs/remotes/origin/" prefix
DEFAULT_BRANCH=$(git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed 's@^refs/remotes/origin/@@')
if [[ -z "$DEFAULT_BRANCH" ]]; then
    # Fallback: query remote directly and extract HEAD branch name
    DEFAULT_BRANCH=$(git remote show origin | grep 'HEAD branch' | cut -d' ' -f5)
fi

# Convert branch slashes to -- for filesystem-safe directory name
WORKTREE_DIR=$(echo "$BRANCH_NAME" | sed 's|/|--|g')
WORKTREE_PATH="$CODE_ROOT/$REPO_NAME/worktrees/$WORKTREE_DIR/$REPO_NAME"

git fetch origin "$DEFAULT_BRANCH"
mkdir -p "$(dirname "$WORKTREE_PATH")"
git worktree add -b "$BRANCH_NAME" "$WORKTREE_PATH" "origin/$DEFAULT_BRANCH"
echo "Worktree created: $WORKTREE_PATH"
