---
name: audit
description:
  "Audit the current branch against a Jira story's acceptance criteria and say
  whether it is ready for a PR. Use when the user types /audit <ISSUE-KEY>
  [checkout path]."
argument-hint: "<ISSUE-KEY> [checkout path]"
disable-model-invocation: true
---

# Audit a branch against a Jira story

Read-only until the user picks fixes. Arguments: a Jira issue key (`PROJ-123` or
a browse URL) and an optional checkout path to `cd` into first.

## Procedure

1. **Read the story.** Fetch the issue with the Jira MCP server: description,
   acceptance criteria, sub-tasks, comments, and linked issues. Comments often
   narrow or defer scope; the latest comment wins over the description.
2. **Collect the change.** Find the default branch with
   `git symbolic-ref --short refs/remotes/origin/HEAD`. The change under audit
   is `git diff <default>...HEAD` plus uncommitted work from `git diff HEAD`.
   Don't touch the git index.
3. **Check each criterion.** Delegate per the `use-luna-for-subagents` skill,
   using read-only subagents, one per group of related criteria. Each criterion
   gets a verdict with evidence:
   - **Met**: the file and line that implement it, and the test that covers it.
   - **Partial**: what is done and what is missing.
   - **Missing**: nothing in the change addresses it.
   - **Can't verify**: why (needs live data, manual check, etc.).
4. **Check the rest of the change.** Flag edits outside the story's scope,
   changed behavior without a test, and docs or requirements that the change
   made stale. Don't flag branch commit messages that aren't conventional
   commits; the squash merge gets a conventional message.
5. **Report.** Start with the verdict: ready for PR, or not ready with the count
   of blocking findings. Then a single numbered list of findings, blocking ones
   first, each with a recommended action (fix, defer to a story, or skip).
   Numbering lets the user reply "fix 1, 3, skip 2".

Make no edits, comments, or Jira changes until the user replies.
