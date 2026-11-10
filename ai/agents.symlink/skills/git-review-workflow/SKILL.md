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

Branch commits are squash merged with a conventional commit message, and repo
rules enforce that style on the squash. When auditing or reviewing a branch,
don't flag individual branch commits that aren't conventional commits.

## Respecting user edits

The user may have edited files after they were created in a prior session. This
means they prefer their implementation. Do not try restoring a previous version
without asking first. Explain why the prior approach was better and let the user
decide.
