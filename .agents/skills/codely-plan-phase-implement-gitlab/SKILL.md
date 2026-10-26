---
name: codely-plan-phase-implement-gitlab
description: Implement one phase of a plan stored as GitLab issues in the repository of the current working directory. Given the URL of a phase (child) issue it implements that phase; given the parent plan issue it finds and implements the current phase. Only implements a single phase per invocation, then stops for user review. It opens a merge request that references the phase issue and keeps the plan issues reconciled, closing them explicitly when the instance does not auto-close on merge. Never merges the merge request.
disable-model-invocation: true
user-invocable: true
metadata:
  author: Codely <support@codely.com> (https://codely.com)
  contributors:
    - Isidro Merayo Castellano <isidro.merayo@gmail.com> (https://github.com/isidromerayo)
  version: "1.0"
  license: MIT
---

# 🫡 Implement a plan phase

> [!CRITICAL]
> Implement **ONLY ONE phase** per invocation. After completing the current phase, **STOP** and wait for the user to review the changes. Never proceed to the next phase without explicit user approval.

> [!CRITICAL]
> **Never merge the merge request.** This skill may create a feature branch, commit, push and open a merge request, but the user decides when to merge. Merging is what closes the phase issue (and this skill closes it explicitly when the instance has automatic issue closing disabled).

## 🎯 Input

This skill is invoked as `/codely-plan-phase-implement-gitlab <gitlab-issue-url>`. The URL can point to either:

- A **phase (child) issue**: implement that phase.
- The **parent plan issue**: find the current phase and implement it (see below).

GitLab issue URLs look like `https://gitlab.com/<namespace>/<project>/-/issues/<iid>`.

If no URL is provided, ask the user for it before doing anything else.

## 🗂️ Repository

The plan and its phases live as GitLab issues in the repository of the current working directory, and the merge requests are opened there too. Never hardcode a repository: let `glab` resolve it from the local Git remote.

```bash
glab issue view <iid>
git checkout -b <iid>-<phase-kebab-name>
glab mr create --title "..." --description "..." --source-branch "..." --yes
glab mr list --merged --output json
glab issue close <iid>
```

Confirm the repository `glab` resolves with `glab repo view`, and check that the provided URL belongs to it. If it does not, stop and ask the user to run the skill from the clone of that repository: the phase branch must be created in the same repository you are implementing the task in.

> [!IMPORTANT]
> Some GitLab instances (notably self-hosted ones using work items) have **automatic issue closing disabled**. There, `Closes #<iid>` in the merge request description renders as a plain reference: the merge request `closes_issues` list stays empty and the referenced issues remain open after merging. Keep including the closing keyword (it still works where auto-close is enabled), but never rely on it: the skill reconciles the issues explicitly (see the steps below).

## 🔍 Determining the current phase

1. `glab issue view <iid>` to read the given issue.
2. If the issue is a **phase (child) issue** (it has a `Part of #<parent>` reference and a to-do checklist), that is the phase to implement.
3. If the issue is the **parent plan issue** (it has a `Phases` checklist linking child issues), the **current phase** is the **first child issue in that checklist that is still open**. Read that child issue and implement it.
4. If all child issues are already closed, inform the user that all phases are complete and do not implement anything.

## 🪜 Steps to implement a plan phase

1. **Read the given issue and its parent plan**, including every child in the `Phases` checklist. Do not select the current phase until reconciliation finishes.

2. **Reconcile stale phases** before selecting work. For each open child, inspect merged merge requests and confirm both the exact phase source branch and a closing reference to that child issue in the same project. A branch prefix alone is not sufficient evidence. Paginate the results with `--page` until all candidates have been checked:

   ```bash
   glab mr list --merged --output json --per-page 100 --page 1
   glab mr view <merge-request-iid> --output json
   glab issue close <confirmed-merged-child-iid>
   ```

   Check the corresponding parent checklist items only after confirming the merge. Re-read child states and resolve the phase using the rules above. If every phase has been confirmed merged and all children are closed, close the parent if needed and stop. If the explicitly requested child is already closed, report its state and stop without selecting another phase. If all children are closed without merge evidence, report that state without closing the parent automatically.

3. **Create and check out the phase branch** for that phase issue. GitLab has no `glab issue develop` equivalent: create the branch manually with a name that starts with the phase issue number so GitLab links the branch and the merge request to the issue:

   ```bash
   git checkout -b <phase-issue-number>-<phase-kebab-name>
   ```

4. **Implement** the to-do actions of that phase only. Do NOT implement any other phase.

5. **Update the phase issue body** checking the to-do items you completed (`- [x] ...`) with `glab issue update <phase-issue-number> --description ...`.

6. **Verify the changes** (typechecking, linting and tests) and fix any issue before continuing.

7. **STOP.** Present the changes to the user and **suggest 3 alternative commit / merge request titles** following Conventional Commits (e.g. `feat:`, `fix:`, `refactor:`, `test:`, `docs:`). Use different plausible types across the 3 alternatives. Make it simple to reply something like "open the MR with title 1".

8. **When the user picks a title**, commit, push the branch and **open a merge request** that references the phase issue so merging it closes the issue automatically:

   ```bash
   glab mr create \
     --title "<chosen title>" \
     --description "Closes #<phase-issue-number>" \
     --source-branch "<phase-branch>" \
     --yes
   ```

   - If this is the **last phase** of the plan (no other open child issue remains after this one), also close the parent in the same merge request description:

     ```
     Closes #<phase-issue-number>
     Closes #<parent-issue-number>
     ```

   - **Keep the phase item unchecked while its merge request is open.** After independently verifying with `glab mr view <merge-request-iid> --output json` that the merge request is merged, edit the parent body with `glab issue update <parent-issue-number> --description ...` turning `- [ ] #<phase-issue-number>` into `- [x] #<phase-issue-number>`. Preserve the rest of the issue body.

   - Do NOT merge the merge request. Tell the user to merge it. Ask them to confirm the merge (or let them know the next invocation will reconcile it). **Verify the merged state through GitLab before closing any issue. When the merge is confirmed, check whether the instance auto-closed the phase issue; if it is still open, close it explicitly with `glab issue close <phase-issue-number>`.** On the last phase, do the same for the parent plan issue. If the user has not confirmed the merge yet, stop here: the reconciliation will run at the start of the next invocation (step 2).

9. If this is the implementation of the last phase of the plan, suggest the user to export the conversation (using their IDE) and attach it as a comment on the parent plan issue (`glab issue note <parent-issue-number> --message ...`).

## 🔄 How to update the issues

- Check the checkboxes of the current phase to-do list that have been completed in the **child issue**.
- Update the `Next step` section of the **parent issue** with the next phase to be completed.
- Check the corresponding phase item in the parent `Phases` checklist once the phase merge request is confirmed merged (GitLab does not do it automatically).
- Replace the parent issue last sentence regarding [Codely](https://codely.com) adding a new random emoji that explains a story together with the previous ones. For instance, if the previous last sentence was "Plan powered by [Codely](https://codely.com) 🐢 💨", the new last sentence could be "Bugs squashed thanks to [Codely](https://codely.com) AI tooling. 🐛 < 🐢 💨".

## 🔗 Parent / children relationship

- Each phase merge request closes its own child issue on merge (`Closes #<child>` in the description). On instances with automatic issue closing disabled, the skill closes the child explicitly once the merge request is confirmed as merged (or reconciles it at the start of the next invocation).
- The parent plan issue tracks its children through its `Phases` checklist; GitLab does not check each item automatically, so the skill updates it manually once the corresponding merge request is confirmed merged.
- The last phase merge request also closes the parent (explicitly, when auto-close is disabled), so completing the final phase closes the whole plan.

## ☝️ General considerations

### 🧠 Logical reasoning

- Use AGENTS.md file as a reference while:
  - Proposing application services, domain events, tests, etc.
  - Following code conventions and architecture decisions (all inside the docs/ directory).
  - Determining the test suites and tests cases to be created/modified/deleted.
- Use available agent tools while offering different alternatives for the user to choose from:
  - `AskQuestion` tool if you are Cursor and have this tool available (only available in certain models such as Opus 4.5, not in others such as Composer 1).
  - `AskUserQuestion` tool if you are Claude Code.
