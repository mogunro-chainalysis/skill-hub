---
name: plan-infra-changes
description: Plan IaC/GitOps changes a code change needs (config, secret, permission, datastore, service). Use when planning, reviewing, or editing infra.
---

# Plan Infra Changes

Every service change gets an explicit infra verdict: "none needed" (with reasons) or a list of infra PRs.

## Procedure

1. **Load the infra map.** Read the private map if present (`~/.agents-work/context/infra-map.md`, `~/.agents/.ai/infra-map.md`, or the repo's `.ai/infra-map.md`): service → deploy repo → provisioning repo, environments, DR layout, handoff conventions. Without one, build it from steps 3–4 and offer to save it there (gitignored, never in a public repo).

2. **Classify the change against infra triggers.** Infra work is needed when the change introduces or alters:
   - a datastore, cache, queue/topic/stream, bucket, or KMS key
   - a cloud permission (IAM/IRSA role, policy action, trust for a new cluster or namespace)
   - a secret or parameter (new key, new name, rotation)
   - runtime config (env var, feature flag, endpoint, hostname/route, gateway)
   - workload shape (new service, replicas/resources, new environment or region)
   - monitoring (SLOs, monitors) for new failure modes
   No trigger → record "no infra change" with the triggers you checked, then stop.

3. **Use fresh sources.** For each affected repo, `git fetch` and read from `origin/main` (use a detached worktree; don't touch the user's checkout). Local clones are often stale or on old branches. Check for repo renames (`gh repo view`).

4. **Read in-repo guidance first.** In every affected infra/env repo, read `AGENTS.md`/`CLAUDE.md`, `docs/`, and every skill under `.agents/skills/`, `.claude/skills/`. Prefer those skills for repo-specific steps (impact analysis, diffs, IRSA checks). Then run `determine-patterns` per repo; flag guidance that contradicts live config.

5. **Trace the provisioning → consumption chain.** For each trigger, find:
   - **Provision**: the IaC root and module that create the resource (module change + release before the live pin bump?).
   - **Handoff**: how the env repo references it — secret/parameter name, role ARN, hostname, substitution variable. Handoffs by naming convention are brittle: a rename on one side requires a coordinated change on the other.
   - **Consume**: the env-repo layer (base / env overlay / region / cluster substitution) that wires it into the workload. Choose the narrowest correct layer.
   - Mirror the closest sibling service doing the same thing (`determine-patterns`); cite it.

6. **Cover every environment, including DR.** List each env/region/cluster where the resource or config must exist. If the system has DR overlays, invoke `maintain-dr-overlays` for the DR side. An infra change that skips an environment is a defect unless the integration is intentionally disabled there; say so explicitly.

7. **Order and ownership.** Provision before consume (IaC apply → env repo merge → app release that needs it). Mark repos owned by other teams as a handoff or request, not a PR you open. Feed the list into `decompose-ticket` / `plan-pr` as separate PRs.

8. **Validation plan.** For each PR, give the validation commands the repo uses (e.g. `kustomize build` / `flux build` with cluster substitutions, `terraform validate`/`tflint`, CI plan output). Infra is never applied locally unless the repo says so.

## Output

```markdown
## Infra Impact: <change>
Triggers checked: <list> → <none | found>
| # | Repo | Layer/root | Change | Envs (incl. DR) | Mirrors | Owner | Depends on |
Handoff contracts: <name/ARN/host that must match across repos>
Stale guidance found: <file:line — what's wrong>
Validation: <commands per PR>
```
