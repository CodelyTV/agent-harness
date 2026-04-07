# 🎯 Object Mothers for Testing

## 💡 Convention

Use the Object Mother pattern to instantiate aggregates and value objects in tests. Each aggregate or value object has a corresponding `*Mother` class located in `tests/contexts/{bounded-context}/{aggregate}/domain/`. Shared mothers live in `tests/contexts/shared/domain/`.

Mothers use `@faker-js/faker` for random data generation and accept an optional `Partial<Primitives>` parameter to override specific fields when needed.

## 🏆 Benefits

- Test data creation is centralized, avoiding duplication across test files.
- Tests clearly express which fields matter by overriding only relevant ones.
- Random data exposes hidden assumptions and coupling to specific values.
- Mothers evolve alongside the domain model in a single place.

## 👀 Examples

### ✅ Good: Object Mother with partial overrides

```typescript
import { faker } from "@faker-js/faker";

import {
	CookedDish,
	CookedDishPrimitives,
} from "../../../../../src/contexts/dishes/cooked-dishes/domain/CookedDish";
import { IngredientMother } from "../../../shared/domain/IngredientMother";

import { CookedDishIdMother } from "./CookedDishIdMother";

export class CookedDishMother {
	static create(params?: Partial<CookedDishPrimitives>): CookedDish {
		const primitives: CookedDishPrimitives = {
			id: CookedDishIdMother.create().value,
			name: faker.food.dish(),
			description: faker.food.description(),
			ingredients: [
				IngredientMother.main().toPrimitives(),
				IngredientMother.main().toPrimitives(),
				IngredientMother.householdStaple().toPrimitives(),
			],
			...params,
		};

		return CookedDish.fromPrimitives(primitives);
	}
}
```

### ❌ Bad: Hardcoded test data inline

```typescript
it("should create a cooked dish", async () => {
	const dish = CookedDish.create(
		"550e8400-e29b-41d4-a716-446655440000",
		"Pasta Carbonara",
		"A classic Italian dish",
		[{ name: "Pasta", type: "main" }, { name: "Egg", type: "main" }],
	);

	await creator.create(dish);
});
```

## 🧐 Real world examples

- `tests/contexts/dishes/cooked-dishes/domain/CookedDishMother.ts`
- `tests/contexts/dishes/cooked-dishes/domain/CookedDishIdMother.ts`
- `tests/contexts/dishes/dishes/domain/DishMother.ts`
- `tests/contexts/shared/domain/IngredientMother.ts`
- `tests/contexts/shared/domain/EmailAddressMother.ts`

## 🔗 Related agreements

- [Mock Objects for Testing](mock-objects.md)
- [Hexagonal Architecture](../backend/hexagonal-architecture.md)
