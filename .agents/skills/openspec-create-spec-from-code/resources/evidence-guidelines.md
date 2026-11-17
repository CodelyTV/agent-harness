# 🔎 Evidence guidelines

How to find what the code really does, and how to decide what of it belongs in the spec.

## 🥇 Authority order

Each source answers a different question, and the later ones correct the earlier ones:

1. **Contracts**: API schemas, route handlers' signatures, public types, event payloads. What the system **promises**.
2. **Implementation**: use cases, domain rules, validations, persistence, screens, their states and their copy. What the system **does**.
3. **Tests**: the **decisive** source. A behaviour a test asserts is verified. When the implementation and a test disagree, the test states the intent.
4. **Docs**: `README`, `AGENTS.md`, `docs/`. Read them first to find the code quickly, and trust them only where the code or a test confirms them. A behaviour that only the docs describe is an aspiration, not behaviour.

## 🤖 Subagents

Dispatch **one subagent per independent area** of the capability: a backend context, a set of screens, a worker, an integration. A small capability that lives in a single area needs a single subagent.

Each subagent reads the implementation **and the tests** of its area. Crossing code against its tests is what surfaces anomalies, so keep them in the same report.

- Use a cheaper model for the subagents than the one running this skill.
- Launch them in parallel, in a single batch.
- Give each one its area, the capability, and the report contract below. It reports facts; you decide what goes in the spec.

### 📋 Report contract

Ask every subagent to return a list of **candidate behaviours**. Each one carries:

- **Behaviour**: one sentence, as a user or a client of the area observes it.
- **Evidence**: `file:line` of the code that implements it.
- **Test**: `file:line` of the test that asserts it, or `none`.
- **Values**: the concrete identifiers, inputs and outputs from tests, fixtures or seed data, to write runnable scenarios.
- **Anomaly**: anything that contradicts the rest of the evidence or looks unintended, with both sources. `none` when everything agrees.

## 🧩 The four cases

Every candidate behaviour falls into exactly one case. The spec holds only the first one.

| Case | Signal | Example | What happens |
| --- | --- | --- | --- |
| **Intended and verified** | A test asserts it, or the code states it on purpose and nothing contradicts it. | The checkout rejects an empty cart, and a test asserts it. | A requirement, with scenarios built from the test's values. |
| **Bug** | The code contradicts an intent the rest of the evidence makes clear. | The checkout lets a shopper buy 5 units of a variant with 3 in stock, while every other path checks the stock. | The requirement states the intent with the scenarios that hold. The scenario that breaks stays out of the spec and goes to the closing as a bug. |
| **Accidental** | Nobody decided it: a side effect of how the code happens to be written. | The admin lists orders in insertion order because the query has no `ORDER BY`. | Out of the spec. |
| **Dead** | Nothing reachable triggers it. | A `cancelOrder` action that no screen or endpoint calls. | Out of the spec, and listed in the report. |

Leave a candidate out at the finest grain that keeps the spec true: one broken scenario removes that scenario, not its whole requirement.

### ❓ Ambiguous candidates

A candidate is **ambiguous** when the evidence cannot tell its case: observable behaviour with no test, where intent and accident are both plausible. For example, the checkout accepts guests and no test or doc says whether that is on purpose.

Classify the clear candidates yourself. Gather every ambiguous one and ask the user in a single round. For each, give the behaviour, its evidence, and your recommended case, and let the user pick:

- **Intended**: it becomes a requirement.
- **Bug**: it stays out of the spec and goes to the closing as a bug.
- **Irrelevant**: it stays out of the spec.

## 🗺️ Inventory

When the user asks what lacks a spec, build this table and stop:

1. List the existing capabilities with `openspec list --specs`.
2. List the business concepts the code holds: backend contexts or modules, route groups, top-level screens.
3. Join them by business concept.

| Candidate capability | Code areas | Existing spec |
| --- | --- | --- |
| `checkout` | `src/contexts/backend/checkout`, `src/app/checkout` | — |

Name each candidate in kebab-case after its business concept, and let the user pick the rows to create.
