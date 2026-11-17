## 🎯 Why

<!-- The problem or goal in 1–3 plain sentences. Link the issue or the discussion. -->

## 🛠️ What changes

<!-- 2–5 bullets with what a reviewer must know. Do not paste the commit list. -->

-

## 📸 Evidence

<!--
Show the change that "Why" describes, not a side effect of it. For a fix, the "before" with the failure matters most.
- Visual change (UI, pages, emails, copies, OG images…): screenshots with the same viewport and crop in both columns. Add a mobile width if the layout changes. Emails: render the template with sample params before and after.
- Flows: add a short video or GIF.
- Behavior without a visual change (agent tools, API endpoints, scripts…): the same input before and after, and the output of each side (tool call and returned JSON, request and response, command and output) in code blocks.
Delete this section if nobody can observe the change outside the tests (refactors, YAML, config, CI, docs, tests…).
-->

| Before | After |
| ------ | ----- |
|        |       |

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
