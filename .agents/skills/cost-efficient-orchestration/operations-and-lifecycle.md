# Operations, lifecycle, and recovery

Read for spawning, retries, external mutation, compaction, or closure. Use one task record, not another brief/log.

## Freeze and budget

Before substantial work freeze objective, task kind/output, accepted inputs, active rules, scope, permissions/prohibitions, observable acceptance/checks, stop conditions, unresolved choices, and next safe action. Resolve specification conflicts before delegation.

Select only needed Scout (facts), Builder (accepted-boundary integration), Coder (implementation Writer), and Reviewer (independent evidence). Normally one/two roles; at most four open threads, one per canonical role. Effective capacity is `min(policy maximum, actual host limit)`, or unknown. Queue dependencies and reserve feasible mandatory review; lower capacity does not assign substantive overflow to Chief. No nested delegation, duplicate units, or overlapping writer turns; one active writing owner.

Budget one initial launch per selected role, at most four initial attempts, normally zero and at most one declared same-role replacement for the whole task. Do not fill unused slots.

Each ticket names contract, task kind/assurance, requested model AND effort/reason, effective permissions, exact owned files/interfaces, accepted integration boundary/inputs, roster/current writer, observable checks, return boundary, stop conditions, and remaining budget. Workers receive only the bounded context. Update the existing evidence index after freeze and meaningful phases with worker state, changed artifacts/version or fingerprint when practical, checks/outcomes, gaps, repair owner, next action. [Host routing](host-model-routing.md#codex-launch-adapters) owns launch support, configured/runtime comparison, and mismatch handling.

## Milestone consolidation

Before the next substantial milestone, scope expansion, or goal/method/artifact-interface change, seal the prior boundary or mark it `incomplete` with missing checks/review/blocking questions. `verified` requires declared checks and applicable review; `accepted` requires an authorized recorded decision, explicit human acceptance for S4. A successful command alone is not acceptance. Retain failed/negative evidence; defer unrelated questions.

Keep a compact index: milestone scope/status; artifact/code/data/configuration version/fingerprint; checks and acceptance evidence; relative source pointers; frozen decision/promoted rule and its scope; deferred items; tooling decision; next bounded handoff/writer. Source artifacts stay authoritative. Do not paste logs/code/host histories/transcripts; keep incidental sensitive logs local/ignored or redact before retention.

Promote rules only within evidence-supported scope, never universalize one project's scientific result. For repeated stable transformations choose `reuse`, `extract`, `defer`, or `not-needed`. Extract only within authorization, with input/output contract, errors/limits, and verification; an existing-tool extension or tested script may suffice. No mandatory new tool/framework.

Next packets carry frozen objective/current rules, accepted facts/pointers, active artifact version, validation, unresolved decisions, next action. Retire bulky logs/inactive context from packets, not user data. Summaries neither compact host context nor reload stale policy; use actual host compaction or an authorized compact fresh handoff.

When new evidence/version invalidates a premise, explicitly reopen only the affected boundary, identify invalidated conclusions, and preserve historical acceptance/evidence. Do not rerun unrelated completed work by default. Consolidation never authorizes deletion/overwrite of user data, auto-archive, force-add of ignored records, auto-commit, or publishing. Shared documentation must not link ignored personal records.

## Resource snapshot

[The entry](SKILL.md#pre-final-resource-receipt) owns adapter/receipt coverage; no second telemetry pass or estimated fields.

## Policy freshness and usage cohorts

File deployment and loaded policy differ:

- `current`: task/run started after accepted managed deployment, or authoritative host reload receipt.
- `stale`: timestamps prove task/run predates deployment.
- `unknown`: deployment/start evidence unavailable.
- `mixed`: post-deployment child of stale or unknown Chief; observed runtime activity does not prove parent-policy adoption.

Surface freshness/evidence in the first nontrivial receipt. Current files/status, application restart, linked Skill update, planned routing, or child launch alone do not prove reload. Start/fork a new task after deployment for portable current-policy verification; do not call stale/unknown work a current-policy test.

Usage comparisons declare machine/host scope, project filter, deployment boundary, cohort, actual-launch evidence, internal auto-review separately, and token coverage. Planned/attempted/rejected/blocked routes are not actual launches; launch counts are not token use. Historical tokens/cost stay unavailable without full privacy-safe authoritative ledger coverage.

## Worker lifecycle

Track `planned -> running -> done | attention -> closed`; a return (`done`) is not acceptance. Inspect observable state, verify returns, close only completed work through supported controls. Do not edit host state or equate stored relationships with live processes. Without close support record `host_close=unsupported`, separating acceptance/completion from closure; never archive user tasks.

Before work, launch adapter and ticket must agree on contract, kind, model/effort, permissions, scope, roster/writer, and acceptance. Unknown runtime cannot prove routing success. Reuse only within fitting capability, ownership, and evidence boundaries. Model/effort change needs real supported control or a declared same-role replacement; compact fresh context must be a real handoff.

Confirmed termination or rejected launch requires partial-side-effect and writer-state inspection before handoff. Confirm predecessor stopped; timeout/unknown never permits replacement. Failed attempts consume budget; replacements cannot overlap or hide in another role.

Ordinary repair stays with the fitting writer under scope, availability, sandbox, attempt, and timeout controls. Transfer only by explicit handoff, not failure alone. Stop after two materially different failed attempts and return evidence to Chief; reuse grants neither unlimited retries nor broader ownership.

## Timeout and retry

Timeout means unknown. Classify operation and inspect observable state; continue when effect is visible. Within allowance, retry read-only or proven-idempotent work once, reusing an idempotency key if provided. Never retry ambiguous mutation. For worker wait timeout poll the same worker/status; no replacement. Record operation class, state check, retries, disposition.

## Resume and completion

After interruption/compaction re-read applicable instructions/record; inspect actual diffs, artifacts, external status, worker state, and retry counters. Resume only recorded next safe action. Authorized commits may anchor recovery but cannot substitute for evidence.

Use [targeted acceptance/rechecks](hierarchical-routing.md#balanced-gate-and-direct-work). Finish when meaningful planned verification answers the claim; no wording-mirror checks or unchanged reruns without evidence need. Authorized in-scope work needs no fresh conversational permission; sandbox escalation still applies.
