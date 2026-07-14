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
- [ ] Step 3: Address, reply to, and resolve each comment
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

Extract `owner/repo` from the URL (e.g., `octocat/hello-world` from `https://github.com/octocat/hello-world/pull/123`).

If specific comment URLs were provided, extract their numeric IDs for filtering in Step 2.

If no PR is found, stop and inform the user.

## Step 2: Fetch and Review Comments

Run the fetch script to retrieve all comments in a single call:

```bash
# All unresolved comments
python3 ~/.claude/skills/addressing-pr-comments/scripts/fetch-comments.py <owner/repo> <pr_number>

# Only specific comment IDs
python3 ~/.claude/skills/addressing-pr-comments/scripts/fetch-comments.py <owner/repo> <pr_number> --comment-ids <id1>,<id2>,...

# Include already-resolved/addressed comments to see the full picture
python3 ~/.claude/skills/addressing-pr-comments/scripts/fetch-comments.py <owner/repo> <pr_number> --all
```

The script outputs structured JSON to stdout:

- `pr` — PR metadata: `number`, `url`, `author`, `head_branch`
- `summary` — Human-readable count of unresolved vs. resolved/addressed comments
- `comments` — Array of comments to address, each with:
  - `id`, `type` (`line`/`review`/`conversation`/`commit`), `user`
  - `path`, `line` — file location (line-level comments only)
  - `body` — the reviewer's comment text
  - `context_snippet` — condensed diff context near the commented line (line-level only)
  - `thread` — array of replies, each with `user`, `body`, `is_agent`, `created_at`
  - `addressed` — `true` if the last reply is an agent reply with no reviewer follow-up
  - `is_resolved` — `true` if GitHub already marks the review thread resolved (line comments only)
  - `is_outdated` — `true` if the commented line has since changed (line comments only)
  - `thread_node_id` — the review thread's GraphQL node ID, needed to resolve it in Step 3 (line comments only; `null` for other types, which have no resolvable thread)

By default the script hides comments that are already resolved on GitHub or that an agent already replied to with no reviewer follow-up, so you only see what still needs work. A thread counts as agent-addressed when its last reply starts with `[comment from ` or `[addressed by ` and no reviewer replied after it. Use `--all` to see everything, including resolved threads.

Progress and summary are printed to stderr.

If no comments need attention, inform the user and stop.

## Step 3: Address, Reply To, and Resolve Each Comment

For each comment in the output:

1. **Read context** — For line-level comments, use `path` and `line` to read the file directly. Read more of the surrounding code if `context_snippet` doesn't show enough.
2. **Understand the request** — Read the `body` and any `thread` entries to understand what the reviewer wants, including follow-up feedback. Decide what the comment actually asks for: a concrete change, a question to answer, a suggestion to weigh, or just an observation.
3. **Make changes** — Code, docs, config, or whatever is appropriate. Follow the `editing-files` skill for code changes. If you disagree with the suggestion or it has trade-offs the reviewer should weigh, it's fine not to make the change — say so in your reply instead.
4. **Reply on GitHub** using the reply script:

```bash
echo '[comment from <AI tool name>]

<brief description of action taken>' \
  | ~/.claude/skills/addressing-pr-comments/scripts/reply-to-comment.sh <owner/repo> <pr_number> <comment_type> <comment_id>
```

Where `<comment_type>` matches the comment's `type` field: `line`, `review`, `conversation`, or `commit`. For `line` type, `<comment_id>` is required. For other types it is optional.

Keep replies concise and specific. State what you did (or why you didn't) and reference the change. Don't restate the reviewer's comment or repeat what's already in the thread. Lead with the agent-attribution prefix so both humans and future runs can tell the reply came from an agent.

5. **Resolve the thread when — and only when — it's truly done.** Only line-level review comments have resolvable threads (use the comment's `thread_node_id`). After replying, decide whether to resolve:

   **Resolve** when the feedback is fully handled and a human reviewer is unlikely to need to revisit it:
   - A concrete, mechanical change you made exactly as asked (rename, remove, typo, formatting, extract a constant).
   - A direct question you answered definitively, with no decision left open.
   - A suggestion you applied in full with no meaningful trade-off.

   **Leave open** (reply but do NOT resolve) when a human reviewer would still benefit from looking:
   - You disagreed, pushed back, or proposed an alternative — let the reviewer decide.
   - You only partially addressed it, deferred it, or filed a follow-up instead.
   - It raises a design, architecture, or scope question, or any judgment call.
   - The reviewer explicitly asked to confirm the result themselves, or it's a non-actionable observation/praise.
   - You're at all unsure whether the reviewer would consider it settled.

   When in doubt, leave it open — resolving is for the unambiguous cases. Resolve with:

   ```bash
   ~/.claude/skills/addressing-pr-comments/scripts/resolve-thread.sh <thread_node_id>
   ```

If a comment is unclear or you're unsure how to address it, skip it (don't reply or resolve) and flag it to the user rather than guessing.

## Step 4: Push and Update

1. Commit the changes with a descriptive message referencing the comments addressed
2. Push to the remote branch
3. Use the `updating-pull-requests` skill to update the PR

## Step 5: Report

Present a summary of what was done:

- Comments addressed (with file and line references), noting which threads you resolved
- Comments replied to but left open for the reviewer, and why
- Comments skipped and why
- Link to the PR
