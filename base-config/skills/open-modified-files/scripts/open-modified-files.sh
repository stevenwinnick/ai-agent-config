#!/bin/bash
# Opens all files modified relative to the default branch in Cursor

set -e

# Get default branch
DEFAULT_BRANCH=$(git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed 's@^refs/remotes/origin/@@')
if [[ -z "$DEFAULT_BRANCH" ]]; then
    DEFAULT_BRANCH=$(git remote show origin | grep 'HEAD branch' | cut -d' ' -f5)
fi

# Get modified files
FILES=$(git diff --name-only "origin/$DEFAULT_BRANCH"...HEAD)

if [[ -z "$FILES" ]]; then
    echo "No modified files found relative to $DEFAULT_BRANCH"
    exit 0
fi

echo "Modified files:"
echo "$FILES"

echo "Opening modified files in Cursor:"
# Open each file in Cursor
echo "$FILES" | xargs cursor
