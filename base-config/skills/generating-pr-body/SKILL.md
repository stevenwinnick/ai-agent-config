---
name: generating-pr-body
description: Generates the title and body content for a new or updated pull request. Use when creating or updating PR titles or descriptions.
---

# Pull Request Formatting

Use the following format for every new pull request

When updating an existing pull request, keep the structure that is already there, and rewrite the body to cover all of the changes in the pull request, not just the most recent commits

## Title

Short, descriptive, and in Title Case

## Body

```markdown
## Summary

What changed in this pull request

## Risk Analysis

The risks of merging this pull request

## Testing

The tests that have been run to verify before merging that these are good changes

## Follow-Up

Any work to be done after merging, including validation that the changes behave as expected

## Additional Details (recommended read)

Details that don't fit in the sections above but that the reviewer should still know

## Reference Details (optional read)

Details that may be useful to future contributors but that the reviewer doesn't need

Co-authored by: <AI tool co-author>
```

## Section Guidelines

Every section above `Additional Details` should be as brief as possible: a reviewer's time is valuable. When brevity means leaving something out, note in that section that there are additional details below

- `Additional Details (recommended read)`: keep brief, or omit it, but it can run longer. It must not omit anything crucial for the reviewer
- `Reference Details (optional read)`: as long as it needs to be. Omit it when there are no reference details worth recording

`Testing` and `Follow-Up` always get content, even when there is nothing to report

- Testing: "No testing of these changes has been done"
- Follow-Up: "No follow-up work needs to be completed after merging". Low-impact and low-risk changes don't need follow-ups

In `Follow-Up`, say who should do each item: Steven, whoever merges the PR, or the agent. Use checkboxes when they help
