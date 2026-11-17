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

## ⚠️ Risk

<!-- The level is the author's declaration, not a verdict. -->

- **Level:** low / medium / high
- **Touches:** <!-- Sensitive areas: payments, auth, DB migrations, customer emails, CI… or "none". -->
- **Rollback:** <!-- How to undo it: revert the PR, toggle a flag, run a down migration… -->

## 🤖 Authorship

<!-- Who did what. If an agent wrote the change, start with who started the work, then name the harness, its surface (CLI, desktop, IDE, cloud…) and the model, with the same agent as the `agent:*` label if there is one. Never write "the user".
- A person directed it: "Directed by Jane Doe (@janedoe), who wrote the spec. Written by Claude Code (desktop) with Claude Opus 5.5. Not reviewed by a human yet."
- A comment, issue or scheduled task started it: name the person behind it and link the origin.
- An automatic event started it with no person behind it: "Triggered automatically by <event> (<link>). No human directed it." -->
