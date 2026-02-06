---
name: create-draft-pr
description: Create a draft pull request for the current branch
---

# Create Draft Pull Request

1. Determine if the current branch name starts with `CLOUDR-<number>`. If so, this branch is implementing a Jira ticket, and that is the ticket ID.

2. Push the current branch to GitHub

```bash
git push -u origin HEAD
```

3. Create a draft PR

- If the branch is implementing a Jira ticket, the PR title should start with the ticket ID wrapped in square brackets
- Use the `pull-request-body` skill to format the pull request body

```bash
gh pr create --draft \
  --title "<Short Descriptive Title Capitalized with Title Case>" \
  --body "<body generated with the pull-request-body skill>"
```

4. Report the PR URL to the caller of this skill
