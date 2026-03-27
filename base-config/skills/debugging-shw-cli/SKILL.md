---
name: debugging-shw-cli
description: Diagnoses problems with the shw CLI installation, commands, or behavior. Use when shw is missing, failing, or returning unexpected results.
argument-hint: [repo-dir] [failing-command]
---

# Debug shw CLI

Use this skill when `shw` is missing, when a `shw` command fails, or when the output does not match expectations.

## Quick Checks

Start with the installed binary:

```bash
which shw
shw -h
```

If the user provided a failing command, run it directly and capture the exact error.

## Worktree Command Checks

When the issue involves worktrees, verify the repo layout and the specific command:

```bash
shw git worktree list "<repo-dir>"
shw git worktree path "<repo-dir>" "<name>"
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
