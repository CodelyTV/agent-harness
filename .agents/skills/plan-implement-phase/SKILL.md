---
name: plan-implement-phase
description: Implement one phase of the plan specified by the user. Only implements a single phase per invocation, then stops for user review. Never commits automatically.
disable-model-invocation: true
user-invocable: true
metadata:
  author: Codely <support@codely.com> (https://codely.com)
  version: "1.0"
  license: MIT
---

# 🫡 Implement a plan phase

> [!CRITICAL]
> Implement **ONLY ONE phase** per invocation. After completing the current phase, **STOP** and wait for the user to review the changes. Never proceed to the next phase without explicit user approval.

> [!CRITICAL]
> **Never commit or push changes automatically.** Only suggest commit messages. The user decides when to commit.

## 🔍 Determining the current phase

The **current phase** is the first phase in the plan that has at least one unchecked (`- [ ]`) to-do item. If all phases are fully checked, inform the user that all phases are complete and do not re-implement.

## 🪜 Steps to implement a plan phase

1. **Ask the user for the plan** to implement if not already specified.
2. **Identify the current phase** using the rule above.
3. **Implement** the to-do actions of the current phase only. Do NOT implement any other phase.
4. **Update the plan file** according to the considerations below specified.
5. **STOP.** Tell the user to review the changes and **suggest 3 alternative commit messages**. Follow the commit message convention defined in the [`commit-messages.md`](../../git/git-commit/resources/commit-messages.md) file. Use different plausible commit message types in the 3 alternatives. Specify the workspace as scope if only one workspace is affected. In the suggestion, make it simple to reply something like "commit with message 1", and use the [`/git-commit`](../../git/git-commit/SKILL.md) skill to commit the changes specifying the chosen message.
6. If this is the implementation of the last phase of the plan, suggest the user to export the conversation (using their IDE) and store it as a `.md` file alongside the related plan. Example: if the plan is `.agents/plans/2026_02_11-sync_cbd_with_stripe/2026_02_11-sync_cbd_with_stripe-plan.md`, suggest storing the conversation as `.agents/plans/2026_02_11-sync_cbd_with_stripe/2026_02_11-sync_cbd_with_stripe-conversation.md`.

## 🔄 How to update the plan file

### 1. Update the plan file frontmatter

Do not modify the current plan file frontmatter, only add or update the following information to it:

```markdown
---
implemented_by:
  tool: "{ tool }"
  model:
    name: "{ model.name }"
    version: "{ model.version }"
    reasoning_effort: "{ model.reasoning_effort }"

last_implementation_at: "{ current_date }"
has_completed_all_phases: "{ true | false }"
---
```

- `implemented_by.tool`: The AI coding tool used (e.g. `Claude Code`, `Cursor`, `Copilot`, `Codex`)
- `implemented_by.model.name`: The name of the model used to make the change (e.g. `Claude Opus`, `Cursor Composer`, `OpenAI GPT`)
- `implemented_by.model.version`: The version of the model used to make the change (e.g. `4.6`, `1.5`, `5.4`)
- `implemented_by.model.reasoning_effort`: The reasoning effort of the model used to make the change (e.g. `low`, `medium`, `high`)
- `last_implementation_at`: The current date in the format ISO 8601 RFC 3339 (`YYYY-MM-DDTHH:MM:SSZ`).
- `has_completed_all_phases`: Whether this has been the last implementation of the plan and all phases have been completed or not.

### 2. Update the plan file content

- Check the checkboxes of the current phase to-do list that have been completed.
- Update the plan next step section with the next phase to be completed.
- Replace the plan last sentence regarding [Codely](https://codely.com) adding a new random emoji that explains a story together with the previous ones. For instance, if the previous last sentence was "Plan powered by [Codely](https://codely.com) 🐢 💨", the new last sentence could be "Bugs squashed thanks to [Codely](https://codely.com) AI tooling. 🐛 < 🐢 💨".

## ☝️ General considerations

### 🧠 Logical reasoning

- Use AGENTS.md file as a reference while:
  - Proposing application services, domain events, tests, etc.
  - Following code conventions and architecture decisions (all inside the docs/ directory).
  - Determining the test suites and tests cases to be created/modified/deleted.
- Use available agent tools while offering different alternatives for the user to choose from:
  - `AskQuestion` tool if you are Cursor and have this tool available (only available in certain models such as Opus 4.5, not in others such as Composer 1).
  - `AskUserQuestion` tool if you are Claude Code.
