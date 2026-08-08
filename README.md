# AI Agent Config

Central configuration repository for AI agents (as of now: Claude Code, Codex CLI)

## Overview

This repo maintains a single source of truth for machine-wide AI agent configurations, with support for tool-specific overrides. Each tool has its own configuration script that merges base configs with overrides when needed to produce tool-specific outputs in `generated/`. Symlinks connect these files to each tool's expected location.

## Directory Structure

```
├── base-config/           # Shared configs and skills for all tools
│   ├── AGENTS.md          # Base agent instructions
│   └── skills/            # Base skill definitions
├── overrides/             # Tool-specific modifications, if necessary
│   ├── claude/            # Claude Code overrides
│   └── codex/             # Codex CLI overrides
├── generated/             # Script-generated outputs to be used (not committed)
└── scripts/               # Configuration scripts
```

## Setup

### One-Time: Create the Robots User

Agents run as a dedicated non-admin macOS user so they are sandboxed from the personal user's credentials

```bash
sudo sysadminctl -addUser stevenwinnickrobots -fullName "Steven Winnick Robots" -password - -shell /bin/zsh

# Must print that the user is NOT a member; sudo access would defeat the sandbox
sudo dseditgroup -o checkmember -m stevenwinnickrobots admin
```

Start agent sessions as that user with `shw robots start`

### Configure Agents

```bash
# Generate and symlink all tool configs
./scripts/configure-all.sh
```

## Development Instructions

### Update configurations after making changes

```bash
# Update all configs (always re-symlinks)
./scripts/configure-all.sh

# Or update a specific tool
./scripts/configure-claude.sh
./scripts/configure-codex.sh
```

### Testing

#### When to Test

Always run tests before proposing modifications to this repo (e.g., before creating or updating a pull request).

#### Validation Scripts

Run the test script to validate that all agents can see AGENTS.md and the `editing-files` skill:

```bash
./scripts/test-configs.sh
```

Or update configs and test in one step:

```bash
./scripts/update-and-test-configs.sh
```

These scripts run each agent (Claude Code, Codex CLI) in headless mode with probe questions to confirm that AGENTS.md is loaded and the `editing-files` skill is accessible.

#### Branch Validation Workflow

Before presenting a PR to the user, apply and test from the branch worktree:

```bash
<branch-worktree>/scripts/update-and-test-configs.sh
```

This repoints `~/.ai-agent-config` to the branch worktree and runs all validation. Tell the user to let you know when they merge so you can apply the post-merge steps.

After the user merges, pull the default branch and re-apply and re-test:

```bash
# From the trunk worktree, after pulling
./scripts/apply-updated-trunk-config.sh
./scripts/test-configs.sh
```

`apply-updated-trunk-config.sh` resolves the default-branch worktree from git metadata, so it still restores trunk even if `~/.ai-agent-config` currently points at a branch worktree.

### Style

- Prefer single sources of truth which can be shared across multiple configurations
  - Example: if a particular agent can use either a general `AGENTS.md` file or a file type specific to that agent equally well, use the general `AGENTS.md`
  - Another example: if an agent can use a symlinked shared configuration file and a custom configuration file equally well, prefer the symlinked file
- Prefer higher determinism (ex. code scripts > natural language agent instructions) when possible

## Architecture

### Config Home Symlink

All configure scripts call `scripts/configure-ai-agent-config-home.sh`, which repoints `~/.ai-agent-config` to the repo checkout where the script is run. This keeps downstream symlinks stable (for example `~/.codex/skills/*`) while still allowing branch worktree testing.

### Configuration Scripts

Each tool has its own configuration script with custom output generation and symlink logic based on the specific requirements of that tool. Tool-specific overrides can thus be applied in tool-specific ways.

## Environment Variables

The `CODE_ROOT` environment variable is expected to be be set to the root directory for all repos.

Example (add to your shell config using the `custom-shell-setup` skill):
```bash
export CODE_ROOT="$HOME"
```
