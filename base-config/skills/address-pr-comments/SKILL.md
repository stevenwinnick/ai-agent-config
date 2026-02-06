---
name: address-pr-comments
description: Address review comments on a pull request. Addresses all unresolved comments or a specific one.
argument-hint: [comment-url-or-number]
---

# Address PR Comments

## Step 1: Identify the Pull Request

Determine the current PR using:

```bash
gh pr view --json number,url,headRefName
```

If no PR is found for the current branch, stop and inform the user.

## Step 2: Fetch Comments

If an argument was provided ($ARGUMENTS), it identifies a specific comment to address:

- If the argument is a URL, extract the comment ID from it
- If the argument is a number, use it as the comment ID

Fetch the relevant comments:

```bash
# All pending review comments
gh api repos/{owner}/{repo}/pulls/{pr_number}/comments --jq '.[] | select(.in_reply_to_id == null) | {id, path, line, body, diff_hunk}'

# Or a specific comment by ID
gh api repos/{owner}/{repo}/pulls/{pr_number}/comments/{comment_id} --jq '{id, path, line, body, diff_hunk}'
```

Also check for unresolved review threads to understand which comments still need attention:

```bash
gh pr view {pr_number} --json reviewDecision,reviews
```

Filter to only comments that haven't been addressed yet (no reply from the PR author indicating the comment was addressed).

If there are no unresolved comments, inform the user and stop.

## Step 3: Present Comments for Confirmation

Before making any changes, present the list of comments to be addressed in a clear summary. For each comment, include:

- The file and line it refers to
- The comment body
- Your understanding of what change is being requested

Ask the user to confirm which comments to address, or to proceed with all of them.

## Step 4: Address Each Comment

For each comment to be addressed:

1. Read the relevant file and surrounding code using the `explore-and-discover` skill if the context from the diff hunk is insufficient
2. Understand what change the reviewer is requesting
3. Make the code change, following the `code-standards` skill
4. Reply to the comment on GitHub indicating what was done:

```bash
gh api repos/{owner}/{repo}/pulls/{pr_number}/comments/{comment_id}/replies -f body="<brief description of the change made>"
```

If a comment is unclear or you're unsure how to address it, skip it and flag it to the user rather than guessing.

## Step 5: Push and Update

1. Commit the changes with a descriptive message referencing the comments addressed
2. Push to the remote branch
3. Use the `update-pull-request` skill to update the PR

## Step 6: Report

Present a summary of what was done:

- Comments addressed (with file and line references)
- Comments skipped and why
- Link to the PR
