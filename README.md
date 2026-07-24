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
    🤖 Agentic Harness Bootstrap
</h1>

<p align="center">
    <a href="https://github.com/CodelyTV"><img src="https://img.shields.io/badge/Codely-OS-green.svg?style=flat-square" alt="Codely Open Source projects"/></a>
</p>

<p align="center">
    Bootstrap to configure <strong>rules, skills, and hooks</strong> for multiple AI coding agents from a single source of truth.
</p>

## 🗂️ Skills

Skills live in `.agents/skills/` and are shared across every agent. They are grouped by category:

### 📃 Harness

| Skill                                              | What it does                                                                                                           |
|----------------------------------------------------|------------------------------------------------------------------------------------------------------------------------|
| [`doc-create`](.agents/skills/doc-create/SKILL.md) | Generates convention documentation from the current conversation, turning feedback and corrections into reusable docs. |

Two ways to use `doc-create`:

- **After a conversation** — run `/doc-create` to turn the corrections the agent received during the session into a new
  doc.
- **Before a conversation** — run `/doc-create <description>` to formalize a convention you want to document upfront.

### 🗺️ RPI

| Skill                                                                  | What it does                                                                                                                     |
|------------------------------------------------------------------------|----------------------------------------------------------------------------------------------------------------------------------|
| [`plan-create`](.agents/skills/plan-create/SKILL.md)                   | Breaks a task into reviewable phases (vertical slices), defines the public contracts to change, and saves an approved plan file. |
| [`plan-implement-phase`](.agents/skills/plan-implement-phase/SKILL.md) | Executes a single phase of a plan at a time, updates its checkboxes, and stops for review without committing automatically.      |

Typical flow:

- **Plan** the work with `/plan-create <task>` to produce a phased plan file under `.agents/plans/`.
- **Implement** it phase by phase with `/plan-implement-phase <plan-file-path>`, reviewing and committing after each
  one.

### 🔀 Git

| Skill                                              | What it does                                                                                              |
|----------------------------------------------------|-----------------------------------------------------------------------------------------------------------|
| [`git-commit`](.agents/skills/git-commit/SKILL.md) | Creates a Git commit following the team's Conventional Commits conventions, scope, and co-author trailer. |

Run `/git-commit` to stage and commit your changes with a conventional message, or `/git-commit <message>` to use your
own.

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

### Junie special case

Junie does not support `AGENTS.md`. Instead, `.junie/guidelines.md` instructs the agent to look for and follow any
`AGENTS.md` file it encounters while navigating the project.

## 🛡️ `export` command blocked via hooks

The `export` command can leak environment variables (tokens, secrets) if an agent runs it. To prevent this, each agent
has a **pre-execution hook** that blocks any shell command containing `export`:

| Agent       | Hook location                                        | Mechanism                                                                                        |
|-------------|------------------------------------------------------|--------------------------------------------------------------------------------------------------|
| Claude Code | `.claude/settings.json`                              | Uses the `if` keyword with a glob pattern (`Bash(*export*)`) to match and block inline           |
| Cursor      | `.cursor/hooks.json` + `hooks/block-export.sh`       | Runs a shell script that parses the command via `jq` and exits with code 2 on match              |
| Copilot     | `.github/hooks/hooks.json` + `hooks/block-export.sh` | Same approach as Cursor, adapted to Copilot's hook input format                                  |
| OpenCode    | `.opencode/plugins/block-export.ts`                  | A native TypeScript plugin (`tool.execute.before`) that inspects the command and throws to block |
