---
name: opening-modified-files
description: Opens all modified files in Cursor for review. Use after making code changes to allow the user to review modifications.
---

# Open Modified Files

Open all files that have been modified relative to the default branch in Cursor, including those outside the current repo, if any.

Files can be opened in Cursor by running

```bash
cursor $FILENAME
```

All files on the current branch which do not match the default branch can be opened with the helper script

```bash
~/.claude/skills/opening-modified-files/scripts/open-modified-files.sh
```
