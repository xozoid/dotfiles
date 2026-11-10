---
name: jira-conventions
description:
  Jira issue creation and commenting conventions. Use whenever creating or
  updating a Jira story or bug, or adding a comment to a Jira issue.
---

## Creating issues

- **Stories** must have acceptance criteria and at least one component set.
- **Bugs** must have affects version(s) set.
- **All issues except Epics** must have a time estimate, set on the real
  "Original Estimate" time-tracking field
  (`customFields: {"timetracking": {"originalEstimate": "30m"}}`), not a "Time
  estimate: ..." text note in the description. Verify with JQL
  (`originalEstimate = 30m`), since `issue get` reports `timetracking` as an
  unresolved custom field even when it's set correctly. Epics are containers,
  not estimated work, and never get one.
- No task is ever quicker than 30m; never estimate below that floor.

If required info isn't available, ask the user rather than leaving the field
blank or guessing.

If the project has no acceptance criteria field, put them in the description
under an `h3. Acceptance Criteria` heading.

## Jira MCP gotchas

- **Link direction.** The `relationship` text echoed by `issue_link create` is
  inverted relative to the Jira UI. For "A blocks B" or "B created by A" (A
  caused bug B), pass `inwardIssueKey=A`, `outwardIssueKey=B`. Never "fix" a
  link based on the echo; verify with JQL such as
  `issue in linkedIssues(A, "blocks")`.
- **Duplicate direction** is easy to get backwards. Verify with JQL
  `issue in linkedIssues(X, "duplicates")`.
- The "created by" link type may be named `Defect` (outward "created", inward
  "created by"). List link types rather than guessing names.
- **Epic link.** `issue get` can report the epic as null when it is set. Verify
  with JQL `"Epic Link" = EPIC-KEY`.
- **Assignee.** `assignee: "current"` fails on create and update. Pass the
  username.
- **Sub-tasks.** Create with `issueType: "subTask"` plus `parent`. Omit fields
  that are not on the sub-task screen (e.g. account), or the create fails.

## Workflow transitions

- List transitions before moving an issue; never guess transition names.
- Closing: resolve first (with the closing comment), then close. Resolution may
  auto-set on resolve; passing `resolutionName` then errors. If close demands
  release-notes fields, ask the user for the value, or reuse the one they used
  on a similar issue.
- Merging duplicate stories: link them with `Duplicate`. If the workflow has no
  Duplicate resolution, close the merged story with the resolution the user uses
  for that (ask once, e.g. "Fixed Elsewhere").

## Disclaimer

Every piece of prose added to a ticket via automation -- descriptions, comments,
anything else free-text -- must end with a short disclaimer that it was written
by AI, e.g.:

> _This was written by AI._
