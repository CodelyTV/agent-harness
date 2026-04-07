# 🎯 Code Style

## 💡 Convention

The project uses `eslint-config-codely` as the base ESLint preset. TypeScript strict mode is enabled along with decorator support (`experimentalDecorators` + `emitDecoratorMetadata`).

Key rules enforced:

- `@typescript-eslint/explicit-function-return-type: error` — every function must declare its return type.
- TypeScript `strict: true` in `tsconfig.json`.

Lint issues are fixed with `npm run lint:fix`. The full check suite runs with `make checks` (lint + build + test).

## 🏆 Benefits

- Explicit return types make function contracts clear and catch unintended type changes at compile time.
- Strict mode eliminates entire categories of runtime bugs (null/undefined, implicit any).
- A shared preset ensures all team members and AI agents produce consistent code style.

## 👀 Examples

### ✅ Good: Function with explicit return type

```typescript
async searchAll(): Promise<CookedDishPrimitives[]> {
	const dishes = await this.repository.searchAll();

	return dishes.map((dish) => dish.toPrimitives());
}
```

### ❌ Bad: Function without return type

```typescript
async searchAll() {
	const dishes = await this.repository.searchAll();

	return dishes.map((dish) => dish.toPrimitives());
}
```

## 🧐 Real world examples

- ESLint config: `eslint.config.mjs`
- TypeScript config: `tsconfig.json`
- Use case with explicit return types: `src/contexts/dishes/cooked-dishes/application/search-all/AllCookedDishesSearcher.ts`

## 🔗 Related agreements

- [Hexagonal Architecture](backend/hexagonal-architecture.md)
