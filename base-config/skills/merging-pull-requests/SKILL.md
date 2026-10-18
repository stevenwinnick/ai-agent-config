---
name: merging-pull-requests
description: Merges a pull request. Use when the user wants to merge a PR.
---

# Merge Pull Request

Use the `shw git pr merge` command to merge the pull request by default:

```bash
shw git pr merge
```

Run it from the repo with the PR's branch checked out, or pass the branch, PR number, or URL explicitly (`shw git pr merge <branch>`). The command runs `gh pr merge --squash --delete-branch`, which squash-merges the PR, deletes the remote and local branches, and switches the checkout to the updated default branch.

Then apply any post-merge steps for the repo, such as re-running validation.

If `shw` is missing or the command fails, use the `debugging-shw-cli` skill.
