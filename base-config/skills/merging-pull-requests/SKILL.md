---
name: merging-pull-requests
description: Merges a pull request. Use when the user wants to merge a PR.
---

# Merge Pull Request

Squash-merge the pull request and delete its branch by default:

```bash
gh pr merge --squash --delete-branch
```

Run it from the repo with the PR's branch checked out, or pass the branch, PR number, or URL explicitly (`gh pr merge <branch> --squash --delete-branch`). `gh` deletes the remote and local branches and switches the checkout to the updated default branch.

Then apply any post-merge steps for the repo, such as re-running validation.
