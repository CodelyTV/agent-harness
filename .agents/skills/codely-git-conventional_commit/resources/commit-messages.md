# 🎯 Git: Follow Conventional Commit style for commit messages

## 💡 Convention

Every commit message must follow the Conventional Commit format: `type[!]: summary`.

## 🏆 Benefits

- Consistent, scannable git history across the entire repository.
- Automated PR title validation in CI.
- Enables filtering commits by type for changelogs and audits.

## 👀 Examples

### ✅ Good: Correct format with a specific type

```text
feat: add newsletter subscription page
fix: prevent duplicate license assignments
fix: resolve 404 on blog posts with localized slugs
docs: update README with new dev setup instructions
chore: bump @some/dep from 1.0.0 to 1.1.0
perf: lazy-load course card images
```

### ❌ Bad: Wrong format, vague type, or missing conventions

```text
Added newsletter page            # No type, past tense, capitalized
feat: Add newsletter page.       # Capitalized summary, period at end
refactor: improve performance    # Should use perf, not refactor
```

## Format reference

```text
type[!]: summary
  │  │      │
  │  │      └─⫸ Present tense. Not capitalized. No period at the end.
  │  │
  │  └─⫸ [Optional] Breaking changes indicator.
  │
  └─⫸ feat|fix|docs|style|refactor|perf|build|ci|chore|revert|test.
```

### Types

Prefer specific types over generic ones (e.g., `perf` over `refactor` for performance changes, `build` over `feat` for build system changes, `ci` over `build` for GitHub Actions workflows).

- `feat`: A new feature.
- `fix`: A bug fix.
- `docs`: Documentation only changes.
- `style`: Formatting changes (not CSS/design — those are `feat`/`fix`/`refactor`).
- `refactor`: Code change that neither fixes a bug nor adds a feature.
- `perf`: Performance improvement without adding fixes or features.
- `build`: Changes to the build system or external dependencies.
- `ci`: Changes to CI configuration files and scripts.
- `chore`: Other changes that don't modify `src` or `test` files.
- `revert`: Reverts a previous commit.
- `test`: Adding missing tests or correcting existing tests.

### Summary

- Imperative present tense: "change" not "changed" nor "changes".
- Lowercase first letter.
- No period at the end.

### Body (optional)

Use imperative present tense. Explain _why_ the change was made, not _what_ changed.
