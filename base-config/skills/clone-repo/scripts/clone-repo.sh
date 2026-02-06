#!/bin/bash
# Clone a GitHub repo into the preferred worktree directory structure
# Usage: clone-repo.sh <owner/repo or GitHub URL>

set -e

REPO_ID="$1"

if [[ -z "$REPO_ID" ]]; then
    echo "Error: Repo identifier is required"
    echo "Usage: clone-repo.sh <owner/repo or GitHub URL>"
    exit 1
fi

if [[ -z "$CODE_ROOT" ]]; then
    echo "Error: CODE_ROOT environment variable is not set"
    exit 1
fi

# Extract repo name from identifier
# Handles: owner/repo, https://github.com/owner/repo, git@github.com:owner/repo.git
REPO_NAME=$(echo "$REPO_ID" | sed 's|\.git$||' | sed 's|.*[/:]||')

if [[ -z "$REPO_NAME" ]]; then
    echo "Error: Could not determine repo name from '$REPO_ID'"
    exit 1
fi

TARGET_BASE="$CODE_ROOT/$REPO_NAME"
TARGET_PATH="$TARGET_BASE/trunk/$REPO_NAME"

if [[ -d "$TARGET_PATH" ]]; then
    echo "Error: Directory already exists: $TARGET_PATH"
    exit 1
fi

# Create directory structure
mkdir -p "$TARGET_BASE/trunk"
mkdir -p "$TARGET_BASE/worktrees"

# Clone into the target path
# Use gh repo clone which handles owner/repo format natively
gh repo clone "$REPO_ID" "$TARGET_PATH"

echo ""
echo "Clone complete"
echo "Path: $TARGET_PATH"
