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

There are four types of PR comments to fetch:

### Line-level review comments

These are comments attached to specific lines of code in the diff.

```bash
# All pending line-level review comments (top-level only, not replies)
gh api repos/{owner}/{repo}/pulls/{pr_number}/comments \
  --jq '[.[] | select(.in_reply_to_id == null) | {id, path, line, body, diff_hunk}]'

# Or a specific comment by ID
gh api repos/{owner}/{repo}/pulls/{pr_number}/comments/{comment_id} \
  --jq '{id, path, line, body, diff_hunk}'
```

### Review-level comments

These are top-level comments submitted as part of a review (the body text written when a reviewer submits a review with "Comment", "Approve", or "Request changes"). They are not attached to specific lines.

```bash
# All reviews with non-empty body text
gh api repos/{owner}/{repo}/pulls/{pr_number}/reviews \
  --jq '[.[] | select(.body | length > 0) | {id, body, state, user: .user.login}]'
```

### Conversation comments

These are general comments on the PR conversation thread, not attached to code or a review. Since GitHub treats PRs as issues, these are fetched via the issues API.

```bash
# All conversation-level comments
gh api repos/{owner}/{repo}/issues/{pr_number}/comments \
  --jq '[.[] | {id, body, user: .user.login}]'
```

### Commit comments

These are comments left directly on individual commits included in the PR (via the commit's page, not through the review flow).

```bash
# Get commits on the PR
gh api repos/{owner}/{repo}/pulls/{pr_number}/commits --jq '[.[].sha]'

# Then for each commit SHA that has comments
gh api repos/{owner}/{repo}/commits/{commit_sha}/comments \
  --jq '[.[] | {id, body, path, line, user: .user.login}]'
```

### Determine which comments still need attention

```bash
gh pr view {pr_number} --json reviewDecision,reviews
```

Filter to only comments that haven't been addressed yet (no reply from the PR author indicating the comment was addressed). For review-level comments, consider a review addressed if a subsequent reply or commit has addressed the feedback.

If there are no unresolved comments across all types, inform the user and stop.

## Step 3: Address Each Comment

For each comment to be addressed:

1. Read the relevant file and surrounding context using the `explore-and-discover` skill if the context from the diff hunk is insufficient
2. Understand what the reviewer is requesting
3. Address the comment — this may involve code changes (following the `code-standards` skill), documentation updates, configuration changes, or any other appropriate action
4. Reply on GitHub indicating what was done and which AI agent/tool made the change:

For line-level comments, reply to the comment thread:

```bash
gh api repos/{owner}/{repo}/pulls/{pr_number}/comments/{comment_id}/replies \
  -f body='[comment from <AI tool name>]

<brief description of the action taken>'
```

For review-level, conversation, and commit comments, leave a PR comment:

```bash
gh pr comment {pr_number} --body '[comment from <AI tool name>]

Addressing feedback from @{username}:

<brief description of the actions taken>'
```

If a comment is unclear or you're unsure how to address it, skip it and flag it to the user rather than guessing.

## Step 4: Push and Update

1. Commit the changes with a descriptive message referencing the comments addressed
2. Push to the remote branch
3. Use the `update-pull-request` skill to update the PR

## Step 5: Report

Present a summary of what was done:

- Comments addressed (with file and line references)
- Comments skipped and why
- Link to the PR
