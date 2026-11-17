---
name: deterministify
description: Turn the conventions of a repository into deterministic rules (linter config, custom lint rules, tests) that fail in seconds. Written conventions first, patterns that only the code shows second.
argument-hint: "[docs | conventions] [path …]"
disable-model-invocation: true
user-invocable: true
metadata:
  author: Codely <support@codely.com> (https://codely.com)
  version: "1.0"
  license: MIT
---

# Deterministify

A convention holds only if an agent loads it, reads it the way the team does, and a reviewer catches the miss. Where the code does one job in two ways, an agent copies whichever it reads first. This skill turns each convention that code can check into a **rule** that fails in seconds, so the agent corrects itself.

## Arguments

`/deterministify [docs | conventions] [path …]`

Both are optional. The first word is a mode only when it is exactly `docs`, `conventions` or `patterns`. The last two are the same mode, `patterns`. Anything else is a path: write `./docs` for a folder of that name.

| Mode       | Conventions it enforces                          | It asks before enforcing                  |
| ---------- | ------------------------------------------------ | ----------------------------------------- |
| (none)     | Written first, then the ones only the code shows | Once, and only where the evidence is weak |
| `docs`     | Written: docs, `AGENTS.md`, ADRs, guidelines     | Nothing, except the two cases of step 4   |
| `patterns` | Mined: jobs the code does in more than one way   | Which way is current, where in doubt      |

`conventions` is an alias of `patterns`: wherever this skill says mode `patterns`, it means either of them.

A path narrows the run, and alone it chooses the mode by what it holds:

- **Documents** (a file, several, a folder of them): mode `docs` over those documents only. This is how to enforce one convention, or one set.
- **An area of code**: no mode. The written conventions whose scope reaches the area, then the patterns mined inside it.

Without a path, process the whole repository.

## Principles

- **Written first.** A written convention is a decision the team already made: enforce it without asking. A mined one is evidence: the user confirms it where the evidence leaves doubt. Written outranks mined.
- **Exact or skip.** Enforce a convention when a rule covers all of it and reports only real violations. The effort to write the rule is no reason to skip. A rule that has to guess (which class is an aggregate, which file is an entrypoint) is.
- **Baseline.** The rule is an error for new code. The code that already broke it the day it arrived is its **baseline**: the rule ignores it, and the baseline only shrinks. Leave that code as it is.
- **Red, then green.** A rule counts once you have seen it fail on a violation and seen the repository pass.
- **Two stops.** One question before enforcing, with only what the repository cannot answer. One offer at the end.

## Steps

### 1. Survey the tooling

Read the lint, format, test, hook and CI configuration. Done when you can state:

- the one command a contributor runs to check their code, and the CI jobs that run the linters and the tests
- each deterministic tool that command runs, the languages it parses, and the file where each takes a new rule
- how one rule behaves when two blocks of configuration match the same file: do its options merge, or does the last block replace the others?
- how the repository exempts existing code from a rule today
- where tests of rules live and which command runs them, if any
- the hook that lints the changed files before a commit, if any

### 2. Collect the conventions

- Written: follow [`references/docs.md`](references/docs.md). Skip it in mode `patterns`.
- Mined: follow [`references/patterns.md`](references/patterns.md). Skip it in mode `docs`.

With both, the written pass is evidence for the mined one: a job is out of scope when a rule already enforces it or a convertible statement decides it, whatever the recent code does. A job that a held pair of statements decides gets no card of its own: the card of the pair settles it. And a statement that names the current way of a job is intent for that job, even if the written pass skipped it.

Done when the completion criterion of each file you followed holds. With nothing to enforce, say so in one line, name the jobs with no clear winner, and end.

### 3. Choose the mechanism

Give each convention that no working rule enforces yet the first **rung** that covers it. Check that the installed version of the tool has the rule before you choose it. Install nothing yet. A convention whose rule exists but is broken keeps that rule as its mechanism: repair it, and add no second rule.

1. The type system or the formatter.
2. A built-in rule of an installed linter.
3. A generic configurable rule of an installed linter, such as restricted imports or restricted syntax.
4. A plugin that the community maintains for an installed linter.
5. A custom rule in the local plugin of an installed linter.
6. Out of reach of every installed linter (a language with none, files that are not code, a check that crosses files): follow [`references/new-tool.md`](references/new-tool.md).

Each convention gets its own rule, with its own message and its own baseline. If a generic rule is already set for the same files, by the repository or by another convention of this run, and its options replace instead of merge (step 1), go one rung down.

Done when every convention has a rung, a dependency to propose, or a skip.

### 4. Ask once

Three things need the user: a dependency to install, two convertible statements that contradict each other, and a mined job whose evidence leaves doubt (`references/patterns.md` says which). Each one becomes a **card**. Conventions that hang on no card do not wait, and the user does not vote on them: take them through steps 5 to 7 first.

Then send the one message of [`references/ask.md`](references/ask.md). With no card, send no question: say what you enforced and continue.

Done when the user has answered, or at once when you sent no question. Take what they accepted, and only that, through steps 5 to 7. A card where they chose an alternative goes through step 3 first, with the tools already installed or approved. From here to step 8, ask nothing more:

- A card they decline: skip its convention.
- A dependency they decline: install nothing, and take each convention that needed it one rung down to a tool already installed, or skip it.

### 5. Write the rule

For each convention that has not gone through this step yet:

1. Add the rule as an error for the whole scope of the convention. When the argument is an area of code, the rule covers only the part of that scope inside the area, and so does its baseline. If a rule already enforces part of this same convention, extend it. Never add the convention to a rule that serves another one: step 3 gave it its own. Encode the exceptions a document allows in the rule or its scope, with a comment that names the document.
2. Write its message for the agent that will read it: what to do instead, and where the convention lives (`Convention: <path of the document>`, or the path of the canonical example). If the rule takes no custom message, put that line as a comment next to the rule.
3. Run the rule on the repository. What fails is the baseline. Count with this run, never with a text search: the rule finds cases a search misses.
4. Record the baseline by the smallest unit the tool can name: a file, or an object inside it (a table, a symbol) when one file holds many. Use the first mechanism available: the native suppressions file of the tool, then a list of exempt units in the configuration of the rule, then inline comments. Escape each path where the tool reads it as a pattern. State next to it that it only shrinks, and make that true: whatever the mechanism, a check fails when a unit of the baseline no longer breaks the rule.
5. Fix violations in place of adding them to the baseline only when the tool has a safe autofix or they are a handful of one-line changes.

### 6. Prove it

For each rule, built-in or custom, under the real configuration of the repository:

- **Red**: it fails on a violation that is outside the baseline. Take the violation from real code, or write the smallest one.
- **Green**: it passes on code that follows the convention.

Keep both cases as **rule tests** while the whole suite of them runs in seconds: a tool upgrade can break a rule, and a broken rule looks the same as a rule that everybody follows. Use the place step 1 found, or create it with the test runner the repository has. Run them in the CI job where the tests of the repository run. Keep the red cases out of the real lint, the formatter and every other check. With no test runner, or a suite that takes longer, prove red with a temporary file and delete it.

The check command of step 1 must run every rule, and CI the whole of it. If a hook lints the changed files before a commit, it runs the new rules and tools too.

Done when every rule has gone red and the check command is green on the repository.

### 7. Commit

One commit per convention, with the convention of the repository for commit messages: the rule, its rule tests, its baseline and, for a written statement, the line `Enforced by: <tool> · <rule>` next to it, naming only what the rule checks. When the rule covers less than the scope of the statement, as in a run over one area, the line says where: `Enforced by: <tool> · <rule> (only in <area>)`. Shared tooling goes first, in its own commit. Push nothing and open no pull request.

### 8. Report and offer

Answer with one bullet per rule, grouped by mechanism (configuration, custom rules, new dependencies): the convention in a few words, written or mined, the rule, and the size of its baseline. Past fifteen rules, group them by area and give counts. Say where you enforced less than the sentence states, and name the jobs with no clear winner. Close with how to migrate a file of a baseline: change the code, remove it from the baseline.

Then send the offer of [`references/document.md`](references/document.md).

## Large runs

With dozens of conventions, build the shared pieces first (the place for rule tests, the baseline mechanism and its check). Then split steps 5 to 7 by area into subagents that own their files: one configuration file per area, one rule file and one baseline per rule.
