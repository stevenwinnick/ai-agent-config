#!/usr/bin/env python3
"""Fetch and process PR comments for the addressing-pr-comments skill.

Fetches all types of PR comments, filters out already-addressed threads,
condenses output, and returns structured JSON for agent consumption.

Usage:
    fetch-comments.py <owner/repo> <pr_number> [options]

Options:
    --include-commit-comments   Also fetch commit-level comments (slow for large PRs)
    --comment-ids ID1,ID2,...   Only return these specific comment IDs
    --all                       Include addressed comments too (marked as addressed)

Output:
    JSON to stdout with pr metadata, summary, and comment array.
    Progress messages to stderr.
"""

import argparse
import html
import json
import re
import subprocess
import sys


def gh_api(endpoint):
    """Fetch a single GitHub API endpoint, returning parsed JSON."""
    result = subprocess.run(
        ["gh", "api", endpoint],
        capture_output=True,
        text=True,
    )
    if result.returncode != 0:
        print(f"Error fetching {endpoint}: {result.stderr.strip()}", file=sys.stderr)
        sys.exit(1)
    return json.loads(result.stdout)


def gh_api_list(endpoint):
    """Fetch a paginated GitHub API list endpoint, returning all items."""
    items = []
    page = 1
    while True:
        sep = "&" if "?" in endpoint else "?"
        url = f"{endpoint}{sep}per_page=100&page={page}"
        result = subprocess.run(
            ["gh", "api", url],
            capture_output=True,
            text=True,
        )
        if result.returncode != 0:
            if not items:
                print(
                    f"Error fetching {endpoint}: {result.stderr.strip()}",
                    file=sys.stderr,
                )
                sys.exit(1)
            break
        page_items = json.loads(result.stdout)
        if not page_items:
            break
        items.extend(page_items)
        if len(page_items) < 100:
            break
        page += 1
    return items


def condense_html(text, max_length=500):
    """Strip HTML tags and truncate if the body is HTML-heavy.

    Light HTML (<=3 tags) is returned as-is. Heavy HTML is stripped,
    decoded, whitespace-collapsed, and truncated.
    """
    if not text:
        return ""
    tag_count = len(re.findall(r"<[^>]+>", text))
    if tag_count <= 3:
        return text
    cleaned = re.sub(r"<[^>]+>", " ", text)
    cleaned = html.unescape(cleaned)
    cleaned = re.sub(r"\s+", " ", cleaned).strip()
    if len(cleaned) > max_length:
        cleaned = cleaned[:max_length] + " [truncated]"
    return cleaned


def condense_diff_hunk(hunk):
    """Return last 5 lines of the diff hunk as a context snippet.

    These are the lines closest to the commented line.
    """
    if not hunk:
        return ""
    lines = hunk.strip().split("\n")
    relevant = lines[-5:] if len(lines) > 5 else lines
    return "\n".join(relevant)


def is_agent_reply(body):
    """Check if a comment starts with a known agent reply prefix.

    Agents may use different prefixes when replying to comments:
    - "[comment from <tool>]" — the standard prefix from this skill
    - "[addressed by <tool>]" — an alternate prefix used in practice
    """
    stripped = body.strip()
    return stripped.startswith("[comment from ") or stripped.startswith("[addressed by ")


def classify_thread(replies):
    """Determine if a thread has been addressed by an agent.

    A thread is "addressed" only if the last reply starts with the
    `[comment from ...]` agent prefix AND no non-agent reply follows it.
    If a reviewer responded after the agent reply, the thread is still
    unresolved and needs attention.
    """
    if not replies:
        return False

    last_agent_idx = -1
    for i, reply in enumerate(replies):
        if is_agent_reply(reply.get("body", "")):
            last_agent_idx = i

    if last_agent_idx == -1:
        return False

    # Check if any non-agent reply came after the last agent reply
    for reply in replies[last_agent_idx + 1 :]:
        if not is_agent_reply(reply.get("body", "")):
            return False

    return True


def fetch_line_comments(repo, pr_number):
    """Fetch line-level review comments and group into threads."""
    all_comments = gh_api_list(f"repos/{repo}/pulls/{pr_number}/comments")

    top_level = []
    replies_by_parent = {}
    for c in all_comments:
        if c.get("in_reply_to_id") is None:
            top_level.append(c)
        else:
            parent_id = c["in_reply_to_id"]
            replies_by_parent.setdefault(parent_id, []).append(c)

    results = []
    for c in top_level:
        thread_replies = replies_by_parent.get(c["id"], [])
        thread_replies.sort(key=lambda r: r.get("created_at", ""))

        addressed = classify_thread(thread_replies)

        results.append(
            {
                "id": c["id"],
                "type": "line",
                "path": c.get("path", ""),
                "line": c.get("line") or c.get("original_line"),
                "user": c["user"]["login"],
                "body": c["body"],
                "context_snippet": condense_diff_hunk(c.get("diff_hunk", "")),
                "addressed": addressed,
                "thread": [
                    {
                        "user": r["user"]["login"],
                        "body": condense_html(r["body"]),
                        "is_agent": is_agent_reply(r["body"]),
                        "created_at": r.get("created_at", ""),
                    }
                    for r in thread_replies
                ],
            }
        )
    return results


def fetch_review_comments(repo, pr_number):
    """Fetch review-level comments (top-level review body text)."""
    reviews = gh_api_list(f"repos/{repo}/pulls/{pr_number}/reviews")
    results = []
    for r in reviews:
        if r.get("body") and r["body"].strip():
            results.append(
                {
                    "id": r["id"],
                    "type": "review",
                    "path": None,
                    "line": None,
                    "user": r["user"]["login"],
                    "body": condense_html(r["body"]),
                    "context_snippet": None,
                    "addressed": False,
                    "state": r.get("state", ""),
                    "thread": [],
                }
            )
    return results


def fetch_conversation_comments(repo, pr_number):
    """Fetch general conversation comments on the PR thread."""
    issue_comments = gh_api_list(f"repos/{repo}/issues/{pr_number}/comments")
    results = []
    for c in issue_comments:
        body = c["body"]
        results.append(
            {
                "id": c["id"],
                "type": "conversation",
                "path": None,
                "line": None,
                "user": c["user"]["login"],
                "body": condense_html(body),
                "context_snippet": None,
                "addressed": is_agent_reply(body),
                "thread": [],
            }
        )
    return results


def fetch_commit_comments(repo, pr_number):
    """Fetch comments left directly on individual commits."""
    commits = gh_api_list(f"repos/{repo}/pulls/{pr_number}/commits")
    results = []
    for commit in commits:
        sha = commit["sha"]
        comments = gh_api_list(f"repos/{repo}/commits/{sha}/comments")
        for c in comments:
            results.append(
                {
                    "id": c["id"],
                    "type": "commit",
                    "path": c.get("path"),
                    "line": c.get("line"),
                    "user": c["user"]["login"],
                    "body": condense_html(c["body"]),
                    "context_snippet": None,
                    "addressed": False,
                    "commit_sha": sha[:8],
                    "thread": [],
                }
            )
    return results


def build_summary(unresolved, addressed):
    """Build a human-readable summary string."""
    type_labels = {
        "line": "line-level",
        "review": "review-level",
        "conversation": "conversation",
        "commit": "commit",
    }

    counts = {}
    for c in unresolved:
        t = c["type"]
        counts[t] = counts.get(t, 0) + 1

    summary_parts = []
    for t in ["line", "review", "conversation", "commit"]:
        if counts.get(t, 0) > 0:
            summary_parts.append(f"{counts[t]} {type_labels[t]}")

    n = len(unresolved)
    summary = f"{n} unresolved comment{'s' if n != 1 else ''}"
    if summary_parts:
        summary += f" ({', '.join(summary_parts)})"
    if addressed:
        summary += f", {len(addressed)} already addressed"

    return summary


def main():
    parser = argparse.ArgumentParser(
        description="Fetch PR comments for agent processing"
    )
    parser.add_argument("repo", help="owner/repo (e.g., DataDog/dd-source)")
    parser.add_argument("pr_number", help="PR number")
    parser.add_argument(
        "--include-commit-comments",
        action="store_true",
        help="Also fetch commit-level comments (slow for large PRs)",
    )
    parser.add_argument(
        "--comment-ids",
        help="Comma-separated comment IDs to filter to",
    )
    parser.add_argument(
        "--all",
        action="store_true",
        help="Include addressed comments too (marked as addressed in output)",
    )
    args = parser.parse_args()

    repo = args.repo
    pr_number = args.pr_number
    filter_ids = set(args.comment_ids.split(",")) if args.comment_ids else None

    # Fetch PR metadata
    print(f"Fetching PR #{pr_number} from {repo}...", file=sys.stderr)
    pr_info = gh_api(f"repos/{repo}/pulls/{pr_number}")
    pr_author = pr_info["user"]["login"]

    # Fetch all comment types
    print("Fetching line-level review comments...", file=sys.stderr)
    line_comments = fetch_line_comments(repo, pr_number)

    print("Fetching review-level comments...", file=sys.stderr)
    review_comments = fetch_review_comments(repo, pr_number)

    print("Fetching conversation comments...", file=sys.stderr)
    conversation_comments = fetch_conversation_comments(repo, pr_number)

    commit_comments = []
    if args.include_commit_comments:
        print("Fetching commit comments...", file=sys.stderr)
        commit_comments = fetch_commit_comments(repo, pr_number)

    # Combine
    all_comments = (
        line_comments + review_comments + conversation_comments + commit_comments
    )

    # Filter to specific IDs if requested
    if filter_ids:
        all_comments = [c for c in all_comments if str(c["id"]) in filter_ids]

    # Separate addressed vs unresolved
    unresolved = [c for c in all_comments if not c["addressed"]]
    addressed = [c for c in all_comments if c["addressed"]]

    summary = build_summary(unresolved, addressed)
    print(f"\n{summary}", file=sys.stderr)

    # Build output
    output_comments = all_comments if args.all else unresolved

    output = {
        "pr": {
            "number": int(pr_number),
            "url": pr_info.get("html_url", ""),
            "author": pr_author,
            "head_branch": pr_info["head"]["ref"],
        },
        "summary": summary,
        "comments": output_comments,
    }

    json.dump(output, sys.stdout, indent=2)
    print()


if __name__ == "__main__":
    main()
