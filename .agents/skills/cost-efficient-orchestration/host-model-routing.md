# Host and model routing

Map portable contracts to real host controls; re-check availability, price, permissions, tool reliability, and context behavior on host changes. Contract controls ownership/permissions/independence; lane selects model/effort.

## Metadata and precedence

[Entry receipts](SKILL.md#one-visible-start-receipt) own provenance; [operations](operations-and-lifecycle.md#policy-freshness-and-usage-cohorts) owns freshness/cohorts. Catalog validation (e.g. `codex debug models`) proves availability, not launch/runtime.

Codex custom-agent file `model`/`model_reasoning_effort` overrides explicit launch, then defaults/inheritance ([official configuration](https://learn.chatgpt.com/docs/agent-configuration/subagents)). All four current role files omit these keys; both launch controls are mandatory. Source edits do not unpin a stale loaded profile: report the session boundary, never send conflicting overrides or claim adoption.

Checked 2026-09-30: [GPT-6.1 Sol](https://developers.openai.com/api/docs/models/gpt-6.1-sol), [selection](https://learn.chatgpt.com/docs/model-selection), and explicit catalog support at medium/high. Guidance describes near-Astra complex work at lower cost but requires own-task evaluation; no measured savings/performance claim here. Revalidate exact IDs, efforts, and controls when host/docs change.

## Speed and cost provenance

Checked 2026-10-09: [pricing](https://learn.chatgpt.com/docs/pricing), [speed](https://learn.chatgpt.com/docs/agent-configuration/speed), [configuration](https://learn.chatgpt.com/docs/config-file/config-reference). Recommend Standard for cost-focused nonurgent work; Fast/Ultrafast needs a latency tradeoff while preserving user selections. Speed differs from family/effort: Fast uses 2.5× included allowance or 2× purchased credits; Ultrafast 8×/6×. API pricing is separate; no copied pricing tables or inferred local-counter costs.

Record planned/configured/observed service tier and sources or unknown. Configuration maps `fast` to request priority and prefers `service_tier` for new turns; configuration proves neither runtime nor billed tier. No invented arguments, automatic speed changes, quota polling, or capability block for absent speed controls/telemetry.

## Canonical task-kind matrix

Choose from bounded output, not “code”/“review” keywords. These local starting policies are not guarantees or a trial ladder; known commands/trivial micro-edits stay direct. Luna = `gpt-6-luna`, Sol = `gpt-6.1-sol`, Astra = `gpt-6-astra`; historical IDs remain unchanged.

| Task kind | Bounded output | Contract | Starting model / effort |
| --- | --- | --- | --- |
| `inventory` | Fixed-field extraction, file/configuration inventory | Scout | `gpt-6-luna` / low |
| `evidence-map` | Source/document evidence with stable concepts | Scout | `gpt-6-luna` / medium |
| `code-map` | Existing calls, branches, parameter flow, or test locations in a bounded source slice | Scout | `gpt-6-luna` / medium for straightforward flow; `gpt-6.1-sol` / medium for interacting state or cross-module constraints |
| `system-map` | Related interfaces, state flow, or cross-module dependencies | Scout | `gpt-6.1-sol` / medium |
| `bounded-synthesis` | Reconcile an accepted evidence set without making the final scientific decision | Scout | `gpt-6.1-sol` / medium |
| `code-edit` | Narrow frozen implementation and its targeted checks | Coder | See Coder subtypes below |
| `coordinated-build` | One coherent implementation boundary across coupled files/interfaces | Builder | See Builder subtypes below |
| `routine-review` | Independent bounded engineering check with objective acceptance, no consequential inference or primary-claim decision | Reviewer | `gpt-6.1-sol` / high |
| `consequential-review` | Independent S3/S4 or similarly demanding judgment | Reviewer | `gpt-6.1-sol` / high |

Method stays separate: mathematical work may request mapping, analysis, or later frozen editing; model ability does not change method. Unresolved design/science/specification conflicts return to Chief. Small diffs do not turn consequential review into routine review.

Choose another pair only with bounded limiting-factor evidence: simple repetition may need less effort; coupled state/API starts balanced; justified multiple interacting invariants/stateful integration may start Sol/high. Diagnose/repair failed checks before claiming capability shortfall. Pair changes never broaden contract or give Scout write access.

## Coder and Builder subtypes

Keep parent kinds; subtype follows frozen ownership/integration, not file count. Template integration uses accepted mappings/dependencies/steps/checks rather than inventing interfaces.

| Parent kind | Subtype | Frozen boundary | Starting model / effort |
| --- | --- | --- | --- |
| `code-edit` | Coder fixed transform | Repeated fixed transform with targeted checks | `gpt-6-luna` / low |
| `code-edit` | Coder straightforward local implementation | Completely specified local implementation with straightforward logic | `gpt-6-luna` / medium |
| `code-edit` | Coder ordinary bounded implementation | Branches or API semantics require ordinary implementation reasoning | `gpt-6.1-sol` / medium |
| `code-edit` | Coder invariant-sensitive bounded edit | Interacting state, gradient, numerical, or other invariants within the frozen edit | `gpt-6.1-sol` / medium; high only for justified multiple interacting invariants |
| `coordinated-build` | Builder frozen template integration | Template wiring across responsibilities, only when interface mappings, dependencies, steps, and checks are already frozen | `gpt-6-luna` / medium |
| `coordinated-build` | Builder ordinary coordinated integration | One ordinary coupled implementation boundary | `gpt-6.1-sol` / medium |
| `coordinated-build` | Builder stateful recovery integration | Agreed checkpoint, recovery, resource, or state transitions that must remain coherent | `gpt-6.1-sol` / high |

The maintained Codex Reviewer route starts at Reviewer / Sol / high for routine and consequential review; a local preference, not mandatory review for every task/host. Cheaper objective-check executors are not independent Reviewer evidence.

## Launch capability and quota evidence

Verify exact model AND effort controls, required permissions, and fork support for the selected pair before launch. Catalog/account presence without launch control is `unsupported`, not quota exhausted. Do not preflight a nonexistent candidate or poll merely at task start.

Use authoritative quota only for supported candidates; retain source/freshness, applicable windows, decision. Block only explicit applicable reached flags or numeric usage ≥100%; absent/incomplete/failed telemetry is `unknown`, not blocked. Unknown must not prevent otherwise supported selection. No reset redemption, capacity purchases, or monitoring without separate authorization.

[Lifecycle](operations-and-lifecycle.md#worker-lifecycle) owns replacement/terminal/side-effect checks. Without capacity/allowance, only minimal safe direct work or report a control decision for substantial work; never relabel another role or use prose as a model change. Optimize expected cost per accepted unit including context/handoff/rework/verification; counts, unused quota, incomplete token counters prove neither savings nor global optimality.

## Effort and escalation

Select explicit effort after capable model:
- `low`: fixed fields/mechanical work with immediate checks.
- `medium`: ordinary bounded mapping, implementation, stable synthesis.
- `high`: justified interacting constraints, difficult diagnosis, consequential review.
- `xhigh`/`max`/`ultra`: explicit user choice or documented unresolved difficulty after lower effort/lane, with model AND host support; never normal defaults or copied Chief settings.

Sol API supports low/medium/high/xhigh/max, not none/minimal; never translate silently. Host ultra is distinct, not API support.

File count, history length, novelty, unused quota do not justify effort. Reduce packets/resolve conflicts first. Ordinary BLOCK, defects, missing evidence/context, profile mismatch, broken tools/launches, and incomplete production integration need repair. For reasoning limits record narrow question, checked evidence, missing capability, expected extra check; justify model and effort separately. Documented Sol/high depth shortfall supports higher Sol effort; coherence shortfall supports Astra/medium, without a mandatory full ladder. Re-evaluate stable next work down.

Preserve user-selected Chief settings. Skills/tables do not switch active Chief or implement hard scheduling; use real authorized controls and disclose direct expensive-Chief work as such.

## Codex launch adapters

Exactly four unpinned canonical profiles; no fixed counterparts/Routed aliases:

| Contract and profile | Required sandbox |
| --- | --- |
| Scout | read-only |
| Coder | workspace-write |
| Builder | workspace-write |
| Reviewer | read-only |

The [role manifest](../../../install/codex-role-files.txt) defines install/update/conflict/status inventory; outside files remain untouched. Untyped Luna/low is defensive fallback, never a valid typed route.

1. Freeze the [ticket](operations-and-lifecycle.md#freeze-and-budget).
2. Inspect advertised exact IDs, efforts, effective permission overrides, fork controls; supply both actual launch arguments, never prose/inheritance alone. Stale fixed profiles cannot honor conflicting values.
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

Sol/medium is balanced; justified Sol/high is strong. Before non-review strong or frontier execution apply the [balanced gate](hierarchical-routing.md#balanced-gate-and-direct-work), never recursively to balanced Sol or through a retired-model trial. Frozen predictable work returns balanced/fast. S3/S4 adds review/human gates, not Astra selection.

## GPT-6 Astra boundary

Frontier is not a fifth contract and expands no scope, authority, permissions, roster, assurance, or acceptance. Reviewer starts Sol/high; only documented Sol/high cross-tool/domain coherence shortfall permits Astra in that same contract, not an `AstraReviewer` role. Ordinary defects, missing evidence, profile mismatch, generic BLOCK require repair. Astra Chief self-review is not independent; S4 still needs human acceptance.

Start newly planned Astra work at medium. Higher xhigh/max/ultra needs user choice or documented insufficiency and host support; preserve existing user effort. [Calibration](hierarchical-routing.md#calibration) is optional.

## Other hosts

Map lanes to least costly capable fast/balanced/strong models and distinct verified frontier only if available. Test new pairs with one bounded read and one reversible edit; API compatibility is not scientific reliability.
