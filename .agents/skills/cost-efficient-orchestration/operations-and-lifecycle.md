# Operations, lifecycle, and recovery

Use this reference when work may spawn, retry, mutate external state, compact, or outlive the current context. It supplements one task record; it does not create another.

## Freeze and budget

Before a substantial phase, state objective, task kind, accepted inputs, active rules, files/evidence in scope, expected verification, and next safe action. Resolve conflicts between old and current specifications before delegation. Record planned distinct workers (normally zero or one, at most two), initial spawn attempts (at most two), and retry allowance (normally zero; one only for a known safe transient retry). Reserve mandatory review before allocating a Scout. Concurrency, profile variants, and closure do not expand or reset the total budget. A second worker needs independent review or non-overlapping evidence. Allow one writing owner and no nested delegation.

Update the existing task record after scope freeze and each meaningful phase with the compact decision/route evidence, accepted inputs, worker state, changed artifacts, checks, unresolved uncertainty, and next safe action. Keep retained evidence portable and concise; omit raw logs and local identifiers.

## Resource snapshot

Close routed nontrivial work with a compact host-telemetry snapshot when an adapter is available. On Codex, run `scripts/codex-task-resource-snapshot.py --format text` relative to this Skill as the final tool call, then place the result after `ROUTE END`. The inline snapshot is intentionally read-only and pre-final: it does not include the response that presents it. Exact terminal accounting requires a host-side post-turn hook or later reconciliation.

Report task wall elapsed time separately from each model/effort row. A row's active elapsed time is end-to-end turn time, including its tool and wait activity; it is not pure inference latency, and concurrent rows may overlap. Report input, cached input, output, reasoning output, and total tokens only when observed. Cached input is a subset of input, not an additional quantity. Missing coverage remains unknown. Never retain raw rollout events or expose paths, IDs, prompts, account data, or billing metadata; never convert telemetry into an unverified cost or savings claim. Skip the extra snapshot call for trivial direct answers.

## Worker lifecycle

Track `planned -> running -> done | attention -> closed`. `done` means a return arrived, not that it was accepted. Inspect current observable worker state, consume and verify completed returns, and close only completed work through a supported host control. Do not edit host state, archive a user task, or treat a stored relationship as a live process.

Before task work, check the selected launch adapter and the worker's ticket:
contract, task kind, requested model/effort, effective permission boundary,
scope and acceptance must agree. Record configured and observed pairs
separately; stop on an observed mismatch and never repair it by rewriting the
planned pair. A fresh route may be declared before fresh work, but the
mismatched attempt still consumes its worker/attempt budget and does not
satisfy the original review. An unknown runtime value stays unknown and cannot
establish a successful runtime-routing test.

Apply the host reference's availability filter before launch. When Spark is the
candidate, require its immediately-pre-launch fresh quota preflight; a prior
snapshot does not authorize a new Spark launch. After a confirmed quota
termination or rejected launch, inspect partial side effects and writer state
before a real Luna/Terra handoff; unknown/time-out state never authorizes a
replacement. Failed workers still consume the total budget. A reset time does
not justify interrupting a healthy fallback or claiming the blocked model has
recovered.

If the host cannot close a completed worker, record acceptance/completion separately from `host_close=unsupported`; do not say its process was closed. Reuse a worker only inside its ownership and evidence boundary and only when its capability still fits. A model or effort change requires host-supported control or a genuinely new worker within the remaining budget; when a lower lane needs compact fresh context, make that handoff real.

Stop a worker after two materially different failed attempts and return the
evidence to Chief. Reuse does not grant unlimited retries or broaden ownership.

## Timeout and retry

A timeout means the result is unknown. Classify the operation, inspect observable state, and continue when the effect is visible. Under the declared allowance, retry only read-only or proven-idempotent work once (reuse an idempotency key when provided). Never retry ambiguous mutation. On a worker wait timeout, poll the same worker/status; do not spawn a replacement. Record operation class, state check, retries, and final disposition.

## Resume and completion

After interruption or compaction, re-read applicable instructions and the task record; inspect actual diffs, artifacts, external status, worker lifecycle, and retry counters; then resume only the recorded next safe action. A commit may be a recovery anchor when authorized, but never substitutes for evidence. Run meaningful planned verification and finish once it answers the claim; do not add wording-mirror checks or repeat unchanged successful runs. Already authorized in-scope work needs no fresh conversational permission, though required sandbox escalation still applies.
