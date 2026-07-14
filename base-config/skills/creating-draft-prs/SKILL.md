---
name: creating-draft-prs
description: Creates a draft pull request for the current branch. Use when initial work on a branch is ready and a PR should be opened.
---

# Create Draft Pull Request

1. Push the current branch to GitHub

```bash
git push -u origin HEAD
```

2. Create a draft PR

- Use the `generating-pr-body` skill to format the pull request body

```bash
gh pr create --draft \
  --title "<Short Descriptive Title Capitalized with Title Case>" \
  --body "<body generated with the generating-pr-body skill>"
```

3. Report the PR URL to the caller of this skill
