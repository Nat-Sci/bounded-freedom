# Host and model routing

Map portable contracts to real host controls; re-check availability, price, permissions, tool reliability, and context behavior on host changes. Contract controls ownership/permissions/independence; lane selects model/effort.

## Metadata and precedence

[Entry receipts](SKILL.md#one-visible-start-receipt) own provenance; [operations](operations-and-lifecycle.md#policy-freshness-and-usage-cohorts) owns freshness/cohorts. Catalog validation (e.g. `codex debug models`) proves availability, not launch/runtime.

Codex custom-agent file `model`/`model_reasoning_effort` overrides explicit launch, then defaults/inheritance ([official configuration](https://learn.chatgpt.com/docs/agent-configuration/subagents)). All four current role files omit these keys; both launch controls are mandatory. Source edits do not unpin a stale loaded profile: report the session boundary, never send conflicting overrides or claim adoption.

Checked 2026-11-18. GPT-6.2 Sol is the ordinary coding and PR model. GPT-6.2 Astra is for the hardest work across boundaries. GPT-6.1 Terra suits supplied material, visual and computer-use work, and scoped fixes. Revalidate the exact launch controls on the intended surface. The desktop worker catalog at intake omitted Luna, while CLI 0.169.0-alpha.11.1 advertised it with efforts through max. Only desktop GPT-6.2 Sol advertised Ultrafast at intake. Historical records keep their recorded values. [GPT-6.2 release](https://learn.chatgpt.com/docs/whats-new/gpt-62-astra-sol), [model selection](https://learn.chatgpt.com/docs/models?surface=app).

For a new task, prefer human-selected `gpt-6.2-sol` / max as Chief. Preserve the current Chief and any user-selected model or effort, including Astra/max. Worker starting pairs remain independent.

## Single-Chief cross-entry

Small local tasks stay direct at the actual entry. Planning may begin with human-led Astra, or an optional bounded Astra consultation under Sol only when the [capability gate](#capability-gates) admits it. A planner is never a second Chief and planning alone does not trigger escalation. With clear agreed scope and the user's instruction to continue, use the current conversation directly, without requiring a written brief or another confirmation; preserve human-owned choices and scientific gates.

For formal execution prefer one actual Sol/max primary, while honoring an explicitly chosen different formal model or effort. If the current primary can continue, dispatch in place and give one concise status within the existing receipts. Astra chosen only for opening/planning is not a choice of formal executor. If Sol/max is expressly required but the actual pair is nonmatching or unknown, pause model-dependent work; use the same-window desktop model/effort picker for the next turn, then verify. Do not claim a switch or use a hidden extra primary. A model-name claim or subagent is not a primary handoff. Create a fresh visible project task only when the human explicitly requests it and authorizes its model; Chief synthesizes the minimal accepted context directly, without a form, file, full history, or extra approval. After authorized transfer the planning entry stops competing execution. Report failure, mismatch or unknown without blind retries. Planning-only requests, irreversible actions, S3/S4 review and human gates remain unchanged.

Desktop native adapter: use `list_projects` to identify the correct project. For an explicitly requested fresh Sol/max project task with authorized selection, call `create_thread` with `model: gpt-6.2-sol`, `thinking: max`, a short synthesized context prompt and the correct local project target; do not copy full history. If unavailable, offer manual new task plus composer selection or the CLI below. No automatic setting changes.

For status only, use the active chat's runtime probe and current-turn receipt when available. Report the observed primary pair, policy freshness and evidenced workers for this turn; `--children` is thread history, not proof of current-turn activity. Distinguish installed files from loaded policy and leave unavailable evidence unknown. Status alone never starts a worker, switches a model or creates a chat; follow the per-turn resource receipt contract.

For a human-initiated CLI entry, invoke `sh scripts/start-sol-chief.sh` relative to this Skill: no arguments starts a fresh interactive Sol/max session in the caller's directory. Optional `--handoff FILE` starts fresh `codex exec` with the brief on stdin; `--ephemeral-read-only --handoff FILE` adds ephemeral, read-only JSON verification. Files must be regular, nonblank and at most 16 KiB; no file is required for ordinary continuation. The helper preserves host defaults and exit status, never forwards arbitrary flags or silently falls back. Workers do not automatically launch it. A configured pair is not a runtime attestation.

## Speed and cost provenance

Choose speed separately after selecting the model and sufficient reasoning effort. A deep decision can use Sol/max with [depth approval](#capability-gates). Astra/max also needs frontier admission. Use Standard when selecting speed without a different user preference. For time-sensitive, bounded execution, use `medium` when adequate. Request Fast when model response time is the bottleneck, the user has authorized the higher usage, and the launcher can bind the tier. Run known commands directly and apply the required review and acceptance checks. Consult the current rates for included allowance, purchased credits, or API billing as applicable. [Pricing](https://learn.chatgpt.com/docs/pricing), [speed](https://learn.chatgpt.com/docs/agent-configuration/speed).

The CLI can set `service_tier="fast"` for a single invocation. It maps to the request value `priority`. The desktop composer can select the primary session's speed. When the worker launcher exposes only model and effort, use the host's speed if acceptable and report a missing control if a specific tier is required. Record planned, configured, and observed service tiers with their sources, using `unknown` where evidence is absent. [Configuration](https://learn.chatgpt.com/docs/config-file/config-reference).

## Canonical task-kind matrix

[model-routing.json](model-routing.json) defines task and subtype → contract, lane and effort → ordered candidate models. Classify by bounded output. Known commands and trivial micro-edits stay direct.

- Scout uses `inventory`, `evidence-map`, `code-map` or `system-map` for discovery. Use `code-map --subtype interacting` for interacting state. Use `bounded-synthesis` for supplied materials, `--subtype visual` for visual work, and `--subtype interdependent` when relationships require complex reasoning. Office and application visual work stays within read access and the authorized scope.
- Coder uses `code-edit` for scoped frozen fixes. Use `fixed-transform` or `straightforward` for fully specified mechanical/local edits, `interdependent` or `invariant-sensitive` for edits requiring coordinated reasoning, and `interacting-invariants` for justified high effort.
- Builder uses `coordinated-build` for ordinary coupled work. Use `frozen-template` only with accepted interface mappings, dependencies, steps and checks. Use `stateful-recovery` for agreed interacting state, checkpoints or recovery.
- Reviewer uses `routine-review` for objective independent engineering checks and `consequential-review` for S3/S4 or similarly demanding judgments. High is the starting floor. GPT-6.1 Sol/high is the automatic same-family alternate when the current pair is absent or explicitly blocked. An explicit GPT-6.1 Sol/high selection is valid when the host can bind it and the pair is eligible.

For ordinary balanced and strong work, GPT-6.1 Sol is the automatic fallback when the current Sol pair is absent or explicitly blocked at the required effort. In mechanical and grounded work, the previous Sol generation is the last eligible substitute after the preferred capability choices.

Method stays separate. Unresolved design, science and specification conflicts return to Chief. Small diffs can still require consequential review.

### Resolve on the intended launch surface

From this Skill directory, run the [resolver](scripts/resolve-model-route.py) with Python 3.9 or newer. For an app worker, supply exact pairs that its launch controls advertise and can bind. For CLI, pass exact pairs or reuse an existing `codex debug models` JSON snapshot for that surface.

```sh
python3 scripts/resolve-model-route.py inventory --surface app-worker \
  --available gpt-6.1-terra/low gpt-6.2-sol/low
python3 scripts/resolve-model-route.py coordinated-build --surface cli \
  --cli-catalog cli-models.json
```

Use `--cli-catalog -` to read a snapshot from stdin. CLI catalog ingestion requires a `models` array and uses rows with `visibility: "list"`, a slug, and explicit `supported_reasoning_levels` efforts. Ignore hidden rows and unbindable entries. Reuse a snapshot for the applicable CLI context. The resolver reads local evidence and performs no model lookup. `--cli-catalog` and `--available` are mutually exclusive, and the app worker takes exact pairs from its own controls.

Omit the catalog argument when evidence is missing. An explicitly empty catalog is unavailable. Use `--exclude MODEL/EFFORT ...` for explicit applicable blocks, or omit blocked pairs when supplying exact pairs.

The compact JSON is a plan. A selected pair exits 0. Unknown or unavailable exits 1 with the reason. An automatic fallback names the preferred model and why earlier candidates were skipped. Preserve an explicit user pair with `--model` and `--effort`. A supported, eligible in-lane model selection reports `explicit_model` and carries no automatic fallback. If the request falls outside the approved route or its exact pair is unavailable, report the boundary to Chief.

A raised effort requires `--depth-approved` under the applicable gate. Frontier requires `--frontier-approved` and, for Reviewer, `--review-shortfall`. These flags record Chief's prior decisions. Before launch, verify the planned exact pair, permissions and role with the actual controls.

## Launch capability and quota evidence

Verify exact model AND effort controls, required permissions, and fork support for the selected pair before launch. Catalog/account presence without launch control is `unsupported`, not quota exhausted. Do not preflight a nonexistent candidate or poll merely at task start.

Use authoritative quota only for supported candidates; retain source/freshness, applicable windows, decision. Block only explicit applicable reached flags or numeric usage ≥100%; absent/incomplete/failed telemetry is `unknown`, not blocked. Unknown must not prevent otherwise supported selection. No reset redemption, capacity purchases, or monitoring without separate authorization.

[Lifecycle](operations-and-lifecycle.md#worker-lifecycle) owns replacement/terminal/side-effect checks. Without capacity/allowance, only minimal safe direct work or report a control decision for substantial work; never relabel another role or use prose as a model change. Optimize expected cost per accepted unit including context/handoff/rework/verification; counts, unused quota, incomplete token counters prove neither savings nor global optimality.

## Effort and escalation

Select explicit effort after capable model:
- `low`: fixed fields/mechanical work with immediate checks.
- `medium`: ordinary bounded mapping, implementation, stable synthesis.
- `high`: justified interacting constraints, difficult diagnosis, consequential review.
- `xhigh`/`max`/`ultra`: explicit user choice or specifically demonstrated depth need, with model AND host support; not ordinary worker defaults or copied Chief settings. The new-task Chief preference is separate.

Check each exact effort on the selected launch surface. API effort names, including API max, do not establish desktop or CLI support. Never silently translate an effort.

Use the [decision gate](#capability-gates) for depth and frontier admission. File count, history length, novelty, unused quota, S level, or simple failure does not justify escalation. Re-evaluate stable next work down.

Preserve user-selected Chief settings. Skills/tables do not switch active Chief or implement hard scheduling; use real authorized controls and disclose direct expensive-Chief work as such.

## Codex launch adapters

Exactly four unpinned canonical profiles; no fixed counterparts/Routed aliases:

| Contract and profile | Required sandbox |
| --- | --- |
| Scout | read-only |
| Coder | workspace-write |
| Builder | workspace-write |
| Reviewer | read-only |

The [role manifest](../../../install/codex-role-files.txt) defines install/update/conflict/status inventory; outside files remain untouched. Terra/low is the defensive default for untyped calls only.

1. Freeze the [ticket](operations-and-lifecycle.md#freeze-and-budget).
2. Resolve the plan using [exact advertised pairs](#resolve-on-the-intended-launch-surface). Verify effective permission overrides and fork controls, then pass both actual launch arguments. Stale fixed profiles cannot honor conflicting values.
3. Enforce actual sandbox/ownership; read-only prose is insufficient. Full-history may forbid overrides; use a supported compact fresh launch, never unsupported arguments.
4. Require startup contract/kind/profile, configured pair/source, runtime receipt or unknown. Stop on observed mismatch; do not rewrite the planned model/effort to fit it. A fresh declared route needs fresh work; mismatched attempts consume budget and fail original review. Unknown is not a verified match.
5. Absent controls are unsupported, distinct from quota. A separately justified supported pair still needs enforceable permissions/independence; otherwise report the boundary or do minimal safe direct work. No cheap untyped S3/S4 review or claimed live switch from source edits.

Model/effort/permission/ownership changes need supported controls or fitting declared same-role replacement within budget, not follow-up prose. Generic unpinned/default agents qualify only with enforced boundary and explicit pair.

### Fast-code gate

Coder owns frozen narrow edit-test-repair with stable interface/checks, observable failure, no unresolved science/architecture. Builder owns coupled integration; code mapping stays Scout. [Implementation rules](hierarchical-routing.md#balanced-gate-and-direct-work) own offload, exceptions, and repair.

## A named role is visible but cannot start

An advertised profile is not a launch receipt. For unavailable-agent errors distinguish rejection from unknown/running child; no unchanged blind retry or timeout replacement. Codex may display symlinked TOMLs yet require secure-readable regular files: use managed copies, never disable safe loading. Skill links differ.

If repair is out of scope, a supported unpinned fallback must retain frozen ownership, explicit pair, permissions, independence, remaining same-role budget. Otherwise report unmet control/review gates; safe direct continuation discloses actual Chief route.

Separate installation, successful child start, configured/observed pair match. Verify changed adapters on the next suitable real unit outside this source repository (local profiles may mask broken installation), without artificial allowance use. Partial linked-Skill updates without refreshed profiles are not complete deployment. See [installer](../../../scripts/install-global.sh).

## Capability gates

After freezing the unit and checking inputs, apply these in order:

1. Run a known cheap check first if it decides the issue. Missing evidence or permissions, an ordinary defect, or broken control calls for gathering or repair; a human-owned choice goes to the human. Do not escalate around the gap.
2. Route separable pieces to lower capable bounded units, even when numerous; consider only the inseparable residual. Keep the existing roles, permissions, writer and budget.
3. Deep reasoning means coherent assumptions need more reasoning within the same well-defined unit; it is distinct from the verified joint contradiction in step 4. For demonstrated depth use supported Terra/max for a suitable scoped unit or Sol/max for interdependent reasoning, within the fitting role. Explicit user requests may select supported max for a unit; do not exhaust a trial ladder. Starting matrix pairs still fit ordinary work.
4. Astra admission requires documented, verified constraints from different tools or domains that are inseparable, plus a concrete integration contradiction or failed end-to-end check/counterexample, one bounded question, and a discriminating check and stop. Existing Sol/max Chief evidence or verified comparable Sol evidence at intake can qualify without a duplicate worker or trial launch. Reviewer additionally requires documented independent Sol/high coherence shortfall.

Use a fitting existing role and real pair controls with remaining budget for one compact Astra/medium consult by default. The previous Astra generation is an explicitly reported same-family alternate. Higher effort needs separate evidence. If unavailable or occupied without suitable control, queue or report. Ticket: `role/pair | verified inputs and contradiction | question | check/stop | scope/budget`. Example: a durable checkpoint and external event log each pass locally, but a verified crash/retry counterexample shows each local-only repair double-counts or loses a confirmed event; one shared replay checks both. By contrast, fixed 80 input and 30 cached is directly checkable. On pass, return verifiable evidence to the same accountable primary session (normally the preferred Sol/max Chief), which verifies it and assigns implementation down; no second Chief or silent switch. On failure or unknown, stop or surface the human choice. No expanded permissions or acceptance authority.

Sol/medium is balanced; justified Sol/high is strong. Before non-review strong or frontier execution apply the [balanced gate](hierarchical-routing.md#balanced-gate-and-direct-work) to eligible work, without mandatory trial launches. S3/S4 retain review/human gates and do not themselves select Astra.

## Frontier boundary

Frontier is not a fifth contract and expands no scope, authority, permissions, roster, assurance, or acceptance. Apply the [decision gate](#capability-gates). Reviewer starts Sol/high and remains independent; no `AstraReviewer` role. Astra Chief self-review is not independent; S3/S4 review and S4 human acceptance remain required.

[Calibration](hierarchical-routing.md#calibration) is optional.

## Other hosts

Map lanes to least costly capable fast/balanced/strong models and distinct verified frontier only if available. Test new pairs with one bounded read and one reversible edit; API compatibility is not scientific reliability.
