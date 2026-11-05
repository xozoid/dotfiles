---
name: git-review-workflow
description:
  Personal git workflow preferences - commit policy, respecting user edits. Use
  when working in any git repository.
---

## Commit policy

Never add a `Co-authored-by` trailer to commit messages.

**Never use `git commit --amend`.** Always create a new commit. The user manages
commit history and rebasing themselves.

## Respecting user edits

The user may have edited files after they were created in a prior session. This
means they prefer their implementation. Do not try restoring a previous version
without asking first. Explain why the prior approach was better and let the user
decide.
