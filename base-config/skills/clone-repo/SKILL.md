---
name: clone-repo
description: Clone a GitHub repo into the preferred worktree directory structure
argument-hint: "<owner/repo or GitHub URL>"
disable-model-invocation: true
---

# Clone Repo

Clones a GitHub repo directly into the preferred worktree directory structure.

## Usage

Based on $ARGUMENTS, run the script:

```bash
./scripts/clone-repo.sh $ARGUMENTS
```

### Arguments

- `<repo>` (required) — GitHub repo identifier. Accepts `owner/repo` or a GitHub URL

### What It Does

1. Parses the repo identifier to determine the repo name
2. Clones the repo into `$CODE_ROOT/<repo-name>/trunk/<repo-name>/`
3. Creates the empty `worktrees/` directory

### Result

Report the path to the cloned repo to the user.
