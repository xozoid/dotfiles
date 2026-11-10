---
name: use-luna-for-subagents
user-invocable: false
description:
  "Use for any task that spans several files, needs research, or audits code:
  delegate to subagents by default, and use GPT-6 Luna for every subagent
  invocation."
---

# Delegate to subagents by default

The user should not have to say "use subagents". Delegate by default when a
task:

- touches more than one or two files,
- needs exploration or research before acting,
- audits or reviews code against requirements, or
- splits into independent parts that can run in parallel.

Keep in the main session: planning, decisions that need the user, integrating
results, and final verification. Do small single-file edits and quick answers
directly.

Give each subagent a self-contained brief: goal, files or areas in scope,
whether it may edit (use a read-only agent such as `Explore` when it may not),
and what to report back. Pass along the user's standing rules, since subagents
don't inherit them: no staging, stashing, resetting, or committing; scratch
files go in `.scratch/`.

Check subagent results before reporting them. Re-read the key file or re-run the
test rather than relaying a claim unchecked.

# Use GPT-6 Luna for Subagents

When launching a subagent, use the Luna identifier accepted by the invoking
interface:

```
GPT-6 Luna (copilot)
gpt-6-luna
```

- Use `GPT-6 Luna (copilot)` for VS Code interfaces that accept the documented
  `Model Name (vendor)` format.
- Use `gpt-6-luna` for the Codex `spawn_agent` tool and other interfaces that
  expose canonical model IDs.

A bare `GPT-6 Luna` may not resolve.

This applies to every subagent invocation: exploration, implementation, review,
and testing. If a subagent tool exposes no model selector, invoke it unchanged;
the settings below already cover the built-in subagents.

## Backing settings

These are set in user `settings.json`, so built-in subagents default to Luna
even when a tool call omits `model`:

- `github.copilot.chat.exploreAgent.model`
- `github.copilot.chat.executionSubagent.model`
- `github.copilot.chat.searchSubagent.model`
- `github.copilot.chat.implementAgent.model`
- `chat.exploreAgent.defaultModel`

## Don't relitigate this

Both identifiers select GPT-6 Luna in their respective interfaces. Treat this as
settled rather than re-deriving it each session. If one fails with an
unknown-model error, use the other only when it is explicitly listed as
available by the invoking interface. Otherwise, report the error and ask rather
than quietly substituting a different model.
