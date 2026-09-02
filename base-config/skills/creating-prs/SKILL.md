---
name: creating-prs
description: Creates a pull request for the current branch. Use when initial work on a branch is ready and a PR should be opened.
---

# Create Pull Request

1. Push the current branch to GitHub

```bash
git push -u origin HEAD
```

2. Create the PR

- Use the `generating-pr-body` skill to format the pull request title and body

```bash
gh pr create \
  --title "<title generated with the generating-pr-body skill>" \
  --body "<body generated with the generating-pr-body skill>"
```

3. Report the PR URL to the caller of this skill
