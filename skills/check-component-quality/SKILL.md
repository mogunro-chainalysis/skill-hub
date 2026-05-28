---
name: check-component-quality
description: Scan for React component quality issues.
---

## Scope

Search for:
1. **JSX section comments**: extract to sub-components.
2. **Undestructured props**: destructure in function signature.
3. **Derived state**: replace `useState` + `useEffect` with derived values.
4. **Logic in presentation**: move fetching/business logic to containers/hooks.
5. **Inline handlers in loops**: extract sub-components or use `useCallback`.
6. **Prop drilling**: lift data or use context for 3+ layers.
