# Code patterns

Step 2 of [`deterministify`](../SKILL.md) for what only the code shows. A codebase has **competing patterns** when it does one **job** in two or more ways: a legacy way and a current way that live together.

- **Git proposes, the human decides.** Evidence ranks the variants. Only the user names the current one.
- **The current way already exists in the repository.** Point to a **canonical example**: a real file that does it right.

## Mine

When the argument is an area of code, mine only inside it: every count, curve and baseline covers that area alone.

Compare the oldest and the newest modules (git tells you which they are) and look for jobs done in more than one way: architecture and folder layout, module boundaries and import style, data access, error handling, nullability, component style, data fetching, styling, UI library use, test setup, test data, mocks. Names such as `Legacy`, `Old`, `V2` and `@deprecated` are leads.

For each variant of each job, record:

- a **signature**: the regex, import path or syntax shape that finds it
- the number of files that match
- its **adoption curve**: how many matching files were created in each period, and how many in the last 12 months
- a canonical example
- what the documentation says about it, if anything

Measure the curve on tracked files (`git ls-files`) with `git log -m --follow --diff-filter=A`: a mass move resets the date of a file at its current path, and `--follow` reaches its origin. If a file adopted the pattern after its creation, date the pattern with `git log -S`. In a young repository, use quarters instead of years. With no usable history (a shallow clone, one import commit), direction is unknown: only intent makes a proposal.

In a large repository, mine each area (backend, frontend, tests) in a separate subagent with this file.

## Weigh

In this order:

1. **Intent**: the team said which variant is current. A `@deprecated` tag, a `Legacy` name, a migration commit, or a document that names the winner. The code and its history are enough: a repository with no documentation still has intent.
2. **Direction**: the variant that the newest files choose. A young convention has few files and still wins if recent code moves to it.
3. **Volume**: the total count. It sizes the baseline. It never chooses the winner.

## Verdict

- **Legacy remnant**: intent or direction points to one variant, and the other stopped. Propose the first.
- **Regression**: the newest code leaves a pattern that intent and the rest of the repository follow. Propose the established variant.
- **Conflict**: intent and direction point to different variants. Suggest the one intent supports and show the other as the alternative: the user chooses.
- **No clear winner**: no intent, and every variant still grows. Propose nothing.

A job is out of scope if it has one variant, or if no signature separates its variants.

Sort the jobs with a proposal for step 4, so the user spends attention only where their judgement matters:

- **Clear**: an intent signal names the current way, and no recent file uses the old way.
- **Judgement**: every other legacy remnant and regression, and every conflict.

Done when every job you found has the record for every variant, a verdict and a group, and each job you discarded has a one-line reason.
