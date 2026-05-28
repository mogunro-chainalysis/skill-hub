# Review Skill — Audit Principles

Use these principles when auditing skills, agents, and instructions in the global hub.

## Core Principles

1. **Prefer the smallest effective artifact.**
   - Skill for reusable procedure
   - Agent for role, tool, or model specialization
   - Instruction rule for durable always-on rules
   - `references/` for explanation, examples, and reference material

2. **Prefer procedural guidance over descriptive background.**
   - Tell the agent what to do, not what something is.
   - Numbered steps with imperative verbs.

3. **Treat the frontmatter `description` as the primary trigger surface.**
   - Include realistic user phrases and contexts.
   - An agent selects skills by matching the description to the task.

4. **Keep artifacts compact.**
   - Skills should stay within roughly 15–80 lines when possible.
   - Long examples, rationale, and reference tables belong in `references/` or docs.
   - Target under ~5000 tokens for the SKILL.md body.

5. **Encode tribal knowledge only.**
   - Keep what the model cannot infer from code, structure, or nearby files.
   - Cut generic advice and obvious restatements.

6. **Prefer positive framing.**
   - Use negatives mainly for hard safety boundaries.
   - Rephrase "do not X" as "do Y instead" when possible.

7. **Constrain agents deliberately.**
   - Minimize tools, steps, and autonomy to what the job actually requires.
   - Delegate specialized work to other skills or agents instead of overloading one.

8. **Never hardcode model names.**
   - Models are updated, renamed, and deprecated constantly.
   - Let the tool pick the best available model.

9. **Global skills must be repo-agnostic.**
   - No specific file paths, project names, design system components, or repo-specific conventions.
   - If a skill needs repo-specific content, it belongs at the project level.

10. **Prefer deterministic enforcement over prose when possible.**
    - If a behavior can be enforced by config, tests, hooks, or tooling, do that instead of relying only on instructions.

## Artifact Type Decision Guide

| Signal | Artifact |
|---|---|
| Reusable procedure an agent follows on demand | Skill |
| Specialized role with distinct prompt and tools | Agent |
| Rule that should apply to every session automatically | Instruction rule |
| Explanation, examples, or rationale too long for a skill body | `references/` file |
| Durable repo-specific convention | Project-level `CLAUDE.md` / `AGENTS.md` |

## Quality Dimensions

| Dimension | What to check |
|---|---|
| **Clarity** | Can the agent follow this without ambiguity? |
| **Specificity** | Does it include concrete steps, patterns, or commands? |
| **Scope** | Is it focused on one well-defined job? |
| **Actionability** | Does it produce a tangible output? |
| **Universality** | Does it work in any project (for global skills)? |
| **Trigger accuracy** | Does the description match realistic usage? |
| **Compactness** | Does every line earn its keep? |
