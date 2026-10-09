# Host and model routing

This adapter maps portable execution contracts to a host. Re-check availability, price, permissions, tool reliability, and context behavior when the host changes. An execution contract controls scope, ownership, permissions, and independence; a capability lane controls model family and effort.

## Metadata and precedence

The [entry Skill](SKILL.md#one-visible-start-receipt) owns planned/configured/runtime provenance and freshness receipts; [operations](operations-and-lifecycle.md#policy-freshness-and-usage-cohorts) owns cohort interpretation. The Codex probe supplies host-recorded session selection, not backend attestation or billing. It selects only the highest numeric state generation and fails closed instead of using older conflicting metadata; output omits paths and thread IDs. Catalog validation (for example, `codex debug models`) proves availability, not launch or runtime.

For Codex custom agents, a file's `model` or `model_reasoning_effort` takes precedence over explicit launch values, which take precedence over configured defaults and parent inheritance. See [Codex subagents](https://learn.chatgpt.com/docs/agent-configuration/subagents). The current package therefore omits both keys from all four role files and requires both explicit launch controls. A loaded host that still fixes a pair is not made dynamic by editing a source file; do not send conflicting overrides or claim the new adapter is active.

Checked 2026-09-30 against [GPT-6.1 Sol](https://developers.openai.com/api/docs/models/gpt-6.1-sol)
and [model selection](https://learn.chatgpt.com/docs/model-selection), with
explicit host catalog support for `gpt-6.1-sol` at medium and high. Official
guidance describes near-Astra complex work at lower cost and calls for evaluating
one's own tasks; this package makes no measured performance or savings claim.
Luna handles clear repeatable work; GPT-6.1 Sol spans balanced and strong lanes
through task-specific effort; Astra remains frontier. Revalidate exact IDs,
efforts, and launch controls when the host or documentation changes.

## Speed and cost provenance

Checked 2026-10-09: [Codex pricing](https://learn.chatgpt.com/docs/pricing), [speed](https://learn.chatgpt.com/docs/agent-configuration/speed), and [configuration reference](https://learn.chatgpt.com/docs/config-file/config-reference). Recommend Standard for cost-focused nonurgent work. Fast/Ultrafast needs a stated latency tradeoff, while preserving user-selected settings. Speed is separate from model family and reasoning effort: Fast consumes 2.5× included allowance or 2× purchased credits; Ultrafast consumes 8× or 6× respectively. API pricing is separate. Do not duplicate pricing tables or infer costs from local counters.

Record planned, configured, and observed service tier with evidence or `unknown`. The configuration reference maps `fast` to request priority and prefers `service_tier` for new turns; configured tier does not establish runtime or billed tier. Use only real host controls: no invented CLI arguments, automatic speed changes, quota polling, or capability-blocking gate when speed controls or telemetry are absent. This guidance leaves the task-kind matrix and explicit role profiles unchanged.

## Canonical task-kind matrix

Choose the task kind from the requested output, not a keyword such as "code"
or "review". This is the maintained starting matrix; other documents describe
the contracts and link here instead of defining competing model tables. The
pairs are local starting policies, not measured quality or price guarantees.
Direct deterministic commands and trivial micro-edits still need no worker.

In this current Codex adapter, Luna means `gpt-6-luna`, Sol means
`gpt-6.1-sol`, and Astra means `gpt-6-astra`. Historical fixtures and usage
retain their recorded model IDs; these aliases do not rewrite them.

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

Task method remains separate: for example, a mathematical Skill can request a
code map, a bounded analysis, or a later frozen edit. Ordinary source mapping
does not become mathematical analysis merely because a model has that ability.
Unresolved design, scientific choices, or conflicting specifications return to
Chief; the matrix does not authorize a worker to decide them. Routine review
cannot substitute for consequential review because the changed diff is small.

The same task kind can justify another pair when evidence identifies a limiting
factor: simple repeated structure may need less effort; coupled logic may need
balanced capability; a documented reasoning shortfall may need strong or
frontier capability. Keep the contract and authority unchanged. Select Luna or
Sol/medium by the work-unit boundary without trying every model in sequence.
Coupled state or API semantics start balanced; justified multiple interacting
invariants or stateful integration can start Sol/high. Failed checks require
diagnosis and repair before they establish a capability shortfall. A truly
trivial edit remains direct. Changing the model alone does not turn a
narrow Coder into a broader Builder or grant write access to Scout.

## Coder and Builder subtypes

Keep `code-edit` and `coordinated-build` as the parent task kinds. Choose one
of these starting policies from the frozen ownership and integration boundary,
not file count. Known deterministic commands and truly trivial changes remain
direct. These are starting policies, not a model-trial ladder, automatic
upgrade, or measured cost guarantee; unresolved scientific or architectural
choices return to Chief.

| Parent kind | Subtype | Frozen boundary | Starting model / effort |
| --- | --- | --- | --- |
| `code-edit` | Coder fixed transform | Repeated fixed transform with targeted checks | `gpt-6-luna` / low |
| `code-edit` | Coder straightforward local implementation | Completely specified local implementation with straightforward logic | `gpt-6-luna` / medium |
| `code-edit` | Coder ordinary bounded implementation | Branches or API semantics require ordinary implementation reasoning | `gpt-6.1-sol` / medium |
| `code-edit` | Coder invariant-sensitive bounded edit | Interacting state, gradient, numerical, or other invariants within the frozen edit | `gpt-6.1-sol` / medium; high only for justified multiple interacting invariants |
| `coordinated-build` | Builder frozen template integration | Template wiring across responsibilities, only when interface mappings, dependencies, steps, and checks are already frozen | `gpt-6-luna` / medium |
| `coordinated-build` | Builder ordinary coordinated integration | One ordinary coupled implementation boundary | `gpt-6.1-sol` / medium |
| `coordinated-build` | Builder stateful recovery integration | Agreed checkpoint, recovery, resource, or state transitions that must remain coherent | `gpt-6.1-sol` / high |

Coder versus Builder depends on narrow editing versus ownership and integration,
not the number of files. Template integration does not invent interfaces; it
uses those already accepted by Chief.

The maintained Codex Reviewer route starts at Reviewer / Sol / high for both
routine and consequential review. This is a local quality preference, not a
claim that every host must map Reviewer to Sol or that every task needs a
Reviewer. Astra remains an evidence-gated escalation inside the same contract
after a documented Sol/high cross-domain or cross-tool coherence shortfall; it
is not a fifth role. A cheaper executor may run objective checks, but it does not become the
independent Reviewer or satisfy an S3/S4 gate.

## Launch capability and quota evidence

After choosing the task pair, verify that the current worker API can supply its
exact model and effort, required permissions, and any needed fork control. A
catalog or account entry is not worker-launch authority: inability to honor the
pair is `unsupported`, not quota exhaustion. Do not preflight a nonexistent
candidate or poll merely because a task is starting.

When authoritative quota data is available for a supported candidate, retain
only source, freshness, applicable windows, and the decision. A known applicable
limit is `blocked` only when an applicable reached flag is explicit or any
applicable numeric usage is at least 100%; absent, incomplete, or failed quota
telemetry is `unknown`, not blocked. Unknown quota must not prevent an otherwise
supported selected pair. Do not redeem resets, purchase capacity, or start
monitoring without separate authorization.

Change the actual model/effort only with supported host controls or one declared
same-role replacement attempt inside the four-role roster, retaining ownership,
permissions, assurance, and independent review. A confirmed failure consumes
an attempt; inspect partial effects and confirm that the predecessor no longer
runs before replacement. A timeout does not free the role. Without host capacity
or remaining retry allowance, finish only minimal safe direct work or report the
needed control decision for substantial remaining work; never occupy another
role under a false label. A follow-up prompt cannot relabel the same model into
another route.

The target is low expected cost per accepted unit, including context, handoff,
rework, and verification. Model counts, unused quota, and incomplete local token
counters are not evidence of measured savings or a globally optimal routing.

## Effort and escalation

Select effort explicitly after selecting a capable model. These are starting
criteria, not automatic upgrades or a substitute for checking host support:

The GPT-6.1 Sol API supports `low`, `medium`, `high`, `xhigh`, and `max`, not
`none` or `minimal`. Do not translate those unsupported values implicitly.
Host `ultra` is a distinct host option, not evidence of API support; verify the
exact selected pair through the actual launch control.

- `low`: fixed fields or genuinely mechanical work with immediate checks.
- `medium`: ordinary bounded mapping, implementation, or stable synthesis.
- `high`: multiple interacting constraints, difficult diagnosis, or consequential independent review with a stated need.
- `xhigh`, `max`, or `ultra`: an explicit user choice or documented unresolved difficulty after a lower-effort/lower-lane attempt; only if that model and host support it. Max and Ultra are not normal defaults. Do not copy Chief's setting into all workers.

More files, a long history, model novelty, or unused quota do not by themselves
justify higher effort. First reduce the work packet and resolve specification
conflicts. Ordinary `BLOCK`, a code defect, missing evidence, profile mismatch,
missing context, broken tool/launch, or incomplete production integration is
not model inadequacy: fix that boundary first. For an actual unresolved
reasoning limitation, record the narrow question, evidence already checked,
missing capability, and expected extra check. Do not raise model and effort
together without saying which limitation each addresses. When depth is limiting
after a documented Sol/high shortfall, raise to a supported higher Sol effort;
when cross-domain or cross-tool coherence is limiting after that shortfall, use
Astra/medium. This is not a mandatory full ladder. After the hard decision is
accepted, re-evaluate the next unit for a lower adequate pair.

Chief's actual model/effort is not changed by this table. Preserve a user-selected
Chief; recommend or use a supported explicit control only within authority.
An expensive Chief doing a bounded check directly is reported as such, not as
a fictitious cheap-model route.

## Codex launch adapters

There is one current adapter, with exactly four canonical profiles. All omit
`model` and `model_reasoning_effort`; the launch supplies both explicitly:

| Contract and profile | Required sandbox |
| --- | --- |
| Scout | read-only |
| Coder | workspace-write |
| Builder | workspace-write |
| Reviewer | read-only |

No fixed-model counterpart or Routed alias remains in the active package. The
installer's [role manifest](../../../install/codex-role-files.txt) keeps install,
update, conflict preflight, and status on the same four-file inventory. Cleanup
of provably unmodified retired managed copies is migration hygiene, not a
second supported routing system; modified or foreign files remain protected.

Before launch:

1. Freeze the launch ticket using [operations](operations-and-lifecycle.md#freeze-and-budget) and the entry's worker contract.
2. Inspect the current host's advertised exact model IDs, supported efforts, effective permissions, and fork controls before launch. Use the canonical profile only when the host can honor the selected pair and permissions. Supply both actual launch arguments, never just a prompt or an inherited setting. A stale loaded profile that fixes the pair despite an unpinned source cannot honor conflicting values; report that deployment/session limitation instead of reinstating the old adapter.
3. Preserve the profile's actual sandbox and ownership. Check applicable runtime permission overrides; a read-only sentence is not a read-only sandbox. Shared/full-history spawning may forbid model overrides; use a supported compact fresh launch, not conflicting arguments.
4. Include the launch ticket in the worker's small context. Require a startup receipt with contract, task kind, profile, configured model/effort and source; add runtime values from a host receipt when available. Stop on an observed mismatch; do not rewrite the planned model/effort to fit it. A fresh route may be declared before fresh work, but the mismatched attempt does not satisfy the original review and still counts toward worker/attempt budget. Missing runtime metadata stays unknown, not a fabricated match.
5. If necessary controls are absent, distinguish unsupported launch capability from model quota. A different available model must still use enforceable permissions and actual controls. Otherwise continue only minimal direct work when appropriate or report the unsupported boundary. Never satisfy S3/S4 review with a cheap untyped fallback, and never claim source edits switched a running session.

The untyped Luna/low default is a defensive cost limit for unspecified calls,
not a valid typed route or a compatibility profile. Calling a role without explicit model
**and** effort is a routing error even if an inherited pair happens to work.
Changing model, effort, permission, or ownership after launch requires supported
host controls or a declared fitting same-role replacement within the attempt
budget; a follow-up message or role label alone does not perform that change.

### Fast-code gate

A request that merely mentions code does not select Coder. Use the Coder contract when the work requires an actual code edit-test loop, the interface and checks are frozen, ownership is narrow, failure is observable, and no unresolved scientific or architectural decision remains. Choose its explicit pair after the availability check. On a strong or frontier Chief, this is the default route even without parallel Chief work because it retires implementation context from the expensive lane. Run a test, formatter, or other known command directly; keep an obvious micro-edit direct when its full implementation is cheaper than the handoff. Use Builder instead when the change coordinates interfaces, migrations, or multiple coupled responsibilities. Pure code mapping follows the Scout row above and does not pass through this write gate.

The four packaged profiles explicitly carry their corresponding sandbox and
contract. A generic unpinned/default agent does not inherit those restrictions
merely from its prompt; use it only if the host can enforce the required
boundary and explicit pair. Otherwise return the limitation to Chief.

## A named role is visible but cannot start

An advertised profile is not a launch receipt. For `agent type is currently not
available`, first distinguish a rejected launch from an unknown or running child;
do not retry an unchanged configuration or create a replacement after a timeout.
Codex can display a symlinked role file but reject it when its secure launch reader
requires a regular file. Use managed regular copies for installed role TOMLs;
do not disable safe file loading. Skill directory links are a separate mechanism.

If repair is outside the authorized scope, a host-supported unpinned route may
carry the same frozen unit only with explicit model/effort, preserved ownership,
required permissions and independence, and remaining same-role attempt budget. Do not
treat default Luna/low as balanced Sol execution or consequential Reviewer evidence. If
the required boundary or review capability is unavailable, report that gate as
unmet. Direct continuation may do already authorized safe work, but must disclose
the actual Chief route rather than claim a lower-model handoff.

Keep three acceptance levels separate: files installed, child successfully
started, and configured/observed model and effort matched. Validate a changed
adapter with the next suitable bounded work unit outside the source repository;
do not spend allowance on artificial work or claim that installation alone fixes
existing sessions. See the [installer](../../../scripts/install-global.sh) and
[Codex custom agents](https://learn.chatgpt.com/docs/agent-configuration/subagents).

## Capability gates

Use the canonical matrix above to choose the work-unit pair. A model family can
span lanes: Sol/medium is balanced, while justified Sol/high work is strong.
Before non-review strong or frontier execution, apply the balanced opportunity
gate; it does not recursively reject balanced Sol/medium or require a Terra
trial. After the hard boundary is frozen, return predictable work to balanced
Sol/medium or fast Luna as appropriate. S3/S4 adds independent review and human
acceptance as applicable; it does not select Astra. These are starting decisions,
not an automatic escalation framework.

## GPT-6 Astra boundary

Astra is a frontier lane, not another execution contract. Reviewer work always starts at Sol/high. Astra may back the existing Reviewer contract only when a documented Sol/high shortfall identifies cross-tool or cross-domain coherence as the limiting factor; ordinary defects, missing evidence, profile mismatch, or a generic `BLOCK` return to input, implementation, or control repair. This is an evidence-gated escalation from the consequential-review starting route, not an `AstraReviewer` role. The review is independent only when a separate Reviewer performs it; an Astra Chief's self-review does not satisfy the S3/S4 gate, and S4 still requires human acceptance.

Start newly planned Astra work at medium; `xhigh`, `max`, and `ultra` require explicit user choice or the documented insufficiency above and host support. Effort availability and semantics, including `ultra`, are host-dependent. A Skill guides Chief decisions but cannot switch the active Chief; planned ideal lane is separate from actual runtime. Do not claim a hard automatic scheduler or that API effort/configuration changes alter the active desktop Chief. Do not silently reset a user-selected effort.

Optional calibration belongs to [hierarchical routing](hierarchical-routing.md#calibration); it never requires model shares, extra work, quota consumption, or inferred billing.

## Other hosts

Map the same four lanes to a host's least costly capable model: fast general, balanced coordinated, strong judgment/review, and a distinct verified frontier tier only when it exists. Test a new pair with one bounded read and one reversible edit before relying on it; API compatibility does not prove scientific reliability.
