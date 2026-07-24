# 🎯 Git: Follow Conventional Commit style for commit messages

## 💡 Convention

Every commit message must follow the Conventional Commit format: `type[(scope)][!]: summary`. Validated locally by commitlint via Husky and in CI by the validate-pr-title workflow.

## 🏆 Benefits

- Consistent, scannable git history across the entire monorepo.
- Automated PR title validation in CI.
- Enables filtering commits by type or scope for changelogs and audits.

## 👀 Examples

### ✅ Good: Correct format with specific type and scope

```text
feat(mooc): add newsletter subscription page
fix(companies-backoffice): prevent duplicate license assignments
fix(backend-mooc-context): resolve 404 on blog posts with localized slugs
docs: update README with new dev setup instructions
chore(mooc): bump @some/dep from 1.0.0 to 1.1.0
perf(mooc): lazy-load course card images
```

### ❌ Bad: Wrong format, vague type, or missing conventions

```text
Added newsletter page                  # No type, past tense, capitalized
feat(mooc): Add newsletter page.       # Capitalized summary, period at end
refactor(mooc): improve performance    # Should use perf, not refactor
```

## Format reference

```text
type[(scope)][!]: summary
  │     │     │      │
  │     │     │      └─⫸ Present tense. Not capitalized. No period at the end.
  │     │     │
  │     │     └─⫸ [Optional] Breaking changes indicator.
  │     │
  │     └─⫸ [Optional] Auto-discovered from Yarn workspace names (see Scopes).
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

### Scopes

Valid scopes are auto-discovered from the Yarn workspace names (without the `@codely/` prefix). Both the local commitlint hook and the CI PR title validator use the same workspace-derived scopes. Omit the scope if multiple workspaces are affected.

To list the current valid scopes, run:

```bash
yarn scopes
```

When a change involves backend routes and code, use the full context workspace name as scope (e.g., `backend-mooc-context`) instead of just the app name (e.g., `mooc`). For example, if you modify backend code in the mooc bounded context, use `feat(backend-mooc-context):` not `feat(mooc):`.

### Summary

- Imperative present tense: "change" not "changed" nor "changes".
- Lowercase first letter.
- No period at the end.

### Body (optional)

Use imperative present tense. Explain _why_ the change was made, not _what_ changed.

## 🔧 Tooling

### commitlint (local)

Every commit message is validated locally via a Husky `commit-msg` hook that runs `yarn commitlint --edit`. The configuration lives in `.commitlintrc.ts`:

- `@commitlint/config-conventional`: enforces the Conventional Commit format (types, structure, casing).
- `scope-enum`: populated from `yarn scopes` (workspace names + `deps`/`deps-dev`).
- `body-max-line-length` is disabled so commit bodies can contain long lines (URLs, stack traces, etc.).

### validate-pr-title (CI)

PR titles are validated in CI by the `amannn/action-semantic-pull-request` GitHub Action (`.github/workflows/validate-pr-title.yml`). It runs `yarn scopes` to build the valid scopes list, keeping it in sync with commitlint.

## 🔗 Related agreements

- [Merge strategy](./merge-strategy.md).
