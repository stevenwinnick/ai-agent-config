---
name: improving-agent-config
description: Suggests and implements improvements to AI agent configuration. Use when improvements to agent behavior are identified or when the user asks for configuration changes.
---

# Improve Agent Configuration

You are improving the AI agent configuration to be more helpful.

## Context

The relevant AI agent configuration most likely lives at `~/.ai-agent-config/`, or the repository symlinked there. Explore that repo to understand how to best make the intended changes there.

## Known Workarounds

### Absolute paths for skill scripts

Claude Code's skill docs recommend relative paths for scripts (e.g., `scripts/helper.py`), but in practice the shell's working directory is the user's project, not the skill directory. Until Claude Code supports a `$SKILL_DIR` variable or changes the working directory for skill script execution, use absolute paths like `~/.claude/skills/<skill-name>/scripts/<script>` in bash command blocks within SKILL.md files. Continue applying this workaround when creating or modifying skills that reference scripts.
