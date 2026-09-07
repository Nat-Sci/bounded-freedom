# Host and model routing

This adapter maps portable execution contracts to a host. Re-check availability, price, permissions, tool reliability, and context behavior when the host changes. An execution contract controls scope, ownership, permissions, and independence; a capability lane controls model family and effort.

## Metadata and precedence

Report planned lane and configured model/effort separately from runtime-observed model/effort. An explicit launch or loaded profile establishes only configuration. A UI-provided value is `UI-selected`, not backend-confirmed. Without an authoritative host receipt, exact Chief runtime model and effort are `unknown`; never infer them from behavior, latency, prose, or a configuration update. After observing the current pair, Chief may explicitly plan to continue the bounded phase on that pair and record it in both planned and runtime fields with source `runtime`; this is a current route decision, not evidence of the launcher's original intent.

For Codex, the entry Skill's read-only runtime metadata probe may supply a host-recorded current-thread pair and direct-child pairs. Treat `status=observed` as runtime session evidence and `status=unknown` as no evidence. The probe is an optional Codex adapter: it must fail closed, emit no local path or thread identifier, and never be required by another harness. Use `codex debug models` separately to validate that configured model IDs and effort values exist in the current catalog; catalog presence is availability evidence, not a launch or runtime receipt.

For Codex custom agents, the effective per-setting precedence is: a named custom agent file's `model` or `model_reasoning_effort` wins; otherwise explicit spawn value wins; otherwise `[agents]` default wins; otherwise parent value is inherited. A selected model without an effort uses that model's default; a named file setting only `model` preserves the already resolved effort. See [Codex subagents](https://learn.chatgpt.com/docs/agent-configuration/subagents). A named fixed-role profile therefore fixes its paired model/effort: do not pass conflicting spawn model or effort arguments. If a different pair is needed, use a host-supported unpinned/default contract with the required ownership and permissions, or report the route unsupported.

## Canonical task-kind matrix

Choose the task kind from the requested output, not a keyword such as "code"
or "review". This is the maintained starting matrix; other documents describe
the contracts and link here instead of defining competing model tables. The
pairs are local starting policies, not measured quality or price guarantees.
Direct deterministic commands and trivial micro-edits still need no worker.

| Task kind | Bounded output | Contract | Starting model / effort | Codex profile when available |
| --- | --- | --- | --- | --- |
| `inventory` | Fixed-field extraction, file/configuration inventory | Scout | `gpt-5.6-luna` / low | ScoutRouted |
| `evidence-map` | Source/document evidence with stable concepts | Scout | `gpt-5.6-luna` / medium | Scout |
| `code-map` | Existing calls, branches, parameter flow, or test locations in a bounded source slice | Scout | `gpt-5.3-codex-spark` / medium | ScoutRouted |
| `system-map` | Related interfaces, state flow, or cross-module dependencies | Scout | `gpt-5.6-terra` / medium | ScoutRouted |
| `bounded-synthesis` | Reconcile an accepted evidence set without making the final scientific decision | Scout | `gpt-5.6-terra` / medium | ScoutRouted |
| `code-edit` | Narrow frozen implementation and its targeted checks | Coder | `gpt-5.3-codex-spark` / medium | Coder |
| `coordinated-build` | One coherent implementation boundary across coupled files/interfaces | Builder | `gpt-5.6-terra` / medium | Builder |
| `routine-review` | Independent bounded engineering check with objective acceptance, no consequential inference or primary-claim decision | Reviewer | `gpt-5.6-terra` / medium | ReviewerRouted |
| `consequential-review` | Independent S3/S4 or similarly demanding judgment | Reviewer | `gpt-5.6-sol` / high | Reviewer |

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
If Spark is unavailable, mechanical units may use Luna and coordinated units
may use Terra with an explicit changed route and preserved permissions. Do not
invent a fallback launch or increase the worker budget.

A host-reported quota block is an availability failure, not a reasoning
shortfall. Remaining allowance in another window does not unblock the active
limit. Use an authoritative limit receipt when needed to explain that failure;
do not poll quota before every unit, retry a known block, redeem a reset without
authorization, or infer billed cost from local token counters. Inspect any
partial side effects before a permitted continuation and attribute that work
to the model that actually completed it.

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

Four legacy profiles retain their fixed pairs for compatibility. Four
`Routed` profiles preserve the same execution contracts but omit both `model`
and `model_reasoning_effort`, so explicit supported launch values can apply:

| Contract | Fixed default profile | Explicit-pair profile | Required sandbox |
| --- | --- | --- | --- |
| Scout | Scout: Luna / medium | ScoutRouted | read-only |
| Coder | Coder: Spark / medium | CoderRouted | workspace-write |
| Builder | Builder: Terra / medium | BuilderRouted | workspace-write |
| Reviewer | Reviewer: Sol / high | ReviewerRouted | read-only |

These are alternate launch adapters, not eight responsibilities, an agent pool,
or additional worker slots. Exact fixed values live in the TOML payloads; the
installer's explicit [role manifest](../../../install/codex-role-files.txt)
keeps install, update, conflict preflight, and status on the same inventory.

Before launch:

1. Freeze task kind, contract, assurance, scope, expected output/checks, intended model/effort, reason, and remaining worker/review budget.
2. Inspect the current host's advertised controls. Use the fixed profile only when its pair matches. Otherwise use the corresponding Routed profile **only when advertised** and the host supports explicit model and effort for it. Supply both actual launch arguments, never just a prompt or an inherited setting. A host that fixes the pair despite an unpinned file cannot honor that route.
3. Preserve the profile's actual sandbox and ownership. Check applicable runtime permission overrides; a read-only sentence is not a read-only sandbox. Shared/full-history spawning may forbid model overrides; use a supported compact fresh launch, not conflicting arguments.
4. Include the launch ticket in the worker's small context. Require a startup receipt with contract, task kind, profile, configured model/effort and source; add runtime values from a host receipt when available. Stop on a mismatch; missing runtime metadata stays unknown, not a fabricated match.
5. If the necessary controls/profile are absent, do not repeatedly try an unavailable role. Use a genuinely fitting available profile with a disclosed actual pair and permissions, continue minimal direct work when appropriate, or report the unsupported boundary. Never satisfy S3/S4 review with a cheap untyped fallback.

The untyped Luna/low default is a compatibility fallback, not the selected
route for every unpinned role. Calling a Routed profile without explicit model
**and** effort is a routing error even if an inherited pair happens to work.
Changing model, effort, permission, or ownership after launch requires supported
host controls or a new fitting worker within the same total budget; a follow-up
message or role label alone does not perform that change.

### Fast-code gate

A request that merely mentions code does not select Coder. Use the Coder contract when the work requires an actual code edit-test loop, the interface and checks are frozen, ownership is narrow, failure is observable, and no unresolved scientific or architectural decision remains. Choose Coder or CoderRouted after selecting the intended pair. On a strong or frontier Chief, this is the default route even without parallel Chief work because it retires implementation context from the expensive lane. Run a test, formatter, or other known command directly; keep an obvious micro-edit direct when its full implementation is cheaper than the handoff. Use Builder instead when the change coordinates interfaces, migrations, or multiple coupled responsibilities. Pure code mapping follows the Scout row above and does not pass through this write gate.

The packaged Routed profiles explicitly carry their corresponding sandbox and
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

Astra is a frontier lane, not another execution contract. Start newly planned Astra work at medium; raise effort only from evidence. Effort availability and semantics, including `ultra`, are host-dependent. Do not claim a universal automatic-delegation effect, or that API effort/configuration changes alter the active desktop Chief. Do not silently reset a user-selected effort.

Calibration is optional and bounded by actual accepted work. Compare eligible work started balanced, first-pass acceptance, rework, elapsed time, evidence coverage, and authoritative cost or quota data when available. Do not impose a unit quota, infer billing, or create work to consume allowance.

## Other hosts

Map the same four lanes to a host's least costly capable model: fast general, balanced coordinated, strong judgment/review, and a distinct verified frontier tier only when it exists. Test a new pair with one bounded read and one reversible edit before relying on it; API compatibility does not prove scientific reliability.
