# Host and model routing

This adapter maps portable execution contracts to a host. Re-check availability, price, permissions, tool reliability, and context behavior when the host changes. An execution contract controls scope, ownership, permissions, and independence; a capability lane controls model family and effort.

## Metadata and precedence

Report planned lane and configured model/effort separately from runtime-observed model/effort. An explicit launch or loaded profile establishes only configuration. A UI-provided value is `UI-selected`, not backend-confirmed. Without an authoritative host receipt, exact Chief runtime model and effort are `unknown`; never infer them from behavior, latency, prose, or a configuration update.

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

An unpinned route must restate the execution contract and permissions; it does
not inherit a named role's restrictions automatically. If the host cannot
enforce a required sandbox boundary, use a suitable supported profile or return
the limitation to Chief. A prompt-only read-only instruction is not a read-only
sandbox. With shared-history spawning, verify whether explicit model overrides
are supported; a compact fresh launch may be required. Untyped fallback remains
Luna / low and should not be mistaken for the Builder route.

## Capability gates

Use fast for clear reversible volume, balanced for stable synthesis or related-file coordination, strong for unresolved judgment or consequential independent review, and frontier only for exceptional end-to-end work or a documented lower-lane shortfall. S3/S4 adds review and human acceptance as applicable; it does not choose Astra. Before non-review strong or frontier work, apply the balanced gate. After the hard boundary is frozen, return predictable work to Terra, Spark, or Luna.

## GPT-6 Astra boundary

Astra is a frontier lane, not another execution contract. Start newly planned Astra work at medium; raise effort only from evidence. Effort availability and semantics, including `ultra`, are host-dependent. Do not claim a universal automatic-delegation effect, or that API effort/configuration changes alter the active desktop Chief. Do not silently reset a user-selected effort.

Calibration is optional and bounded by actual accepted work. Compare eligible work started balanced, first-pass acceptance, rework, elapsed time, evidence coverage, and authoritative cost or quota data when available. Do not impose a unit quota, infer billing, or create work to consume allowance.

## Other hosts

Map the same four lanes to a host's least costly capable model: fast general, balanced coordinated, strong judgment/review, and a distinct verified frontier tier only when it exists. Test a new pair with one bounded read and one reversible edit before relying on it; API compatibility does not prove scientific reliability.
