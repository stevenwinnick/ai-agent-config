#!/bin/bash
# Convert a standard-format git repo to the preferred worktree directory structure
# Usage: convert-repo.sh <path-to-repo>

set -e

REPO_SOURCE="$1"

if [[ -z "$REPO_SOURCE" ]]; then
    echo "Error: Path to repo is required"
    echo "Usage: convert-repo.sh <path-to-repo>"
    exit 1
fi

if [[ -z "$CODE_ROOT" ]]; then
    echo "Error: CODE_ROOT environment variable is not set"
    exit 1
fi

# Resolve to absolute path
REPO_SOURCE=$(cd "$REPO_SOURCE" && pwd)

# Validate it's a git repo
if ! git -C "$REPO_SOURCE" rev-parse --git-dir > /dev/null 2>&1; then
    echo "Error: '$REPO_SOURCE' is not a git repository"
    exit 1
fi

# Reject repos that already use worktree format (have a .git file pointing to a worktree)
if [[ -f "$REPO_SOURCE/.git" ]]; then
    echo "Error: '$REPO_SOURCE' appears to be a git worktree, not a standard repo"
    exit 1
fi

REPO_NAME=$(basename "$REPO_SOURCE")
TARGET_BASE="$CODE_ROOT/$REPO_NAME"
TARGET_PATH="$TARGET_BASE/trunk/$REPO_NAME"

# Check the target doesn't already exist (unless the source IS already at the target)
if [[ -d "$TARGET_PATH" && "$REPO_SOURCE" != "$TARGET_PATH" ]]; then
    echo "Error: Target directory already exists: $TARGET_PATH"
    exit 1
fi

# If the repo is already at the target location, just create worktrees dir
if [[ "$REPO_SOURCE" == "$TARGET_PATH" ]]; then
    echo "Repo is already at $TARGET_PATH"
    mkdir -p "$TARGET_BASE/worktrees"
    echo "Created worktrees directory"
    echo ""
    echo "Conversion complete"
    echo "Path: $TARGET_PATH"
    exit 0
fi

# Check that the target base doesn't conflict with something else
if [[ -d "$TARGET_BASE" ]]; then
    echo "Error: Directory already exists: $TARGET_BASE"
    echo "If the repo is already partially set up, resolve manually."
    exit 1
fi

# Create target structure and move the repo
mkdir -p "$TARGET_BASE/trunk"
mkdir -p "$TARGET_BASE/worktrees"
mv "$REPO_SOURCE" "$TARGET_PATH"

# Checkout default branch if not already on it
DEFAULT_BRANCH=$(git -C "$TARGET_PATH" symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed 's@^refs/remotes/origin/@@')
if [[ -n "$DEFAULT_BRANCH" ]]; then
    CURRENT_BRANCH=$(git -C "$TARGET_PATH" rev-parse --abbrev-ref HEAD)
    if [[ "$CURRENT_BRANCH" != "$DEFAULT_BRANCH" ]]; then
        echo "Switching from '$CURRENT_BRANCH' to default branch '$DEFAULT_BRANCH'"
        git -C "$TARGET_PATH" checkout "$DEFAULT_BRANCH"
    fi
fi

echo ""
echo "Conversion complete"
echo "Path: $TARGET_PATH"
