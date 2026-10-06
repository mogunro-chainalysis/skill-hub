---
name: maintain-dr-overlays
description: Audit and update disaster-recovery (DR) GitOps overlays and IaC for prod parity. Use for "check DR parity", "update DR overlay", or prod DR changes.
---

# Maintain DR Overlays

Keep DR environments deployable: every dependency prod relies on exists in DR, or is intentionally disabled there.

## Procedure

1. **Load DR context.** Read the private infra map (`~/.agents-work/context/infra-map.md`, `~/.agents/.ai/infra-map.md`, or repo `.ai/infra-map.md`) for the DR layout, accounts, clusters, and **DR version policy** (does DR mirror prod, or follow a lower env?). Only policy-sanctioned differences count as intended. If there's no map or policy, ask the user before judging version skew.

2. **Find DR entrypoints from live config.** Work from a fresh `origin/main` worktree. Start at the cluster manifests (`flux/clusters/*`) and follow `spec.path` to each DR overlay. Don't assume a `dr/` directory exists: DR may be its own overlay, reuse a prod or lower-env overlay, or several DR clusters may share one overlay that differs only in substitutions. Read the repo's in-repo skills and docs first (`plan-infra-changes` step 4).

3. **Render, don't eyeball.** For prod and each DR cluster, render the final manifests with cluster substitutions applied (e.g. `flux build kustomization … --kustomization-file <cluster file> --dry-run`, or `kustomize build` when there are no substitutions). Diff prod against DR per workload.

4. **Classify every difference.**
   - **Intended:** fewer replicas, disabled integrations, DR hostnames, DR account/region IDs, and version skew if the policy allows it.
   - **Drift (fix):** a secret key, env var, config entry, volume, service account or IRSA annotation, route, or substitution variable that prod has and DR lacks without a stated reason.
   - **Broken:** unresolved `${VAR}`, malformed substitutions (separator or prefix inconsistencies), hardcoded regions in a shared DR overlay, or references to resources that don't exist in the DR account.

5. **Check the IaC side.** For each DR dependency (DB, cache, bucket, role, secret, CNAME), confirm the DR IaC root defines it with region-unique names. Also check whether DR plan/apply is enabled in CI, and that role trust covers the DR cluster OIDC.

6. **Check guardrails.**
   - Is DR built and validated in CI? (Path regexes often skip DR dirs.)
   - Does dependency automation (e.g. Renovate) update DR the way the policy requires?
   - Are any rules dead because they point at paths that don't exist?
   Report the gaps and recommend deterministic checks over prose.

7. **Apply changes at the narrowest layer.**
   - Shared defaults go in base.
   - DR-only values go in the DR overlay.
   - Per-cluster values go in the cluster substitutions.
   When you change a shared overlay, list every cluster that consumes it. Re-render to verify.

8. **Report.** Findings without a render or live check you ran are "suspected".

## Output

```markdown
## DR Audit: <repo> — <date>
Policy: <versions mirror prod | follow <env>> (source)
| Workload | DR cluster(s) | Finding | Class (intended/drift/broken) | Evidence | Fix (layer, file) |
IaC gaps: <resource — DR root — status>
Guardrail gaps: <CI / automation / dead rules>
```
