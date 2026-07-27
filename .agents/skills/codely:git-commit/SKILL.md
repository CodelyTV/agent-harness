---
name: codely:git-commit
description: Create a git commit following the team's Conventional Commit conventions. Use when the user asks to commit changes or create a commit.
disable-model-invocation: false
user-invocable: true
metadata:
  author: Codely <support@codely.com> (https://codely.com)
  version: "1.0"
  license: MIT
---

## Context

If the user does not specify the commit message, run `bash "${CLAUDE_SKILL_DIR}/scripts/context.sh"` from the repository root to gather context about the current Git changes to determine it.

## Your task

Create a single Git commit. Follow the conventions in [`resources/commit-messages.md`](resources/commit-messages.md) to determine the commit message if it has not been already specified.

The context script output already provides all the information needed (status, diff, branch, recent commits). Do not run additional Git commands to gather context — proceed directly to staging and committing.

## Scope selection

Use the "Available scopes" section from the context script output above to pick the right scope. When a change involves backend routes and code, use the full context workspace name as scope (e.g., `mooc`) instead of just the context name. For example: `feat(mooc): add course enrollment endpoint`.

## Co-authors

Always add a co-author trailer to the commit message with the following format:

```text
Co-Authored-By: {tool} - {model.name} {model.version} ({model.reasoning_effort}) <{tooling_email}>
```

- `tool`: The AI coding tool used (e.g. `Claude Code`, `Cursor`, `Copilot`, `Codex`)
- `model.name`: The name of the model used to make the change (e.g. `Claude Opus`, `Cursor Composer`, `OpenAI GPT`)
- `model.version`: The version of the model used to make the change (e.g. `4.6`, `1.5`, `5.4`)
- `model.reasoning_effort`: The reasoning effort of the model used to make the change (e.g. `low`, `medium`, `high`)
- `tooling_email`:
  - Claude Code: `noreply@anthropic.com`
  - Cursor: `cursoragent@cursor.com`
  - Copilot: `copilot@github.com`
  - Codex: `codex@openai.com`
