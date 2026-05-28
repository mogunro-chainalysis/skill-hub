---
name: check-code-cleanup
description: Scan for cleanup issues before committing.
---

## Scope

Scan staged files for:
1. **Console statements**: remove `console.log/warn/info`.
2. **Commented-out code**: delete instead of committing.
3. **TODOs**: must include a ticket reference (e.g., `TODO(PROJ-123)`).
4. **Unnecessary comments**: remove comments that restate the code.
5. **Readability**: simplify nested logic, long functions, or unclear names.
6. **Maintainability**: flag duplication or tight coupling.
7. **Performance**: flag unnecessary re-renders or missing keys.
8. **Unused imports**: remove unused symbols.
