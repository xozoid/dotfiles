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

## Disclaimer

Every piece of prose added to a ticket via automation -- descriptions, comments,
anything else free-text -- must end with a short disclaimer that it was written
by AI, e.g.:

> _This was written by AI._
