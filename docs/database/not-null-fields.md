# 🎯 PostgreSQL: Use `NOT NULL` in fields that are required by business logic

## 💡 Convention

If there are no specific reasons to use a nullable data type, use `NOT NULL`.

## 🏆 Benefits

- Prevents accidental null values: Catches missing data at database level.
- Simpler application logic: No need to handle null checks in most cases.
- Better data integrity: Ensures required fields always have values.
- Performance: NOT NULL fields can be optimized better by PostgreSQL.
- Clear intent: Makes required vs optional fields explicit.

## 👀 Examples

### ✅ Good: Use `NOT NULL` in fields that are required by business logic

```sql
CREATE TABLE users (
    id UUID DEFAULT gen_random_uuid() NOT NULL,
    email TEXT NOT NULL,
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL,
    created_at TIMESTAMPTZ DEFAULT now() NOT NULL,
    updated_at TIMESTAMPTZ DEFAULT now() NOT NULL,
    CONSTRAINT pk__users PRIMARY KEY (id)
);
```

### ❌ Bad: Allow `NULL` by not adding the `NOT NULL` constraint in fields that are required by business logic

```sql
CREATE TABLE users (
    id UUID DEFAULT gen_random_uuid(),
    email TEXT,
    first_name TEXT,
    last_name TEXT,
    created_at TIMESTAMPTZ DEFAULT now(),
    updated_at TIMESTAMPTZ DEFAULT now(),
    CONSTRAINT pk__users PRIMARY KEY (id)
);
```

## ☝️ Exceptional cases: When to not take into account this convention

Cases where we allow NULL values by default:

- Truly optional data: Fields that legitimately may not have values
- Future expansion: Fields added later that cannot have defaults
- Business logic requirements: When "unknown" vs "empty" has different meanings

### 🥽 Example of exceptional case

Same example as before, but now we allow `NULL` values for the `bio`, `avatar_url` and `phone_number` fields because they are optional data. That is, we don't really make them required fields in the edit user profile form.

```sql
CREATE TABLE users (
    id UUID DEFAULT gen_random_uuid() NOT NULL,
    email TEXT NOT NULL,
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL,
    bio TEXT,
    avatar_url TEXT,
    phone_number TEXT,
    created_at TIMESTAMPTZ DEFAULT now() NOT NULL,
    updated_at TIMESTAMPTZ DEFAULT now() NOT NULL,
    CONSTRAINT pk__users PRIMARY KEY (id)
);
```
