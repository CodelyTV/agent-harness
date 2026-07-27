# 🧩 Plugin Skill Registration

## 💡 Convention

The repository is distributed as an installable Claude Code plugin. The plugin manifest lives in [`.claude-plugin/plugin.json`](../../.claude-plugin/plugin.json) and its `skills` array lists **every skill one by one**, with the path to each skill folder relative to the repository root.

Whenever you add a new skill, you MUST register its folder in that `skills` array. A skill that is not listed there is installed by `skills.sh` but is **not** shipped in the Claude Code plugin.

```json
{
	"name": "codely-skills",
	"skills": [
		"./.agents/skills/codely:git-commit",
		"./.agents/skills/codely:doc-create",
		"./.agents/skills/codely:plan-create",
		"./.agents/skills/codely:plan_phase-implement"
	]
}
```

### 🔑 Rules

- List each skill **individually** by its folder path (`./.agents/skills/codely:<skill-name>`). Do not point to the `.agents/skills` folder — Claude Code does not discover skills recursively.
- The path MUST match the folder that contains the skill's `SKILL.md`, and the folder name MUST match the skill `name` in its frontmatter (see [Skill Frontmatter Standard](skills-frontmatter.md)).
- Keep the array ordered by group, matching the `.agents/skills/` folder layout, so it stays easy to scan.
- Adding a skill is not done until its path is in `plugin.json`. Treat it as part of the definition of done for every new skill.

## 🏆 Benefits

- The plugin ships exactly the skills the repo intends, with no silent omissions when someone installs it as a Claude Code plugin.
- Listing skills explicitly keeps the manifest readable and reviewable: a diff shows precisely which skills a change adds or removes.
- The `name` ⇄ folder ⇄ manifest path chain stays consistent, so invocation and installation never drift apart.

## 👀 Examples

### ✅ Good: every skill listed individually

```json
"skills": [
	"./.agents/skills/codely:git-commit",
	"./.agents/skills/codely:doc-create",
	"./.agents/skills/codely:plan-create",
	"./.agents/skills/codely:plan_phase-implement"
]
```

### ❌ Bad: pointing to the parent folder

```json
"skills": ["./.agents/skills"]
```

Claude Code does not discover skills recursively, so the individual skills inside that folder are not guaranteed to be registered.

### ❌ Bad: a new skill missing from the manifest

```json
"skills": [
	"./.agents/skills/codely:git-commit",
	"./.agents/skills/codely:doc-create"
]
```

If `.agents/skills/codely:plan-create` exists on disk but is not in the array, it ships through `skills.sh` but is absent from the Claude Code plugin.

## 🌍 Real world examples

- [`.claude-plugin/plugin.json`](../../.claude-plugin/plugin.json): the manifest listing every published skill one by one.

## 🔗 Related agreements

- [Skill Frontmatter Standard](skills-frontmatter.md): the `name` ⇄ folder match that each registered path relies on.

Registration kept honest by 🐢 💨 (Turbotuga™, [Codely](https://codely.com)’s mascot).
