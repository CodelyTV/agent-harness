# 📐 Spec format

A main spec lives at `openspec/specs/<capability>/spec.md`. The OpenSpec CLI parses it by its headings, so this skeleton is the contract that `openspec validate`, `openspec show` and every later change rely on.

```markdown
# <capability> Specification

## Purpose

<One to four sentences: the business concept, who uses it, and what this capability is responsible for.>

## Requirements

### Requirement: <Short name of one behaviour>
<Normative sentence with SHALL, SHALL NOT or MAY, holding the concrete constraints: limits, formats, ordering, status codes.>

#### Scenario: <The main case>
- **WHEN** <a concrete action with concrete values>
- **THEN** <the observable result, with the concrete values expected>

#### Scenario: <The error or edge case>
- **WHEN** ...
- **THEN** ...
```

## 🔑 Rules the parser relies on

- The title is `# <capability> Specification`, and `<capability>` matches the folder name.
- One `## Purpose` and one `## Requirements`, in that order.
- Every requirement heading starts with `### Requirement: `, and its text holds `SHALL` or `MUST`.
- Every requirement has at least one `#### Scenario: ` with a `- **WHEN**` and a `- **THEN**` bullet. `- **AND**` bullets may follow either.
- Requirement names are unique in the spec: later changes reference them by name.
- A main spec states behaviour, so it uses only `## Requirements`. The `ADDED`, `MODIFIED`, `REMOVED` and `RENAMED` sections belong to the delta specs of a change.
- The structural headings and the `SHALL`/`MUST` keywords stay in English whatever language the spec is written in.

## ✨ What makes a baseline useful

**The normative voice.** Write `SHALL` about present behaviour. From now on the spec is the promise, and the next change proposes a delta against it. Wording such as "currently" or "the code does" marks the text as a snapshot, and the next author cannot tell what is still guaranteed.

**One requirement, one behaviour.** Split when a client would test two behaviours separately. Merge when splitting would repeat the same normative sentence. "Place an order" and "Placing an order with an empty cart is rejected" are two scenarios of one requirement.

**Concrete values.** Scenarios name the identifiers, quantities and texts found in tests, fixtures and seed data, so a reader can run them against the application. "An invalid request is rejected" cannot be run; "a quantity above the 3 units in stock is rejected with the message 'Not enough stock'" can.

**Observable behaviour only.** Tables, classes, folders and frameworks stay out. Persistence is observable as "survives a reload", not as "stored in the `orders` table".

## 👀 Example

```markdown
### Requirement: Stock limits the quantity in the cart
The checkout SHALL reject adding a quantity of a variant above its available stock, and SHALL keep the cart unchanged.

#### Scenario: Quantity within the stock
- **WHEN** a shopper adds 2 units of "Pure Function Tee" Black / M, which has 3 units in stock
- **THEN** the cart holds 2 units of that variant

#### Scenario: Quantity above the stock
- **WHEN** a shopper adds 5 units of "Pure Function Tee" Black / M, which has 3 units in stock
- **THEN** the checkout shows "Not enough stock" and the cart is unchanged
```
