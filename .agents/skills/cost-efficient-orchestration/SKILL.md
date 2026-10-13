---
name: cost-efficient-orchestration
description: Use for nontrivial research or repository work that needs Chief-led routing, bounded delegation, model choice, risk gates, verification, or independent review.
---

# Chief-first orchestration

Chief owns intent, non-goals, decision constraints, unresolved scientific/architectural choices, assurance, routing, verification, and acceptance. Workers cannot redefine science or become sub-Chiefs.

Separate task method, execution contract, model/effort, and S0–S4 assurance. Select task kind and acceptance output before model. Use one matching specialized Skill; freeze or close its handoff before changing methods. Run known deterministic commands and genuine micro-edits directly.

## Dispatch only the needed rules

- Above clear S0, read [scientific-risk.md](scientific-risk.md). Code, configuration, executable-workflow, and routing mutations are at least S1; S3/S4 needs independent Reviewer evidence, S4 human acceptance.
- For pair selection or host changes, read [host-model-routing.md](host-model-routing.md): canonical matrix, launch controls, effective permissions, quota, effort, escalation, and mismatch rules.
- For spawning, retries, external mutation, compaction, or closure, read [operations-and-lifecycle.md](operations-and-lifecycle.md): freeze/tickets, roster, budgets, recovery, milestones, and freshness.
- For substantial implementation, multi-phase/delegated work, strong/frontier execution, or calibration, read [hierarchical-routing.md](hierarchical-routing.md): implementation ownership, direct exceptions, production verification, targeted acceptance.
- For research claim/method boundaries read [research-lineage.md](research-lineage.md); for policy changes use [routing-evals.md](routing-evals.md).

Builder and Coder do not execute overlapping write turns. Preserve sandbox boundaries and unrelated edits; continue authorized reversible work without repeated permission requests.

## One visible start receipt

Bootstrap reads may precede the receipt. On Codex run [the read-only runtime probe](scripts/codex-runtime-metadata.sh) once when available, resolved relative to this Skill. It selects the highest numeric state generation and fails closed without older fallback. Omit state paths/IDs. Other hosts use authoritative receipts or unknown.

Show one combined receipt before mutation/delegation, including all eight named Chief fields even when unknown:

```text
CHIEF DECISION / ROUTE START
method; task kind/output; assurance; execution; planned role roster; current writing owner; initial/replacement attempt budget
Chief planned capability lane: fast | balanced | strong | frontier | UI-selected | unknown
Chief planned model: exact | inherited | UI-selected | unknown
Chief planned reasoning effort: exact | inherited | UI-selected | unknown
Chief runtime model: authoritative host value | unknown
Chief runtime reasoning effort: authoritative host value | unknown
Chief metadata source: explicit launch | host profile | runtime | supplied UI | inherited | UI-selected | unknown
Chief policy freshness: current | stale | unknown
Chief policy evidence: managed install marker plus task start | authoritative host reload | unknown
scope; verification; checkpoint/next safe action; rationale
```

Label configuration, supplied UI, inheritance, and runtime separately. Only authoritative host metadata establishes runtime, not backend attestation or billing. An observed pair may explicitly become the planned continuation without claiming original launch intent. [Freshness/cohort rules](operations-and-lifecycle.md#policy-freshness-and-usage-cohorts) govern policy evidence; source installation does not reload live sessions.

No second start banner. Emit `ROUTE CHANGE` for material method, role, worker, pair, assurance, or scope changes. Finish with `ROUTE END`: outcome, route, evidence, retries, lifecycle, unknowns, next handoff.

## Pre-final resource receipt

For routed nontrivial Codex work, run [the read-only resource adapter](scripts/codex-task-resource-snapshot.py) with `--format text` as the last tool call when Python/local event telemetry is available. Append `TASK RESOURCE SNAPSHOT` after `ROUTE END`. Other hosts use authoritative equivalents or unknown; skip trivial answers.

This pre-final checkpoint excludes the final response/later telemetry; it is not terminal accounting or an invoice. Coverage is this Chief turn and direct-child turns started within it: input, cached input, output, reasoning, and total tokens per model/effort. Keep task wall time separate from overlapping per-model active elapsed time, including tools/waits. Cached input is included in input. Missing fields stay unknown; counters establish neither cost/savings nor quality/scientific validity. A host post-turn receipt may supersede it.

## Evidence and privacy

For routine already-reviewed deployment use [deploy-verify.py](../../../scripts/deploy-verify.py) once for a compact batch receipt; its static file check always reports `live_route=not_run`. Chief reads changed/failed evidence and sufficient worker checks rather than repeating them. [Lifecycle rules](operations-and-lifecycle.md#resume-and-completion) scope any necessary independent live-route check.

Use production evidence proportional to the claim; command success alone is not scientific validity. Keep relative paths/neutral placeholders; exclude local accounts, absolute paths, hostnames, environment/workspace/checkout/mount names, IDs, raw histories/logs without explicit human authorization. Retain compact evidence and uncertainty.

## Credits

Informed by [Agent Skills](https://agentskills.io/specification), [Codex subagents](https://learn.chatgpt.com/docs/agent-configuration/subagents), and the [harness landscape](../../../docs/harness-landscape.md); see the [adoption ledger](../../../docs/ecosystem-and-credits.md#adoption-ledger-by-local-skill).
