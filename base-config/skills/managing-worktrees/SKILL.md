---
name: managing-worktrees
description: Manages git worktrees - creates, lists, cleans up, or switches between them. Use when working with multiple branches simultaneously or managing worktree structure.
argument-hint: "[create <branch-name>] | [list] | [remove <branch-name>] | [clean-all] | [switch <name>]"
---

# Worktree Management

## Directory Structure

Worktrees follow this structure, allowing multiple branches to be checked out simultaneously for parallel work in the same Git repo:

```
$CODE_ROOT/
  <repo-name>/
    <default-branch-name>/
      <repo-name>/           # Main working copy (on default branch)
    worktrees/
      stevenwinnick--CLOUDR-123-feature-name/
        <repo-name>/         # Worktree for this branch
      stevenwinnick--NOJIRA-260204-fix-bug/
        <repo-name>/         # Another worktree
```

The `<default-branch-name>/` directory is named after the repo's default branch (e.g., `main`, `master`, `trunk`, etc.). Always detect the default branch dynamically rather than assuming its name.

Branch names have slashes replaced with `--` in the directory name.

## Commands

Based on $ARGUMENTS, run the appropriate command:

### create <branch-name>

```bash
~/.claude/skills/managing-worktrees/scripts/create.sh "<branch-name>"
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
~/.claude/skills/managing-worktrees/scripts/list.sh
```

Lists all active worktrees and shows the status of each

### remove <branch-name>

```bash
~/.claude/skills/managing-worktrees/scripts/remove.sh "<branch-name>"
```

Removes the worktree for the specified branch. Also deletes the local branch.

### clean-all

```bash
~/.claude/skills/managing-worktrees/scripts/clean-all.sh
```

Prunes stale worktree references and checks for branches which don't exist on remote. Will remove branches which have never been pushed to remote, so be careful not to run it before pushing branches.

### switch <name>

```bash
~/.claude/skills/managing-worktrees/scripts/switch.sh "<name>"
```

Switches to a specific worktree
