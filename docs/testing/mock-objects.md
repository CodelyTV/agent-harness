# 🎯 Mock Objects for Testing

## 💡 Convention

Mock objects are hand-written implementations of domain interfaces (repositories, event buses, gateways) used in unit tests. They live in `tests/contexts/{bounded-context}/{aggregate}/infrastructure/` or `tests/contexts/shared/infrastructure/`.

Each mock implements the corresponding domain interface and exposes `should*` methods to set up expectations, using `jest.fn()` internally for assertion. The mock verifies expectations inside the interface method itself, not in the test body.

## 🏆 Benefits

- Tests verify behavior through domain contracts, not framework-specific mock APIs.
- `should*` methods make test setup read like a specification: "the repository should save this dish".
- Mocks are reusable across all tests for the same aggregate.
- Swapping the assertion library only requires changing the mock, not every test.

## 👀 Examples

### ✅ Good: Mock implementing domain interface with should* setup methods

```typescript
import { CookedDish } from "../../../../../src/contexts/dishes/cooked-dishes/domain/CookedDish";
import { CookedDishRepository } from "../../../../../src/contexts/dishes/cooked-dishes/domain/CookedDishRepository";

export class MockCookedDishRepository implements CookedDishRepository {
	private readonly mockSave = jest.fn();
	private readonly mockSearchAll = jest.fn();

	async save(dish: CookedDish): Promise<void> {
		expect(this.mockSave).toHaveBeenCalledWith(dish.toPrimitives());

		return Promise.resolve();
	}

	shouldSave(dish: CookedDish): void {
		this.mockSave(dish.toPrimitives());
	}

	async searchAll(): Promise<CookedDish[]> {
		return this.mockSearchAll() as CookedDish[];
	}

	shouldSearchAllReturn(dishes: CookedDish[]): void {
		this.mockSearchAll.mockReturnValue(dishes);
	}
}
```

### ❌ Bad: Using jest.mock() or inline mocking in tests

```typescript
import { CookedDishRepository } from "../../domain/CookedDishRepository";

jest.mock("../../infrastructure/PostgresCookedDishRepository");

it("should create a cooked dish", async () => {
	const mockRepo = {
		save: jest.fn(),
		searchAll: jest.fn(),
	} as unknown as CookedDishRepository;

	const creator = new CookedDishCreator(mockRepo);

	await creator.create("id", "name", "desc", []);

	expect(mockRepo.save).toHaveBeenCalled();
});
```

## 🧐 Real world examples

- `tests/contexts/dishes/cooked-dishes/infrastructure/MockCookedDishRepository.ts`
- `tests/contexts/shared/infrastructure/MockEventBus.ts`
- `tests/contexts/shared/infrastructure/MockClock.ts`
- `tests/contexts/shared/domain/MockUuidGenerator.ts`
- `tests/contexts/dishes/dishes/infrastructure/MockDishByIngredientsSuggesterGateway.ts`

## 🔗 Related agreements

- [Object Mothers for Testing](object-mothers.md)
- [Hexagonal Architecture](../backend/hexagonal-architecture.md)
