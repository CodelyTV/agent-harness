# 🎯 PostgreSQL: Use TEXT with CHECK constraints over VARCHAR/CHAR

## 💡 Convention

Use `TEXT` with `CHECK` constraints instead of `VARCHAR(n)` or `CHAR(n)` for string columns. PostgreSQL stores `TEXT` and `VARCHAR` identically in terms of performance, but `TEXT` with `CHECK` constraints offers more flexible validation (min/max length, patterns) and avoids table locking when altering constraints.

Common CHECK patterns:

- Fixed length: `CHECK(length(field) = 3)`
- Length range: `CHECK(length(field) BETWEEN 2 AND 10)`
- Pattern match: `CHECK(field ~ '^[[:alpha:]]{3}$')`

## 🏆 Benefits

- Same performance as `VARCHAR` with more flexible length validation.
- Altering `CHECK` constraints does not lock the entire table.
- Avoids `CHAR(n)` padding with unnecessary spaces.
- Supports richer validation (regex patterns, ranges) beyond simple max length.

## 👀 Examples

### ✅ Good: TEXT with CHECK constraints for validation

```sql
CREATE TABLE countries (
    id UUID DEFAULT gen_random_uuid() NOT NULL,
    name TEXT NOT NULL
        CONSTRAINT chk__countries__name__max_length
            CHECK (length(name) <= 100),
    iso_code TEXT NOT NULL
        CONSTRAINT chk__countries__iso_code__fixed_length_3
            CHECK (length(iso_code) = 3),
    created_at TIMESTAMPTZ DEFAULT now() NOT NULL,
    updated_at TIMESTAMPTZ DEFAULT now() NOT NULL,
    CONSTRAINT pk__countries PRIMARY KEY (id)
);
```

### ❌ Bad: VARCHAR and CHAR for length constraints

```sql
CREATE TABLE countries (
    id UUID DEFAULT gen_random_uuid() NOT NULL,
    name VARCHAR(100) NOT NULL,
    iso_code CHAR(3) NOT NULL,
    created_at TIMESTAMPTZ DEFAULT now() NOT NULL,
    updated_at TIMESTAMPTZ DEFAULT now() NOT NULL,
    CONSTRAINT pk__countries PRIMARY KEY (id)
);
```

## 🧐 Real world examples

- `databases/` — Init scripts with table definitions

## 🔗 Related agreements

- [Use NOT NULL in required fields](not-null-fields.md)
- [Table Naming Convention](table-naming-singular-plural-convention.md)
- [PostgreSQL with pgvector](postgresql-pgvector.md)
