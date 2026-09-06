---
name: cost-efficient-orchestration
description: Use for nontrivial research or repository work that needs Chief-led routing, bounded delegation, model choice, risk gates, verification, or independent review.
---

# Chief-first orchestration

The primary session is Chief: it owns intent, scope, scientific-risk classification, routing, verification, and the final decision. Do not create a Chief subagent. Keep four decisions independent: task method; execution contract (direct, Scout, Coder, Builder, Reviewer); model and effort; and S0–S4 assurance. Neither a role nor an assurance level selects a model.

Bootstrap reads needed to discover instructions or the host may precede the declaration. Before any mutation or delegation, freeze scope, permitted and prohibited actions, acceptance evidence, stop conditions, and unresolved choices. For nontrivial work, show one compact combined receipt and preserve its evidence in one `tasks/` record:

```text
CHIEF DECISION / ROUTE START
task method; assurance; execution; workers and total budget
Chief planned capability lane: fast | balanced | strong | frontier | UI-selected | unknown
Chief planned model: exact value | inherited | UI-selected | unknown
Chief planned reasoning effort: exact value | inherited | UI-selected | unknown
Chief runtime model: exact authoritative value | unknown
Chief runtime reasoning effort: exact authoritative value | unknown
Chief metadata source: explicit launch | host profile | runtime | supplied UI | inherited | UI-selected | unknown
phase/context; exact scope; verification; checkpoint/next safe action; rationale
```

Keep all six named Chief fields in this user-visible receipt, including unknowns; storing them only in a task file does not satisfy visibility. There is no second start banner. Keep detailed scope and evidence in the task record. Emit `ROUTE CHANGE` only for a material method, role, worker, model, effort, assurance, or scope change, and a compact `ROUTE END` with route, evidence, retries, lifecycle state, and remaining unknowns. Exact values require an explicit launch, loaded host profile, authoritative runtime receipt, or a value supplied by the UI; otherwise use `inherited`, `UI-selected`, or `unknown`. Launch or profile data proves configuration, not backend runtime. A Skill cannot silently switch Chief or infer hidden state.

Read [scientific-risk.md](scientific-risk.md) when the assurance classification is not clearly S0. Read [host-model-routing.md](host-model-routing.md) before selecting a worker model or adapting to another harness. Read [operations-and-lifecycle.md](operations-and-lifecycle.md) before spawning, retrying, external mutation, compaction, or lifecycle closure. Read [hierarchical-routing.md](hierarchical-routing.md) for phases, frontier work, calibration, or substantial delegation. Read [research-lineage.md](research-lineage.md) only when research Skills or claim lineage cross boundaries. Use [routing-evals.md](routing-evals.md) for policy changes without mutating project files.

## Select the smallest adequate route

1. Match one specialized Skill only when its method or deliverable is needed; otherwise use general work. A larger task closes or freezes one method unit before loading the next and passes only the needed lineage slice.
2. Split phases only for genuinely different methods, contexts, or capability limits. Freeze the unit before consequential work.
3. Select the execution contract from ownership and independence: direct for clear work; Scout for read-only discovery that would flood Chief context; Coder for narrow frozen edits; Builder for coordinated implementation; Reviewer only for independent evidence.
4. Select the least costly capable lane. Fast is for clear, reversible volume; balanced for stable synthesis or coordinated implementation; strong for ambiguous judgment or consequential independent review; frontier only for exceptional end-to-end coherence or a documented lower-lane shortfall.
5. Classify S0–S4 by highest plausible consequence. S3/S4 require independent Reviewer evidence; S4 also needs explicit human acceptance. These gates do not upgrade an executor or relax scientific authority.
6. Verify actual diffs, outputs, comparisons, artifacts, or inspection proportional to the accepted claim. Command success alone does not prove scientific validity.

Work directly for known deterministic commands. Do not spawn merely to run one. Default to zero workers; one is normal. Plan at most two distinct workers and two initial attempts; exceeding the user's limit requires their explicit approval and a revised decision. Permit one writing worker, no recursion, and no duplicate work. When Chief is fixed on an expensive lane and a substantial reversible coordinated unit has a frozen boundary, use one bounded balanced worker only if it has an independent work unit *and* Chief has useful concurrent work. A direct exception records the concrete handoff, tool, or availability cost; “Chief already knows the scope” is insufficient. Direct work on an expensive Chief is not a measured downgrade.

Before non-review strong or frontier execution, use the balanced opportunity gate: bounded, reversible, stable interface/evidence boundary, observable acceptance, detectable failure, and no unresolved scientific or architectural decision delegated. Keep mechanical work fast. Once the hard decision is frozen, return predictable implementation, extraction, tests, and formatting to the lower adequate lane. Do not create work, count models, or drain allowance to meet a quota. Optional bounded calibration compares accepted eligible work, first-pass acceptance, rework, elapsed time, evidence coverage, and authoritative cost or quota data when available; otherwise cost is unknown.

## Delegation, context, and recovery

Every worker message states objective, owned files/evidence, known inputs, permissions and prohibitions, required verification, return format, and stop conditions. Workers preserve unrelated edits and do not delegate. Chief consumes cited evidence instead of repeating assigned discovery.

Pass the smallest phase packet: frozen objective, active rules, bounded evidence/files, expected observable, verification, and return boundary. Checkpoint at a frozen decision, method or lane change, worker return, retired large context, or likely compaction. Preserve accepted inputs, changed artifacts, checks, route outcome, retries, worker lifecycle, unresolved items, and next safe action—not raw logs or private identifiers.

Use `planned -> running -> done | attention -> closed`. A timeout is unknown, not failure: inspect observable state and retry only a read-only or proven-idempotent operation once under the declared allowance. Never spawn a replacement after a wait timeout. Reuse an existing worker only when ownership and capability still fit. A lower model requires an actual host action: supported control or a genuinely new worker within budget with compact fresh context where needed, never a conceptual relabel. If no close control exists, record accepted/completed work separately from `host_close=unsupported`; do not claim process closure or archive a user task.

## Boundaries

Frontier is a capability lane, not a fifth role: it does not widen scope, authority, worker budget, assurance, privacy, or acceptance requirements. Model names, supported effort values, defaults, and launch controls belong in [host-model-routing.md](host-model-routing.md). Do not silently reset a user-selected model or effort, or infer current-session changes from configuration edits.

Keep repository artifacts, commands, retained evidence, and returns portable: use repository-relative paths or neutral placeholders; omit machine-specific absolute paths, account names, private hostnames, and local environment or mount names unless the user explicitly authorizes exact disclosure. Continue already authorized in-scope reversible work without repeated conversational permission requests; sandbox escalation remains required where the harness requires it. Stop when meaningful planned checks pass; do not add wording-mirror tests or rerun unchanged passes. Report outcome, changed artifacts, route end, metadata provenance, verification, deviations, and uncertainty. Report cost only from an authoritative source.

## Credits

This is an original local integration informed by the [Agent Skills specification](https://agentskills.io/specification), [Codex subagents](https://learn.chatgpt.com/docs/agent-configuration/subagents), and the repository [harness landscape](../../../docs/harness-landscape.md). See the [adoption ledger](../../../docs/ecosystem-and-credits.md#adoption-ledger-by-local-skill).
