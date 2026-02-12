#!/bin/bash
# List all git worktrees and their status

set -e

git worktree list

# Extract worktree paths from porcelain output (lines starting with "worktree ")
for wt in $(git worktree list --porcelain | grep "^worktree " | cut -d' ' -f2-); do
    echo "$wt:"
    # Run git status in each worktree directory
    git -C "$wt" status --short 2>/dev/null || echo "(not accessible)"
done
