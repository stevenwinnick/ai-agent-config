---
name: debugging-shw-cli
description: Information on the `shw` CLI. Use when shw is missing, failing, or returning unexpected results.
---

# The `shw` CLI

The `shw` CLI provides helper commands for Steven's repeated workflows

## Source Code

The source code for the `shw` CLI should exist locally at the `shw-cli` repo

Update the source code and install the CLI from that repo to validate changes. Create pull requests when fixes are made.

## Installation Path

Use `which shw` to verify the installation and identify the installation path

## Worktree Command Checks

When the issue involves worktrees, verify the repo layout and the specific command:

```bash
shw git worktree list --repo-dir "<repo-dir>"
shw git worktree path --repo-dir "<repo-dir>" "<branch-name>"
```

If needed, rerun the failing worktree command with the exact arguments the user or calling skill used.

## Source-of-Truth Checks

The source for `shw` lives at:

```bash
$CODE_ROOT/shw-cli/trunk/shw-cli
```

From that repo:

```bash
go test ./...
go run ./cmd/shw/main.go -h
```

If the installed binary appears out of date relative to the source checkout, reinstall it:

```bash
cd "$CODE_ROOT/shw-cli/trunk/shw-cli"
./scripts/install.sh
```

## Report Back

Summarize:

- Whether `shw` was installed and on `PATH`
- Whether the failure reproduced from the installed binary
- Whether it also reproduced from `go run ./cmd/shw/main.go`
- Any fix applied, such as reinstalling the binary or correcting command usage
