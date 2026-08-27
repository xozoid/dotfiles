---
name: use-luna-for-subagents
user-invocable: false
description:
  "Use when launching or delegating work to subagents; use GPT-5.6 Luna for
  every subagent invocation."
---

# Use GPT-5.6 Luna for Subagents

When launching a subagent, pass this exact string as the `model` argument:

```
GPT-5.6 Luna (copilot)
```

The `Model Name (vendor)` format is what VS Code's model-override settings
document, so the vendor suffix is required — a bare `GPT-5.6 Luna` may not
resolve.

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

The label is valid in this environment; passing it has been verified to invoke
without error. Treat it as settled rather than re-deriving it each session. If a
call ever fails with an unknown-model error, report the error and ask — don't
quietly substitute a different model.
