---
name: codely:plan-create-github
description: Create a plan for the specified task and store it as GitHub issues in the repository of the current working directory. Given the URL of a GitHub issue, it turns that issue into the parent "plan" issue (Goal, Context and a checklist of phases) and creates one child issue per phase, linking every phase as a native GitHub sub-issue of the parent. Stops for user approval before creating any issue. After creation, the plan is meant to be implemented with the codely:plan_phase-implement-github skill.
disable-model-invocation: true
user-invocable: true
metadata:
  author: Codely <support@codely.com> (https://codely.com)
  version: "1.0"
  license: MIT
---

# 🧠 How to create a plan

> [!CRITICAL]
> Do NOT create or edit any GitHub issue until the user has agreed on the specific public contracts to be considered and the implementation phases. Propose first, get approval, then create the issues.

The structure of a plan, its sections and the rules to shape them are defined in [`resources/plan-guidelines.md`](resources/plan-guidelines.md). Read it before proposing anything.

## 🎯 Input

This skill is invoked as `/codely:plan-create-github <github-issue-url>`.

- `<github-issue-url>` is the URL of the GitHub issue describing the task to plan. **This issue becomes the parent "plan" issue.**
- If no URL is provided, ask the user for it before doing anything else.

## 🗂️ Repository

All the plan lives as GitHub issues in the repository of the current working directory. Never hardcode a repository: let `gh` resolve it from the local Git remote.

```bash
gh issue view <number>
gh issue create --title "..." --body "..."
gh issue edit <number> --body "..."
```

Derive `<number>` from the provided URL. Confirm the repository `gh` resolves with `gh repo view --json nameWithOwner --jq .nameWithOwner`, and check that the provided URL belongs to it. If it does not, stop and ask the user to run the skill from the clone of that repository.

To link a phase as a **native GitHub sub-issue** of the parent, use the sub-issues REST API. It expects the child's numeric database `id` (not its issue number), so resolve it first. The `{owner}` and `{repo}` placeholders are substituted by `gh` with the current repository:

```bash
# Resolve the child issue database id from its number
child_id=$(gh api repos/{owner}/{repo}/issues/<child> --jq .id)

# Attach the child as a native sub-issue of the parent
gh api --method POST repos/{owner}/{repo}/issues/<parent>/sub_issues -F sub_issue_id="$child_id"
```

## 🧱 Issue structure

A plan is stored as a **tree of issues**, using GitHub's **native sub-issues** feature:

- **Parent "plan" issue**: the issue whose URL was passed in. It holds the `Goal`, the `Context`, the agreed design decisions, and a **checklist of the phases**, each item linking its child issue. The parent depends on its children: when every child issue is closed, the parent closes too.
- **One child issue per phase**: each holds the phase description and its to-do actions as a checkbox list, plus a reference back to the parent (`Part of #<parent>`). Every child is attached to the parent as a **native GitHub sub-issue** (via the sub-issues API), not only as a checklist link.

```
#12 Product Bundles (parent plan)
     Goal / Context / design decisions
     - [ ] #13 Phase 1: ...
     - [ ] #14 Phase 2: ...
#13 Phase 1: ...   (child, to-do checkboxes)
#14 Phase 2: ...   (child, to-do checkboxes)
```

## 🪜 Steps to create a plan

1. **Read the task** from the parent issue with `gh issue view <parent>`.

2. Define task phases, letting the user choose the amount of phases as described in the guidelines.

3. Specify the public contracts to be created/modified/deleted on each phase task, as described in the guidelines.

4. Propose the plan to the user for approval. IMPORTANT: Do not create any issue until the user has agreed on the specific contracts to be considered and the implementation phases.

5. **Create one child issue per phase** with `gh issue create`. Each child issue body must contain:
   - The phase description.
   - The phase to-do actions as a checkbox list (`- [ ] ...`).
   - The public contracts for that phase.
   - A `Part of #<parent>` reference line.

   Capture the number of every child issue returned by `gh`.

6. **Attach every child as a native sub-issue of the parent.** For each child, resolve its database id and link it to the parent with the sub-issues API (see the snippet in the Repository section above):

   ```bash
   child_id=$(gh api repos/{owner}/{repo}/issues/<child> --jq .id)
   gh api --method POST repos/{owner}/{repo}/issues/<parent>/sub_issues -F sub_issue_id="$child_id"
   ```

   Do this for every phase, in order, so the parent lists all phases as native sub-issues.

7. **Update the parent issue** with `gh issue edit <parent> --body ...` so its body contains the `Goal`, `Context`, agreed design decisions and a `Phases` checklist that links every child issue (`- [ ] #<child> Phase N: <title>`). Preserve the original task description from the parent issue: keep it as-is and append the new plan content below it, separated by a `---` line (do not lose or rewrite the original text).

8. Suggest next steps. Ask the user what do they want to do:
   - Do not do anything else.
   - Implement the plan by executing the `/codely:plan_phase-implement-github <parent-issue-url>` skill (implements Phase 1 only).
   - Implement a specific phase by executing the `/codely:plan_phase-implement-github <child-issue-url>` skill.

   > [!IMPORTANT]
   > `/codely:plan_phase-implement-github` handles one phase per invocation. Never implement all phases at once.

## 🗃️ Plan metadata

GitHub issues have no YAML frontmatter, so add the plan metadata as a footer at the end of the **parent** issue body:

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

As the phases are implemented through pull requests, the last to-do action of every phase asks for pull request titles instead of commit messages.
