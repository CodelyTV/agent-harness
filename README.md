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
    Improve your agents harness.
</p>

## 🔗 Unify skills in .agents

Commands:

- `make claude-symlinks`
- `make copilot-symlinks`
- `make cursor-symlinks`
- `make junie-symlinks`


## 👤 Claude Code Agents.md and junie guidelines

The command `make claude-symlinks` also generates a `CLAUDE.md` linking to `AGENT.md` recursively.

Also, since Junie does not have support for `AGENTS.md`, there is a `.junie/guidelines.md` file that links to all `AGENT.md` files.

## 📃 /create-doc

There is a skill to improve the repo's harness. This is the `/create-doc` this creates a documentation following our guidelines so the next session is better.

There are 2 ways to use it:
- When a conversation is finished: Execute `/create-doc` to apply all the feedback given to the agent.
- Before starting a conversation. Execute `/create-doc some explanation` to create a new documentation.

## 🛡️ Ban `export` command 

The command `export` is dangerous and agents should be able to use it. So there are hooks to disable its invocation. The Claude Code one is special because they have the `if` keyword.
