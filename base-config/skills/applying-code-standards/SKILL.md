---
name: applying-code-standards
description: Defines code quality standards that apply to all code written or modified. Use when writing or modifying any code, setting up a project's environment, or installing dependencies.
---

# Code Standards

Apply these standards to all code written or modified. If instructions conflict, prefer active user instructions, then the applicable standard higher in this document.

## Follow Existing Patterns

Match the conventions and style already present in the codebase. Look at nearby code or code in similar contexts for guidance.

## Follow Best Practices

Follow up-to-date best practices when writing code

## Environment & Dependency Management

For projects I own or create, use an isolated, reproducible environment so dependencies stay project-scoped and collaborators can onboard quickly. Do not install project dependencies into a global or system-wide location.

### Standard Tools by Language

Use the recorded tool for each language so setup stays consistent across my projects:

- **Python**: `uv` for the Python version, virtual environment, dependencies, and lockfile-based reproducibility (onboard collaborators with `uv sync`)

When starting a project in a language not listed above:

1. Recommend an approach for an isolated, reproducible environment; if there are multiple good options, present the pros and cons and let me pick
2. After I choose, use the `improving-agent-config` skill to add the choice to the list above so future projects stay consistent

### Global Installs

Before installing anything globally (system-wide or user-wide) that could interfere with my other work or projects, confirm with me first. Prefer project-scoped installation.

### Scope and Limits

- Don't default to Docker or other containers; they add overhead that slows things down, so use them only when a task explicitly needs them
- Don't impose these tools on repos cloned from others that don't already use them, where doing so would pollute the repo or add local-only rules to remember; follow the conventions already present in that repo instead

## Testing

Always write tests for new code when feasible. Tests should test actual desired code functionality, and not just implementation details.

## Single Source of Truth

Avoid duplicating logic or data. Centralize definitions and reference them where needed.

## Prefer Determinism

Prefer more deterministic code (ex. traditional programmatic scripts) over nondeterministic code (ex. AI prompting) when possible

## Stay Focused

Only implement the changes requested. Don't make other improvements to the code or complete existing TODO comments unless necessary to implement your task. Instead, when you identify that these improvements should be made, suggest them to the user to complete as a follow-up action

## Formatting Preferences

- Avoid using emojis
- Use markdown formatting in documentation and comments where appropriate
- When possible, use angled brackets to indicate placeholders
- Leave a newline at the end of files

### Markdown Formatting Preferences

- Leave blank lines above and below headers and between paragraphs
- One-sentence-or-less paragraphs and bullet points should not end with a period
- Include at most one H1 header in a markdown block or file. If included, it should be at the top.

## Comment Complex Code

Add explanatory comments to code that is difficult to read at a glance. This includes regex patterns, non-trivial shell commands, and other logic where the intent is not immediately obvious.

## Avoid Formatting Requiring Visual Consistency

Avoid code that requires manual alignment or visual coordination across lines. Examples:
- Underlines or borders that must match the length of adjacent text
- Indentation in terminal output for visual hierarchy (e.g., leading spaces in echo statements)
- ASCII art or box-drawing that breaks if content changes

## Don't Over-Engineer

Prefer the simplest, minimal required solution when possible.
