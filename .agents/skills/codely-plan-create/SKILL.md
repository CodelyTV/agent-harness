---
name: codely-plan-create
description: Create a plan for the specified task.
disable-model-invocation: true
user-invocable: true
metadata:
  author: Codely <support@codely.com> (https://codely.com)
  version: "1.0"
  license: MIT
---

# 🧠 How to create a plan

The structure of a plan, its sections and the rules to shape them are defined in [`resources/plan-guidelines.md`](resources/plan-guidelines.md). Read it before proposing anything.

1. Ask the user for the task to create a plan for if not specified.

2. Explore the codebase using subagents, as described in [🔍 Codebase exploration with subagents](#-codebase-exploration-with-subagents). Do not explore the codebase yourself: delegate it, telling each subagent only where to explore, never what the task is.

3. Define task phases, letting the user choose the amount of phases as described in the guidelines.

4. Specify the public contracts to be created/modified/deleted on each phase task, as described in the guidelines.

5. Propose the plan to the user for approval. IMPORTANT: Do not start creating the plan file until the user has agreed on the specific contracts to be considered and the implementation phases.

6. Save the plan in a new file inside a subfolder of `.agents/plans` with the current date and a semantic name based on the task description. The structure is: `.agents/plans/{plan-name}/{plan-name}-plan.md`. Example: `2026_01_16-create_embeddable_changelog_widget/2026_01_16-create_embeddable_changelog_widget-plan.md`.

7. Suggest next steps
    - Once you create the plan file, ask the user what do they want to do:
        - Do not do anything else.
        - Commit the plan file to the repository by running the `/codely-git-conventional_commit` skill. Consider plan file only changes as `docs` type.
        - Implement the plan by running the `/codely-plan_phase-implement @plan-file-path` skill.
        - Commit the plan file and then implement Phase 1 only.

   > [!IMPORTANT]
   > If the user asks to "commit and implement", commit the plan file first, then implement **only Phase 1**. Never implement all phases at once. The `/codely-plan_phase-implement` skill handles one phase per invocation.

## 🔍 Codebase exploration with subagents

Gather the context needed for the plan (relevant files, existing conventions, current behavior, affected contracts) by delegating the exploration to subagents instead of reading the codebase yourself. Keep the main agent focused on reasoning and on writing the plan.

- **Reuse an existing exploration subagent if there is one.** Check the subagent types available in the current tool/environment (for example, agent definitions living in the repository or in the user configuration). If one of them is already meant for read-only codebase exploration or research, launch that one instead of a generic subagent.
- **Use cheaper models for the subagents.** Exploration is a search and summarization job, so the subagents do not need to be as capable as the main model. Pick a lighter/faster model from the same family whenever the tool allows overriding it. For example, in a session running Opus, launch the exploration subagents with Haiku.
- **Decide how many subagents to launch based on the task.** There is no fixed number: a small, well-localized change may need a single subagent, while a task touching several bounded contexts, layers, or screens deserves one subagent per independent area of research. Do not launch subagents for areas that are irrelevant to the task.
- **Launch independent subagents in parallel**, in a single batch, so the exploration does not become sequential.
- **Give each subagent a narrow, self-contained assignment**: what to look for, where to start looking, and the fact that it must be read-only (no file modifications). Ask each one to report back the concrete file paths, the relevant existing contracts, and the conventions to follow, instead of dumping whole files.
- **Never pass the task context to the subagents.** They must explore blind: tell them only which areas of the codebase to explore (paths, bounded contexts, layers, screens) and which patterns, contracts or conventions to describe. Do not mention the task, the feature to build, the bug to fix, the intended solution or any goal of the plan. This keeps their reports free of assumptions about the change and prevents them from biasing the exploration towards a solution you have not decided yet.
    - ❌ `We need to add discount codes to checkout, explore how the checkout context works to know where to add them.`
    - ✅ `Explore src/contexts/backend/checkout and report its use cases, domain entities, value objects, repository interfaces and infrastructure implementations, with file paths and the conventions they follow.`
- **Synthesize the subagent reports yourself** before proposing the plan. Read directly only the specific files you still need to confirm a contract or a convention.

## 🗃️ Frontmatter

The plan file should contain the following frontmatter:

```markdown
---
name: "{ plan_name }"
description: "{ plan_description }"
created_at: "{ current_date }"

created_by:
  tool: "{ tool }"
  model:
    name: "{ model.name }"
    version: "{ model.version }"
    reasoning_effort: "{ model.reasoning_effort }"
---
```

- `current_date`: The current date in the format ISO 8601 RFC 3339 (`YYYY-MM-DDTHH:MM:SSZ`).
- `created_by.tool`: The AI coding tool used (e.g. `Claude Code`, `Cursor`, `Copilot`, `Codex`)
- `created_by.model.name`: The name of the model used to make the change (e.g. `Claude Opus`, `Cursor Composer`, `OpenAI GPT`)
- `created_by.model.version`: The version of the model used to make the change (e.g. `4.6`, `1.5`, `5.4`)
- `created_by.model.reasoning_effort`: The reasoning effort of the model used to make the change (e.g. `low`, `medium`, `high`)
