---
name: addressing-pr-comments
description: Addresses feedback on a pull request. Use when the user wants to address, fix, or respond to PR comments.
argument-hint: "[pr-url-or-number] | [comment-url-or-number ...]"
---

# Address PR Comments

Copy this checklist and track progress:

```
Task Progress:
- [ ] Step 1: Parse arguments and identify PR
- [ ] Step 2: Fetch and review comments
- [ ] Step 3: Address each comment
- [ ] Step 4: Push and update
- [ ] Step 5: Report
```

## Step 1: Parse Arguments and Identify the Pull Request

Arguments ($ARGUMENTS) can be:

- **Nothing** — use the current branch's PR
- **A PR URL or number** — address all unresolved comments on that PR
- **One or more comment URLs** — address only those specific comments

PR URLs contain `/pull/` while comment URLs contain `/discussion_r` or `#discussion_r`. A bare number refers to a PR number.

To identify the PR:

```bash
# From current branch
gh pr view --json number,url,headRefName

# From a PR number or URL
gh pr view <pr-number-or-url> --json number,url,headRefName
```

Extract `owner/repo` from the URL (e.g., `DataDog/dd-source` from `https://github.com/DataDog/dd-source/pull/123`).

If specific comment URLs were provided, extract their numeric IDs for filtering in Step 2.

If no PR is found, stop and inform the user.

## Step 2: Fetch and Review Comments

Run the fetch script to retrieve all comments in a single call:

```bash
# All unresolved comments
python3 ~/.claude/skills/addressing-pr-comments/scripts/fetch-comments.py <owner/repo> <pr_number>

# Only specific comment IDs
python3 ~/.claude/skills/addressing-pr-comments/scripts/fetch-comments.py <owner/repo> <pr_number> --comment-ids <id1>,<id2>,...

# Include already-addressed comments to see full picture
python3 ~/.claude/skills/addressing-pr-comments/scripts/fetch-comments.py <owner/repo> <pr_number> --all
```

The script outputs structured JSON to stdout:

- `pr` — PR metadata: `number`, `url`, `author`, `head_branch`
- `summary` — Human-readable count of unresolved vs addressed comments
- `comments` — Array of comments to address, each with:
  - `id`, `type` (`line`/`review`/`conversation`/`commit`), `user`
  - `path`, `line` — file location (line-level comments only)
  - `body` — the reviewer's comment text
  - `context_snippet` — condensed diff context near the commented line (line-level only)
  - `thread` — array of replies, each with `user`, `body`, `is_agent`, `created_at`
  - `addressed` — `true` if the last reply is an agent reply with no reviewer follow-up

A thread is "addressed" only when the last reply starts with `[comment from ` or `[addressed by ` and no reviewer replied after it. Threads where a reviewer followed up after the agent are still shown as unresolved.

Progress and summary are printed to stderr.

If no comments need attention, inform the user and stop.

## Step 3: Address Each Comment

For each comment in the output:

1. **Read context** — For line-level comments, use `path` and `line` to read the file directly. Use the `exploring-and-discovering` skill if more context is needed beyond what `context_snippet` shows.
2. **Understand the request** — Read the `body` and any `thread` entries to understand what the reviewer wants, including follow-up feedback.
3. **Make changes** — Code, docs, config, or whatever is appropriate. Follow the `editing-files` skill for code changes.
4. **Reply on GitHub** using the reply script:

```bash
echo '[comment from <AI tool name>]

<brief description of action taken>' \
  | ~/.claude/skills/addressing-pr-comments/scripts/reply-to-comment.sh <owner/repo> <pr_number> <comment_type> <comment_id>
```

Where `<comment_type>` matches the comment's `type` field: `line`, `review`, `conversation`, or `commit`. For `line` type, `<comment_id>` is required. For other types it is optional.

If a comment is unclear or you're unsure how to address it, skip it and flag it to the user rather than guessing.

## Step 4: Push and Update

1. Commit the changes with a descriptive message referencing the comments addressed
2. Push to the remote branch
3. Use the `updating-pull-requests` skill to update the PR

## Step 5: Report

Present a summary of what was done:

- Comments addressed (with file and line references)
- Comments skipped and why
- Link to the PR
