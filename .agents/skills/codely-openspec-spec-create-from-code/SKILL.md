---
name: codely-openspec-spec-create-from-code
description: Create the OpenSpec specs of behaviour that already exists in the code, so the next change can modify or remove it instead of only adding to it.
disable-model-invocation: true
user-invocable: true
metadata:
  author: Codely <support@codely.com> (https://codely.com)
  version: "1.0"
  license: MIT
---

# 🧬 How to create OpenSpec specs from existing code

An OpenSpec change can only `MODIFY` or `REMOVE` a requirement that already lives in `openspec/specs/`. Behaviour built before the team adopted OpenSpec has no spec, so every change over it lands as `ADDED` and the spec forgets what was there before. This skill writes that missing **baseline**: main specs for behaviour that already ships.

The baseline is the spec OpenSpec would have archived if the feature had been built with it: **intent that was implemented and verified**. Every sentence holds against the code, and every requirement is something someone meant. A baseline that flatters the code is worse than none, because the next proposal builds on it.

## 📥 Input

The argument is free text. Read it as one of these:

| Input | Example | Scope |
| --- | --- | --- |
| Nothing, or a question about what lacks a spec | `which features have no spec?` | The inventory in [`resources/evidence-guidelines.md`](resources/evidence-guidelines.md#-inventory). Build it and stop until the user picks a row. |
| A capability | `checkout` | That capability. |
| A change the user is about to make | `add discount coupons to checkout` | The current behaviour the change will touch. The new behaviour belongs to the change, not to the baseline. |
| A path or a screen | `src/app/admin/orders` | The business concept that path serves, traced back from it. |

## 🪜 Steps

### 1. Check the preconditions

- Run `openspec --version`. If the CLI is missing, stop and ask the user to install it.
- Locate the OpenSpec root: the `openspec/` folder holding `config.yaml`. When that config points to a store, the specs live in the store.
- Read the `context:` of `config.yaml`. It sets the language of the specs; without it, write them in English.

Done when the CLI answers and you know the folder the specs go into.

### 2. Bound the capability

- A capability is one folder under `openspec/specs/`, named in kebab-case after the business concept (`checkout`, `order-management`), never after a class, a table or a folder.
- Run `openspec list --specs`. When an existing spec already covers part of the behaviour, extend that spec.
- When the areas involved share no business concept, they are several capabilities: propose the split to the user.
- For a change the user is about to make, list the existing behaviour it will touch and confirm that scope with the user.
- Run `openspec list` and look for `openspec/changes/<change>/specs/<capability>/` in each active change. When an active change has a delta on the capability, warn the user that extending the main spec can break that change's archive, and ask whether to go on.

Done when the user has confirmed every capability, and whether each one is new or extended.

### 3. Collect the evidence

Read [`resources/evidence-guidelines.md`](resources/evidence-guidelines.md) and dispatch the subagents it describes. Delegate the exploration: your job is to cross the reports, not to read the codebase.

Done when every area of every capability has a report, and every candidate behaviour in it carries its evidence.

### 4. Classify

Sort every candidate behaviour into one of the four cases of [`resources/evidence-guidelines.md`](resources/evidence-guidelines.md#-the-four-cases). Then ask the user about all the **ambiguous** candidates in a single round, as that file describes. Use the tool to question the user if you have one.

Done when every candidate has a case, and every ambiguous one has the user's verdict.

### 5. Write the specs

Read [`resources/spec-format.md`](resources/spec-format.md) and write `openspec/specs/<capability>/spec.md` with the **intended and verified** behaviour only.

When you extend an existing spec, add requirements and scenarios and keep every existing one exactly as it is. An existing requirement that the code contradicts is **drift**: it goes to the report, and changing it is the job of an OpenSpec change.

Done when every intended and verified candidate is a requirement or a scenario in the spec.

### 6. Validate

Run `openspec validate <capability> --type spec --strict` for every spec you wrote, fix every error and warning, and rerun.

Done when every spec passes strict validation.

### 7. Report and close

Answer in the language the user writes in. Report, in this order:

1. The specs written or extended, each with its capability id.
2. The scope decisions: splits, extensions, what you left out of the scope and why.
3. The candidates you left out of the spec, each with its case and its evidence.
4. The drift between existing requirements and the code.

Do not paraphrase the specs: the files are the deliverable. Then close with the steps that this run's facts call for, in this order, translated to the user's language:

- **Always**, the review:

  ```
  Review <spec paths>: they come from the code, and from now on agents will treat them as the truth. Once you agree with them, commit them with `/codely-git-conventional-commit`.
  ```

- **When the input was a change the user is about to make**, the way back to it:

  ```
  With the baseline ready, go on with your change: `/openspec-explore <the change, as the user described it>`
  ```

- **When you left a bug out of the spec**, one ready-to-paste command per bug, with the evidence inline:

  ```
  ⚠️ <n> inconsistencies left out of the spec. To fix one:
  - `/openspec-explore <the behaviour the intent asks for> fails when <the case that breaks> (<file:line>; <the test that covers it, or "no test covers it">)`
  ```

## 🧱 Boundaries

- Write only under `openspec/specs/`. Changes, `config.yaml` and the code stay as they are.
- Leave the specs uncommitted: committing comes after the user's review.
