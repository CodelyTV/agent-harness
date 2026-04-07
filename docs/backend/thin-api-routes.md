# 🎯 Thin API Routes

## 💡 Convention

API routes (`src/app/api/**/route.ts`) must be thin controllers. They resolve a use case from the DI container, call it, and return the response. They must not contain business logic such as filtering, sorting, mapping, or any domain rule.

All business logic belongs in the Application layer (use cases) or the Domain layer.

## 🏆 Benefits

- Business logic stays testable through unit tests against use cases, without needing HTTP infrastructure.
- API routes become trivially simple, reducing the chance of bugs in the delivery layer.
- Logic is reusable — the same use case can be called from API routes, CLI commands, or event handlers.

## 👀 Examples

### ✅ Good: Route delegates entirely to a use case

```typescript
import "reflect-metadata";

import { NextResponse } from "next/server";

import { AllCookedDishesSearcher } from "../../../contexts/dishes/cooked-dishes/application/search-all/AllCookedDishesSearcher";
import { container } from "../../../contexts/shared/infrastructure/dependency-injection/diod.config";
import { HttpNextResponse } from "../../../contexts/shared/infrastructure/http/HttpNextResponse";

const searcher = container.get(AllCookedDishesSearcher);

export async function GET(): Promise<NextResponse> {
	const dishes = await searcher.searchAll();

	return HttpNextResponse.json(dishes);
}
```

### ❌ Bad: Business logic inside the API route

```typescript
import "reflect-metadata";

import { NextResponse } from "next/server";

import { container } from "../../../contexts/shared/infrastructure/dependency-injection/diod.config";
import { CookedDishRepository } from "../../../contexts/dishes/cooked-dishes/domain/CookedDishRepository";

const repository = container.get(CookedDishRepository);

export async function GET(): Promise<NextResponse> {
	const dishes = await repository.searchAll();
	const filtered = dishes.filter((d) => d.ingredients.length > 3);
	const sorted = filtered.sort((a, b) => a.name.localeCompare(b.name));

	return NextResponse.json(sorted.map((d) => d.toPrimitives()));
}
```

## 🧐 Real world examples

- `src/app/api/cooked-dishes/route.ts`
- `src/app/api/cooked-dishes/[uuid]/route.ts`
- `src/app/api/dishes/suggest/route.ts`

## 🔗 Related agreements

- [API Routes with reflect-metadata](api-routes-reflect-metadata.md)
- [Hexagonal Architecture](hexagonal-architecture.md)
