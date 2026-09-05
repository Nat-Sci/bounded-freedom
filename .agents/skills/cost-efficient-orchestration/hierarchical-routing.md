# Hierarchical routing and cost evaluation

Use this protocol when work spans several phases or capability lanes, when frontier capability is selected, or when a host's balanced lane is being calibrated. It refines the dispatcher without creating a standing agent hierarchy.

## Route phases, not whole tasks

A long request may contain work units with different limits. Freeze the current phase and make the four routing decisions for that phase only:

```text
admission -> bounded method -> execution and capability -> verification
          -> compact checkpoint -> next phase or stop
```

The hierarchy is a sequence of decisions, not a requirement to spawn more workers. Chief normally works directly or uses one worker, reuses a suitable worker for an in-scope follow-up, and retains the total worker budget across every phase.

## Keep the control plane thin

Chief retains the user's intent, non-goals, assurance, accepted evidence, unresolved choices, worker lifecycle, and final decision. A phase receives only:

- the frozen objective and permitted actions;
- the active method and relevant project rules;
- the smallest evidence or file slice needed for the work;
- the expected observable and verification command or inspection;
- the stop condition and next return boundary.

Do not pass the full conversation, raw logs, an entire literature corpus, or every Skill body when a compact accepted record is sufficient. Use deterministic inventory, filtering, comparison, and rendering before spending model context on judgment.

## Apply the capability ladder in both directions

Start with the least costly lane that clears the phase's limiting factor:

| Phase limit | Starting lane |
| --- | --- |
| Repeated fields, bulk discovery, or narrow reversible edits | Fast and economical |
| Stable synthesis, coordinated files, or bounded implementation with clear acceptance | Balanced |
| Ambiguous judgment, conflicting evidence, or consequential independent review | Strong reasoning |
| Exceptional end-to-end coherence across tools or domains, or a documented strong-lane shortfall | Frontier escalation |

Escalate one lane at a time after a relevant failure, unresolved ambiguity, or evidence conflict. Record why the lower lane was insufficient. After the difficult decision or design is frozen, route the predictable implementation, extraction, or formatting phase back down. A frontier entry is incomplete until its exit lane is considered.

## Balanced opportunity gate

Before assigning non-review execution to strong or frontier capability, ask whether all of the following are true:

- the work unit is bounded and reversible;
- its interfaces, evidence boundary, or expected observable are stable;
- a test, comparison, render, or inspection can decide acceptance;
- failure can be detected before consequential use;
- no unresolved scientific or architectural choice is being delegated.

When they are true, start in the balanced lane. When the unit is mechanical and high-volume, keep it in the fast lane; do not promote it merely to increase balanced-model usage. Reviewer independence and S3/S4 evidence requirements remain separate from this gate.

## Frontier control phase

Use frontier capability for the smallest phase that needs it. Appropriate work includes resolving a cross-domain design whose dependencies must remain coherent, integrating several tools when lower lanes have exposed material conflicts, or adjudicating an unresolved strong-review disagreement.

The frontier phase should return a frozen decision, interface, evidence boundary, or implementation contract that a lower lane can execute. It should not absorb bulk discovery, routine edits, repeated testing, or final formatting. If the frontier model remains Chief for host reasons, keep those lower-cost phases delegated or otherwise isolated from its standing context.

## Context and checkpoint budget

Declare an active context slice before each substantial phase:

```text
phase objective:
accepted inputs:
active Skill and project rules:
files or evidence in scope:
discarded or checkpointed context:
expected verification:
next safe action:
```

Checkpoint when the method changes, a decision is frozen, a worker return is accepted, a large evidence slice is no longer needed, or compaction is likely. Resume from the checkpoint plus observable repository or external state rather than reconstructing the full conversation.

## Route receipt

For nontrivial work, retain the smallest aggregate receipt needed to evaluate routing:

```text
phase:
task method:
execution contract:
planned capability lane:
actual host model and effort:
lower lane considered and decision:
context slice or size bucket:
verification and outcome: accepted | rework | escalated | blocked
retry count and escalation evidence:
elapsed-time bucket:
authoritative cost or quota source, when available:
```

Do not retain prompts, message or command bodies, private paths, row-level identifiers, or inferred billing. If the host's token or cost fields are incomplete, mark cost unknown.

## Evaluate accepted work, not model counts alone

Use an explicitly frozen calibration window when changing a route. Compare:

- balanced-opportunity capture: eligible balanced units that started there;
- first-pass acceptance and evidence coverage;
- rework, retry, and escalation rates;
- wall time to an accepted result;
- authoritative billed cost or account quota consumption when available;
- failures grouped by limiting factor rather than model prestige.

A higher model count is not success. Promote a route only when it preserves the required evidence and reduces expected cost per accepted work unit. Do not infer quality, causality, or billing from stored thread counts or unreliable token fields.
