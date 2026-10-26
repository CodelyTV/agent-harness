---
name: codely-plan-create-gitlab
description: Create a plan for the specified task and store it as GitLab issues in the repository of the current working directory. Given the URL of a GitLab issue, it turns that issue into the parent "plan" issue (Goal, Context and a checklist of phases) and creates one child issue per phase, linking every phase to the parent with GitLab related-issue links. Stops for user approval before creating any issue. After creation, the plan is meant to be implemented with the codely-plan-phase-implement-gitlab skill.
disable-model-invocation: true
user-invocable: true
metadata:
  author: Codely <support@codely.com> (https://codely.com)
  contributors:
    - Isidro Merayo Castellano <isidro.merayo@gmail.com> (https://github.com/isidromerayo)
  version: "1.0"
  license: MIT
---

# 🧠 How to create a plan

> [!CRITICAL]
> Do NOT create or edit any GitLab issue until the user has agreed on the specific public contracts to be considered and the implementation phases. Propose first, get approval, then create the issues.

The structure of a plan, its sections and the rules to shape them are defined in [`resources/plan-guidelines.md`](resources/plan-guidelines.md). Read it before proposing anything.

## 🎯 Input

This skill is invoked as `/codely-plan-create-gitlab <gitlab-issue-url>`.

- `<gitlab-issue-url>` is the URL of the GitLab issue describing the task to plan. **This issue becomes the parent "plan" issue.** GitLab issue URLs look like `https://gitlab.com/<namespace>/<project>/-/issues/<iid>`.
- If no URL is provided, ask the user for it before doing anything else.

## 🗂️ Repository

All the plan lives as GitLab issues in the repository of the current working directory. Never hardcode a repository: let `glab` resolve it from the local Git remote.

```bash
glab issue view <iid>
glab issue create --title "..." --description "..." --linked-issues <parent-iid> --link-type relates_to --yes
glab issue update <iid> --description "..."
```

Derive `<iid>` from the provided URL. Confirm the repository `glab` resolves with `glab repo view`, and check that the provided URL belongs to it. If it does not, stop and ask the user to run the skill from the clone of that repository.

To link a phase to the parent, use GitLab **related-issue links** (`relates_to`). The simplest way is to link at creation time with the `--linked-issues` and `--link-type` flags shown above. Alternatively, link an already created issue with the issues API. Resolve the current project ID first, then pass that numeric ID as the target project:

```bash
project_id="$(glab api projects/:id --jq .id)"
glab api projects/:id/issues/<parent-iid>/links -F target_project_id="$project_id" -F target_issue_iid=<child-iid>
```

## 🧱 Issue structure

A plan is stored as a **tree of issues**, using GitLab **related-issue links**:

- **Parent "plan" issue**: the issue whose URL was passed in. It holds the `Goal`, the `Context`, the agreed design decisions, and a **checklist of the phases**, each item linking its child issue. The parent is closed when the plan completes: the merge request of the last phase references it with `Closes #<parent>` and, on instances with automatic issue closing disabled, the `/codely-plan-phase-implement-gitlab` skill closes it explicitly.
- **One child issue per phase**: each holds the phase description and its to-do actions as a checkbox list, plus a reference back to the parent (`Part of #<parent>`). Every child is linked to the parent with a **related-issue link** (`relates_to`), not only as a checklist link.

```
#12 Product Bundles (parent plan)
     Goal / Context / design decisions
     - [ ] #13 Phase 1: ...
     - [ ] #14 Phase 2: ...
#13 Phase 1: ...   (child, to-do checkboxes)
#14 Phase 2: ...   (child, to-do checkboxes)
```

> [!IMPORTANT]
> GitLab does NOT auto-check task list items when the referenced issue closes (unlike GitHub sub-issues). Some instances even have automatic issue closing disabled, so `Closes #<iid>` in a merged merge request does not close the referenced issues. The `/codely-plan-phase-implement-gitlab` skill is responsible for checking the corresponding phase item in the parent checklist once each phase merge request is confirmed as merged and for closing the issues explicitly when the merge is confirmed.

## 🪜 Steps to create a plan

1. **Read the task** from the parent issue with `glab issue view <parent>`.

2. Define task phases, letting the user choose the amount of phases as described in the guidelines.

3. Specify the public contracts to be created/modified/deleted on each phase task, as described in the guidelines.

4. Propose the plan to the user for approval. IMPORTANT: Do not create any issue until the user has agreed on the specific contracts to be considered and the implementation phases.

5. **Create one child issue per phase** with `glab issue create`, linking each child to the parent as a related issue at creation time. Each child issue body must contain:
   - The phase description.
   - The phase to-do actions as a checkbox list (`- [ ] ...`).
   - The public contracts for that phase.
   - A `Part of #<parent>` reference line.

   ```bash
   glab issue create \
     --title "Phase N: <title>" \
     --description "..." \
     --linked-issues <parent-iid> \
     --link-type relates_to \
     --yes
   ```

   Capture the issue number (IID) from the URL `glab` prints for every child issue. If the command reports a failure, first check whether it already created the child issue to avoid duplicates. If the `--linked-issues` flag is unavailable, create the issue without it. Attach any missing link afterwards with the API snippet in the Repository section above.

6. **Update the parent issue** with `glab issue update <parent> --description ...` so its body contains the `Goal`, `Context`, agreed design decisions and a `Phases` checklist that links every child issue (`- [ ] #<child> Phase N: <title>`). Preserve the original task description from the parent issue: keep it as-is and append the new plan content below it, separated by a `---` line (do not lose or rewrite the original text).

7. Suggest next steps. Ask the user what do they want to do:
   - Do not do anything else.
   - Implement the plan by executing the `/codely-plan-phase-implement-gitlab <parent-issue-url>` skill (implements Phase 1 only).
   - Implement a specific phase by executing the `/codely-plan-phase-implement-gitlab <child-issue-url>` skill.

   > [!IMPORTANT]
   > `/codely-plan-phase-implement-gitlab` handles one phase per invocation. Never implement all phases at once.

## 🗃️ Plan metadata

GitLab issues have no YAML frontmatter, so add the plan metadata as a footer at the end of the **parent** issue body:

```markdown
---

<sub>Created by { tool } · { model.name } { model.version } (reasoning effort: { model.reasoning_effort }) · { current_date }</sub>
```

- `current_date`: The current date in the format ISO 8601 RFC 3339 (`YYYY-MM-DDTHH:MM:SSZ`).
- `tool`: The AI coding tool used (e.g. `Claude Code`, `Cursor`, `Copilot`, `Codex`)
- `model.name`: The name of the model used to make the change (e.g. `Claude Opus`, `Cursor Composer`, `OpenAI GPT`)
- `model.version`: The version of the model used to make the change (e.g. `4.6`, `1.5`, `5.4`)
- `model.reasoning_effort`: The reasoning effort of the model used to make the change (e.g. `low`, `medium`, `high`)

## 🗂️ Where each plan section lives

The parent issue holds the `Goal`, the `Context`, the `Phases` checklist and the `Next step` sections described in [`resources/plan-guidelines.md`](resources/plan-guidelines.md). Each child issue holds the description and the to-do actions list of its own phase.

As the phases are implemented through merge requests, the last to-do action of every phase asks for merge request titles instead of commit messages.
