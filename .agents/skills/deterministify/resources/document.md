# The closing offer

Step 8 of [`deterministify`](../SKILL.md). Once a rule enforces a convention, its document only has to say what the rule cannot: why. Offer to leave every enforced convention documented the same way:

```markdown
# <title>

<what it is, in one sentence>

**Why**: <the reason, if known>

Enforced by: <tool> · <rule>
```

Send one message, as plain text, with the parts that apply:

1. **Prune**, for the written conventions you enforced: reduce to that shape only the statements a proven rule now enforces in their whole scope. A statement whose line says `(only in <area>)` stays as it is: the other areas still need its guidance. The rule holds the how, so their examples and enforcement notes go. Everything else in the document stays as it is: the statements you skipped, the exceptions, the guidance that no rule replaces. List the documents and what leaves each one.
2. **Document**, for the mined conventions you enforced: write that shape for each, where the repository keeps its conventions. With no such place, propose one. Take the why from the repository (commit messages, pull requests, comments). Where it says nothing, show the title and the sentence you would write, and ask for the why in one line. The why is optional: with no answer, document the convention without it.
3. **Hook**, when no hook lints the changed files before a commit: propose the command that lints only those files and the hook that runs it, with the hook tool the repository has. The whole linter stays in CI.

Close with: "Reply `yes` to accept everything, or tell me which numbers to change or skip."

Commit what the user accepts: the documentation in one commit, the hook in another.
