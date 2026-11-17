---
name: verification-habits
description:
  "Rules for claiming why something failed or who changed something. Use when
  diagnosing a failure, writing a root cause into code comments, docs, or
  memory, or explaining a change in repository state."
---

## Scope root-cause claims

When a comment, doc, or memory note explains why something failed, state only
what was observed: which host, which tool, which command. Mark the cause as
unconfirmed until it has been tested.

## Test a theory before building on it

If a plausible root-cause theory is driving a workaround, test it directly
first: reproduce on the affected host and run the actual failing tool. A
convincing theory that was never tested is often wrong outright, not just too
broad.

## Don't assign blame without evidence

The user works in the repository at the same time as the agent. Staged files,
modified files, or branch changes can come from them. Before attributing a state
change to a subagent or tool, check (`git reflog`, timestamps) or ask: "These
files are now staged. Did you do that?"
