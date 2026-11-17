---
name: create-pull-request
description: Write the title and the description of a pull request following the team template, with before/after evidence of the change (screenshots, videos, outputs and architecture diagrams). Use before you create or edit a pull request, and after you push new commits to a branch with an open pull request.
disable-model-invocation: false
user-invocable: true
metadata:
  author: Codely <support@codely.com> (https://codely.com)
  version: "1.1"
  license: MIT
---

# How to write a pull request

Write the title and the body in ASD-STE100 Simplified Technical English. Follow the rules in [`references/ste100.md`](references/ste100.md). Also apply these rules when you update the pull request.

## 1. Title

- Use the Conventional Commits format of [`commit-messages.md`](../git-commit/references/commit-messages.md): `type(scope): summary`.
- If the repository restricts the scopes (a script, a config file or a CI check that validates the title), use one of them.

## 2. Agent label and assignee

If the repository has `agent:*` labels, an agent that creates the pull request adds exactly one, with its own name. Automations such as a cross-agent review can read it.

| Agent       | Label          |
| ----------- | -------------- |
| Claude Code | `agent:claude` |
| Codex       | `agent:codex`  |
| Cursor      | `agent:cursor` |

- Add the label with `gh pr create --label agent:<name>`.
- If a person creates the pull request without an agent, do not add an `agent:*` label.
- If `gh pr create` fails because the label does not exist, create the pull request without the label and tell the user.

Assign the pull request to the person who directed the agent (the person who wrote the prompt):

- If `gh` uses that person's credentials (local CLI, desktop), add `--assignee @me`.
- If `gh` uses a bot or app account (cloud agents) and you know the GitHub username of the person who gave the task, add `--assignee <username>`.
- If you do not know the username, do not guess. Create the pull request without an assignee and tell the user.

## 3. Body

`gh pr create --body` ignores the GitHub template. Build the body from a template explicitly:

1. Read the template of the repository, `.github/pull_request_template.md`. If it does not exist, use [`references/pull-request-template.md`](references/pull-request-template.md).
2. Copy it to a temporary file outside the repository, for example `"$TMPDIR/pr-body.md"`.
3. Fill each section with facts from the diff and from your session.
4. Delete the sections that do not apply and all the HTML comments.
5. Pass the file with `--body-file`.

Rules for each section of the bundled template. With the template of the repository, apply the rules of the sections it shares:

- **🎯 Why:** write the problem, not the solution. Link the issue or the discussion if you know it.
- **🛠️ What changes:** 2–5 bullets with decisions, trade-offs and non-obvious effects. Do not repeat the commit list.
- **📸 Evidence:** see "4. Evidence".
- **✅ How I verified it:** write the commands that you ran and their real result. Write what you did not check. Do not write a check that you did not do.
- **🧩 Complexity:** one line, `**Level:** low / medium / high · <what makes it so>`, for example `**Level:** medium · a new endpoint, use case and table`. The level is how hard the change is to review, not a verdict.
- **🚀 Deploy steps:** optional. Add it only if someone must do something by hand to ship the pull request (run a query or a script in production, change a flag or an environment variable, configure an external service…). Otherwise, delete it. Write one step for each action, in the order to run them, as a numbered checkbox (`1. [ ] …`) so whoever runs it can check it. Start each step with when to run it in bold (**Before merging:**, **After deploying:**…), then where to run it and the exact command, query or flag in a code block. Never check a box yourself unless you ran that step.
- **↩️ Rollback:** the steps to undo the pull request in production, in the order to run them. If reverting the pull request is enough, write only "Revert this pull request." If the change touches state outside the code (database migrations, backfills, feature flags, queues, crons, external config, published events), write each step with the exact command, migration name or flag, and say what data is lost or kept. Undo the deploy steps too, for example with the inverse query. Put the steps that undo state before the revert when the old code cannot run with the new state, and after it otherwise. If a part cannot be undone (deleted data, sent emails, events already consumed), say so and write what to do instead. Read the migrations of the diff to write this, never guess them.
- **🤖 Authorship:** one sentence. Name the harness and the model with its version, then who started the work, see "Who started the work" below. For example "Claude Code with Claude Opus 5.5, guided by Jane Doe (@janedoe)." If you added an `agent:*` label, name the same agent.

If your tool adds an attribution footer (for example "🤖 Generated with Claude Code"), keep it as the last line.

### Who started the work

Never write "the user" and never guess a name. Pick the first case that applies:

| How the agent runs                                                 | End of the Authorship sentence, after "Claude Code with Claude Opus 5.5,"                                              |
| ------------------------------------------------------------------ | ---------------------------------------------------------------------------------------------------------------------- |
| With the person's own `gh` credentials (local CLI, desktop)        | "guided by Jane Doe (@janedoe)." Get it with `gh api user --jq '"\(.name) (@\(.login))"'`.                             |
| Started by a comment, an issue or a mention (`@claude`, `@codex`…) | "guided by @janedoe from [this comment](link)." Use the author of the comment or the person who assigned the issue.    |
| Started by a scheduled task or a routine                           | "triggered by the scheduled task <name>, owned by @janedoe."                                                           |
| Started by an automatic event with no person behind it             | "triggered automatically by <event> ([link](link)). No human directed it."                                             |

With a bot or app account (cloud agents, GitHub Actions), `gh api user` returns the bot: take the person from the event instead. Ask who it is only in an interactive session. If the agent runs unattended and the event does not name a person, use the last row.

## 4. Evidence

The evidence proves the change that "🎯 Why" describes. A reviewer must see that change without running the code.

- Capture the main change, not a side effect of it. For example, if the fix restores a tool that agents call, a screenshot of a new loading style does not prove the fix: the tool call and its result do.
- For a fix, the "before" with the failure is the most important part. Never skip it because the page looks the same: capture the failure in the form that shows it (console error, response, tool result).
- Pick the formats for the kind of change. A pull request can need more than one:
  - **Visual change** (UI, pages, emails, copies, OG images…): screenshots. See "Screenshots".
  - **Flow** (several steps or an interaction): a short video or GIF. See "Videos".
  - **Behavior without a visual change** (agent tools, API endpoints, scripts…): the same input on each side and the output of each side (tool call and returned JSON, request and response, command and output) in code blocks. Trim long outputs to the relevant fields.
  - **Architecture change** (how components call each other, a decision or routing flow, the order of calls, the dependencies between modules): before/after diagrams. See "Architecture diagrams". Add them to the other evidence, do not replace it.
- Delete the section only if nobody can observe the change outside the tests and the architecture does not change (YAML, config, CI, docs, tests, a refactor inside one component…).

### Structure of the section

1. Start with one line that tells where each side comes from: the base commit, the branch, the environment, the URL or state, and the shared input. For example: "Before is `main` at `a3d91f2` and after is this branch, both on the local dev server at `/pricing` with the same seed data."
2. Put the main change first. Then add the scenarios and the variants.
3. Write one block for each thing to prove: a `###` heading and one sentence that tells the reviewer what to look at. Then the evidence.
4. Pick the layout of each block:

| Layout                      | Use it for                                                                                        |
| --------------------------- | ------------------------------------------------------------------------------------------------- |
| Before/after table          | The main change.                                                                                  |
| Close-up crop               | A defect of a few pixels. Use the same crop and zoom on both sides.                               |
| State grid                  | One column for each state that the reviewer cannot infer from the main case (empty, error, long). |
| Variant matrix              | One row for each variant (width, theme, language) and one column for each side.                   |
| One subsection per platform | The same check on several platforms, browsers or environments.                                    |
| Inline GIF and linked video | A short flow as a GIF, and the full walkthrough as a video.                                       |
| Pair of diagrams            | An architecture change, with Before above After.                                                  |

### Screenshots

- For a visual change on the web, always capture desktop (1440 px) and mobile (390 px), on both sides. Show them in a variant matrix.
- If the change exists at one width only (for example, a menu that shows only on mobile), capture that width and write why the other one is missing.
- For emails, also capture both widths.
- Add other variants (dark mode, tablet, languages…) only if the change affects them.
- Use the same viewport and the same crop on both sides of each width.

### Videos

Read [`references/video-recording.md`](references/video-recording.md) before you record.

- Show all the relevant part of the screen: the place of the action and its result. If the result shows far from the click (a toast, a side panel), keep both in the frame.
- Show where each click happens: a visible cursor and a mark on each click.
- Show what you type: type at a readable speed and show the keyboard shortcuts on the screen.
- Wait about 1 s after each action, so the reviewer sees the result before the next step.
- Keep each video under 60 s. Split a longer flow into several videos.
- Write one sentence above each video with the steps that it shows and its duration. GitHub shows a video as a player without alt text.
- If the flow changes, record each side with the same steps, or put both sides next to each other.
- Use the same viewports as the screenshots. Record mobile too if the flow changes there.

### Architecture diagrams

Read [`references/architecture-diagrams.md`](references/architecture-diagrams.md) before you draw.

- Add diagrams when the pull request changes how components call each other, a decision or routing flow, the order of calls, or the dependencies between modules. Omit them if the architecture does not change.
- Pick the diagram for the change:
  - **Decision or routing:** `flowchart TD` with decision nodes.
  - **Order of messages between components:** `sequenceDiagram`.
  - **Structure or dependencies between modules:** `flowchart LR`.
- Draw a Before diagram and an After diagram with the same node names, one above the other. Mermaid does not render inside a table.
- Mark what is added in green, what is removed in red with a dashed line (in Before only) and what changes in amber. Add the legend line above the pair.
- For a new flow with no "before", draw only After, with all of it marked as added.
- Draw only the affected part, with about 12 nodes at most. Draw one pair for each affected flow.

### Produce the evidence

1. Create a temporary directory, for example `mkdir -p "$TMPDIR/pr-evidence"`. Never commit the screenshots or the videos.
2. Capture the "before" state from the base branch and the "after" state from the branch, with the same input.
3. Capture both widths, as in "Screenshots".
4. If the change is a flow, record it as in "Videos".
5. If the architecture changes, write the diagrams as in "Architecture diagrams". They are Markdown, so they go in the body and need no upload.

Sources for each type of change:

- **Web pages:** use a browser automation tool (for example Playwright) against the local dev server or the preview deployment of each side.
- **Emails:** render the email template with the same sample params on each side, write the result to an HTML file and screenshot it.
- **Architecture:** read the code of each side (`git show origin/<base>:<path>` for the "before") and draw the components that the diff touches.

## 5. Attach the images and the videos

Use the `--attach` flag of `gh pr create`, `gh pr edit` or `gh pr comment`. It needs gh v2.99.0 or later (`gh --version`) and works on GitHub.com only.

- If the body references a local file and you attach the same file, gh uploads it and rewrites the reference with the URL.
- If the body has no reference to an attached file, gh appends it at the end of the body.
- Use the same absolute path in the body and in `--attach`. Run `gh` from the repository root.
- The alt text of a rewritten reference comes from the Markdown. The `#` suffix of the flag (`--attach "<file>#<alt text>"`) applies only to appended images. A video has no alt text.
- Repeat the flag for each file. The limit is 50 files for each command.
- Keep each video under 10 MB. gh appends a video at the end of the body: move it under its sentence as in "In the body" of [`references/video-recording.md`](references/video-recording.md).

Example with `TMPDIR=/var/folders/ab/T`:

```markdown
|             | Before                                                                           | After                                                                          |
| ----------- | -------------------------------------------------------------------------------- | ------------------------------------------------------------------------------ |
| **Desktop** | ![Course card before, desktop](/var/folders/ab/T/pr-evidence/before-desktop.png) | ![Course card after, desktop](/var/folders/ab/T/pr-evidence/after-desktop.png) |
| **Mobile**  | ![Course card before, mobile](/var/folders/ab/T/pr-evidence/before-mobile.png)   | ![Course card after, mobile](/var/folders/ab/T/pr-evidence/after-mobile.png)   |
```

```bash
gh pr create \
  --title "fix(courses): align course card price" \
  --body-file "$TMPDIR/pr-body.md" \
  --label agent:claude \
  --assignee @me \
  --attach "$TMPDIR/pr-evidence/before-desktop.png" \
  --attach "$TMPDIR/pr-evidence/after-desktop.png" \
  --attach "$TMPDIR/pr-evidence/before-mobile.png" \
  --attach "$TMPDIR/pr-evidence/after-mobile.png"
```

If some uploads fail, gh creates the pull request, prints its URL and exits with a non-zero status. Then run `gh pr edit --body-file … --attach …` again with the missing files. Open the pull request and make sure that no local path stays in the body and that each diagram renders.

## 6. Update the pull request after new commits

After each push, run `gh pr view --json number,body`. If the branch has an open pull request, update its description:

1. Write the current body to `"$TMPDIR/pr-body.md"`.
2. Compare each section with the full diff against the base branch (`git diff origin/<base>...HEAD`).
3. Update the sections that changed:
   - **🛠️ What changes:** the current changes of the whole pull request.
   - **📸 Evidence:** capture new screenshots or videos if the visual change or the flow is different. Update the diagrams if the architecture is different. Add the section if a visual or architecture change appears. Delete it if none remains.
   - **✅ How I verified it:** the checks for the current state.
   - **🧩 Complexity:** the level and its reason for the current state.
   - **🚀 Deploy steps:** add the section if a manual step appears, and delete it if none remains. Keep the boxes that someone already checked.
   - **↩️ Rollback:** the steps for the current state, including new migrations or flags.
   - **🤖 Authorship:** new contributors.
4. Apply it with `gh pr edit --body-file "$TMPDIR/pr-body.md"`. If the body references new local images or videos, add one `--attach` flag for each file, as in "5. Attach the images and the videos". Then make sure that no local path stays in the body.

The description always describes the current state of the whole pull request. Do not append a commit log or a "changes since last review" list. Do not change the `agent:*` label or the assignees.
