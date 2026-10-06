# determine-patterns — Per-Category Checklists

Gather only the categories the task needs (step 3 of `SKILL.md`).

## Components

- File naming and directory structure (flat vs nested, index files, co-located tests)
- Function style (arrow vs declaration, default vs named export)
- Props pattern (type vs interface, destructuring, readonly)
- State management approach (local state, context, external store)
- Styling approach (CSS modules, styled-components, Tailwind, design system components)

## Hooks

- Naming conventions (use-prefix, file location)
- Return type patterns (tuple vs object)
- Error handling approach
- How data fetching hooks are structured (React Query, SWR, custom)

## API / Data layer

- Client structure (REST, GraphQL, RPC)
- Type definitions (shared types, generated types, co-located)
- Adapter/transform patterns
- Error handling and loading states

## Tests

- Which suite tests *this kind of behavior* (unit vs integration vs e2e source set) — find an existing test of the same behavior type before choosing a level or harness
- Framework (Jest, Vitest, Cypress, Playwright)
- File naming and location (co-located, `__tests__/`, `.test.ts`, `.spec.ts`)
- Mocking approach (MSW, jest.mock, manual mocks)
- Assertion style and common utilities
- How shared prerequisites are provided in tests (test wrappers, fixtures, bootstrap helpers, harnesses)

## Routing

- Router library and version
- Route definition pattern (file-based, config-based)
- How new routes/pages are added
