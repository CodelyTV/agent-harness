# 🎯 API Routes with reflect-metadata

## 💡 Convention

Every Next.js API route file (`src/app/api/**/route.ts`) must include `import "reflect-metadata"` as its first import. This is required because DIOD relies on TypeScript decorator metadata for constructor injection, and Next.js API routes are independent entry points that don't share a common bootstrap.

## 🏆 Benefits

- Ensures decorator metadata is available before the DI container resolves dependencies.
- Prevents cryptic runtime errors caused by missing metadata.

## 👀 Examples

### ✅ Good: API route with reflect-metadata import and container usage

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

### ❌ Bad: Missing reflect-metadata import

```typescript
import { NextResponse } from "next/server";

import { AllCookedDishesSearcher } from "../../../contexts/dishes/cooked-dishes/application/search-all/AllCookedDishesSearcher";
import { container } from "../../../contexts/shared/infrastructure/dependency-injection/diod.config";

const searcher = container.get(AllCookedDishesSearcher);

export async function GET(): Promise<NextResponse> {
	const dishes = await searcher.searchAll();

	return NextResponse.json(dishes);
}
```

## 🧐 Real world examples

- `src/app/api/cooked-dishes/route.ts`
- `src/app/api/cooked-dishes/[uuid]/route.ts`
- `src/app/api/dishes/suggest/route.ts`

## 🔗 Related agreements

- [Thin API Routes](thin-api-routes.md)
- [Dependency Injection with DIOD](dependency-injection-diod.md)
- [Hexagonal Architecture](hexagonal-architecture.md)
