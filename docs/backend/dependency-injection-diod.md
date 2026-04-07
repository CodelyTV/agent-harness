# 🎯 Dependency Injection with DIOD

## 💡 Convention

Use the [DIOD](https://github.com/niceDev0908/DIOD) library for dependency injection. Every injectable class must be decorated with `@Service()`. The DI container is configured in a single file: `src/contexts/shared/infrastructure/dependency-injection/diod.config.ts`.

Domain interfaces are registered and mapped to their infrastructure implementations in the container config. Use cases and infrastructure services are registered with `registerAndUse()` or `register().use()`.

## 🏆 Benefits

- Decouples application and domain layers from concrete infrastructure implementations.
- Central container config makes it easy to see all bindings at a glance.
- `@Service()` decorator enables automatic constructor injection without boilerplate.

## 👀 Examples

### ✅ Good: Class decorated with @Service and depending on abstractions

```typescript
import { Service } from "diod";

import { CookedDish } from "../../domain/CookedDish";
import { CookedDishRepository } from "../../domain/CookedDishRepository";

@Service()
export class CookedDishCreator {
	constructor(private readonly repository: CookedDishRepository) {}

	async create(
		id: string,
		name: string,
		description: string,
		ingredients: { name: string; type: string }[],
	): Promise<void> {
		const dish = CookedDish.create(id, name, description, ingredients);

		await this.repository.save(dish);
	}
}
```

### ❌ Bad: Manual instantiation of infrastructure dependencies

```typescript
import { PostgresCookedDishRepository } from "../../infrastructure/PostgresCookedDishRepository";
import { PostgresConnection } from "../../../shared/infrastructure/postgres/PostgresConnection";

export class CookedDishCreator {
	private readonly repository: PostgresCookedDishRepository;

	constructor() {
		const connection = new PostgresConnection("localhost", 5432, "user", "pass", "db");
		this.repository = new PostgresCookedDishRepository(connection);
	}
}
```

## 🧐 Real world examples

- DI container config: `src/contexts/shared/infrastructure/dependency-injection/diod.config.ts`
- Service with injection: `src/contexts/dishes/cooked-dishes/application/create/CookedDishCreator.ts`
- Infrastructure implementation: `src/contexts/shared/infrastructure/NativeUuidGenerator.ts`

## 🔗 Related agreements

- [Hexagonal Architecture](hexagonal-architecture.md)
- [API Routes with reflect-metadata](api-routes-reflect-metadata.md)
