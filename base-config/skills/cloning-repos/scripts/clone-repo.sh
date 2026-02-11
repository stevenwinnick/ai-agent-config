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

if [[ -d "$TARGET_BASE" ]]; then
    echo "Error: Directory already exists: $TARGET_BASE"
    exit 1
fi

# Clone into a temporary location to detect the default branch
TEMP_PATH="$TARGET_BASE/.clone-tmp"
mkdir -p "$TARGET_BASE"
gh repo clone "$REPO_ID" "$TEMP_PATH"

# Detect the default branch
DEFAULT_BRANCH=$(git -C "$TEMP_PATH" symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed 's@^refs/remotes/origin/@@')
if [[ -z "$DEFAULT_BRANCH" ]]; then
    DEFAULT_BRANCH=$(git -C "$TEMP_PATH" rev-parse --abbrev-ref HEAD)
fi

# Move clone to final location named after the default branch
TARGET_PATH="$TARGET_BASE/$DEFAULT_BRANCH/$REPO_NAME"
mkdir -p "$TARGET_BASE/$DEFAULT_BRANCH"
mv "$TEMP_PATH" "$TARGET_PATH"

# Create empty worktrees directory
mkdir -p "$TARGET_BASE/worktrees"

echo ""
echo "Clone complete"
echo "Path: $TARGET_PATH"
