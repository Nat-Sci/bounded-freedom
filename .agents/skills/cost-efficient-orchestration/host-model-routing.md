# Host and model routing

This adapter maps portable execution contracts to a host. Re-check availability, price, permissions, tool reliability, and context behavior when the host changes. An execution contract controls scope, ownership, permissions, and independence; a capability lane controls model family and effort.

## Metadata and precedence

Report planned lane and configured model/effort separately from runtime-observed model/effort. An explicit launch or loaded profile establishes only configuration. A UI-provided value is `UI-selected`, not backend-confirmed. Without an authoritative host receipt, exact Chief runtime model and effort are `unknown`; never infer them from behavior, latency, prose, or a configuration update. After observing the current pair, Chief may explicitly plan to continue the bounded phase on that pair and record it in both planned and runtime fields with source `runtime`; this is a current route decision, not evidence of the launcher's original intent.

For Codex, the entry Skill's read-only runtime metadata probe may supply a host-recorded current-thread pair and direct-child pairs. Treat `status=observed` as runtime session evidence and `status=unknown` as no evidence. The probe is an optional Codex adapter: it must fail closed, emit no local path or thread identifier, and never be required by another harness. Use `codex debug models` separately to validate that configured model IDs and effort values exist in the current catalog; catalog presence is availability evidence, not a launch or runtime receipt.

The same probe may compare a managed deployment marker with the current task start and report policy freshness. This is separate from model runtime evidence. A fresh child of a stale Chief can prove its own observed model/effort while the route remains a `mixed` policy cohort; never use that child to claim the parent loaded the latest Skill or global instructions.

For Codex custom agents, a file's `model` or `model_reasoning_effort` takes precedence over explicit launch values, which take precedence over configured defaults and parent inheritance. See [Codex subagents](https://learn.chatgpt.com/docs/agent-configuration/subagents). The current package therefore omits both keys from all four role files and requires both explicit launch controls. A loaded host that still fixes a pair is not made dynamic by editing a source file; do not send conflicting overrides or claim the new adapter is active.

## Canonical task-kind matrix

Choose the task kind from the requested output, not a keyword such as "code"
or "review". This is the maintained starting matrix; other documents describe
the contracts and link here instead of defining competing model tables. The
pairs are local starting policies, not measured quality or price guarantees.
Direct deterministic commands and trivial micro-edits still need no worker.

| Task kind | Bounded output | Contract | Starting model / effort | When Spark is blocked |
| --- | --- | --- | --- | --- |
| `inventory` | Fixed-field extraction, file/configuration inventory | Scout | `gpt-5.6-luna` / low | Unchanged |
| `evidence-map` | Source/document evidence with stable concepts | Scout | `gpt-5.6-luna` / medium | Unchanged |
| `code-map` | Existing calls, branches, parameter flow, or test locations in a bounded source slice | Scout | `gpt-5.3-codex-spark` / medium | Luna / medium for straightforward flow; Terra / medium for interacting state or constraints |
| `system-map` | Related interfaces, state flow, or cross-module dependencies | Scout | `gpt-5.6-terra` / medium | Unchanged |
| `bounded-synthesis` | Reconcile an accepted evidence set without making the final scientific decision | Scout | `gpt-5.6-terra` / medium | Unchanged |
| `code-edit` | Narrow frozen implementation and its targeted checks | Coder | `gpt-5.3-codex-spark` / medium | Luna / medium for straightforward tested edits; Terra / medium for coupled logic within the frozen boundary |
| `coordinated-build` | One coherent implementation boundary across coupled files/interfaces | Builder | `gpt-5.6-terra` / medium | Unchanged |
| `routine-review` | Independent bounded engineering check with objective acceptance, no consequential inference or primary-claim decision | Reviewer | `gpt-5.6-terra` / medium | Unchanged |
| `consequential-review` | Independent S3/S4 or similarly demanding judgment | Reviewer | `gpt-5.6-sol` / high | Unchanged; never weaken this gate for quota |

Task method remains separate: for example, a mathematical Skill can request a
code map, a bounded analysis, or a later frozen edit. Ordinary source mapping
does not become mathematical analysis merely because a model has that ability.
Unresolved design, scientific choices, or conflicting specifications return to
Chief; the matrix does not authorize a worker to decide them. Routine review
cannot substitute for consequential review because the changed diff is small.

The same task kind can justify another pair when evidence identifies a limiting
factor: simple repeated structure may need less effort; coupled logic may need
balanced capability; a documented reasoning shortfall may need strong or
frontier capability. Keep the contract and authority unchanged. A read-only
Spark assignment uses Scout, never a writable Coder merely to reach Spark.
Luna and Terra alternatives are selected by the same work-unit boundary, not
by trying every model in sequence. Code with state transitions, interacting
invariants, or repeated failed checks starts Terra when Spark is unavailable;
a truly trivial edit remains direct. Changing the model alone does not turn a
narrow Coder into a broader Builder or grant write access to Scout.

Reviewer policy has no universal Sol floor. The maintained routine-review
default is Reviewer / Terra / medium; consequential S3/S4 review is Reviewer /
Sol / high. A narrowly bounded, objective S1/S2 review may use Reviewer / Luna
/ high only as an explicitly justified exception selected before launch. It is
not a maintained default and is never eligible for consequential review.

## Spark quota preflight and fallback

Run this preflight only after task-kind selection makes Spark the candidate and
immediately before every prospective Spark worker launch. Do not poll before
unrelated work or during a healthy worker. On Codex, use the authoritative host
quota read when available (`get_usage_limits` or app-server
`account/rateLimits/read`). Match the Spark bucket through the host-reported
stable label/model mapping, never a versioned opaque internal ID.

Retain only the source, checked-at/freshness, status, each window's used
percent/duration/reset time, and resulting decision. Do not retain raw payloads,
account IDs, authentication fields, or credit/reset identifiers. Classify the
result as follows:

1. `blocked`: a limit-reached flag applies, or any applicable returned Spark
   window has numeric usage at least 100%.
2. `available`: the Spark bucket is found, every applicable window has numeric
   usage below 100%, and no reached flag applies.
3. `unknown`: the bucket or required fields are missing, or the read errors.

For `available`, launch explicit Spark / medium. For `blocked`, do not waste a
Spark attempt: launch the fitting explicit Luna / medium or Terra / medium
fallback. A five-hour block remains blocking even when a weekly window is
available. For `unknown`, never call the result quota-informed or invent a
block: choose Spark only when the declared risk and attempt budget can absorb a
quota rejection; otherwise conservatively choose the fitting Luna/Terra route
and record that rationale. A preflight snapshot never authorizes a later launch;
refresh it for each separate prospective Spark launch. If a launch is rejected
or quota interrupts a worker, follow the partial-side-effect and timeout
protocol below before any handoff.

Change the actual model/effort only with supported host controls or one fitting
new worker inside the remaining two-distinct-worker budget, retaining ownership,
permissions, assurance, and any reserved independent review. A confirmed
failure still counts toward that budget. No slot means no third worker: finish
only minimal safe direct work or report the needed budget/control decision for
substantial remaining work. A follow-up prompt cannot relabel the same model
into a fallback. Keep a healthy fallback on its unit even if Spark's reset time
passes; reconsider Spark only for a later eligible unit with fresh preflight
evidence. Never redeem a reset, buy quota, or wait/monitor indefinitely without
applicable user authorization.

The target is low expected cost per accepted unit, including context, handoff,
rework, and verification. Model counts, unused quota, and incomplete local token
counters are not evidence of measured savings or a globally optimal routing.

## Effort and escalation

Select effort explicitly after selecting a capable model. These are starting
criteria, not automatic upgrades or a substitute for checking host support:

- `low`: fixed fields or genuinely mechanical work with immediate checks.
- `medium`: ordinary bounded mapping, implementation, or stable synthesis.
- `high`: multiple interacting constraints, difficult diagnosis, or consequential independent review with a stated need.
- `xhigh`, `max`, or `ultra`: an explicit user choice or documented unresolved difficulty after a lower-effort/lower-lane attempt; only if that model and host support it. Do not copy Chief's setting into all workers.

More files, a long history, model novelty, or unused quota do not by themselves
justify higher effort. First reduce the work packet and resolve specification
conflicts. Do not raise model and effort together without identifying what each
change addresses. On a difficult return, distinguish missing context, a broken
tool/launch, incomplete production integration, and a reasoning shortfall.
Fix the first three at the appropriate boundary instead of treating every
failure as proof that the whole model family is inadequate. After the hard
decision is accepted, re-evaluate the next unit for a lower adequate pair.

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

1. Freeze task kind, contract, assurance, scope, expected output/checks, intended model/effort, reason, and remaining worker/review budget.
2. Inspect the current host's advertised controls and the model's supported efforts. Use the canonical profile only when the host can honor the selected pair and permissions. Supply both actual launch arguments, never just a prompt or an inherited setting. A stale loaded profile that fixes the pair despite an unpinned source cannot honor conflicting values; report that deployment/session limitation instead of reinstating the old adapter.
3. Preserve the profile's actual sandbox and ownership. Check applicable runtime permission overrides; a read-only sentence is not a read-only sandbox. Shared/full-history spawning may forbid model overrides; use a supported compact fresh launch, not conflicting arguments.
4. Include the launch ticket in the worker's small context. Require a startup receipt with contract, task kind, profile, configured model/effort and source; add runtime values from a host receipt when available. Stop on an observed mismatch; do not rewrite the planned model/effort to fit it. A fresh route may be declared before fresh work, but the mismatched attempt does not satisfy the original review and still counts toward worker/attempt budget. Missing runtime metadata stays unknown, not a fabricated match.
5. If necessary controls are absent, distinguish unsupported launch capability from model quota. A different available model must still use enforceable permissions and actual controls. Otherwise continue only minimal direct work when appropriate or report the unsupported boundary. Never satisfy S3/S4 review with a cheap untyped fallback, and never claim source edits switched a running session.

The untyped Luna/low default is a defensive cost limit for unspecified calls,
not a valid typed route or a compatibility profile. Calling a role without explicit model
**and** effort is a routing error even if an inherited pair happens to work.
Changing model, effort, permission, or ownership after launch requires supported
host controls or a new fitting worker within the same total budget; a follow-up
message or role label alone does not perform that change.

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
required permissions and independence, and remaining launch/worker budget. Do not
treat default Luna/low as Terra execution or consequential Reviewer evidence. If
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

Use fast for clear reversible volume, balanced for stable synthesis or related-file coordination, strong for unresolved judgment or consequential independent review, and frontier only for exceptional end-to-end work or a documented lower-lane shortfall. S3/S4 adds review and human acceptance as applicable; it does not choose Astra. Before non-review strong or frontier work, apply the balanced gate. After the hard boundary is frozen, return predictable work to Terra, Spark, or Luna.

## GPT-6 Astra boundary

Astra is a frontier lane, not another execution contract. It may back the existing Reviewer contract only for an exceptional review whose limiting factor is cross-tool or cross-domain coherence, or after a documented Sol/high shortfall. This is an evidence-gated escalation from the consequential-review starting route, not an `AstraReviewer` role. The review is independent only when a separate Reviewer performs it; an Astra Chief's self-review does not satisfy the S3/S4 gate, and S4 still requires human acceptance.

Start newly planned Astra work at medium; raise effort only from evidence. Effort availability and semantics, including `ultra`, are host-dependent. Do not claim a universal automatic-delegation effect, or that API effort/configuration changes alter the active desktop Chief. Do not silently reset a user-selected effort.

Calibration is optional and bounded by actual accepted work. Compare eligible work started balanced, first-pass acceptance, rework, elapsed time, evidence coverage, and authoritative cost or quota data when available. Do not impose a unit quota, infer billing, or create work to consume allowance.

## Other hosts

Map the same four lanes to a host's least costly capable model: fast general, balanced coordinated, strong judgment/review, and a distinct verified frontier tier only when it exists. Test a new pair with one bounded read and one reversible edit before relying on it; API compatibility does not prove scientific reliability.
