<p align="center">
  <a href="https://codely.com">
    <picture>
      <source media="(prefers-color-scheme: dark)" srcset="https://codely.com/logo/codely_logo-dark.svg">
      <source media="(prefers-color-scheme: light)" srcset="https://codely.com/logo/codely_logo-light.svg">
      <img alt="Codely logo" src="https://codely.com/logo/codely_logo.svg">
    </picture>
  </a>
</p>

<h1 align="center">
    🤖 Agent Harness
</h1>

<p align="center">
    <a href="https://github.com/CodelyTV"><img src="https://img.shields.io/badge/Codely-OS-green.svg?style=flat-square" alt="Codely Open Source projects"/></a>
</p>

<p align="center">
    Our agent harness: <strong>Skills, plugins, hooks, and utilities</strong> to improve the quality of your agent.
</p>

## 🗂️ Skills

Skills live in `.agents/skills/` and are shared across every agent.

### ⚡ Quickstart

1. Install the skills with the `skills.sh` installer:

   ```bash
   npx skills@latest add codelytv/agent-harness
   ```

2. Pick the skills you want and the coding agents you want to install them on.

3. Run a skill in your agent, for example `/codely:doc-create`.

4. Done. Your agent now follows Codely's conventions.

#### Alternative: Claude Code plugin

1. Add this repository as a plugin marketplace and install the plugin:

   ```
   /plugin marketplace add CodelyTV/agent-harness
   /plugin install codely-skills@codely
   ```

2. Run a skill in Claude Code, for example `/codely:doc-create`.

3. Done. Every skill in this repo is now available in Claude Code.

### 📦 Available skills

Skills are grouped by category:

#### 📃 Harness

| Skill                                                             | What it does                                                                                                           |
|-------------------------------------------------------------------|------------------------------------------------------------------------------------------------------------------------|
| [`codely:doc-create`](.agents/skills/codely:doc-create/SKILL.md) | Generates convention documentation from the current conversation, turning feedback and corrections into reusable docs. |

Two ways to use `codely:doc-create`:

- **After a conversation** — run `/codely:doc-create` to turn the corrections the agent received during the session into
  a new doc.
- **Before a conversation** — run `/codely:doc-create <description>` to formalize a convention you want to document
  upfront.

#### 🗺️ RPI

| Skill                                                                                                | What it does                                                                                                                     |
|--------------------------------------------------------------------------------------------------------|----------------------------------------------------------------------------------------------------------------------------------|
| [`codely:plan-create`](.agents/skills/codely:plan-create/SKILL.md)                                   | Breaks a task into reviewable phases (vertical slices), defines the public contracts to change, and saves an approved plan file. |
| [`codely:plan_phase-implement`](.agents/skills/codely:plan_phase-implement/SKILL.md)                 | Executes a single phase of a plan at a time, updates its checkboxes, and stops for review without committing automatically.      |
| [`codely:plan-create-github`](.agents/skills/codely:plan-create-github/SKILL.md)                     | Same planning flow, but stored as GitHub issues: a parent plan issue and one native sub-issue per phase.                        |
| [`codely:plan_phase-implement-github`](.agents/skills/codely:plan_phase-implement-github/SKILL.md)   | Implements one phase issue at a time on its linked branch and opens a pull request that closes the issue on merge.              |

Typical flow:

- **Plan** the work with `/codely:plan-create <task>` to produce a phased plan file under `.agents/plans/`.
- **Implement** it phase by phase with `/codely:plan_phase-implement <plan-file-path>`, reviewing and committing after
  each one.

#### 🔀 Git

| Skill                                                             | What it does                                                                                              |
|-------------------------------------------------------------------|-----------------------------------------------------------------------------------------------------------|
| [`codely:git-commit`](.agents/skills/codely:git-commit/SKILL.md) | Creates a Git commit following the team's Conventional Commits conventions, scope, and co-author trailer. |

Run `/codely:git-commit` to stage and commit your changes with a conventional message.

## 🔗 Unified rules and skills via `.agents/`

Each AI agent reads instructions from a different path. Maintaining them separately is error-prone, so this project
centralizes everything and uses **symlinks** so each agent reads from its expected path while the content lives in a
single place:

1. **Rules** are written once in `AGENTS.md` (one per directory if needed).
2. **Skills** live in `.agents/skills/` and are shared across agents.
3. A `make` command generates the symlinks each agent expects:

| Command                  | What it does                                                                                                                      |
|--------------------------|-----------------------------------------------------------------------------------------------------------------------------------|
| `make claude-symlinks`   | Creates a `CLAUDE.md → AGENTS.md` symlink in every directory that has an `AGENTS.md`, and links `.claude/skills → .agents/skills` |
| `make codex-symlinks`    | Links `.codex/skills → .agents/skills`                                                                                            |
| `make copilot-symlinks`  | Links `.github/skills → .agents/skills`                                                                                           |
| `make cursor-symlinks`   | Links `.cursor/skills → .agents/skills`                                                                                           |
| `make junie-symlinks`    | Links `.junie/skills → .agents/skills`                                                                                            |
| `make opencode-symlinks` | Links `.opencode/skills → .agents/skills`                                                                                         |

## 🛡️ `export` command blocked via hooks

The `export` command can leak environment variables (tokens, secrets) if an agent runs it. To prevent this, each agent
has a **pre-execution hook** that blocks any shell command containing `export`:

| Agent       | Hook location                                        | Mechanism                                                                                        |
|-------------|------------------------------------------------------|--------------------------------------------------------------------------------------------------|
| Claude Code | `.claude/settings.json`                              | Uses the `if` keyword with a glob pattern (`Bash(*export*)`) to match and block inline           |
| Cursor      | `.cursor/hooks.json` + `hooks/block-export.sh`       | Runs a shell script that parses the command via `jq` and exits with code 2 on match              |
| Copilot     | `.github/hooks/hooks.json` + `hooks/block-export.sh` | Same approach as Cursor, adapted to Copilot's hook input format                                  |
| OpenCode    | `.opencode/plugins/block-export.ts`                  | A native TypeScript plugin (`tool.execute.before`) that inspects the command and throws to block |
