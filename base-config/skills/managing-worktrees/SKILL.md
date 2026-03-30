---
name: managing-worktrees
description: Manages git worktrees - creates, lists, cleans up, or resolves paths to them. Use when working with multiple branches simultaneously or managing worktree structure.
argument-hint: "<repo-dir> [create <branch-name>] | [list] | [remove <branch-name>] | [prune-stale] | [path <branch-name>]"
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

`shw git worktree` defaults to using the current directory as the repo. When you are operating on a different repo, pass `--repo-dir "<repo-dir>"`. `<repo-dir>` may be either the path to any directory inside the target git repository, or the repo container directory that contains the default-branch folder and `worktrees/`.

Use the `shw` CLI for all worktree operations. If `shw` is missing, misconfigured, or returns unexpected output, use the `debugging-shw-cli` skill before continuing.

For agent workflows:

- Prefer `path` when you need a worktree path for a `workdir` or follow-up command
- After `create`, use `path` if you need the resulting path in machine-readable form
- Avoid `prune-stale` unless cleanup is the explicit task, because it can remove local branches without remote-tracking refs

Based on $ARGUMENTS, run the appropriate command:

### create <repo-dir> <branch-name>

```bash
shw git worktree create --repo-dir "<repo-dir>" "<branch-name>"
```

Creates a new worktree with the specified branch name. By default it updates the default branch first, then prints the created path plus a navigation hint.

**Branch Naming Convention:**

In Datadog repos (remote origin contains `DataDog` or `datadog`):
- With Jira ticket: `stevenwinnick/CLOUDR-<number>-<kebab-case-summary>`
- Without Jira ticket: `stevenwinnick/NOJIRA-<YYMMDD>-<kebab-case-summary>`

In all other repos:
- `steven/<short-kebab-case-name>`

### list <repo-dir>

```bash
shw git worktree list --repo-dir "<repo-dir>"
```

Lists all active worktrees

### remove <repo-dir> <branch-name>

```bash
shw git worktree remove --repo-dir "<repo-dir>" "<branch-name>"
```

Removes the worktree for the specified branch. Also deletes the local branch.

### prune-stale <repo-dir>

```bash
shw git worktree prune-stale --repo-dir "<repo-dir>"
```

Prunes stale worktree references and checks for branches which don't exist on remote. Will remove branches which have never been pushed to remote, so be careful not to run it before pushing branches.

### path <repo-dir> <branch-name>

```bash
shw git worktree path --repo-dir "<repo-dir>" "<branch-name>"
```

Prints the path to a specific worktree by branch name. This also works for the default branch, returning the main checkout path.

Use the returned path as the working directory for subsequent commands, or in a shell command such as:

```bash
REPO_DIR="<repo-dir>"
BRANCH_NAME="<branch-name>"
cd $(shw git worktree path --repo-dir "$REPO_DIR" "$BRANCH_NAME")
```
