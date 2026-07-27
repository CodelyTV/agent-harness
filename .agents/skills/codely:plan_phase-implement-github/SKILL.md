---
name: codely:plan_phase-implement-github
description: Implement one phase of a plan stored as GitHub issues in CodelyTV/rpi-course. Given the URL of a phase (child) issue it implements that phase; given the parent plan issue it finds and implements the current phase. Only implements a single phase per invocation, then stops for user review. It opens a pull request that references the phase issue so merging it closes the issue automatically. Never merges the pull request.
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
> **Never merge the pull request.** This skill may create a feature branch, commit, push and open a pull request, but the user decides when to merge. Merging is what closes the phase issue.

## 🎯 Input

This skill is invoked as `/codely:plan_phase-implement-github <github-issue-url>`. The URL can point to either:

- A **phase (child) issue**: implement that phase.
- The **parent plan issue**: find the current phase and implement it (see below).

If no URL is provided, ask the user for it before doing anything else.

## 🗂️ Repository

The plan and its phases live as GitHub issues in the `CodelyTV/rpi-course` repository, and the pull requests are opened there too. Every `gh` command must target it explicitly, e.g.:

```bash
gh issue view <number> --repo CodelyTV/rpi-course
gh issue develop <number> --repo CodelyTV/rpi-course --checkout
gh pr create --repo CodelyTV/rpi-course --title "..." --body "..."
```

## 🔍 Determining the current phase

1. `gh issue view <url> --repo CodelyTV/rpi-course` to read the given issue.
2. If the issue is a **phase (child) issue** (it has a `Part of #<parent>` reference and a to-do checklist), that is the phase to implement.
3. If the issue is the **parent plan issue** (it has a `Phases` checklist linking child issues), the **current phase** is the **first child issue in that checklist that is still open**. Read that child issue and implement it.
4. If all child issues are already closed, inform the user that all phases are complete and do not implement anything.

## 🪜 Steps to implement a plan phase

1. **Resolve the phase issue** to implement using the rule above.

2. **Create and check out the linked branch** for that phase issue so the branch is linked to it:

   ```bash
   gh issue develop <phase-issue-number> --repo CodelyTV/rpi-course --checkout
   ```

3. **Implement** the to-do actions of that phase only. Do NOT implement any other phase.

4. **Update the phase issue body** checking the to-do items you completed (`- [x] ...`) with `gh issue edit <phase-issue-number> --repo CodelyTV/rpi-course --body ...`.

5. **Verify the changes** (typechecking, linting and tests) and fix any issue before continuing.

6. **STOP.** Present the changes to the user and **suggest 3 alternative commit / pull request titles** following Conventional Commits (e.g. `feat:`, `fix:`, `refactor:`, `test:`, `docs:`). Use different plausible types across the 3 alternatives. Specify the affected workspace as scope if only one workspace is affected. Make it simple to reply something like "open the PR with title 1".

7. **When the user picks a title**, commit, push the branch and **open a pull request** that references the phase issue so merging it closes the issue automatically:

   ```bash
   gh pr create --repo CodelyTV/rpi-course \
     --title "<chosen title>" \
     --body "Closes #<phase-issue-number>"
   ```

   - If this is the **last phase** of the plan (no other open child issue remains after this one), also close the parent in the same pull request body:

     ```
     Closes #<phase-issue-number>
     Closes #<parent-issue-number>
     ```

   - Do NOT merge the pull request. Tell the user that merging it will close the phase issue (and, on the last phase, the parent plan issue).

8. If this is the implementation of the last phase of the plan, suggest the user to export the conversation (using their IDE) and attach it as a comment on the parent plan issue.

## 🔄 How to update the issues

- Check the checkboxes of the current phase to-do list that have been completed in the **child issue**.
- Update the `Next step` section of the **parent issue** with the next phase to be completed.
- Replace the parent issue last sentence regarding [Codely](https://codely.com) adding a new random emoji that explains a story together with the previous ones. For instance, if the previous last sentence was "Plan powered by [Codely](https://codely.com) 🐢 💨", the new last sentence could be "Bugs squashed thanks to [Codely](https://codely.com) AI tooling. 🐛 < 🐢 💨".

## 🔗 Parent / children relationship

- Each phase pull request closes its own child issue on merge.
- The parent plan issue tracks its children through its `Phases` checklist; GitHub checks each item as the corresponding child issue closes.
- The last phase pull request also closes the parent, so completing the final phase closes the whole plan.

## ☝️ General considerations

### 🧠 Logical reasoning

- Use AGENTS.md file as a reference while:
  - Proposing application services, domain events, tests, etc.
  - Following code conventions and architecture decisions (all inside the docs/ directory).
  - Determining the test suites and tests cases to be created/modified/deleted.
- Use available agent tools while offering different alternatives for the user to choose from:
  - `AskQuestion` tool if you are Cursor and have this tool available (only available in certain models such as Opus 4.5, not in others such as Composer 1).
  - `AskUserQuestion` tool if you are Claude Code.
