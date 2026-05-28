---
name: check-types
description: Scan for TypeScript hygiene violations.
---

## Scope

Search for:
1. **`any` usage**: replace with `unknown` or specific types.
2. **Props using `interface`**: use `type` instead.
3. **Missing `readonly`**: prefix prop fields with `readonly`.
4. **`||` for defaults**: use `??` for null/undefined defaults.
5. **Leaked API types**: components should import from UI/domain layers.
