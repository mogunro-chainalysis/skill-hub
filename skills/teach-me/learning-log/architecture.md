# Architecture Learning Log

## 2026-04-20 — API/UI type layer separation: naming conventions vs structural contracts

**Question:** Should API types get a `DTO` suffix (e.g. `CommunityMessageDTO`) and UI types use plain names (e.g. `CommunityMessage`), with UI types trimmed to only what the UI needs?

**Key lessons:**

1. **The naming collision is already handled at the import site.** Adapters alias API types on import (`import { CommunityMessage as ApiCommunityMessage }`), so the disambiguation exists without any suffix.

2. **DTO is a Java/enterprise naming pattern, not idiomatic TypeScript.** In TypeScript codebases, module paths carry the disambiguation: `api/types/api/` vs `api/types/ui/` already tells you which layer you're in. Adding a suffix replicates information the file system already provides.

3. **The more substantive part of the proposal is the explicit UI contract.** Using `...api` spread in adapters silently leaks API fields into UI types. Listing UI type properties explicitly creates a clear, enforced contract — the UI only ever sees what it is intentionally given.

4. **Two separable concerns were bundled into one proposal.** The DTO naming change and the explicit-contract change are independent. Identifying this separation lets you evaluate each on its own merits and sequence them separately if needed.

**Generalised principle:** When evaluating a refactor proposal that bundles naming and structure changes, decompose first. Naming is cosmetic and should follow language idioms; structural contracts (what fields cross a layer boundary) have real coupling consequences and are worth addressing regardless of naming.

**Concepts:** adapter pattern, API/UI layer separation, TypeScript module namespacing, type coupling via spread, paradigm drift (Java patterns in TypeScript)
