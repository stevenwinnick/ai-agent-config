---
name: worktrees
description: Manage git worktrees - create, list, clean up, or switch between them
argument-hint: "[create <branch-name>] | [list] | [remove <branch-name>] | [clean-all] | [switch <name>]"
---

# Worktree Management

## Directory Structure

Worktrees follow this structure, allowing multiple branches to be checked out simultaneously for parallel work in the same Git repo:

```
$CODE_ROOT/
  <repo-name>/
    trunk/
      <repo-name>/           # Main working copy (on default branch)
    worktrees/
      stevenwinnick--CLOUDR-123-feature-name/
        <repo-name>/         # Worktree for this branch
      stevenwinnick--NOJIRA-260204-fix-bug/
        <repo-name>/         # Another worktree
```

Branch names have slashes replaced with `--` in the directory name.

## Commands

Based on $ARGUMENTS, run the appropriate command:

### create <branch-name>

```bash
./scripts/create.sh "<branch-name>"
```

Creates a new worktree with the specified branch name. Inform the user of the new worktree location.

**Branch Naming Convention:**

In Datadog repos (remote origin contains `DataDog` or `datadog`):
- With Jira ticket: `stevenwinnick/CLOUDR-<number>-<kebab-case-summary>`
- Without Jira ticket: `stevenwinnick/NOJIRA-<YYMMDD>-<kebab-case-summary>`

In all other repos:
- `steven/<short-kebab-case-name>`

### list

```bash
./scripts/list.sh
```

Lists all active worktrees and shows the status of each

### remove <branch-name>

```bash
./scripts/remove.sh "<branch-name>"
```

Removes the worktree for the specified branch. Also deletes the local branch.

### clean-all

```bash
./scripts/clean-all.sh
```

Prunes stale worktree references and checks for branches which don't exist on remote. Will remove branches which have never been pushed to remote, so be careful not to run it before pushing branches.

### switch <name>

```bash
./scripts/switch.sh "<name>"
```

Switches to a specific worktree
