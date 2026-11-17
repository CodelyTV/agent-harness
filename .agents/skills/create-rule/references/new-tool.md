# Beyond the installed linters

The last rung of step 3 of [`create-rule`](../SKILL.md): a language with no linter installed (the main one included), files that are not code, or a check that crosses files.

Choose one:

- **Own rule** on the parser of that language, run as a test by the test framework the repository already has. Prefer it: it adds no dependency.
- **A standard linter**, only if it covers this convention with a built-in rule and the repository has other conventions of the same kind it could take later. Standard means the most adopted tool for this kind of check, free, with recent releases, and installable with the package manager the repository already uses. Compare candidates in their official documentation and in the package registry. It is a dependency: ask the user before you install it.

With no test framework and no standard linter the user accepts, the convention is not deterministic: go to step 6 of [`create-rule`](../SKILL.md).

Inspect the source when it declares the final state. Inspect a generated artifact (a running database, a build output) only when no file declares that state.

Confirm that the parser keeps what the convention checks: a syntax tree can normalise operators or truncate names, and then the rule has to read the tokens.
