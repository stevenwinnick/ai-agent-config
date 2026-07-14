---
name: merging-pull-requests
description: Merges a pull request. Use when the user wants to merge a PR.
---

# Merge Pull Request

Use the `shw git pr merge` command to merge the pull request by default:

```bash
shw git pr merge
```

Run it from the branch's worktree to merge that branch's PR, or pass a branch name explicitly (`shw git pr merge <branch>`). The command squash-merges the PR, deletes the remote branch, and removes the local worktree and branch.

Because the command removes the current worktree, run any post-merge steps from the default branch's worktree. Apply any post-merge steps for the repo, such as pulling the default branch and re-running validation.

If `shw` is missing or the command fails, use the `debugging-shw-cli` skill.
