# 🎯 Documentation Standard

## 💡 Convention

Every project convention must be documented as a standalone Markdown file inside the `docs/` folder, organized by area (`backend/`, `frontend/`, `database/`). Each document follows a fixed structure with these sections in order: Convention, Benefits, Examples (good and bad), Real world examples, and Related agreements.

The goal is to provide AI agents and developers with self-contained, discoverable references that require no extra context to understand.

## 🏆 Benefits

- AI agents can consume individual docs without loading the entire knowledge base, reducing token usage.
- New team members find conventions faster through a browsable folder structure.
- Each doc is independently reviewable in PRs, making convention changes easy to track.
- The fixed structure ensures consistency and completeness across all documented conventions.

## 👀 Examples

### ✅ Good: Well-structured convention document

```markdown
# 🎯 Name of the convention

## 💡 Convention

Convention description.

## 🏆 Benefits

- List of why to use this convention.

## 👀 Examples

### ✅ Good: Definition of a good example

good example

### ❌ Bad: Definition of a bad example

bad example

## 🧐 Real world examples

- Links to files following this convention

## 🔗 Related agreements

- Links to agreements related to this convention if applies
```

### ❌ Bad: Convention buried in a monolithic file

```markdown
# Project Guidelines

## Architecture
We use hexagonal architecture...

## Testing
Use object mothers...

## Database
PostgreSQL with pgvector...
```

## 🧐 Real world examples

- [Hexagonal Architecture convention](backend/hexagonal-architecture.md)
- [Object Mothers convention](testing/object-mothers.md)
- [PostgreSQL with pgvector convention](database/postgresql-pgvector.md)

## 🔗 Related agreements

- All docs inside `docs/` must follow this standard
