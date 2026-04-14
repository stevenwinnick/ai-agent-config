#!/bin/bash
# Reply to a PR comment on GitHub.
#
# Routes to the correct GitHub API based on comment type:
#   - line: replies to the review comment thread (requires comment_id)
#   - review/conversation/commit: posts a new PR comment
#
# Usage:
#   echo "<body>" | reply-to-comment.sh <owner/repo> <pr_number> <comment_type> [comment_id]
#
# Body is read from stdin to avoid shell quoting issues with multi-line text.

set -e

REPO="$1"
PR_NUMBER="$2"
COMMENT_TYPE="$3"
COMMENT_ID="$4"

if [[ -z "$REPO" || -z "$PR_NUMBER" || -z "$COMMENT_TYPE" ]]; then
    echo "Usage: echo '<body>' | reply-to-comment.sh <owner/repo> <pr_number> <comment_type> [comment_id]" >&2
    echo "" >&2
    echo "  comment_type: line, review, conversation, commit" >&2
    echo "  comment_id:   required for 'line' type (thread reply)" >&2
    echo "  Body is read from stdin" >&2
    exit 1
fi

BODY=$(cat)

if [[ -z "$BODY" ]]; then
    echo "Error: No body provided on stdin" >&2
    exit 1
fi

case "$COMMENT_TYPE" in
    line)
        if [[ -z "$COMMENT_ID" ]]; then
            echo "Error: comment_id is required for line-level comment replies" >&2
            exit 1
        fi
        gh api "repos/$REPO/pulls/$PR_NUMBER/comments/$COMMENT_ID/replies" \
            -f body="$BODY" --silent
        echo "Replied to line-level comment $COMMENT_ID" >&2
        ;;
    review|conversation|commit)
        gh pr comment "$PR_NUMBER" --repo "$REPO" --body "$BODY"
        echo "Posted PR comment on #$PR_NUMBER" >&2
        ;;
    *)
        echo "Error: Unknown comment type '$COMMENT_TYPE'. Must be: line, review, conversation, commit" >&2
        exit 1
        ;;
esac
