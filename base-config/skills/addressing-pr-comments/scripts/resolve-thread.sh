#!/bin/bash
# Resolve a line-level review thread on GitHub after replying to it.
#
# Only line-level review comments live in resolvable threads (review-body,
# conversation, and commit comments cannot be resolved). Resolution is a
# GraphQL mutation; the REST API does not support it.
#
# Usage:
#   # Preferred: pass the thread_node_id from fetch-comments.py output
#   resolve-thread.sh <thread_node_id>
#
#   # Fallback: look the thread up from the top-level comment's numeric id
#   resolve-thread.sh --comment <owner/repo> <pr_number> <comment_id>
#
# Resolve a thread ONLY when the feedback is fully handled and unlikely to
# need further human follow-up. Leave threads open when the reviewer should
# weigh in (disagreement, partial fix, design question, judgment call).

set -euo pipefail

resolve() {
    local thread_id="$1"
    gh api graphql -f query='
      mutation($threadId: ID!) {
        resolveReviewThread(input: { threadId: $threadId }) {
          thread { isResolved }
        }
      }' -F threadId="$thread_id" --jq '.data.resolveReviewThread.thread.isResolved' > /dev/null
    echo "Resolved thread $thread_id" >&2
}

if [[ "${1:-}" == "--comment" ]]; then
    REPO="${2:-}"
    PR_NUMBER="${3:-}"
    COMMENT_ID="${4:-}"
    if [[ -z "$REPO" || -z "$PR_NUMBER" || -z "$COMMENT_ID" ]]; then
        echo "Usage: resolve-thread.sh --comment <owner/repo> <pr_number> <comment_id>" >&2
        exit 1
    fi
    OWNER="${REPO%%/*}"
    NAME="${REPO##*/}"
    THREAD_ID=$(gh api graphql -f query="
      {
        repository(owner: \"$OWNER\", name: \"$NAME\") {
          pullRequest(number: $PR_NUMBER) {
            reviewThreads(first: 100) {
              nodes { id comments(first: 1) { nodes { databaseId } } }
            }
          }
        }
      }" --jq ".data.repository.pullRequest.reviewThreads.nodes[] | select(.comments.nodes[0].databaseId == $COMMENT_ID) | .id")
    if [[ -z "$THREAD_ID" ]]; then
        echo "Error: no review thread found for comment $COMMENT_ID on $REPO#$PR_NUMBER" >&2
        echo "(Only line-level review comments have resolvable threads. If the thread" >&2
        echo " is beyond the first 100, pass the thread_node_id directly instead.)" >&2
        exit 1
    fi
    resolve "$THREAD_ID"
else
    THREAD_ID="${1:-}"
    if [[ -z "$THREAD_ID" ]]; then
        echo "Usage:" >&2
        echo "  resolve-thread.sh <thread_node_id>" >&2
        echo "  resolve-thread.sh --comment <owner/repo> <pr_number> <comment_id>" >&2
        exit 1
    fi
    resolve "$THREAD_ID"
fi
