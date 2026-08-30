---
name: use-luna-for-subagents
user-invocable: false
description:
  "Use when launching or delegating work to subagents; use GPT-5.6 Luna for
  every subagent invocation."
---

# Use GPT-5.6 Luna for Subagents

When launching a subagent, use the Luna identifier accepted by the invoking
interface:

```
GPT-5.6 Luna (copilot)
gpt-5.6-luna
```

- Use `GPT-5.6 Luna (copilot)` for VS Code interfaces that accept the documented
  `Model Name (vendor)` format.
- Use `gpt-5.6-luna` for the Codex `spawn_agent` tool and other interfaces that
  expose canonical model IDs.

A bare `GPT-5.6 Luna` may not resolve.

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

Both identifiers select GPT-5.6 Luna in their respective interfaces. Treat this
as settled rather than re-deriving it each session. If one fails with an
unknown-model error, use the other only when it is explicitly listed as
available by the invoking interface. Otherwise, report the error and ask rather
than quietly substituting a different model.
