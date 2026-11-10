---
name: implement
description:
  "Implement a Jira story end to end in a given checkout. Use when the user
  types /implement <ISSUE-KEY> [checkout path]."
argument-hint: "<ISSUE-KEY> [checkout path]"
disable-model-invocation: true
---

# Implement a Jira story

Arguments: a Jira issue key (`PROJ-123` or a browse URL) and an optional
checkout path. Text after the arguments is extra context from the user; treat it
as part of the requirements.

## Procedure

1. **Pick the checkout.** If a path was given, `cd` there and do all work in
   that checkout only. If none was given and the workspace holds more than one
   checkout of the same repo, ask which one. Never create a worktree.
2. **Check the branch.** If the checkout is on the default branch, propose a
   branch name (see the `git-branch-names` skill) and ask before creating it.
3. **Read the story.** Fetch the issue with the Jira MCP server: description,
   acceptance criteria, sub-tasks, comments, and linked issues. Comments often
   narrow or change scope; the latest comment wins over the description. Note
   any open blockers.
4. **Settle open decisions.** Look up facts yourself (code, tests, other
   stories). If design decisions remain that only the user can make, ask them in
   one numbered round with your recommended answer for each, in the format of
   the `grilling` skill. Skip this step when nothing is open.
5. **Implement.** Delegate per the `use-luna-for-subagents` skill. Split work by
   acceptance criterion or module, and pass every subagent the git rules below.
6. **Verify.** Run the repo's formatters, linters, and targeted tests or
   coverage on the changed source paths (e.g. `tools/formatters.sh`,
   `tools/linters.sh`, `tools/run_coverage.py <paths>` when they exist). Fix
   failures before reporting.
7. **Report.** One line per acceptance criterion: done, partial, or skipped,
   with the file that satisfies it. Then list anything deferred and why.

## Git rules

- Do not stage, stash, restore, reset, or commit. Leave all changes in the
  working tree for the user to review.
- Do not open a PR. The user asks for that separately.
- Do not edit test changes the user made; change the implementation instead.
