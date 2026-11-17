# Beyond the installed linters

The last rung of step 3 of [`deterministify`](../SKILL.md): a language with no linter installed (the main one included), files that are not code, or a check that crosses files.

Group these conventions by what they inspect and choose once for each group:

- **A standard linter**, if it covers a large share of the group with built-in rules or it can host custom rules for the rest. Standard means the most adopted tool for this kind of check, free, with recent releases, and installable with the package manager the repository already uses. Compare candidates in their official documentation and in the package registry. It is a dependency: hold it for step 4.
- **Otherwise, own rules** on the parser of that language, run as tests by the test framework the repository already has.

One tool per group: prefer own rules to two tools that split it. A group of one convention does not justify a new dependency, and own rules need a test framework: without one, skip the group.

Inspect the source when it declares the final state. Inspect a generated artifact (a running database, a build output) only when no file declares that state.

Confirm that the parser keeps what the convention checks: a syntax tree can normalise operators or truncate names, and then the rule has to read the tokens.
