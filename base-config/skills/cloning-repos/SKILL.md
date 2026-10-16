---
name: cloning-repos
description: Clones a GitHub repo into `$CODE_ROOT`. Use when the user wants to clone a new repository.
argument-hint: "<owner/repo or GitHub URL>"
disable-model-invocation: true
---

# Clone Repo

Clones a GitHub repo into `$CODE_ROOT/<repo-name>/`.

## Usage

Based on $ARGUMENTS, run the script:

```bash
~/.claude/skills/cloning-repos/scripts/clone-repo.sh $ARGUMENTS
```

### Arguments

- `<repo>` (required) — GitHub repo identifier. Accepts `owner/repo` or a GitHub URL

### What It Does

1. Parses the repo identifier to determine the repo name
2. Clones the repo into `$CODE_ROOT/<repo-name>/`

### Result

Report the path to the cloned repo to the user.
