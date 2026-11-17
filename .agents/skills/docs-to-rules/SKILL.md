---
name: docs-to-rules
description: Turn the written conventions of a repository (docs, AGENTS.md, ADRs, guidelines) into deterministic rules that fail in seconds. Alias of deterministify in docs mode.
argument-hint: "[path …]"
disable-model-invocation: true
user-invocable: true
metadata:
  author: Codely <support@codely.com> (https://codely.com)
  version: "1.0"
  license: MIT
---

# Docs to rules

Follow [`deterministify`](../deterministify/SKILL.md) in mode `docs`, with the paths the user passed, if any: `/deterministify docs [path …]`.
