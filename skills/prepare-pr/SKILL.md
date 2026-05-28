---
name: prepare-pr
description: Run final quality checks and generate PR description.
---

# Prepare a Pull Request for Review

## Procedure

0. **Load context.**
   Read `.ai/<task-slug>/` files to verify scope, acceptance criteria, and decisions.

1. **Verify the branch state.**
   Confirm all changes are committed and match the planned scope.

2. **Size gate.**
   Count total lines added + removed:
   - **Over 400 lines**: ❌ Stop. This PR must be split. Use `split-pr`.

3. **Test gate — hard stop.**
   Run the full test suite and type checking. If any fail, **stop here**.

4. **Acceptance criteria check.**
   Verify each criterion from the plan is met.

5. **Code quality checks.**
   Run `check-code-cleanup`, `check-types`, and `check-component-quality`.

6. **Observability check.**
   Verify planned logging/alerting is implemented.

7. **Performance check.**
   Review for re-renders, N+1 patterns, expensive operations, etc.

8. **Shared contract check.**
   If changing a shared unit, verify consumers were audited.

9. **Generate the PR title.**
   Conventional format: `type: description`. Under 72 characters.

10. **Generate the PR description.**

    ```markdown
    ## Motivation
    <Problem addressed. No implementation detail.>

    ## Changes
    - <bullet: what changed>

    ## Test Coverage
    <What is tested and how.>

    ## Observability
    <Logged/alerted on, or "none needed".>

    ## Results
    <What is now true.>

    ## Risks
    <Known limitations or areas for monitoring.>
    ```

11. **Present final title and description for approval.**

12. **Update progress.**
    Mark as "ready for review" in `.ai/<task-slug>/progress.md`.
