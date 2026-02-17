# AI Agent Config

Central configuration repository for AI agents (as of now: Claude Code, Cursor, Codex CLI)

## Overview

This repo maintains a single source of truth for machine-wide AI agent configurations, with support for tool-specific overrides. Each tool has its own configuration script that merges base configs with overrides when needed to produce tool-specific outputs in `generated/`. Symlinks connect these files to each tool's expected location.

## Directory Structure

```
├── base-config/           # Shared configs and skills for all tools
│   ├── AGENTS.md          # Base agent instructions
│   └── skills/            # Base skill definitions
├── overrides/             # Tool-specific modifications, if necessary
│   ├── claude/            # Claude Code overrides
│   ├── codex/             # Codex CLI overrides
│   └── cursor/            # Cursor overrides
├── generated/             # Script-generated outputs to be used (not committed)
└── scripts/               # Configuration scripts
```

## Setup

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
./scripts/configure-cursor.sh
```

### Testing

#### When to Test

Always run tests before proposing modifications to this repo (e.g., before creating or updating a pull request).

#### Validation Scripts

Run the test script to validate that all agents can see AGENTS.md and the `exploring-and-discovering` skill:

```bash
./scripts/test-configs.sh
```

Or update configs and test in one step:

```bash
./scripts/update-and-test-configs.sh
```

These scripts run each agent (Claude Code, Codex CLI, Cursor CLI) in headless mode with probe questions to confirm that AGENTS.md is loaded and the `exploring-and-discovering` skill is accessible.

The configure scripts derive paths from their own location, so you can test changes from a branch worktree by running the scripts from that worktree's path:

```bash
# Test from a branch worktree
<branch-worktree>/scripts/update-and-test-configs.sh

# After testing, restore trunk config
./scripts/apply-updated-trunk-config.sh
```

You must also run `apply-updated-trunk-config.sh` after merging changes to trunk to apply the latest configuration.

#### Manual Testing

##### Cursor UI

Manually validate configurations used by the Cursor UI (matches validation script checks):

1. Open Cursor Settings (Cmd+Shift+J) and navigate to **Rules**
2. Verify skills appear in the **Agent Decides** section (e.g., `exploring-and-discovering`)
3. In Agent chat, type `/exploring-and-discovering` to confirm the skill is available
4. Ask Cursor: "What skill should I use for file editing tasks?" - response should reference 'exploring-and-discovering'

Don't forget that setting a global `AGENTS.md` requires a manual operation for Cursor. You'll have to

1. Run `cat ./base-config/AGENTS.md | pbcopy`
2. Open Cursor Settings (Cmd+Shift+J)
3. Navigate to: Rules and Commands > User Rules
4. Delete the existing rule
5. Paste

### Style

- Prefer single sources of truth which can be shared across multiple configurations
  - Example: if a particular agent can use either a general `AGENTS.md` file or a file type specific to that agent equally well, use the general `AGENTS.md`
  - Another example: if an agent can use a symlinked shared configuration file and a custom configuration file equally well, prefer the symlinked file
- Prefer higher determinism (ex. code scripts > natural language agent instructions) when possible

## Architecture

### Configuration Scripts

Each tool has its own configuration script with custom output generation and symlink logic based on the specific requirements of that tool. Tool-specific overrides can thus be applied in tool-specific ways.

## Environment Variables

The `CODE_ROOT` environment variable is expected to be be set to the root directory for all repos.

Example (add to your shell config using the `custom-shell-setup` skill):
```bash
export CODE_ROOT="$HOME"
```
