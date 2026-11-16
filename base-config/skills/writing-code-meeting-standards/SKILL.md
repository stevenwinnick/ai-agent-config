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

Represent each concept one way everywhere. Reuse an existing type instead of adding a near-copy, share one shape between features that express the same thing, and when a representation changes, change it everywhere it appears.

## Prefer Standards

Prefer an industry-standard library, format, or protocol over writing your own, e.g. the JSON Schema `date-time` format over a custom date pattern

## Naming

- Name new concepts after the industry-standard term, even when the request suggests another name
- Name a thing for what it holds, not for how it's shown or delivered, e.g. `ProductSearchResults` rather than `ProductPage`
- Qualify a name when a sibling could be confused with it, e.g. `stockAlerts` next to `arrivalAlerts` rather than `alerts`
- When you rename a concept, rename it everywhere it appears (types, fields, functions, files, components, tests, and user-facing text), then make the same pattern consistent elsewhere

## Data Modeling

- When which fields apply depends on a kind, model one variant per kind (a discriminated union) rather than one object with every field optional
- Compose a type by extending a smaller one, e.g. a record that adds an `id` to its input type. Remove fields (`Omit`) only when taking fields away is what you mean
- Key values by name, not by position in an array, so reordering or extending the array can't silently change what they mean
- Compare dates and times by the moment they represent, not as text, since one instant can be written several ways
- Record a value that changes over time, like a price, as a history of effective-dated entries, so past and announced future values stay known
- Keep planned data apart from recorded data, so changing a plan updates only what that plan created

## Documentation

- Don't list in documentation what the code already lists, such as a type's members or the supported values. Point to the file that defines them, since a copied list goes stale
- Put guidance about using a definition in a comment next to that definition, not in a README
- Write steps as instructions ("Define the schema"), not as descriptions of what happens
- Describe what the code does exactly, e.g. "in the order they were added" rather than "in preference order" when nothing ranks them
- When a name doesn't say what something is for, its description does
- Use January 1, 2000 in date examples

## Prefer Determinism

Prefer more deterministic code (ex. traditional programmatic scripts) over nondeterministic code (ex. AI prompting) when possible

## Stay Focused

Only implement the changes requested. Don't make other improvements to the code or complete existing TODO comments unless necessary to implement your task. Instead, when you identify that these improvements should be made, suggest them to the user to complete as a follow-up action

## Formatting Preferences

- Use markdown formatting in documentation and comments where appropriate
- When possible, use angled brackets to indicate placeholders
- Leave a newline at the end of files

### Markdown Formatting Preferences

- Leave blank lines above and below headers and between paragraphs
- One-sentence-or-less paragraphs and bullet points should not end with a period
- Include at most one H1 header in a markdown block or file. If included, it should be at the top.

## Comment Sparingly

Default to no comments. Most code should be self-explanatory. Add a comment only when it captures something that a quick read of the code doesn't: confusing or non-obvious behavior, workarounds and design constraints not captured elsewhere, footguns, or facts that if unknown may trip future contributors.

Only reference the current task if necessary to understanding design decisions, or if a link to the task tracked in other software contains additional context that would benefit future contributors.

Keep comments to one line where possible. A longer, multi-line comment is warranted when explaining something with broad scope or genuine complexity, such as a non-obvious algorithm, regex pattern, or a non-trivial shell command.

## Avoid Formatting Requiring Visual Consistency

Avoid code that requires manual alignment or visual coordination across lines. Examples:
- Underlines or borders that must match the length of adjacent text
- Indentation in terminal output for visual hierarchy (e.g., leading spaces in echo statements)
- ASCII art or box-drawing that breaks if content changes

## Don't Over-Engineer

Prefer the simplest, minimal required solution when possible.
