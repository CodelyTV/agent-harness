# The one question

Step 4 of [`deterministify`](../SKILL.md). Ask in the chat as plain text, even when you have a question tool: one message shows everything at once, and it reads the same in every agent. Use plain words in place of the terms of this skill.

1. One line per kind of finding: how many it has.
2. What you already enforced without asking, as a plain list with no numbers, one line each. It informs and asks nothing: say once that each line is one commit. For a clear job: `<old way> → <current way> (<n> files keep the old way)`. Past fifteen lines, group them by area and give counts.
3. What needs an answer, as numbered **cards**: one for everything that leaves doubt, written or mined, with no limit. Dependencies and contradictions go first, then the mined jobs, strongest evidence first.
4. The jobs with no clear winner, by name.
5. One closing question: "Reply `yes` to accept every suggestion, or tell me which cards to change or skip."

## Cards

The user reads a card in ten seconds. Show only the key part of each variant: one to three lines of real code from the repository, with its arguments shortened until the difference stands out.

```markdown
### 1 · <the job, in plain words> (<where it applies>)

- **Use**: `<key part of the proposed variant>`
- **Stop using**: `<key part of the old variant>`

- **Why**: <the one strongest reason, in one sentence>
- **Existing code**: <n> files use the old way. They stay as they are: the rule skips them.
```

A conflict, between the variants of a job or between two written statements, still gets a suggestion, so `yes` settles every card. Its title says it is a conflict, and it shows **Suggested** and one **Alternative** for each other option, each with what supports it in one line. Suggest the option that intent supports, then the one that direction supports. Between two written statements, suggest the one the existing code follows.

A dependency card shows **Install**, **Covers** (the conventions that need it) and **Why** (the documentation you checked).
