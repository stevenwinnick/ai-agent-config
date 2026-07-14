#!/bin/bash
# Remove a specific worktree by branch name
#
# Usage: ./remove.sh <repo-dir> <branch-name>

set -e

REPO_DIR="$1"
branch_name="$2"

if [[ -z "$REPO_DIR" || -z "$branch_name" ]]; then
    echo "Usage: ./remove.sh <repo-dir> <branch-name>"
    exit 1
fi

cd "$REPO_DIR"

# Convert branch slashes to -- for filesystem-safe directory name (matching create.sh)
worktree_dir=$(echo "$branch_name" | sed 's|/|--|g')

# Find the worktree for this branch
worktree_path=$(git worktree list --porcelain | grep -B2 "branch refs/heads/$branch_name$" | grep "^worktree " | cut -d' ' -f2-)

if [[ -z "$worktree_path" ]]; then
    echo "Error: No worktree found for branch '$branch_name'"
    echo ""
    echo "Available worktrees:"
    git worktree list
    exit 1
fi

# Get the parent directory (the worktree_dir folder that contains the repo)
parent_dir=$(dirname "$worktree_path")

echo "Removing worktree: $worktree_path (branch: $branch_name)"
git worktree remove --force "$worktree_path"

# Delete the parent directory (e.g., worktrees/steven--foo/)
if [[ -d "$parent_dir" ]]; then
    echo "Removing directory: $parent_dir"
    rm -rf "$parent_dir"
fi

# Delete the local branch
if git show-ref --verify --quiet "refs/heads/$branch_name"; then
    echo "Deleting local branch: $branch_name"
    git branch -D "$branch_name" 2>/dev/null || true
fi

echo "Worktree removed successfully"
