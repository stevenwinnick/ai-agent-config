---
name: starting-code-projects
description: Sets up a reproducible, isolated environment when starting work on a code project. Use when creating a new project or onboarding to an existing project I will work in.
---

# Starting Code Projects

Use these standards when starting work on a project I own — either a new project I create or an existing project I onboard to and will work in. The goal is an isolated, reproducible environment so dependencies stay project-scoped and collaborators can onboard quickly. Do not install project dependencies into a global or system-wide location.

This does not apply to repos cloned from others that don't already use these tools; see "Scope and Limits" below.

## Creating or Cloning the Project

Set the project up in my preferred worktree layout using the `shw` CLI, via the relevant skill:

- New project: use the `initializing-repos` skill, which wraps `shw git repo create`
- Existing project I'm onboarding to: use the `cloning-repos` skill, which clones into the same layout
- Additional branches: use the `managing-worktrees` skill, which wraps `shw git worktree`

## Standard Tools by Language

Use the recorded tool for each language so setup stays consistent across my projects:

- **Python**: `uv` for the Python version, virtual environment, dependencies, and lockfile-based reproducibility

When starting a project in a language not listed above:

1. Recommend an approach for an isolated, reproducible environment; if there are multiple good options, present the pros and cons and let me pick
2. After I choose, use the `improving-agent-config` skill to add the choice to the list above so future projects stay consistent

## Scope and Limits

- Don't default to Docker or other containers unless a task clearly needs or would benefit from them; they typically add overhead that slows things down too much given the value they add
- Don't impose these tools on repos cloned from others that don't already use them if doing so would pollute the repo or add local-only rules to remember; follow the conventions already present in that repo instead
