# tsgo-lsp

TypeScript/JavaScript code intelligence for Claude Code using the [TypeScript 7 native compiler](https://devblogs.microsoft.com/typescript/announcing-typescript-7-0/) (the Go rewrite formerly known as tsgo), which ships an LSP server built in.

Compared to the official `typescript-lsp` plugin (which spawns `typescript-language-server` + `tsserver`), the native compiler indexes large monorepos roughly 10x faster and with far less CPU.

## Requirements

A TypeScript 7+ `tsc` binary on `PATH` (e.g. `npm install -g typescript`).

## Install

```sh
claude plugin marketplace add CodelyTV/agent-harness
claude plugin install tsgo-lsp@codely
claude plugin disable typescript-lsp@claude-plugins-official
```
