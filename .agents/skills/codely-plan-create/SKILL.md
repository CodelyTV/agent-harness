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

2. Define task phases, letting the user choose the amount of phases as described in the guidelines.

3. Specify the public contracts to be created/modified/deleted on each phase task, as described in the guidelines.

4. Propose the plan to the user for approval. IMPORTANT: Do not start creating the plan file until the user has agreed on the specific contracts to be considered and the implementation phases.

5. Save the plan in a new file inside a subfolder of `.agents/plans` with the current date and a semantic name based on the task description. The structure is: `.agents/plans/{plan-name}/{plan-name}-plan.md`. Example: `2026_01_16-create_embeddable_changelog_widget/2026_01_16-create_embeddable_changelog_widget-plan.md`.

6. Suggest next steps
   - Once you create the plan file, ask the user what do they want to do:
     - Do not do anything else.
     - Commit the plan file to the repository by running the `/codely-git-conventional_commit` skill. Consider plan file only changes as `docs` type.
     - Implement the plan by running the `/codely-plan_phase-implement @plan-file-path` skill.
     - Commit the plan file and then implement Phase 1 only.

   > [!IMPORTANT]
   > If the user asks to "commit and implement", commit the plan file first, then implement **only Phase 1**. Never implement all phases at once. The `/codely-plan_phase-implement` skill handles one phase per invocation.

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
