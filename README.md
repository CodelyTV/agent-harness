<p align="center">
  <a href="https://codely.com">
    <picture>
      <source media="(prefers-color-scheme: dark)" srcset="https://codely.com/logo/codely_logo-dark.svg">
      <source media="(prefers-color-scheme: light)" srcset="https://codely.com/logo/codely_logo-light.svg">
      <img alt="Codely logo" src="https://codely.com/logo/codely_logo.svg">
    </picture>
  </a>
</p>

<h1 align="center">🤖 Agent Harness</h1>

<p align="center">
  <a href="https://github.com/CodelyTV"><img alt="Codely OS" src="https://img.shields.io/badge/Codely-OS-green?style=flat-square"></a>
  <a href="https://codely.com/cafe"><img alt="Codely Cafe News" src="https://img.shields.io/badge/Codely-Cafe_News-%235A3E2B?style=flat-square"></a>
  <a href="https://codely.com/newsletter"><img alt="Codely Newsletter" src="https://img.shields.io/badge/Codely-Newsletter-%23D3D3D3?style=flat-square"></a>
  <a href="https://youtube.com/codelytv"><img alt="Codely YouTube" src="https://img.shields.io/badge/Codely-YouTube-red?style=flat-square"></a>
  <a href="https://codely.com/courses"><img alt="Codely Courses" src="https://img.shields.io/badge/Codely-Courses-black?style=flat-square"></a>
  <a href="https://github.com/CodelyTV/agent-harness/stargazers"><img alt="GitHub Repo stars" src="https://img.shields.io/github/stars/codelytv/agent-harness"></a>
</p>

<p align="center">
    Skills, plugins and hooks so your agent writes the code you expect, the way you expect.<br>
    Review outputs, not code.
</p>

Your agent writes code faster than you can review it. Instead of reading every line, turn your conventions into rules
that fail in seconds: the agent corrects itself, and you review what the change does, not how it is written.

## Workflow

1. **Make your docs deterministic** with `/docs-to-rules`.
2. **Enforce your code conventions** with `/code-conventions-to-rules`.
3. **Add a new rule** with `/create-rule` every time you correct the agent.
4. **Commit** with `/git-commit`.
5. **Open the pull request** with `/create-pull-request`, with before/after evidence of what the change does.

For larger tasks, plan the work with `/create-plan` and implement it one phase at a time with
`/implement-plan-phase`. Already using [OpenSpec](https://openspec.dev)? Run `/openspec-create-spec-from-code` first.

## Why

### Your docs are suggestions

You wrote your conventions down, but the agent only follows them if it loads the right doc and reads it the way your
team does.

**The fix:** `/docs-to-rules` turns every convention that code can check into a linter rule or a test.

### Your code does the same job in two ways

A legacy way and a current way live together, and the agent copies whichever it reads first.

**The fix:** `/code-conventions-to-rules` finds them in the code and its history, and enforces the current way with a
rule, after you confirm it.

### You correct the same thing again and again

You fix the agent in one session, and it makes the same mistake in the next one.

**The fix:** run `/create-rule` after the correction. It becomes a rule when a rule can check it, and a minimal doc
with the reason when it cannot.

### The history is a mess

Commit messages follow whatever the agent felt like that day.

**The fix:** `/git-commit` writes Conventional Commits with the co-author trailer of the agent that made the change.

## Install

```bash
npx skills@latest add codelytv/agent-harness
```

Pick the skills you want and the agents to install them on. Then run one, for example `/create-rule`.

<details>
<summary>Claude Code plugin</summary>

```
/plugin marketplace add CodelyTV/agent-harness
/plugin install codely-skills@codely
```

</details>

## Skills

| Skill                                                                                      | Use it when                                                                                    | Variants                           |
|--------------------------------------------------------------------------------------------|------------------------------------------------------------------------------------------------|------------------------------------|
| [`deterministify`](.agents/skills/deterministify/SKILL.md)                                 | You want the conventions your repository already has enforced by linter rules and tests.       | aliases                            |
| [`create-rule`](.agents/skills/create-rule/SKILL.md)                                       | You corrected the agent, or want a new convention enforced, and want a rule instead of a doc.  |                                    |
| [`git-commit`](.agents/skills/git-commit/SKILL.md)                                         | You want to commit your changes with a Conventional Commit message.                            |                                    |
| [`create-pull-request`](.agents/skills/create-pull-request/SKILL.md)                       | You open or update a pull request and want its description to follow a template with evidence. |                                    |
| [`create-plan`](.agents/skills/create-plan/SKILL.md)                                       | You start a larger task and want a plan split into reviewable phases.                          | `-subagents`, `-github`, `-gitlab` |
| [`implement-plan-phase`](.agents/skills/implement-plan-phase/SKILL.md)                     | You have a plan and want to implement its next phase.                                          | `-github`, `-gitlab`               |
| [`openspec-create-spec-from-code`](.agents/skills/openspec-create-spec-from-code/SKILL.md) | You need the OpenSpec specs of behaviour that already exists in the code.                      |                                    |
| [`create-doc`](.agents/skills/create-doc/SKILL.md)                                         | Deprecated: use `create-rule`.                                                                 |                                    |

<details>
<summary>Variants</summary>

- aliases: [`docs-to-rules`](.agents/skills/docs-to-rules/SKILL.md) runs `deterministify docs`, and
  [`code-conventions-to-rules`](.agents/skills/code-conventions-to-rules/SKILL.md) runs `deterministify patterns`. Both
  need `deterministify` installed next to them.
- `-subagents`: [`create-plan-subagents`](.agents/skills/create-plan-subagents/SKILL.md) delegates the codebase
  exploration to cheaper subagents running in parallel.
- `-github`: [`create-plan-github`](.agents/skills/create-plan-github/SKILL.md) stores the plan as a parent issue with
  one sub-issue per phase, and [`implement-plan-phase-github`](.agents/skills/implement-plan-phase-github/SKILL.md)
  opens one pull request per phase.
- `-gitlab`: [`create-plan-gitlab`](.agents/skills/create-plan-gitlab/SKILL.md) and
  [`implement-plan-phase-gitlab`](.agents/skills/implement-plan-phase-gitlab/SKILL.md) do the same with GitLab issues
  and merge requests.

</details>

<details>
<summary><code>codely-spec-plan</code> OpenSpec schema</summary>

An [OpenSpec custom schema](https://github.com/Fission-AI/OpenSpec/blob/main/docs/customization.md) that brings the
`create-plan-subagents` flow to OpenSpec. Each change produces only two things to review:

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

</details>

## Claude Code plugins

Plugins for Claude Code only, installed from this repository's marketplace.

<details>
<summary><code>ste100</code>: answers in Simplified Technical English</summary>

Makes the agent write to you in [ASD-STE100 Simplified Technical English](https://www.asd-ste100.org/): short
sentences, active voice, one word per meaning, no idioms. It changes how the agent writes to you, not how it writes
code.

```
/plugin marketplace add CodelyTV/agent-harness
/plugin install ste100@codely
```

Then run `/config`, look for **Output Style**, and select `ASD-STE100`. More in its
[README](.claude/plugins/ste100/README.md).

</details>

<details>
<summary><code>ts7-lsp</code>: faster TypeScript code intelligence</summary>

Go-to-definition, references and diagnostics through the
[TypeScript 7 native compiler](https://devblogs.microsoft.com/typescript/announcing-typescript-7-0/) LSP. It indexes
large monorepos roughly 10x faster and with far less CPU than the official `typescript-lsp` plugin.

Requires a TypeScript 7+ `tsc` binary on `PATH` (e.g. `npm install -g typescript`).

```
/plugin marketplace add CodelyTV/agent-harness
/plugin install ts7-lsp@codely
/plugin disable typescript-lsp@claude-plugins-official
```

More in its [README](.claude/plugins/ts7-lsp/README.md).

</details>

## Under the hood

<details>
<summary>One source for every agent</summary>

Rules live in `AGENTS.md` and skills in `.agents/skills/`. Each agent expects them in a different path, so a `make`
command creates the symlinks it needs. They are not committed, so run the ones you need after cloning:

| Command                  | What it does                                                                                    |
|--------------------------|-------------------------------------------------------------------------------------------------|
| `make claude-symlinks`   | Links `CLAUDE.md → AGENTS.md` in every directory with an `AGENTS.md`, and `.claude/skills`      |
| `make codex-symlinks`    | Links `.codex/skills → .agents/skills`                                                          |
| `make copilot-symlinks`  | Links `.github/skills → .agents/skills`                                                         |
| `make cursor-symlinks`   | Links `.cursor/skills → .agents/skills`                                                         |
| `make junie-symlinks`    | Links `.junie/skills → .agents/skills`                                                          |
| `make opencode-symlinks` | Links `.opencode/skills → .agents/skills`                                                       |

</details>

<details>
<summary><code>export</code> blocked via hooks</summary>

The `export` command can leak environment variables (tokens, secrets) if an agent runs it. Each agent has a
pre-execution hook that blocks any shell command containing `export`:

| Agent       | Hook location                                        | Mechanism                                                                                        |
|-------------|------------------------------------------------------|--------------------------------------------------------------------------------------------------|
| Claude Code | `.claude/settings.json`                              | Uses the `if` keyword with a glob pattern (`Bash(*export*)`) to match and block inline           |
| Cursor      | `.cursor/hooks.json` + `hooks/block-export.sh`       | Runs a shell script that parses the command via `jq` and exits with code 2 on match              |
| Copilot     | `.github/hooks/hooks.json` + `hooks/block-export.sh` | Same approach as Cursor, adapted to Copilot's hook input format                                  |
| OpenCode    | `.opencode/plugins/block-export.ts`                  | A native TypeScript plugin (`tool.execute.before`) that inspects the command and throws to block |

</details>
