---
name: cost-efficient-orchestration
description: Use for nontrivial research or repository work that needs Chief-led routing, bounded delegation, model choice, risk gates, verification, or independent review.
---

# Chief-first orchestration

The primary session is Chief: it owns intent, scope, scientific-risk classification, routing, verification, and the final decision. Do not create a Chief subagent. Keep four decisions independent: task method; execution contract (direct, Scout, Coder, Builder, Reviewer); model and effort; and S0–S4 assurance. Describe the concrete task kind and expected output before choosing a host profile. Neither a role nor an assurance level selects a model.

Bootstrap reads needed to discover instructions or the host may precede the declaration. Before any mutation or delegation, freeze scope, permitted and prohibited actions, acceptance evidence, stop conditions, and unresolved choices. For nontrivial work, show one compact combined receipt and preserve its evidence in one `tasks/` record:

```text
CHIEF DECISION / ROUTE START
task method; task kind; assurance; execution; workers and total budget
Chief planned capability lane: fast | balanced | strong | frontier | UI-selected | unknown
Chief planned model: exact value | inherited | UI-selected | unknown
Chief planned reasoning effort: exact value | inherited | UI-selected | unknown
Chief runtime model: exact authoritative value | unknown
Chief runtime reasoning effort: exact authoritative value | unknown
Chief metadata source: explicit launch | host profile | runtime | supplied UI | inherited | UI-selected | unknown
phase/context; exact scope; verification; checkpoint/next safe action; rationale
```

Keep all six named Chief fields in this user-visible receipt, including unknowns; storing them only in a task file does not satisfy visibility. There is no second start banner. Keep detailed scope and evidence in the task record. Emit `ROUTE CHANGE` only for a material method, role, worker, model, effort, assurance, or scope change, and a compact `ROUTE END` with route, evidence, retries, lifecycle state, and remaining unknowns. Exact values require an explicit launch, loaded host profile, authoritative runtime receipt, or a value supplied by the UI; otherwise use `inherited`, `UI-selected`, or `unknown`. Launch or profile data proves configuration, not backend runtime. A Skill cannot silently switch Chief or infer hidden state.

On Codex, before the first nontrivial receipt, run [the read-only runtime metadata probe](scripts/codex-runtime-metadata.sh) once when it is available, resolving the script relative to this loaded `SKILL.md`. An `observed` result fills the Chief runtime fields and uses `runtime` as metadata source; an unavailable result leaves them `unknown`. If Chief explicitly plans to keep the observed current pair for this phase, the same exact pair may appear in the planned fields; that records the new route decision, not original launch provenance. `inherited` is valid only when the host establishes inheritance, not merely because launch flags are invisible to the model. After a direct child returns, `--children` can verify the host-recorded role, model, effort, and lifecycle for `ROUTE END`. This Codex session record proves effective host selection, not a hidden backend snapshot, billing, or scientific quality. Other hosts use their own receipt or keep the values unknown; never expose state paths or thread IDs.

Read [scientific-risk.md](scientific-risk.md) when the assurance classification is not clearly S0. Read [host-model-routing.md](host-model-routing.md) before selecting a worker model or adapting to another harness; it owns the canonical task-kind matrix, effort rules, and launch adapter selection. Read [operations-and-lifecycle.md](operations-and-lifecycle.md) before spawning, retrying, external mutation, compaction, or lifecycle closure. Read [hierarchical-routing.md](hierarchical-routing.md) for phases, frontier work, calibration, or substantial delegation. Read [research-lineage.md](research-lineage.md) only when research Skills or claim lineage cross boundaries. Use [routing-evals.md](routing-evals.md) for policy changes without mutating project files.

## Select the smallest adequate route

1. Match one specialized Skill only when its method or deliverable is needed; otherwise use general work. A larger task closes or freezes one method unit before loading the next and passes only the needed lineage slice.
2. Identify the unit by its actual output: inventory, evidence map, code map, system map, code edit, coordinated build, bounded synthesis, or review. These are task kinds, not new Skills or standing workers. Split phases only for genuinely different methods, contexts, or capability limits. Resolve conflicting input specifications and freeze the effective unit before consequential work.
3. Select the execution contract from ownership and independence: direct for clear work; Scout for bounded read-only discovery or synthesis; Coder for narrow frozen edits; Builder for coordinated implementation; Reviewer only for independent evidence. Reading code is still Scout work; it does not require granting Coder write permissions.
4. Select model and effort separately using the unit's limiting factor and host matrix, then resolve a launch profile that can actually honor the pair and permissions. Fast is for clear, reversible volume; balanced for stable synthesis or coordinated implementation; strong for ambiguous judgment or consequential independent review; frontier only for exceptional end-to-end coherence or a documented lower-lane shortfall. A familiar role name, long context, or the Chief's effort is not a reason to inherit its model or effort.
5. Classify S0–S4 by highest plausible consequence. S3/S4 require independent Reviewer evidence; S4 also needs explicit human acceptance. These gates do not upgrade an executor or relax scientific authority.
6. Verify actual diffs, outputs, comparisons, artifacts, or inspection proportional to the accepted claim. Command success alone does not prove scientific validity.

Any mutation to code, configuration, executable workflow, or routing behavior starts at S1 even when narrow and reversible. S0 is limited to read-only work and presentation-only changes that cannot affect behavior or interpretation.

Work directly for known deterministic commands and truly trivial micro-edits; do not spawn merely to run one command. For an actual code change, use the fast-code gate: the interface and acceptance checks are frozen, file ownership is narrow, failure is observable, and no unresolved scientific or architectural choice controls the implementation. When that gate passes and Chief is strong or frontier, route a separable edit-test loop to the named Coder rather than retaining its code context in Chief. This handoff does not require parallel Chief work; keep it direct only when concrete setup or return cost is likely to exceed the context retired. Default to zero workers; one is normal. Plan at most two distinct workers and two initial attempts; exceeding the user's limit requires their explicit approval and a revised decision. Permit one writing worker, no recursion, and no duplicate work. When Chief is fixed on an expensive lane and a substantial reversible coordinated unit has a frozen boundary, use one bounded balanced worker only if it has an independent work unit *and* Chief has useful concurrent work. A direct exception records the concrete handoff, tool, or availability cost; “Chief already knows the scope” is insufficient. Direct work on an expensive Chief is not a measured downgrade.

Before non-review strong or frontier execution, use the balanced opportunity gate: bounded, reversible, stable interface/evidence boundary, observable acceptance, detectable failure, and no unresolved scientific or architectural decision delegated. Keep mechanical work fast. Once the hard decision is frozen, return predictable implementation, extraction, tests, and formatting to the lower adequate lane. Do not create work, count models, or drain allowance to meet a quota. Optional bounded calibration compares accepted eligible work, first-pass acceptance, rework, elapsed time, evidence coverage, and authoritative cost or quota data when available; otherwise cost is unknown.

## Delegation, context, and recovery

Every worker receives a compact launch ticket: task kind, execution contract, assurance, selected host profile, requested model and effort with selection reason, owned files/evidence, accepted inputs, permissions, observable checks, return format, stop conditions, and remaining worker budget. Bind model and effort through actual host controls; prose is not a model switch. Record configured and observed pairs separately, stop on an observed mismatch, and label missing runtime metadata unknown. Workers preserve unrelated edits and do not delegate. Chief consumes cited evidence instead of repeating assigned discovery.

Plan required review before allocating discovery. There is no mandatory Scout → Coder/Builder → Reviewer sequence: if execution and independent review need both worker slots, Chief performs minimal discovery directly. A Scout cannot become a writer by prompt or name change. Closed workers still count toward the total budget; a different profile does not create an extra allowance.

Pass the smallest phase packet: frozen objective, active rules, bounded evidence/files, expected observable, verification, and return boundary. Checkpoint at a frozen decision, method or lane change, worker return, retired large context, or likely compaction. Preserve accepted inputs, changed artifacts, checks, route outcome, retries, worker lifecycle, unresolved items, and next safe action—not raw logs or private identifiers.

Use `planned -> running -> done | attention -> closed`. A timeout is unknown, not failure: inspect observable state and retry only a read-only or proven-idempotent operation once under the declared allowance. Never spawn a replacement after a wait timeout. Reuse an existing worker only when ownership and capability still fit. A lower model requires an actual host action: supported control or a genuinely new worker within budget with compact fresh context where needed, never a conceptual relabel. If no close control exists, record accepted/completed work separately from `host_close=unsupported`; do not claim process closure or archive a user task.

## Boundaries

Frontier is a capability lane, not a fifth role: it does not widen scope, authority, worker budget, assurance, privacy, or acceptance requirements. Model names, supported effort values, defaults, and launch controls belong in [host-model-routing.md](host-model-routing.md). Do not silently reset a user-selected model or effort, or infer current-session changes from configuration edits.

Keep repository artifacts, commands, retained evidence, and returns portable: use repository-relative paths or neutral placeholders; omit machine-specific absolute paths, account names, private hostnames, and local environment or mount names unless the user explicitly authorizes exact disclosure. Continue already authorized in-scope reversible work without repeated conversational permission requests; sandbox escalation remains required where the harness requires it. Stop when meaningful planned checks pass; do not add wording-mirror tests or rerun unchanged passes. Report outcome, changed artifacts, route end, metadata provenance, verification, deviations, and uncertainty. Report cost only from an authoritative source.

## Credits

This is an original local integration informed by the [Agent Skills specification](https://agentskills.io/specification), [Codex subagents](https://learn.chatgpt.com/docs/agent-configuration/subagents), and the repository [harness landscape](../../../docs/harness-landscape.md). See the [adoption ledger](../../../docs/ecosystem-and-credits.md#adoption-ledger-by-local-skill).
