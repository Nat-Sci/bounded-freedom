---
name: cost-efficient-orchestration
description: Use for nontrivial research or repository work that needs Chief-led routing, bounded delegation, model choice, risk gates, verification, or independent review.
---

# Chief-first orchestration

Chief owns objective meaning, non-goals, decision constraints, unresolved scientific or architectural choices, assurance, routing, verification, and final acceptance. Scout supplies facts; Builder integrates an accepted boundary; Coder is the narrow implementation Writer; Reviewer supplies independent evidence. Workers do not become sub-Chiefs or redefine science.

Keep four decisions separate: task method; execution contract (direct or one of those four roles); model and reasoning effort; S0–S4 assurance. Select the concrete task kind and acceptance output before selecting a model. Use one matching specialized Skill for the method; freeze or close its handoff before changing methods. Roles and assurance do not select models.

## Dispatch only the needed rules

- For assurance above clear S0, read [scientific-risk.md](scientific-risk.md). Every code, configuration, executable-workflow, or routing mutation is at least S1. S3/S4 requires independent Reviewer evidence; S4 also requires explicit human acceptance.
- Before selecting a worker pair or changing hosts, read [host-model-routing.md](host-model-routing.md): canonical task-kind matrix, explicit unpinned profiles, launch controls, effort, speed/cost guidance, and mismatch handling. Reviewer starts Sol/high; ordinary defects, missing evidence, `BLOCK`, and profile mismatch require repair, not escalation. Astra requires documented Sol/high coherence shortfall.
- Before spawning, retrying, external mutation, compaction, or closure, read [operations-and-lifecycle.md](operations-and-lifecycle.md): freeze, roster, writer ownership, budget, checkpoints, recovery, and acceptance.
- For multi-phase work, substantial delegation, strong/frontier work, or calibration, read [hierarchical-routing.md](hierarchical-routing.md): balanced opportunity gate, context retirement, and production verification.
- For research method/claim boundaries read [research-lineage.md](research-lineage.md); for policy changes use [routing-evals.md](routing-evals.md).

Run deterministic commands and truly trivial micro-edits directly. For nontrivial work choose only needed roles, at most four open threads and one per canonical role; effective capacity is `min(policy, actual host limit)` or unknown. Reserve mandatory review and queue dependencies. Builder and Coder do not execute overlapping write turns. Workers never delegate or duplicate units. Strong/frontier Chief routes eligible discovery, integration, implementation, and review; direct retention needs a concrete handoff, tool, control, or availability cost.

Freeze objective, scope, permissions/prohibitions, acceptance, stop conditions, and unresolved choices before mutation or delegation. Keep one compact task record as an evidence index, not a raw log. Each worker gets exact ownership, accepted inputs, task kind/contract/assurance, requested pair and reason, effective permissions, checks, return/stop boundary, roster/writer state, and remaining budget. Bind both explicit launch controls; catalog/account presence alone is not support. Configured and observed pairs remain separate; stop on observed mismatch without rewriting the plan. Missing runtime is unknown. Frontier is not a fifth role and expands no boundary.

## One visible start receipt

Bootstrap instruction/host reads may precede this receipt. On Codex run [the read-only runtime probe](scripts/codex-runtime-metadata.sh) once when available before the first receipt; resolve it relative to this Skill. Never expose state paths or thread IDs. Other hosts use authoritative receipts or unknown. Configuration, supplied UI, inheritance, and runtime sources must be labeled separately; only authoritative host metadata establishes runtime. An observed current pair may explicitly become the planned continuation, without claiming original launch provenance.

Show one combined receipt before mutation or delegation; keep all eight named Chief fields visible even when unknown:

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

Current policy requires task/run start after accepted deployment or authoritative reload. A known pre-deployment task is stale; missing evidence is unknown. Current files, status output, application restart, planned routes, and child launch alone do not prove parent-policy adoption. A fresh child of a stale Chief has mixed attribution. Source edits cannot reload an existing session. The host reference and lifecycle reference own adapter details and usage comparisons.

There is no second start banner. Emit `ROUTE CHANGE` only for material method, role, worker, pair, assurance, or scope changes. Finish with `ROUTE END`: outcome, route, evidence, retries, lifecycle, remaining unknowns, and next handoff. Without a close control record `host_close=unsupported`; never claim closure or archive a user task.

## Pre-final resource receipt

For routed nontrivial Codex work run [the read-only resource adapter](scripts/codex-task-resource-snapshot.py) with `--format text` as the last tool call when Python/local event telemetry is available. Append its compact `TASK RESOURCE SNAPSHOT` after `ROUTE END`. It is a **pre-final checkpoint**, excluding the final response and later telemetry, not terminal accounting or an invoice. Other hosts use authoritative equivalents; unavailable adapters/fields remain unknown without estimates. Skip the extra call for trivial answers.

Keep task wall time separate from overlapping per-model active elapsed time (including tools/waits). Cached input is already included in input. Never infer cost, savings, quality, or scientific validity from counters. The adapter reports this Chief turn and direct-child turns started within it; a host post-turn receipt may supersede it.

## Evidence and privacy

Verify actual production diffs, outputs, comparisons, artifacts, and inspection proportional to the accepted claim; command success alone is not scientific validity. Stop when meaningful planned checks pass. Continue authorized reversible work without repeated permission requests, preserving actual sandbox boundaries and unrelated edits.

Use relative paths or neutral placeholders in artifacts, commands, retained logs, and returns. Do not expose local account names, absolute paths, hostnames, workspace/mount names, or private identifiers without explicit human authorization. Retain compact accepted evidence and uncertainty, not raw histories.

## Credits

Original local integration informed by [Agent Skills](https://agentskills.io/specification), [Codex subagents](https://learn.chatgpt.com/docs/agent-configuration/subagents), and the [harness landscape](../../../docs/harness-landscape.md). See the [adoption ledger](../../../docs/ecosystem-and-credits.md#adoption-ledger-by-local-skill).
