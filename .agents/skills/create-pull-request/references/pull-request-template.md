## 🎯 Why

<!-- The problem or goal in 1–3 plain sentences. Link the issue or the discussion. -->

## 🛠️ What changes

<!-- 2–5 bullets with what a reviewer must know. Do not paste the commit list. -->

-

## 📸 Evidence

<!--
Show the change that "Why" describes, not a side effect of it. For a fix, the "before" with the failure matters most.
Start with one line that tells where each side comes from (base commit, branch, environment, URL or state, shared input). Then the main change first, then scenarios and variants. Each block: a ### heading and one sentence that tells what to look at.
- Visual change (UI, pages, emails, copies, OG images…): screenshots of desktop (1440 px) and mobile (390 px), before and after, with the same viewport and crop. Emails: render the template with sample params before and after.
- Flows: a short video or GIF with a visible cursor and clicks, about 1 s of pause after each action, and one sentence with its steps and duration.
- Behavior without a visual change (agent tools, API endpoints, scripts…): the same input before and after, and the output of each side (tool call and returned JSON, request and response, command and output) in code blocks.
- Architecture change: a Before and an After Mermaid diagram, one above the other (flowchart TD for decisions, sequenceDiagram for the order of calls, flowchart LR for dependencies). Green is added, red dashed is removed, amber is changed.
Add as many blocks as the change needs. Delete this section if nobody can observe the change outside the tests and the architecture does not change (YAML, config, CI, docs, tests…).
-->

|             | Before | After |
| ----------- | ------ | ----- |
| **Desktop** |        |       |
| **Mobile**  |        |       |

## ✅ How I verified it

<!-- Commands that you ran and their result, manual checks, and what you did NOT check. -->

-

## 🧩 Complexity

<!-- How hard the change is to review, and what makes it so: "medium · a new endpoint, use case and table". -->

**Level:** low / medium / high · 

## 🚀 Deploy steps

<!--
Only if someone must do something by hand to ship this pull request. Delete this section otherwise.
One numbered checkbox per step, in order. Each step says when to run it, where, and the exact command, query or flag.
Whoever runs a step checks its box. Merge only when every "Before merging" box is checked.
-->

1. [ ] **Before merging:** run in production:
   ```sql

   ```
2. [ ] **After deploying:**

## ↩️ Rollback

<!--
How to undo this pull request in production, as steps in order.
- Code only: "Revert this pull request."
- Feature flag: name the flag and the value that turns the change off.
- Database migration, backfill, queue, cron or external config: write each step with the exact command or migration name, and say what data is lost or kept. For example:
  1. Run the down migration `20261117_create_course_review` (drops the `course_review` table and its rows).
  2. Revert this pull request.
- If it cannot be undone (data deleted, emails sent, event consumed by other services), say so and write what to do instead.
-->

- 

## 🤖 Authorship

<!-- One sentence: the harness and the model, then who started the work. Use the same agent as the `agent:*` label if there is one. Never write "the user".
- A person directed it: "Claude Code with Claude Opus 5.5, guided by Jane Doe (@janedoe)."
- A comment, issue or scheduled task started it: name the person behind it and link the origin.
- An automatic event started it with no person behind it: "Claude Code with Claude Opus 5.5, triggered automatically by <event> (<link>)." -->
