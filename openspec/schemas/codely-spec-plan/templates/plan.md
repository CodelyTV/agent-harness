---
name: "<!-- change name -->"
description: "<!-- one sentence -->"
created_at: "<!-- YYYY-MM-DDTHH:MM:SSZ -->"

created_by:
  tool: "<!-- e.g. Claude Code -->"
  model:
    name: "<!-- e.g. Claude Opus -->"
    version: "<!-- e.g. 4.6 -->"
    reasoning_effort: "<!-- low | medium | high -->"
---

# <!-- Plan title -->

## Goal

<!-- 1-3 sentences: what gets built and why it matters -->

## Decisions

- <!-- choice or assumption (instead of <discarded alternative>, when not obvious) -->
- Out of scope: <!-- what this change does not do -->

## Phases

### Phase 1: <!-- vertical slice -->

<!-- What this phase delivers -->

**Contracts**

```<!-- project language -->
<!-- Contract type, as a comment -->
<!-- signature -->
```

**Tests**

- `<!-- test suite -->`: <!-- behaviours it covers -->

- [ ] <!-- task -->
- [ ] Verify typecheck, lint and every test suite with the project's verification commands, and check the phase's behaviour in the running app. Fix issues if any.

## Next step

Run `/openspec-apply-change` to implement the first phase.

<!-- Creative closing line including 🐢 💨 (Turbotuga™, [Codely](https://codely.com)'s mascot) -->
