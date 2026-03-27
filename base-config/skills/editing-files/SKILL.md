---
name: editing-files
description: Completes tasks that involve editing files, orchestrating the full workflow from worktree setup through PR creation. Use when the user describes a feature, bug fix, configuration change, or any task requiring file modifications.
argument-hint: [description]
---

# File Editing Task Workflow

You are starting a new task that involves editing files. Follow this workflow precisely.

Copy this checklist and track progress:

```
Task Progress:
- [ ] Step 1: Parse the request
- [ ] Step 2: Setup worktree and branch
- [ ] Step 3: Evaluate task complexity
- [ ] Step 4: Create a plan (if needed)
- [ ] Step 5: Implement
- [ ] Step 6: Create or update pull request
- [ ] Step 7: Present summary
- [ ] Step 8: Iterate on feedback
```

## Step 1: Parse the Request

Analyze the user's input: ($ARGUMENTS)

If the input contains "CLOUDR-" followed by numbers, this is a Jira ticket. Use the `reading-jira-tickets` skill to understand its contents. If you cannot read it, stop and report that information back to the user.

## Step 2: Setup Worktree and Branch

Use the `managing-worktrees` skill to understand the local repo's worktree structure. If the user specified a branch or worktree to use, use it. Otherwise, create a new worktree with the appropriate branch.

If `shw` is unavailable or the worktree command fails in an unexpected way, use the `debugging-shw-cli` skill before falling back to manual investigation.

## Step 3: Evaluate Task Complexity

Evaluate the complexity of the requested task to determine if there is a clear best implementation method using the `exploring-and-discovering` skill. If so, skip the next step.

## Step 4 (if applicable): Create a Plan

Use the `creating-plans` skill to create a plan for the user to review before you implement it.

## Step 5: Implement

Implement the desired task, using the code standards from the `applying-code-standards` skill

## Step 6: Create or Update Pull Request

If a pull request has not yet been created, use the `creating-draft-prs` skill to create a pull request. If a pull request has already been created, use the `updating-pull-requests` skill to update it.

## Step 7: Present Summary

Present to the user a summary of the changes which have been made since the last summary in the following format:

Summary: <summary of changes>
Details: <more detailed description of the changes and why they were made>
(if applicable) Assumptions Made: <list of any ambiguities in the user's request, and the assumptions made in this implementation>
(if applicable) Suggested Next Steps: <list of suggested follow-up work and why it is suggested>
Pull request: <link to the pull request>

## Step 8: Iterate

If the user requests further changes, return to step 3 and continue from there
