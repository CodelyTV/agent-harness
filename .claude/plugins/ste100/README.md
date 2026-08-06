# ste100

An output style that makes Claude Code answer in [ASD-STE100 Simplified Technical English](https://www.asd-ste100.org/), the controlled English that the aerospace and defence industry uses for its technical documentation.

Short sentences, active voice, one word per meaning, no idioms. The answers become easier to scan, easier to translate, and harder to misread.

The style only changes how Claude writes to you. It does not change the conventions of the code it produces.

## Install

```sh
claude plugin marketplace add CodelyTV/agent-harness
claude plugin install ste100@codely
```

Then activate the style with `/output-style ASD-STE100`.
