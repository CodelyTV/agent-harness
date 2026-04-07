# 🎯 Hexagonal Architecture / DDD

## 💡 Convention

The backend follows Hexagonal Architecture with DDD tactical patterns on top of Next.js 16. Code is organized in three layers:

- **Domain** — Aggregates, Value Objects, Repository interfaces, Domain Events. No framework dependencies.
- **Application** — One use case per class. Orchestrates domain objects. Decorated with `@Service()` for DI.
- **Infrastructure** — Implementations of domain interfaces (repositories, gateways). Framework and library aware.

Directory structure:

```
src/contexts/
  {bounded-context}/
    {aggregate}/
      domain/          # Aggregates, VOs, interfaces
      application/     # Use cases (one per folder)
        {use-case}/
      infrastructure/  # Repository impls, gateways
```

Frontend lives in `src/app/`, API routes in `src/app/api/`.

## 🏆 Benefits

- Domain logic stays framework-agnostic and independently testable.
- Swapping infrastructure (e.g. database, external API) requires no domain or application changes.
- One use case per class keeps application services small, focused, and easy to name.
- Folder structure mirrors the architecture, making navigation predictable.

## 👀 Examples

### ✅ Good: Use case with single responsibility

```typescript
import { Service } from "diod";

import { CookedDishPrimitives } from "../../domain/CookedDish";
import { CookedDishRepository } from "../../domain/CookedDishRepository";

@Service()
export class AllCookedDishesSearcher {
	constructor(private readonly repository: CookedDishRepository) {}

	async searchAll(): Promise<CookedDishPrimitives[]> {
		const dishes = await this.repository.searchAll();

		return dishes.map((dish) => dish.toPrimitives());
	}
}
```

### ❌ Bad: Use case that depends on infrastructure directly

```typescript
import { Service } from "diod";
import { PostgresConnection } from "../../../shared/infrastructure/postgres/PostgresConnection";

@Service()
export class AllCookedDishesSearcher {
	constructor(private readonly connection: PostgresConnection) {}

	async searchAll(): Promise<CookedDishPrimitives[]> {
		const rows = await this.connection.query("SELECT * FROM cooked_dishes");

		return rows;
	}
}
```

## 🧐 Real world examples

- Domain aggregate: `src/contexts/dishes/cooked-dishes/domain/CookedDish.ts`
- Domain repository interface: `src/contexts/dishes/cooked-dishes/domain/CookedDishRepository.ts`
- Application use case: `src/contexts/dishes/cooked-dishes/application/create/CookedDishCreator.ts`
- Application use case: `src/contexts/dishes/cooked-dishes/application/search-all/AllCookedDishesSearcher.ts`
- Infrastructure repository: `src/contexts/dishes/cooked-dishes/infrastructure/PostgresCookedDishRepository.ts`
- Shared domain base class: `src/contexts/shared/domain/AggregateRoot.ts`

## 🔗 Related agreements

- [Dependency Injection with DIOD](dependency-injection-diod.md)
- [Object Mothers for Testing](../testing/object-mothers.md)
- [Mock Objects for Testing](../testing/mock-objects.md)
