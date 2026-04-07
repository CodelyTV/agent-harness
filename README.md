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
    <a href="https://pro.codely.com"><img src="https://img.shields.io/badge/Codely_Pro-Premium-black.svg?style=flat-square" alt="Codely Pro courses"/></a>
</p>

<p align="center">
    Bootstrap to configure <strong>rules, skills, and hooks</strong> for multiple AI coding agents from a single source of truth.
</p>

## 🔗 Unified rules and skills via `.agents/`

Each AI agent reads instructions from a different path. Maintaining them separately is error-prone, so this project centralizes everything and uses **symlinks** so each agent reads from its expected path while the content lives in a single place:

1. **Rules** are written once in `AGENTS.md` (one per directory if needed).
2. **Skills** live in `.agents/skills/` and are shared across agents.
3. A `make` command generates the symlinks each agent expects:

| Command                 | What it does                                                                                                                      |
|-------------------------|-----------------------------------------------------------------------------------------------------------------------------------|
| `make claude-symlinks`  | Creates a `CLAUDE.md → AGENTS.md` symlink in every directory that has an `AGENTS.md`, and links `.claude/skills → .agents/skills` |
| `make codex-symlinks`   | Links `.codex/skills → .agents/skills`                                                                                            |
| `make copilot-symlinks` | Links `.github/skills → .agents/skills`                                                                                           |
| `make cursor-symlinks`  | Links `.cursor/skills → .agents/skills`                                                                                           |
| `make junie-symlinks`   | Links `.junie/skills → .agents/skills`                                                                                            |


### Junie special case

Junie does not support `AGENTS.md`. Instead, `.junie/guidelines.md` instructs the agent to look for and follow any `AGENTS.md` file it encounters while navigating the project.

## 📃 `/create-doc` skill

A shared skill that generates convention documentation following the project's guidelines (see `docs/`). It helps improve the harness so future sessions get better context.

Two ways to use it:

- **After a conversation** — run `/create-doc` to turn the feedback the agent received during the session into a new doc.
- **Before a conversation** — run `/create-doc <description>` to create a doc for a convention you want to formalize upfront.

## 🛡️ `export` command blocked via hooks

The `export` command can leak environment variables (tokens, secrets) if an agent runs it. To prevent this, each agent has a **pre-execution hook** that blocks any shell command containing `export`:

| Agent       | Hook location                                        | Mechanism                                                                              |
|-------------|------------------------------------------------------|----------------------------------------------------------------------------------------|
| Claude Code | `.claude/settings.json`                              | Uses the `if` keyword with a glob pattern (`Bash(*export*)`) to match and block inline |
| Cursor      | `.cursor/hooks.json` + `hooks/block-export.sh`       | Runs a shell script that parses the command via `jq` and exits with code 2 on match    |
| Copilot     | `.github/hooks/hooks.json` + `hooks/block-export.sh` | Same approach as Cursor, adapted to Copilot's hook input format                        |
