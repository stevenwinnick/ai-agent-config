---
name: custom-shell-setup
description: Add, modify, or remove settings in Steven's custom shell setup section of ~/.zshrc. Use when making changes to personal shell configuration.
---

# Custom Shell Setup

Steven's personal shell configuration lives in `~/.zshrc` within a clearly marked section. Other sections of the file are managed externally and must not be modified by this skill.

## Structure

All custom shell settings belong inside the outer block:

```bash
# BEGIN: Steven's Custom Setup
...
# END: Steven's Custom Setup
```

Each individual setting within that block must be wrapped with its own BEGIN/END comments that describe the setting's purpose:

```bash
# BEGIN: Steven's Custom Setup

# BEGIN: Setting CODE_ROOT to enable preferred agent worktree structure
export CODE_ROOT="$HOME"
# END: Setting CODE_ROOT to enable preferred agent worktree structure

# END: Steven's Custom Setup
```

## Adding a New Setting

1. Read `~/.zshrc` and locate the `# BEGIN: Steven's Custom Setup` / `# END: Steven's Custom Setup` block
2. Add the new setting between the outer markers, but outside any existing inner BEGIN/END blocks
3. Wrap the new setting with its own `# BEGIN: <description>` / `# END: <description>` comments where the description explains the purpose of the setting

## Updating an Existing Setting

1. Read `~/.zshrc` and search for the matching `# BEGIN: <description>` / `# END: <description>` block by its description text
2. Modify the contents between those markers
3. If the purpose of the setting has changed, update the BEGIN/END description to match

## Removing a Setting

1. Read `~/.zshrc` and search for the matching `# BEGIN: <description>` / `# END: <description>` block by its description text
2. Remove the entire block including its BEGIN/END comments

## Rules

- Never assume line numbers — always search for the relevant BEGIN/END markers by description text
- Never modify anything outside the outer `Steven's Custom Setup` block
- Every setting must have its own inner BEGIN/END comment pair
- Keep descriptions concise but clear about the setting's purpose
