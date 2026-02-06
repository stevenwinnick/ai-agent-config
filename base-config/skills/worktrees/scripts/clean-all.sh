#!/bin/bash
# Clean up stale worktrees
#
# Stale worktrees are entries where:
# - The worktree directory was manually deleted but git still tracks it
# - The worktree references a branch that does not exist on the remote

set -e

# Remove stale worktree entries (directories deleted but still tracked by git)
git worktree prune
# Remove remote-tracking refs for branches deleted on remote
git fetch --prune

# Get the main worktree path (first one listed, which is the main repo)
main_worktree=$(git worktree list --porcelain | grep "^worktree " | head -1 | cut -d' ' -f2-)

# Extract worktree paths from porcelain output (lines starting with "worktree ")
for wt in $(git worktree list --porcelain | grep "^worktree " | cut -d' ' -f2-); do
    # Skip the main worktree (trunk)
    if [[ "$wt" == "$main_worktree" ]]; then
        continue
    fi

    # Get current branch name for this worktree
    branch=$(git -C "$wt" rev-parse --abbrev-ref HEAD 2>/dev/null)
    if [[ -n "$branch" && "$branch" != "HEAD" ]]; then
        # Check if remote tracking branch still exists
        if ! git show-ref --verify --quiet "refs/remotes/origin/$branch"; then
            echo "Removing worktree $wt: branch '$branch' not on remote"
            git worktree remove --force "$wt"
            # Also delete the local branch
            git branch -D "$branch" 2>/dev/null || true
        fi
    fi
done

echo "Worktree cleanup complete"
