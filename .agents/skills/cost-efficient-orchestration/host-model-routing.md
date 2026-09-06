# Host and model routing

This adapter maps portable execution contracts to a host. Re-check availability, price, permissions, tool reliability, and context behavior when the host changes. An execution contract controls scope, ownership, permissions, and independence; a capability lane controls model family and effort.

## Metadata and precedence

Report planned lane and configured model/effort separately from runtime-observed model/effort. An explicit launch or loaded profile establishes only configuration. A UI-provided value is `UI-selected`, not backend-confirmed. Without an authoritative host receipt, exact Chief runtime model and effort are `unknown`; never infer them from behavior, latency, prose, or a configuration update. After observing the current pair, Chief may explicitly plan to continue the bounded phase on that pair and record it in both planned and runtime fields with source `runtime`; this is a current route decision, not evidence of the launcher's original intent.

For Codex, the entry Skill's read-only runtime metadata probe may supply a host-recorded current-thread pair and direct-child pairs. Treat `status=observed` as runtime session evidence and `status=unknown` as no evidence. The probe is an optional Codex adapter: it must fail closed, emit no local path or thread identifier, and never be required by another harness. Use `codex debug models` separately to validate that configured model IDs and effort values exist in the current catalog; catalog presence is availability evidence, not a launch or runtime receipt.

For Codex custom agents, the effective per-setting precedence is: a named custom agent file's `model` or `model_reasoning_effort` wins; otherwise explicit spawn value wins; otherwise `[agents]` default wins; otherwise parent value is inherited. A selected model without an effort uses that model's default; a named file setting only `model` preserves the already resolved effort. See [Codex subagents](https://learn.chatgpt.com/docs/agent-configuration/subagents). A named fixed-role profile therefore fixes its paired model/effort: do not pass conflicting spawn model or effort arguments. If a different pair is needed, use a host-supported unpinned/default contract with the required ownership and permissions, or report the route unsupported.

## Current Codex mapping

| Work shape | Starting route |
| --- | --- |
| Clear read-only inventory or fixed-field volume | Scout / `gpt-5.6-luna` / medium |
| Narrow frozen code mapping or edit-test loop | Coder / `gpt-5.3-codex-spark` / medium |
| Stable bounded read-only synthesis | Scout contract on a supported unpinned `gpt-5.6-terra` / medium route; retain read-only restrictions |
| Coordinated reversible implementation | Builder / `gpt-5.6-terra` / medium |
| Ambiguous judgment or independent consequential review | Chief or Reviewer / `gpt-5.6-sol` / high |
| Exceptional cross-tool coherence or documented lower-lane shortfall | Chief or Builder / `gpt-6-astra` / medium initially |

These are configured defaults, not runtime proof and not task-wide profiles. Spark remains a fast-code specialization; keep non-code volume on Luna and coordinated code on Terra. If Spark is unavailable, route the same frozen unit to Luna when genuinely mechanical or Terra when coordinated, without increasing the worker budget.

### Fast-code gate

A request that merely mentions code does not select Coder. Use the named Coder when the work requires an actual code edit-test loop, the interface and checks are frozen, ownership is narrow, failure is observable, and no unresolved scientific or architectural decision remains. On a strong or frontier Chief, this is the default route even without parallel Chief work because it retires implementation context from the expensive lane. Run a test, formatter, or other known command directly; keep an obvious micro-edit direct when its full implementation is cheaper than the handoff. Use Builder instead when the change coordinates interfaces, migrations, or multiple coupled responsibilities.

An unpinned route must restate the execution contract and permissions; it does
not inherit a named role's restrictions automatically. If the host cannot
enforce a required sandbox boundary, use a suitable supported profile or return
the limitation to Chief. A prompt-only read-only instruction is not a read-only
sandbox. With shared-history spawning, verify whether explicit model overrides
are supported; a compact fresh launch may be required. Untyped fallback remains
Luna / low and should not be mistaken for the Builder route.

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
