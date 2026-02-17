#!/bin/bash
# Switch to a specific worktree
# Usage: switch.sh <repo-dir> <worktree-name>

set -e

REPO_DIR="$1"
NAME="$2"

if [[ -z "$REPO_DIR" || -z "$NAME" ]]; then
    echo "Usage: switch.sh <repo-dir> <worktree-name>"
    exit 1
fi

cd "$REPO_DIR"

if [[ -z "$CODE_ROOT" ]]; then
    echo "Error: CODE_ROOT environment variable is not set"
    exit 1
fi

# Extract repo name from git root path
REPO_NAME=$(basename "$(git rev-parse --show-toplevel)")
WORKTREE_PATH="$CODE_ROOT/$REPO_NAME/worktrees/$NAME/$REPO_NAME"

if [[ -d "$WORKTREE_PATH" ]]; then
    cd "$WORKTREE_PATH" 
else
    echo "Worktree not found. Available:"
    ls "$CODE_ROOT/$REPO_NAME/worktrees/" 2>/dev/null || echo "(none)"
    exit 1
fi
