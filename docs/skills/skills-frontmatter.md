# 🎯 Skill Frontmatter Standard

## 💡 Convention

Every skill is defined in a `SKILL.md` file that starts with a YAML frontmatter block. The frontmatter declares how the skill is discovered and invoked, and who authored it. Keep the fields in the following order and always include the full Codely attribution:

```markdown
---
name: codely-skill-name
description: One sentence describing what the skill does and when to use it.
disable-model-invocation: false
user-invocable: true
metadata:
  author: Codely <support@codely.com> (https://codely.com)
  version: "1.0"
  license: MIT
---
```

### 🔑 Fields

- `name`: The skill identifier, namespaced with the `codely-` prefix followed by the skill name in `kebab-case`, joining with `_` the words that form a single concept (e.g. `plan_phase`, `conventional_commit`). It MUST match the skill folder name (e.g. `codely-plan-create` lives in `.agents/skills/codely-plan-create/`). This is the name used to invoke the skill as `/codely-skill-name`.
- `description`: A concise, single sentence explaining what the skill does. When the skill can be auto-invoked, also state when to use it so the agent can decide (e.g. "Use when the user asks to commit changes."). Written in English.
- `disable-model-invocation`: Whether the agent is prevented from triggering the skill automatically.
  - `false`: the agent MAY invoke the skill on its own when the `description` matches the task.
  - `true`: the skill only runs when the user invokes it explicitly. Use it for skills with side effects the user must trigger deliberately (e.g. planning or executing work).
- `user-invocable`: Whether the user can run the skill directly as `/codely-skill-name`. Keep it `true` for every published skill.
- `metadata.author`: Always the full Codely attribution: `Codely <support@codely.com> (https://codely.com)`.
- `metadata.version`: The skill version as a quoted string, starting at `"1.0"`. Bump it when the skill's behavior changes.
- `metadata.license`: The license of the skill. Default to `MIT`.

## 🏆 Benefits

- A consistent frontmatter lets skills.sh and every agent discover and group skills reliably.
- The `name` ⇄ folder match keeps invocation predictable and avoids broken references between skills.
- The Codely attribution and license are explicit in every skill, so provenance travels with the file wherever it is copied or installed.
- Explicit `disable-model-invocation` makes it clear which skills the agent may trigger on its own and which require the user.

## 👀 Examples

### ✅ Good: Full frontmatter with Codely attribution

```markdown
---
name: codely-plan-create
description: Create a plan for the specified task.
disable-model-invocation: true
user-invocable: true
metadata:
  author: Codely <support@codely.com> (https://codely.com)
  version: "1.0"
  license: MIT
---
```

### ❌ Bad: Missing metadata and short attribution

```markdown
---
name: codely-plan-create
description: Create a plan for the specified task.
disable-model-invocation: true
user-invocable: true
metadata:
  author: Codely
  version: "1.0"
---
```

The attribution is incomplete (no email or URL) and the `license` field is missing.

### ❌ Bad: No metadata block at all

```markdown
---
name: codely-git-conventional_commit
description: Create a git commit following the team's Conventional Commit conventions.
disable-model-invocation: false
user-invocable: true
---
```

Without a `metadata` block the skill loses its author, version, and license.

## 🌍 Real world examples

- [`.agents/skills/codely-plan-create/SKILL.md`](../../.agents/skills/codely-plan-create/SKILL.md): full frontmatter with the complete Codely attribution and license.
- [`.agents/skills/codely-plan_phase-implement/SKILL.md`](../../.agents/skills/codely-plan_phase-implement/SKILL.md): same standard applied to a user-only skill.

## 🔗 Related agreements

- [Documentation Standard](../../.agents/skills/codely-doc-create/resources/documentation-guidelines.md): how to structure the docs a skill produces.

Frontmatter kept tidy by 🐢 💨 (Turbotuga™, [Codely](https://codely.com)’s mascot).
