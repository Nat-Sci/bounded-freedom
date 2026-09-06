# BoundedFreedom

> **Boundaries turn capability into reliable action.**

Current package: **v0.4.2 — Astra Edition**.

![BoundedFreedom research cover showing MRI anatomy, cortical networks, evidence verification, and human judgment](docs/assets/bounded-freedom-neuro-research-cover.png)

Modern AI models can already do a great deal. In long research tasks, the bottleneck is often not access to a stronger model but using available capability well. Packing retrieval, paper reading, coding, and scientific judgment into one strongest-model context can increase token use while blurring ownership and verification.

BoundedFreedom is a small, constraint-first control layer for AI-assisted research and engineering. Its **Chief** keeps the goal and final judgment, sends ordinary work through the General route, loads one specialized research or mathematical Skill only when needed, and selects execution scope and model effort separately for each bounded unit.

The model sets what may be possible, context sets what it can see, and the harness sets what it may do, what it must protect, how it gets feedback, and how its work is checked. Sources, evidence, claims, hypotheses, code, figures, and software remain linked so the work can be reviewed and recovered. BoundedFreedom does not replace scientific tools or project-owned rules.

## Repository activity

[![Repository activity since the first commit](https://raw.githubusercontent.com/Nat-Sci/bounded-freedom/repository-activity/repository-activity.svg)](.github/workflows/update-repository-activity.yml)

The card runs from the first commit to the refresh date and adapts its interval to repository age. It updates after `main` changes and once daily on a separate branch. Activity is a maintenance signal, not a research-quality score.

## The small portable core

| Layer | Source of truth |
| --- | --- |
| Human, scientific, privacy, and evidence boundaries | `CONSTITUTION.md` |
| Chief routing, six research methods, and one mathematical entry with three on-demand modules | `.agents/skills/` |
| Host discovery, roles, permissions, and model syntax | `AGENTS.md`, `CLAUDE.md`, `GEMINI.md`, `.codex/` |
| Data, methods, execution, and acceptance for a real study | The working project's own instructions |

The Constitution and Skills are portable. Host files stay thin, and project facts remain with the project.

## One dispatcher, four separate decisions

```text
request -> admission and phase boundary -> Chief -> General or one Skill
        -> execution contract and capability -> verification -> compact checkpoint
        -> lower-cost next phase, evidence-gated escalation, or decision
```

| Decision | Question |
| --- | --- |
| Task method | Is General enough, or does this unit need one specialist Skill? |
| Execution contract | Who owns the unit, what may it change, and must it be independent? |
| Model and effort | How much context, coding ability, and reasoning does this unit need? |
| Assurance | What evidence, review, or human acceptance does the consequence require? |

Scout, Coder, Builder, and Reviewer are execution contracts, not intelligence levels. S0–S4 controls assurance, not task type or model choice.

For nontrivial work, one combined `CHIEF DECISION / ROUTE START` shows the
planned capability lane, model, reasoning effort, runtime model, runtime
reasoning effort, and metadata source before delegation or changes. Necessary
instruction and host-discovery reads may come first. Emit `ROUTE CHANGE` only
when the route materially changes and `ROUTE END` with the accepted result. When
the host does not expose an authoritative value, the field says `inherited`,
`UI-selected`, or `unknown` rather than disappearing or guessing. These
receipts show routing control, not private chain-of-thought.

| Execution contract | Owns | Current Codex default |
| --- | --- | --- |
| Scout | Bounded read-only discovery | Luna / medium |
| Coder | Narrow, frozen, code-specific edits | Codex-Spark / medium |
| Builder | Coordinated implementation across logic or files | Terra / medium |
| Reviewer | Independent read-only assessment | Sol / high |

These are the reference adapter's configured pairs. In Codex, a named custom
profile's model and effort take precedence over launch defaults; the current
named-role interface fixes these pairs. To use another pair, Chief needs a
supported unpinned route with the same ownership and permission contract.
Profile or launch settings establish the configured pair, not proof of backend
execution. Chief selects the least costly capable route within the host's
actual controls. See the [official subagent configuration](https://learn.chatgpt.com/docs/agent-configuration/subagents).

The Codex adapter keeps at most two spawned worker threads open at once, and the orchestration contract separately caps the default total task budget at two distinct workers. Most tasks still use zero or one; only one worker may write.

GPT-6 Astra is the Codex adapter's on-demand frontier lane. Select it explicitly
for the hardest end-to-end phase or a material documented shortfall. For a new
route, medium effort is a local starting policy; existing user-selected effort
is preserved. Supported effort values and delegation behavior must be checked
against the active host. See the [host model routing boundary](.agents/skills/cost-efficient-orchestration/host-model-routing.md#gpt-6-astra-boundary).

## Astra Edition: a thin frontier and a strong middle

The Astra Edition routes phases rather than assigning one model to a whole task:

```text
deterministic preparation
        ↓
Chief control phase
        ├── Luna: bounded discovery and general mechanical work
        ├── Spark: frozen code mapping and narrow edit-test loops
        ├── Terra: coordinated, reversible, objectively verifiable work
        ├── Sol: ambiguous judgment and independent review
        └── Astra: exceptional cross-tool coherence or documented shortfall
                          ↓
                 compact accepted checkpoint
                          ↓
                 return to Terra, Spark, or Luna
```

Before non-review work starts on Sol or Astra, the dispatcher checks whether
stable scope and objective verification make Terra sufficient. If Astra remains
Chief, substantial independent implementation can run on one Terra worker while
Chief handles a separate decision or acceptance check. Small known commands
run directly. A direct-work exception records the actual handoff, tool, or
availability cost; merely labeling a phase "balanced" does not change its
runtime model. General volume stays on Luna and narrow frozen code edits can
use Spark. There is no required model share or quota-draining target.

Astra receives the smallest phase packet that preserves intent, accepted evidence, unresolved dependencies, verification, and the stop condition. Bulk discovery, completed logs, inactive Skills, predictable implementation, and routine testing stay outside its standing context. Cost evaluation uses accepted outcomes, rework, escalation, elapsed time, evidence coverage, and authoritative billing or quota data when available; stored model counts and incomplete token fields are not treated as savings.

The full portable protocol is in [hierarchical routing and cost evaluation](.agents/skills/cost-efficient-orchestration/hierarchical-routing.md). Current model IDs and availability handling remain in the [host mapping](.agents/skills/cost-efficient-orchestration/host-model-routing.md).

## General, six research Skills, and one mathematical entry

| Task method | Chief | Scout, usually fast | Coder, usually fast | Builder, usually balanced | Reviewer, usually strong |
| --- | --- | --- | --- | --- | --- |
| General repository work | Frame, route, integrate, decide | Locate files and dependencies | Make a frozen narrow edit | Coordinate logic and interfaces | Audit consequential evidence |
| [`evidence-review`](.agents/skills/evidence-review/SKILL.md) | Freeze boundary and synthesize | Search, deduplicate, screen, extract | Fixed ledger or export only | Retrieval tooling moves to software work | Audit systematic or novelty claims |
| [`hypothesis-study-design`](.agents/skills/hypothesis-study-design/SKILL.md) | Compare hypotheses and freeze decisions | Extract evidence, assumptions, confounders | Frozen calculation scripts only | Simulations use the general build route | Audit causal and statistical logic |
| [`scientific-data-quality`](.agents/skills/scientific-data-quality/SKILL.md) | Freeze data purpose, contract, and acceptance | Inventory schema, provenance, and checks | Add one deterministic validator | Coordinate QC and lineage plumbing | Audit consequential leakage or exclusions |
| [`paper-code-reproduction`](.agents/skills/paper-code-reproduction/SKILL.md) | Freeze protocol and assign status | Map claims, code, data, dependencies | Repair environment or smoke path | Build coordinated claim-level execution | Grade protocol and claim evidence |
| [`scientific-figure`](.agents/skills/scientific-figure/SKILL.md) | Freeze the visual argument | Locate data, assets, provenance | Make a narrow plotting edit | Build panels or editable schematics | Audit scientific and visual meaning |
| [`research-software-lifecycle`](.agents/skills/research-software-lifecycle/SKILL.md) | Grow a verified software container | Inventory baseline and tool fit | Add one frozen capability | Coordinate increments or frame migration | Audit baseline, migration, and release boundary |

The mathematical layer adds a reconstruction-first bridge between a real
research question and its data or code:

```text
paper + code + data + frozen claim or hypothesis
        ↓
mathematical-methods/                      one installed directory
├── SKILL.md                               discoverable entry
└── references/
    ├── problem-map.md                     default stage
    ├── statistical-model-analysis/        on demand
    ├── neural-network-mathematical-analysis/  on demand
    └── loss-objective-optimization/       on demand

strict proof request -> formal-proof-gap
```

| Mathematical stage | Owns | Typical profiles or handoff |
| --- | --- | --- |
| [`mathematical-methods`](.agents/skills/mathematical-methods/SKILL.md) / problem map | Reconstruct existing variables, equations, assumptions, constraints, and claim-equation-code-data links | Stop if answered; otherwise select at most one module |
| [Statistical module](.agents/skills/mathematical-methods/references/statistical-model-analysis/method.md) | Estimands, dependence, model specification, uncertainty, diagnostics, sensitivity, and claim support | Cross-sectional, longitudinal, developmental/normative, or clinical-prediction profile |
| [Network module](.agents/skills/mathematical-methods/references/neural-network-mathematical-analysis/method.md) | Functional structure, information and gradient paths, invariance, identifiability, stability, counterexamples, and proof obligations | Freeze an architecture decision or return `formal-proof-gap` |
| [Loss and optimization module](.agents/skills/mathematical-methods/references/loss-objective-optimization/method.md) | Loss terms, reductions, weights, constraints, surrogate alignment, gradient incentives, and degeneracy | Freeze one objective or optimization change for later implementation |

This is a routing map, not a standing team. Chief normally works alone or
selects one cell. One bounded work unit has one discoverable method Skill and,
inside the mathematical entry, at most one active module. Infant development
and AD diagnostic/prediction are bounded statistical profiles, not catch-all
top-level agents. S3/S4 require independent review, and S4 also requires human
acceptance. Detailed ownership and overlap rules live in
[Skill coordination](docs/skill-coordination.md).

Research handoffs retain only the needed slice of a shared lineage:

```text
source -> evidence -> claim -> gap -> hypothesis -> study
                                  -> mathematical contract -> proof obligation
data source -> contract / QC / leakage gate -> model -> run -> finding
                                                            -> code / figure / software
```

The [research-lineage contract](.agents/skills/cost-efficient-orchestration/research-lineage.md) preserves traceability without loading an entire project history into every task.

## Install and use

Preview the default Codex installation:

```sh
./scripts/install-global.sh --dry-run
```

Select `--host portable`, `claude`, or `all` when needed, then replace `--dry-run` with `--install`. After pulling updates, use `--update`; use `--status` for a read-only check. Installer output reports the package version and edition so linked Skills and managed host instructions can be checked against the repository revision.

If `codex doctor` reports that HTTPS works but the Responses WebSocket times out while macOS has an active manual HTTP(S) proxy, preview and then import that proxy into a marked Codex `.env` block:

```sh
./scripts/install-global.sh --dry-run --host codex --codex-proxy system
./scripts/install-global.sh --update --host codex --codex-proxy system
```

The proxy address is detected at installation time and is never stored in the repository or printed by the installer. Existing user-owned proxy variables cause a safe stop. Use `--codex-proxy remove` to remove only the managed block, and restart Codex after either change. The option is explicit because a local proxy may later stop or move; ordinary installations leave network settings unchanged. An HTTP-only custom provider was verified as a fallback but is intentionally not installed because changing provider identity is more invasive than repairing the existing WebSocket route.

The installer links back to this clone, updates only marked global blocks, and refuses to replace conflicting user files. It does not copy the repository into every project and does not require Python.

A working project normally keeps only its local instruction file, one `tasks/` record for consequential work, and truly necessary host overrides. The user starts a normal task; Chief performs the routing.

## Compatibility and current boundary

The portable core follows the open [Agent Skills specification](https://agentskills.io/specification). Compatible hosts can use `.agents/skills` directly; Claude Code receives links in its native Skill location; other systems may need a thin adapter. Codex remains the reference implementation because the execution-role profiles under `.codex/` are already configured. See the [harness landscape](docs/harness-landscape.md) for the exact boundary.

Version 0.4.2 provides the Astra-aware hierarchical control plane, six research
method contracts, one discoverable mathematical entry with three on-demand
method modules, model and effort fields directly in `CHIEF DECISION`, compact
phase handoffs, a Terra opportunity gate, a Spark fast-code route, an optional
reversible Codex system-proxy adapter, thin host adapters, and a tested
installer with safe legacy-link migration. The efficiency audit removes
duplicated route banners, clarifies fixed-profile precedence and actual lane
changes, and separates direct calculations from delegated implementation.
Required checks stop once accepted unless a new change or failure warrants more.
Strict proof production and
proof-assistant verification remain explicit Future Work: the mathematical
entry can record proof obligations but must not certify them. Databases,
plotting libraries,
mathematical runtimes, reproduction runtimes, and benchmarks remain optional.
Token, latency, quality, and scientific benefits still need repeated real-task
measurement rather than promotional percentages.

## Documentation and credits

- [Constitution](CONSTITUTION.md): non-negotiable boundaries.
- [Orchestration Skill](.agents/skills/cost-efficient-orchestration/SKILL.md): live selection algorithm.
- [Skill coordination](docs/skill-coordination.md): ownership, handoffs, and explicit Future Work.
- [Harness landscape](docs/harness-landscape.md): host compatibility and adopted control ideas.
- [Ecosystem and credits](docs/ecosystem-and-credits.md): related work and the selected, deferred, and excluded ledger.
- [Public Wiki](https://github.com/Nat-Sci/bounded-freedom/wiki): shorter navigable introduction.

Upstream work is credited and reviewed, never merged automatically. Stars acknowledge useful work; releases and scheduled reviews are the update signal.
