---
name: managing-worktrees
description: Manages git worktrees - creates, lists, cleans up, or resolves paths to them. Use when working with multiple branches simultaneously or managing worktree structure.
argument-hint: "<repo-dir> [create <branch-name>] | [list] | [remove <branch-name>] | [clean-all] | [path <name>]"
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

All commands take `<repo-dir>` as their first argument — either the path to any directory inside the target git repository, or the repo container directory that contains the default-branch folder and `worktrees/`. This ensures commands work regardless of the agent's current working directory.

Use the `shw` CLI for all worktree operations. If `shw` is missing, misconfigured, or returns unexpected output, use the `debugging-shw-cli` skill before continuing.

For agent workflows:

- Prefer `create --quiet` when you need the new worktree path as machine-readable output
- Prefer `path` when you need to resolve an existing worktree to a `workdir`
- Avoid `clean-all` unless cleanup is the explicit task, because it can remove local branches without remote-tracking refs

Based on $ARGUMENTS, run the appropriate command:

### create <repo-dir> <branch-name>

```bash
shw git worktree create --quiet "<repo-dir>" "<branch-name>"
```

Creates a new worktree with the specified branch name and prints only the created path.

**Branch Naming Convention:**

In Datadog repos (remote origin contains `DataDog` or `datadog`):
- With Jira ticket: `stevenwinnick/CLOUDR-<number>-<kebab-case-summary>`
- Without Jira ticket: `stevenwinnick/NOJIRA-<YYMMDD>-<kebab-case-summary>`

In all other repos:
- `steven/<short-kebab-case-name>`

### list <repo-dir>

```bash
shw git worktree list "<repo-dir>"
```

Lists all active worktrees and shows the status of each

### remove <repo-dir> <branch-name>

```bash
shw git worktree remove "<repo-dir>" "<branch-name>"
```

Removes the worktree for the specified branch. Also deletes the local branch.

### clean-all <repo-dir>

```bash
shw git worktree clean-all "<repo-dir>"
```

Prunes stale worktree references and checks for branches which don't exist on remote. Will remove branches which have never been pushed to remote, so be careful not to run it before pushing branches.

### path <repo-dir> <name>

```bash
shw git worktree path "<repo-dir>" "<name>"
```

Prints the path to a specific worktree

Use the returned path as the working directory for subsequent commands, or in a shell command such as:

```bash
REPO_DIR="<repo-dir>"
NAME="<name>"
cd "$(shw git worktree path "$REPO_DIR" "$NAME")"
```
