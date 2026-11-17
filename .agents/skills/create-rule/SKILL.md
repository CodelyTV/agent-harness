---
name: create-rule
description: Turn one new convention into a deterministic rule (linter config, custom lint rule or test) that fails in seconds. When no rule can check it exactly, write a minimal doc with the reason instead. Use after the user corrects you on a convention, or when they describe one to enforce.
argument-hint: "[convention]"
disable-model-invocation: false
user-invocable: true
metadata:
  author: Codely <support@codely.com> (https://codely.com)
  version: "1.0"
  license: MIT
---

# Create rule

A written convention holds only if an agent loads it, reads it the way the team does, and a reviewer catches the miss. A **rule** fails in seconds and tells the agent what to do instead, so the agent corrects itself. This skill takes one convention and makes it a rule when it can. When it cannot, it documents the convention in a few lines, with the reason no rule checks it.

To enforce the conventions that a repository already has, use `deterministify` instead.

## Arguments

`/create-rule [convention]`

- **Without arguments:** take the convention from the conversation: what the user corrected you on, and your version before the correction.
- **With a description:** take the convention from it and from the code.

## Principles

- **Exact or document.** Write a rule when it covers the whole convention and reports only real violations. The effort to write the rule is no reason to skip it. A rule that has to guess (which class is an aggregate, which file is an entrypoint) is: document the convention instead.
- **Baseline.** The rule is an error for new code. The code that already breaks it is its **baseline**: the rule ignores it, and the baseline only shrinks. Leave that code as it is.
- **Red, then green.** A rule counts once you have seen it fail on a violation and seen the repository pass.
- **The rule holds the how, the doc holds the why.** Every convention ends with a minimal doc. With a rule, the doc names it and drops the examples.

## Steps

### 1. Pin down the convention

Done when you can state, in one sentence each:

- what code must do or must not do
- its scope: which folders, layers or file types
- its exceptions, if the user or the docs mention any
- why the team wants it, if the conversation or the repository says it
- a real example that follows it and one that breaks it: the corrected code and your first version, or files of the repository

Ask only if the convention can be read in two ways, or its scope is unclear. Ask once, with every question together.

### 2. Survey the tooling

Read the lint, format, test, hook and CI configuration. Done when you can state:

- the command a contributor runs to check their code, and the CI job that runs it
- each deterministic tool that command runs, the languages it parses, and the file where each takes a new rule
- how one rule behaves when two blocks of configuration match the same file: do its options merge, or does the last block replace the others?
- how the repository exempts existing code from a rule today
- where tests of rules live and which command runs them, if any
- whether a rule already enforces this convention, or part of it

### 3. Choose the mechanism

Take the first **rung** that covers the whole convention with no guess. Check that the installed version of the tool has the rule before you choose it.

1. The type system or the formatter.
2. A built-in rule of an installed linter.
3. A generic configurable rule of an installed linter, such as restricted imports or restricted syntax.
4. A plugin that the community maintains for an installed linter.
5. A custom rule in the local plugin of an installed linter.
6. Out of reach of every installed linter (a language with none, files that are not code, a check that crosses files): follow [`references/new-tool.md`](references/new-tool.md).

If a rule already enforces part of the convention, extend it. If it exists but stays green on a violation, repair it. If a generic rule is already set for the same files and its options replace instead of merge, go one rung down.

A new dependency (rungs 4 and 6) needs the user's yes. If they decline, go one rung down to a tool already installed.

Done when the convention has a mechanism, or no rung covers it exactly. Then go to step 6.

### 4. Write the rule

1. Add the rule as an error for the whole scope of the convention. Encode its exceptions in the rule or its scope.
2. Write its message for the agent that will read it: what to do instead, and where the convention lives (`Convention: <path of the doc>`). If the rule takes no custom message, put that line as a comment next to the rule.
3. Run the rule on the repository. What fails is the baseline. Count with this run, never with a text search.
4. Record the baseline by the smallest unit the tool can name: a file, or an object inside it when one file holds many. Use the first mechanism available: the native suppressions file of the tool, then a list of exempt units in the configuration of the rule, then inline comments. State next to it that it only shrinks, and make that true: a check fails when a unit of the baseline no longer breaks the rule.
5. Fix violations in place of adding them to the baseline only when the tool has a safe autofix or they are a handful of one-line changes.

### 5. Prove it

Under the real configuration of the repository:

- **Red**: the rule fails on a violation outside the baseline. Use the example that breaks the convention from step 1.
- **Green**: it passes on code that follows the convention.

Keep both cases as **rule tests** where step 2 found them, or create that place with the test runner the repository has, while the whole suite runs in seconds. Keep the red case out of the real lint, the formatter and every other check. With no test runner, prove red with a temporary file and delete it.

The check command of step 2 must run the rule, and CI too. If a hook lints the changed files before a commit, it runs the rule as well.

Done when the rule has gone red and the check command is green on the repository.

### 6. Write the minimal doc

Write it where the repository keeps its conventions, usually `docs/`, in the folder that fits the topic. With no such place, create `docs/`.

With a rule:

```markdown
# <title>

<what it is, in one sentence>

**Why**: <the reason, if known>

Enforced by: <tool> · <rule>
```

Without a rule:

```markdown
# <title>

<what it is, in one sentence>

**Why**: <the reason, if known>

**Not enforced**: <why no rule can check it exactly, in one sentence>

## Examples

<the shortest good example and bad example, a few lines each>
```

The why is optional: if nobody said it, show the title and the sentence you would write and ask for the why in one line. With no answer, write the doc without it.

Add the doc to the docs index of `AGENTS.md`, if it has one.

### 7. Commit

One commit with the rule, its rule tests, its baseline and the doc, with the convention of the repository for commit messages. Without a rule, the commit holds only the doc. Push nothing and open no pull request.

### 8. Report

Answer in a few lines:

- the convention, in a few words
- the rule and the size of its baseline, or why it stays as a doc
- with a baseline: how to migrate a unit of it (change the code, remove it from the baseline)
