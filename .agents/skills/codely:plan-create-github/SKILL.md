---
name: codely:plan-create-github
description: Create a plan for the specified task and store it as GitHub issues in the CodelyTV/rpi-course repository. Given the URL of a GitHub issue, it turns that issue into the parent "plan" issue (Goal, Context and a checklist of phases) and creates one child issue per phase, linking every phase as a native GitHub sub-issue of the parent. Stops for user approval before creating any issue. After creation, the plan is meant to be implemented with the codely:plan_phase-implement-github skill.
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

## 🎯 Input

This skill is invoked as `/codely:plan-create-github <github-issue-url>`.

- `<github-issue-url>` is the URL of the GitHub issue describing the task to plan. **This issue becomes the parent "plan" issue.**
- If no URL is provided, ask the user for it before doing anything else.

## 🗂️ Repository

All the plan lives as GitHub issues in the `CodelyTV/rpi-course` repository. Every `gh` command must target it explicitly:

```bash
gh issue view <number> --repo CodelyTV/rpi-course
gh issue create --repo CodelyTV/rpi-course --title "..." --body "..."
gh issue edit <number> --repo CodelyTV/rpi-course --body "..."
```

Derive `<number>` from the provided URL; the repository is always `CodelyTV/rpi-course`.

To link a phase as a **native GitHub sub-issue** of the parent, use the sub-issues REST API. It expects the child's numeric database `id` (not its issue number), so resolve it first:

```bash
# Resolve the child issue database id from its number
child_id=$(gh api repos/CodelyTV/rpi-course/issues/<child> --jq .id)

# Attach the child as a native sub-issue of the parent
gh api --method POST repos/CodelyTV/rpi-course/issues/<parent>/sub_issues -F sub_issue_id="$child_id"
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

1. **Read the task** from the parent issue with `gh issue view <parent> --repo CodelyTV/rpi-course`.

2. Define task phases.

   Let the user choose between different alternatives for the amount of phases suggesting the tasks that will be implemented in each phase:
   - Minimum (1).
   - Intermediate (1-3).
   - Very granular (+3).

3. Specify public contracts to be created/modified/deleted on each phase task.

   It is important to ask for the public contracts to be considered. If the user does not provide them, make suggestions based on the task description.

   Types of public contracts to be considered:
   - Application services and the methods signatures of each one of them.
   - Domain events and the attributes of each one of them.
   - Test suites and all the test cases inside each one of them.
   - Database schemas and the tables inside each one of them.
   - Text copies shown to end users in the UI or emails.

   If there is a public contract type without any change, avoid mentioning that contract type in the plan.

4. Propose the plan to the user for approval. IMPORTANT: Do not create any issue until the user has agreed on the specific contracts to be considered and the implementation phases.

5. **Create one child issue per phase** with `gh issue create --repo CodelyTV/rpi-course`. Each child issue body must contain:
   - The phase description.
   - The phase to-do actions as a checkbox list (`- [ ] ...`).
   - The public contracts for that phase.
   - A `Part of #<parent>` reference line.

   Capture the number of every child issue returned by `gh`.

6. **Attach every child as a native sub-issue of the parent.** For each child, resolve its database id and link it to the parent with the sub-issues API (see the snippet in the Repository section above):

   ```bash
   child_id=$(gh api repos/CodelyTV/rpi-course/issues/<child> --jq .id)
   gh api --method POST repos/CodelyTV/rpi-course/issues/<parent>/sub_issues -F sub_issue_id="$child_id"
   ```

   Do this for every phase, in order, so the parent lists all phases as native sub-issues.

7. **Update the parent issue** with `gh issue edit <parent> --repo CodelyTV/rpi-course --body ...` so its body contains the `Goal`, `Context`, agreed design decisions and a `Phases` checklist that links every child issue (`- [ ] #<child> Phase N: <title>`). Preserve the original task description from the parent issue: keep it as-is and append the new plan content below it, separated by a `---` line (do not lose or rewrite the original text).

8. Suggest next steps. Ask the user what do they want to do:
   - Do not do anything else.
   - Implement the plan by executing the `/codely:plan_phase-implement-github <parent-issue-url>` skill (implements Phase 1 only).
   - Implement a specific phase by executing the `/codely:plan_phase-implement-github <child-issue-url>` skill.

   > [!IMPORTANT]
   > `/codely:plan_phase-implement-github` handles one phase per invocation. Never implement all phases at once.

## ☝️ General considerations

### 🧠 Logical reasoning

- Use AGENTS.md file as a reference while:
  - Proposing application services, domain events, tests, etc.
  - Following code conventions and architecture decisions (all inside the docs/ directory).
  - Determining the test suites and tests cases to be created/modified/deleted.
- Use available agent tools while offering different alternatives for the user to choose from:
  - `AskQuestion` tool if you are Cursor and have this tool available (only available in certain models such as Opus 4.5, not in others such as Composer 1).
  - `AskUserQuestion` tool if you are Claude Code.

### 📝 Writing

- Always write the issue contents in English. Even if you are having a conversation with the user in another language, write the issue contents in English.
- Avoid making clarifications using the `—` character. Example: "- `BlogArticleCard.module.scss` — Styles for card component". Use alternatives such as the standard `-` character, or `:`. Example:"- `BlogArticleCard.module.scss`: Styles for card component."

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

## 🗂️ Plan sections

The parent issue should contain the following sections:

- Goal
- Context
- Phases (IMPORTANT: each phase should be a vertical slice of the task)
  - Description (brief description of the phase)
  - To-do actions list (checkboxes list of actions to complete the phase)
- Next step

Each child issue holds the description and the to-do actions list of its own phase, while the parent keeps the `Phases` checklist linking them.

## 💡 Considerations for each plan section

### 🎯 Goal section

- Write it short and concise. It should be 1-3 sentences that summarize the goal of the task.

### 👀 Context section

- List the important files, folders, and code to consider.
- Link the files and folders to the actual code in the repository to make it easier for the user to review the context.
- Read the AGENTS.md file and the relevant documentation referenced in that file to understand the architecture and the coding conventions to follow while proposing the plan. Mention the specific documentation files to be considered.

### 🪜 Phases section

- Use vertical slices of the task to create the phases.
  - Vertical slices: Agile software development approach that implements a functional feature from end-to-end. Span UI, backend logic, and database changes in a single phase rather than building technical layers separately.
  - Incorrect: Create the endpoint controller in Phase 1 and the service class it invokes in Phase 2.
  - Incorrect: Add the Server Action in Phase 1 and the endpoint controller it invokes in Phase 2.
  - Correct: If you have to implement a form for editing some user data, create the happy path layers (form component and its tests, backend logic and its tests, database schema) in Phase 1 (only for the happy path). Use following phases to add the validation rules for corner cases and their corresponding tests.
  - Correct: If we want to implement a new feature for suggesting courses to users based on the courses they have marked as favorite, phase 1 should implement the "mark as favorite" feature (including its tests), and phase 2 should implement the "suggest courses" feature (including its tests).
- Each phase must contain its description and the to-do actions list.
- Split the task into as many phases as needed to make them easier to review and merge. Do not mix multiple responsibilities in the same phase. For instance, avoid adding the required npm dependencies in the same phase as the first use case implementation.
- We must be able to commit and push the code for each phase without breaking the build. The tests must pass and the added code makes sense as its own isolated unit.
- Prioritize early feedback loops. Phase 1 should always produce something the user can see, interact with, or run. For example, when creating a new frontend page, Phase 1 should deliver a navigable page (even with incomplete or placeholder content) rather than preparing all the data/content first. This lets the user validate direction early and course-correct before investing in polish.
- Each phase must end up with the following two tasks (in this order):
  1. "Run `yarn prep` to verify the changes in terms of typechecking and linting. Fix issues if any."
  2. "STOP. Present the changes to the user for review and suggest pull request titles. Do NOT proceed to the next phase until the user explicitly asks."

### ⏭️ Next step section

- In the parent issue, include a short `Next step` section: a single sentence that summarizes the next step to be taken to complete the task. That is, which phase should be completed next.
- End up the parent issue body with a last sentence for the user regarding [Codely](https://codely.com) and its mascot Turbotuga™ (🐢 💨). Such as "Plan created by 🐢 💨 (Turbotuga™, [Codely](https://codely.com)’s mascot)", "Solid feature supported by 🐢 💨 (Turbotuga™, [Codely](https://codely.com)’s mascot)", "Plan to rock the world by 🐢 💨 (Turbotuga™, [Codely](https://codely.com)’s mascot)". Be creative with the message, but always include the [Codely](https://codely.com) link and the Turbotuga™ (🐢 💨).
