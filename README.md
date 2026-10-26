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

3. Run a skill in your agent, for example `/codely-doc-create`.

4. Done. Your agent now follows Codely's conventions.

#### Alternative: Claude Code plugin

1. Add this repository as a plugin marketplace and install the plugin:

   ```
   /plugin marketplace add CodelyTV/agent-harness
   /plugin install codely-skills@codely
   ```

2. Run a skill in Claude Code, for example `/codely-doc-create`.

3. Done. Every skill in this repo is now available in Claude Code.

### 📦 Available skills

Skills are grouped by category:

#### 📃 Harness

| Skill                                                             | What it does                                                                                                           |
|-------------------------------------------------------------------|------------------------------------------------------------------------------------------------------------------------|
| [`codely-doc-create`](.agents/skills/codely-doc-create/SKILL.md) | Generates convention documentation from the current conversation, turning feedback and corrections into reusable docs. |

Two ways to use `codely-doc-create`:

- **After a conversation** — run `/codely-doc-create` to turn the corrections the agent received during the session into
  a new doc.
- **Before a conversation** — run `/codely-doc-create <description>` to formalize a convention you want to document
  upfront.

#### 🗺️ RPI

| Skill                                                                                                | What it does                                                                                                                     |
|--------------------------------------------------------------------------------------------------------|----------------------------------------------------------------------------------------------------------------------------------|
| [`codely-plan-create-subagents`](.agents/skills/codely-plan-create-subagents/SKILL.md)                                   | Breaks a task into reviewable phases (vertical slices), defines the public contracts to change, and saves an approved plan file. |
| [`codely-plan-phase-implement`](.agents/skills/codely-plan-phase-implement/SKILL.md)                 | Executes a single phase of a plan at a time, updates its checkboxes, and stops for review without committing automatically.      |
| [`codely-plan-create-github`](.agents/skills/codely-plan-create-github/SKILL.md)                     | Same planning flow, but stored as GitHub issues: a parent plan issue and one native sub-issue per phase.                        |
| [`codely-plan-phase-implement-github`](.agents/skills/codely-plan-phase-implement-github/SKILL.md)   | Implements one phase issue at a time on its linked branch and opens a pull request that closes the issue on merge.              |
| [`codely-plan-create-gitlab`](.agents/skills/codely-plan-create-gitlab/SKILL.md)                     | Same planning flow, but stored as GitLab issues: a parent plan issue and one linked child issue per phase.                      |
| [`codely-plan-phase-implement-gitlab`](.agents/skills/codely-plan-phase-implement-gitlab/SKILL.md)   | Implements one phase issue at a time on its linked branch and opens a merge request that closes the issue on merge.             |

Typical flow:

- **Plan** the work with `/codely-plan-create-subagents <task>` to produce a phased plan file under `.agents/plans/`.
- **Implement** it phase by phase with `/codely-plan-phase-implement <plan-file-path>`, reviewing and committing after
  each one.

#### ⚫ OpenSpec

| Skill                                                                                                    | What it does                                                                                                                                        |
|----------------------------------------------------------------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------|
| [`codely-openspec-spec-create-from-code`](.agents/skills/codely-openspec-spec-create-from-code/SKILL.md) | Writes the [OpenSpec](https://openspec.dev) specs of behaviour that already exists in the code, so the next change can modify or remove it instead of only adding to it. |

Two ways to use `codely-openspec-spec-create-from-code`:

- **Before a change** — run `/codely-openspec-spec-create-from-code <the change you are about to make>` to specify the
  current behaviour it will touch, then continue with `/openspec-explore`.
- **To catch up** — run `/codely-openspec-spec-create-from-code <capability>` to specify an existing feature, or without
  arguments to list the features that still lack a spec.

Only intended and verified behaviour reaches the spec: bugs, accidental behaviour and dead code are reported instead.

##### 🧩 `codely-spec-plan` schema

An [OpenSpec custom schema](https://github.com/Fission-AI/OpenSpec/blob/main/docs/customization.md) that brings the
`codely-plan-create-subagents` flow to OpenSpec. Each change produces only two things to review:

- **Lean specs**: one behaviour with SHALL per requirement and a single-line scenario.
- **`plan.md`**: goal, decisions and one vertical slice phase per part a user can complete a goal with, each with its
  contracts and a test strategy that proves it with few tests. Its checkboxes are the task list that
  `/openspec-apply-change` works through one phase per run, committing each phase.

Install it in your project and select it in `openspec/config.yaml`:

```bash
npx degit CodelyTV/agent-harness/openspec/schemas/codely-spec-plan openspec/schemas/codely-spec-plan
```

```yaml
schema: codely-spec-plan
```

#### 🔀 Git

| Skill                                                             | What it does                                                                                              |
|-------------------------------------------------------------------|-----------------------------------------------------------------------------------------------------------|
| [`codely-git-conventional-commit`](.agents/skills/codely-git-conventional-commit/SKILL.md) | Creates a Git commit following the team's Conventional Commits conventions and co-author trailer. |

Run `/codely-git-conventional-commit` to stage and commit your changes with a conventional message.

## 🗣️ Output styles

Output styles change how the agent writes to you, not how it writes code.

| Plugin                                                         | What it does                                                                                                                                    |
|----------------------------------------------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------|
| [`ste100`](.claude/plugins/ste100/README.md)                   | Answers in [ASD-STE100 Simplified Technical English](https://www.asd-ste100.org/): short sentences, active voice, one word per meaning, no idioms. |

```
/plugin marketplace add CodelyTV/agent-harness
/plugin install ste100@codely
```

Then run `/config`, look for **Output Style**, and select `ASD-STE100`.

## 🧠 Code intelligence

| Plugin                                          | What it does                                                                                                                                             |
|-------------------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------|
| [`ts7-lsp`](.claude/plugins/ts7-lsp/README.md)  | TypeScript/JavaScript go-to-definition, references, and diagnostics through the [TypeScript 7 native compiler](https://devblogs.microsoft.com/typescript/announcing-typescript-7-0/) LSP. |

The native compiler (the Go rewrite formerly known as tsgo) indexes large monorepos roughly 10x faster and with far
less CPU than the official `typescript-lsp` plugin, which spawns `typescript-language-server` + `tsserver`.

Requires a TypeScript 7+ `tsc` binary on `PATH` (e.g. `npm install -g typescript`).

```
/plugin marketplace add CodelyTV/agent-harness
/plugin install ts7-lsp@codely
/plugin disable typescript-lsp@claude-plugins-official
```

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
