---
name: convert-repo
description: Convert a standard-format git repo to the preferred worktree directory structure
argument-hint: "<path-to-repo>"
disable-model-invocation: true
---

# Convert Repo

Converts an existing standard-format git repo (a normal clone) into the preferred worktree directory structure.

## Usage

Based on $ARGUMENTS, run the script:

```bash
./scripts/convert-repo.sh $ARGUMENTS
```

### Arguments

- `<path-to-repo>` (required) — Path to the existing repo to convert

### What It Does

1. Validates the source is a git repo
2. Creates the preferred directory structure at `$CODE_ROOT/<repo-name>/`
3. Moves the existing repo into `$CODE_ROOT/<repo-name>/<default-branch-name>/<repo-name>/`
4. Creates the empty `worktrees/` directory
5. Ensures the checked-out branch is the default branch

### Result

Report the new path to the user.
