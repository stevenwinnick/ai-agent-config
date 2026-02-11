---
name: init-repo
description: Initialize a new local git repo in the preferred worktree directory structure and create its GitHub remote
argument-hint: "<repo-name> [--description <description>] [--public]"
disable-model-invocation: true
---

# Initialize Repo

Creates a new git repo in the preferred worktree directory structure and pushes it to GitHub.

## Usage

Based on $ARGUMENTS, run the script:

```bash
~/.claude/skills/init-repo/scripts/init-repo.sh $ARGUMENTS
```

### Arguments

- `<repo-name>` (required) — Name of the new repo
- `--description <description>` (optional) — Description for the GitHub repo
- `--public` (optional) — Make the GitHub repo public. Defaults to private

### What It Does

1. Creates the directory structure at `$CODE_ROOT/<repo-name>/trunk/<repo-name>/`
2. Initializes a git repo with `trunk` as the default branch
3. Creates a `.gitignore` file
4. Makes an initial commit
5. Creates the GitHub repo (private by default)
6. Pushes the initial commit

### Result

Report the path to the new repo and the GitHub URL to the user.
