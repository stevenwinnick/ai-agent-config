---
name: writing-code-meeting-standards
description: Defines code quality standards that apply to all code written or modified. Use when writing or modifying any code.
---

# Code Standards

Apply these standards to all code written or modified. If instructions conflict, prefer active user instructions, then the applicable standard higher in this document.

## Follow Existing Patterns

Match the conventions and style already present in the codebase. Look at nearby code or code in similar contexts for guidance.

## Follow Best Practices

Follow up-to-date best practices when writing code

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
