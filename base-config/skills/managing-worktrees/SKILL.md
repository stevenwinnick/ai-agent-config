---
name: managing-worktrees
description: Manages git worktrees - creates, lists, cleans up, or resolves paths to them. Use when working with multiple branches simultaneously or managing worktree structure.
argument-hint: "[create <branch-name>] | [list] | [remove <branch-name>] | [prune-stale] | [path <branch-name>]"
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

Use the `shw` CLI for all worktree operations.

`shw git worktree` defaults to using the current directory as the repo. When you are operating on a different repo, pass `--repo-dir "<repo-dir>"`.

Based on $ARGUMENTS, run the appropriate command:

### create <branch-name>

```bash
shw git worktree create "<branch-name>"
```

Creates a new worktree with the specified branch name. By default it updates the default branch first, then prints the created path plus a navigation hint.

**Branch Naming Convention:**

In Datadog repos (remote origin contains `DataDog` or `datadog`):
- With Jira ticket: `stevenwinnick/CLOUDR-<number>-<kebab-case-summary>`
- Without Jira ticket: `stevenwinnick/NOJIRA-<YYMMDD>-<kebab-case-summary>`

In all other repos:
- `steven/<short-kebab-case-name>`

### list

```bash
shw git worktree list
```

Lists all active worktrees for a repo

### remove <branch-name>

```bash
shw git worktree remove "<branch-name>"
```

Removes the worktree for the specified branch and deletes the local branch

### prune-stale

```bash
shw git worktree prune-stale
```

Prunes stale worktree references and checks for branches which don't exist on remote. Will remove branches which have never been pushed to remote, so be careful not to run it before pushing branches.

### path <branch-name>

```bash
shw git worktree path "<branch-name>"
```

Prints the path to a specific worktree by branch name

Use the returned path as the working directory for subsequent commands, or in a shell command such as:

```bash
REPO_DIR="<repo-dir>"
BRANCH_NAME="<branch-name>"
cd $(shw git worktree path --repo-dir "$REPO_DIR" "$BRANCH_NAME")
```
