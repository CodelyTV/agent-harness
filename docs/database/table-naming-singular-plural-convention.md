# 🎯 PostgreSQL Table Naming Convention

## 💡 Convention

Use **plural** for main entity tables, **singular + plural** for relationship tables, and **singular** for uncountable or abstract concepts.

- Main entities: `users`, `companies`, `courses`
- Relationships: `user_courses`, `company_licenses` (singular owner + plural related)
- Uncountable concepts: `user_course_progress`, `system_configuration`

## 🏆 Benefits

- Naming becomes predictable — no debates about singular vs plural on a per-table basis.
- Relationship tables clearly express the direction of the association.
- Uncountable concepts stay grammatically natural.

## 👀 Examples

### ✅ Good: Consistent naming following the convention

```sql
CREATE TABLE users (...);
CREATE TABLE companies (...);

CREATE TABLE user_courses (...);
CREATE TABLE company_licenses (...);

CREATE TABLE user_course_progress (...);
CREATE TABLE system_configuration (...);
```

### ❌ Bad: Inconsistent or fully singular naming

```sql
CREATE TABLE user (...);
CREATE TABLE company (...);

CREATE TABLE users_courses (...);
CREATE TABLE companys_license (...);

CREATE TABLE user_course_progresses (...);
```

## 🧐 Real world examples

- `databases/` — Init scripts with table definitions

## 🔗 Related agreements

- [PostgreSQL with pgvector](postgresql-pgvector.md)
- [Use NOT NULL in required fields](not-null-fields.md)
- [Use TEXT over VARCHAR/CHAR](text-over-varchar-char-convention.md)
