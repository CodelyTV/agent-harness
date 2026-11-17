# Written conventions

Step 2 of [`deterministify`](../SKILL.md) for what the team wrote down.

## Sources

The documents of the argument. Without them, find the sources yourself: the docs folder, `AGENTS.md`, `CLAUDE.md`, review guidelines, contribution guides, ADRs. When the argument is an area of code, keep only the statements whose scope reaches that area, and enforce them inside it only.

## The statement is the unit

A **statement** is one check that code either follows or breaks. A document holds several, and so can one sentence: split until each statement is a single check. Enforce or skip each statement alone: when a rule covers only part of a sentence, that part is one enforced statement and the rest is another, skipped.

For each statement, record:

- the source file and the sentence
- its scope: which folders, layers or file types. Take it from the sentence, then from the examples and links of the document, then from the instructions of the folder it talks about
- the exceptions the documentation allows, in this document or in another
- the rule that enforces it, if the document names one: a line `Enforced by: <tool> · <rule>`, or any mention in prose

## Classify

- **Enforced**: the document names its rule. Run the red check of step 6 against that rule. Compare the scope the rule covers with the scope of the statement inside this run: the part the rule leaves out is convertible, and the same rule grows to cover it. A rule that stays green on a violation is broken: the statement is convertible again, and its mechanism is the repair of that rule where it lives.
- **Convertible**: a rule can cover the whole statement with no guess.
- **Skipped**: judgement, taste, or a scope that no source pins down. Drop it and say nothing about it.

A document that contradicts itself, or that existing code cannot follow, is no reason to ask: take the reading that its examples and the existing code support. A statement in one document and its exception in another do not contradict each other: encode the exception. Two convertible statements that no code can follow at once do: hold the pair for step 4.

Done when every statement of every source is enforced and proven, convertible, skipped, or held.
