---
name: address-pr-comments
description: Address review comments on a pull request. Addresses all unresolved comments or specific ones.
argument-hint: [pr-url-or-number] | [comment-url-or-number ...]
---

# Address PR Comments

## Step 1: Parse Arguments and Identify the Pull Request

Arguments ($ARGUMENTS) can be:

- **Nothing** — use the current branch's PR
- **A PR URL or number** — address all unresolved comments on that PR
- **One or more comment URLs or numbers** — address only those specific comments

Determine which case applies by inspecting the arguments. PR URLs contain `/pull/` while comment URLs contain `/discussion_r` or `#discussion_r`. A bare number is ambiguous — treat it as a PR number if it's the only argument, or as comment IDs if there are multiple.

To identify the PR:

```bash
# From current branch
gh pr view --json number,url,headRefName

# From a PR number or URL
gh pr view <pr-number-or-url> --json number,url,headRefName
```

If no PR is found, stop and inform the user.

## Step 2: Fetch Comments

Determine whether to fetch all comments or specific ones based on Step 1.

There are two types of PR comments to fetch:

### Line-level review comments

These are comments attached to specific lines of code in the diff.

```bash
# All pending line-level review comments
gh api repos/{owner}/{repo}/pulls/{pr_number}/comments --jq '.[] | select(.in_reply_to_id == null) | {id, path, line, body, diff_hunk}'

# Or a specific comment by ID
gh api repos/{owner}/{repo}/pulls/{pr_number}/comments/{comment_id} --jq '{id, path, line, body, diff_hunk}'
```

### Review-level comments

These are top-level comments submitted as part of a review (the body text written when a reviewer submits a review with "Comment", "Approve", or "Request changes"). They are not attached to specific lines.

```bash
# All reviews with non-empty body text
gh api repos/{owner}/{repo}/pulls/{pr_number}/reviews --jq '.[] | select(.body != null and .body != "") | {id, body, state, user: .user.login}'
```

### Determine which comments still need attention

```bash
gh pr view {pr_number} --json reviewDecision,reviews
```

Filter to only comments that haven't been addressed yet (no reply from the PR author indicating the comment was addressed). For review-level comments, consider a review addressed if a subsequent reply or commit has addressed the feedback.

If there are no unresolved comments of either type, inform the user and stop.

## Step 3: Present Comments for Confirmation

If specific comments were provided, skip this step.

Before making any changes, present the list of comments to be addressed in a clear summary.

For line-level comments, include:

- The file and line it refers to
- The comment body
- Your understanding of what change is being requested

For review-level comments, include:

- The reviewer and review state (e.g., "requested changes", "commented")
- The comment body
- Your understanding of what changes are being requested

## Step 4: Address Each Comment

For each comment to be addressed:

1. Read the relevant file and surrounding context using the `explore-and-discover` skill if the context from the diff hunk is insufficient
2. Understand what the reviewer is requesting
3. Address the comment — this may involve code changes (following the `code-standards` skill), documentation updates, configuration changes, or any other appropriate action
4. Reply on GitHub indicating what was done and which AI agent/tool made the change:

For line-level comments, reply to the comment thread:

```bash
gh api repos/{owner}/{repo}/pulls/{pr_number}/comments/{comment_id}/replies -f body="<brief description of the action taken>

— addressed by <AI tool name>"
```

For review-level comments, leave a regular PR comment referencing the review:

```bash
gh pr comment {pr_number} --body "Addressing review from @{reviewer_username}:

<brief description of the actions taken>

— addressed by <AI tool name>"
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
