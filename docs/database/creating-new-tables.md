# 🎯 PostgreSQL: Creating new tables

## 💡 Convention

Create new tables using SQL init scripts inside the `databases/` directory. Each script defines tables following project conventions: `NOT NULL` by default, `TEXT` with `CHECK` constraints over `VARCHAR`/`CHAR`, plural naming for entities, and UUIDs as primary keys.

Every new table must include:

- `id` column: `UUID DEFAULT gen_random_uuid() NOT NULL` with a named primary key constraint (`pk__<table>`)
- `created_at` and `updated_at` columns: `TIMESTAMPTZ DEFAULT now() NOT NULL`
- Named constraints: `pk__<table>`, `chk__<table>__<field>__<rule>`, `fk__<table>__<referenced_table>`
- `NOT NULL` on all fields unless the field is truly optional by business logic

## 🏆 Benefits

- Init scripts in `databases/` are versioned and reproducible with `docker compose up`.
- Named constraints make error messages readable and migrations predictable.
- Consistent column patterns (id, timestamps) across all tables reduce cognitive load.
- Following all conventions from a single checklist prevents back-and-forth reviews.

## 👀 Examples

### ✅ Good: New table following all conventions

```sql
CREATE TABLE courses (
    id UUID DEFAULT gen_random_uuid() NOT NULL,
    title TEXT NOT NULL
        CONSTRAINT chk__courses__title__max_length
            CHECK (length(title) <= 200),
    slug TEXT NOT NULL
        CONSTRAINT chk__courses__slug__max_length
            CHECK (length(slug) <= 100),
    description TEXT,
    published_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ DEFAULT now() NOT NULL,
    updated_at TIMESTAMPTZ DEFAULT now() NOT NULL,
    CONSTRAINT pk__courses PRIMARY KEY (id)
);
```

### ❌ Bad: Table ignoring project conventions

```sql
CREATE TABLE course (
    id SERIAL PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    slug CHAR(100) NOT NULL,
    description TEXT,
    published_at TIMESTAMP
);
```

Problems:

- Singular name (`course` instead of `courses`)
- `SERIAL` instead of `UUID`
- `VARCHAR`/`CHAR` instead of `TEXT` with `CHECK`
- Missing `created_at` / `updated_at`
- Missing named constraints
- `TIMESTAMP` instead of `TIMESTAMPTZ`

## 🧐 Real world examples

- `databases/` — Init scripts with table definitions

## 🔗 Related agreements

- [Use NOT NULL in required fields](not-null-fields.md)
- [Use TEXT over VARCHAR/CHAR](text-over-varchar-char-convention.md)
- [Table Naming Convention](table-naming-singular-plural-convention.md)

---

Doc crafted with care by 🐢 💨 (Turbotuga™, [Codely](https://codely.com)'s mascot)
