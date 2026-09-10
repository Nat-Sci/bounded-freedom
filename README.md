# BoundedFreedom

> **Boundaries turn capability into reliable action.**

Current package: **v0.6.4 — Astra Edition**.

![BoundedFreedom research cover showing MRI anatomy, cortical networks, evidence verification, and human judgment](docs/assets/bounded-freedom-neuro-research-cover.png)

Modern AI models can already do a great deal. In long research tasks, the bottleneck is often not access to a stronger model but using available capability well. Packing retrieval, paper reading, coding, and scientific judgment into one strongest-model context can increase token use while blurring ownership and verification.

BoundedFreedom is a small, constraint-first control layer for AI-assisted research and engineering. Its **Chief** keeps the goal and final judgment, sends ordinary work through the General route, loads one specialized research or mathematical Skill only when needed, and selects execution scope and model effort separately for each bounded unit.

The model sets what may be possible, context sets what it can see, and the harness sets what it may do, what it must protect, how it gets feedback, and how its work is checked. Sources, evidence, claims, hypotheses, code, figures, and software remain linked so the work can be reviewed and recovered. BoundedFreedom does not replace scientific tools or project-owned rules.

## Recommended: let each model work in its strongest context

> **Use one context to act, and another to think again.**

Model capability is used more fully when execution and interpretation do not
compete for the same context.

For research that moves from computation to scientific judgment, BoundedFreedom
recommends an optional two-context loop. Use Codex close to the real repository,
data, runtime, diffs, and tests; then pass a compact evidence packet to a fresh
ChatGPT conversation for interpretation, competing explanations, challenge, and
decision compression. After the human freezes a decision, return its bounded
change request to Codex for implementation and re-verification.

```text
Codex: inspect -> run -> test -> retain evidence
                         |
                         v
              compact Research Handoff Packet
                         |
                         v
ChatGPT: interpret -> challenge -> compare -> decision memo
                         |
                         v
Human: review the decision memo -> freeze the next action
                         |
                         v
Codex: implement -> reproduce -> verify
                         |
                         v
Human: accept the scientific claim
```

The handoff carries the question, source and data snapshot, method and parameters,
positive and negative results, checks, evidence-linked claims, prohibited
interpretations, and open decisions—not raw logs or the whole conversation. This
separation keeps execution noise out of scientific reasoning and gives important
judgments a fresh pass. It is cost-efficient only when the packet is compact;
duplicating the full context spends more tokens rather than fewer.

This remains one accountable chain, not two competing Chiefs. Codex owns the
execution evidence, ChatGPT provides a bounded interpretation or review pass, and
the human owns final scientific acceptance. Routine work should stay in Codex;
use the cross-interface loop at high-value interpretation and decision points.
The current pairing follows the tool-facing and evidence-synthesis patterns in
the official [Codex use cases](https://developers.openai.com/codex/use-cases) and
[ChatGPT research use cases](https://learn.chatgpt.com/use-cases?team=research);
the same boundary can be adapted to other compatible hosts.

## Repository activity

[![Commits in the generated main snapshot](https://raw.githubusercontent.com/Nat-Sci/bounded-freedom/repository-activity/repository-activity.svg?schema=2)](https://github.com/Nat-Sci/bounded-freedom/blob/repository-activity/repository-activity.svg)

The card counts all commits reachable from its displayed source SHA on `main`,
grouped by **committer-date** in Asia/Shanghai (UTC+08), using the finest
calendar interval that keeps the bar count within the configured limit: day,
Monday-based week, aligned two-week period, month, quarter, half-year, or year.
If those still exceed the limit, it falls back to an aligned multi-year interval.
It spans the history's earliest commit date through the refresh date (or a later
commit timestamp). The source SHA and generation time identify the exact snapshot;
compare with that revision, not a newer commit list.

[Generation](.github/workflows/update-repository-activity.yml) runs after `main`
changes and once daily, publishing only to a separate image branch. The card is
a static image: refresh an already open README to load updates, and allow for
the raw image's five-minute cache. Click the card to inspect the generated file.
Activity is a maintenance signal, not a research-quality score.

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
reasoning effort, metadata source, policy freshness, and freshness evidence
before delegation or changes. Necessary
instruction and host-discovery reads may come first. Emit `ROUTE CHANGE` only
when the route materially changes and `ROUTE END` with the accepted result. When
the host does not expose authoritative runtime values, runtime fields stay
`unknown`; configuration, inheritance, or UI values are labeled separately. These
receipts show routing control, not private chain-of-thought.

Policy freshness is separate from file installation and model runtime. `current`
means the task/run began after the accepted managed deployment or the host gave
an authoritative reload receipt; an older task is `stale`, and missing evidence
is `unknown`. A fresh worker launched by a stale Chief is recorded as real model
activity but belongs to a `mixed` policy cohort. This prevents a current role
file or one successful child launch from being misreported as adoption by every
open task.

At the end of routed Codex work, BoundedFreedom can also show a compact
`TASK RESOURCE SNAPSHOT`: task wall time plus observed input, cached input,
output, reasoning, and total tokens for each model/effort pair used by Chief
and its direct workers. It reads local event telemetry without retaining prompts
or identifiers. Because a Skill runs before its own final answer, the inline
snapshot is labeled pre-final and excludes that answer; exact terminal accounting
still belongs to a host-side receipt. Per-model elapsed times may overlap, and
cached input is already part of input tokens.

| Execution contract | Owns | Permission boundary |
| --- | --- | --- |
| Scout | Bounded discovery, code/evidence/system mapping, or stable synthesis | Read-only |
| Coder (Writer) | Narrow, frozen, code-specific edits and checks | Scoped workspace write |
| Builder | Coordinated implementation across logic or files | Scoped workspace write |
| Reviewer | Independent assessment of evidence and acceptance | Read-only |

Chief first identifies the **task kind**, then selects a capable model and
reasoning effort, and only then resolves a host launch profile. For example,
code mapping can use a read-only Spark Scout; it does not need Coder's write
permissions. General evidence and cross-module synthesis can use different
Scout models, and routine engineering review is distinguished from consequential
review. The [canonical task-kind matrix and effort rules](.agents/skills/cost-efficient-orchestration/host-model-routing.md#canonical-task-kind-matrix)
own these starting choices; they are policies to validate, not measured savings.

Only four canonical profiles remain: `Scout`, `Coder`, `Builder`, and `Reviewer`.
All preserve their permission boundary without pinning model or effort; there
are no fixed-model counterparts or duplicate Routed aliases. Chief supplies
both values through supported, advertised launch controls. A stale loaded
profile can still override those values, and prose cannot switch a running
model. The [launch adapter protocol](.agents/skills/cost-efficient-orchestration/host-model-routing.md#codex-launch-adapters)
covers current controls, permission overrides, runtime receipts and unsupported
sessions. See the [official subagent configuration](https://learn.chatgpt.com/docs/agent-configuration/subagents).

The Codex adapter permits at most four concurrently open worker threads, one
per canonical role: Scout, Builder, Coder, and Reviewer. `Coder` is the
implementation Writer; there is no fifth Writer profile. This is a capacity
ceiling, not a requirement to launch a full team: most bounded tasks still use
one or two roles, and deterministic commands or micro-edits remain direct.
Effective capacity is the policy maximum reduced by the actual host limit when
known (otherwise unknown); queue dependent roles and reserve feasible review
rather than moving substantive work into Chief. The host setting enforces only the total ceiling; one-thread-per-role and
single-writer ownership are orchestration-policy checks recorded in launch
tickets and route receipts, not separate host locks.
Builder and Coder may both exist in the roster, but only one has active writing
ownership at a time and their write turns never overlap. A confirmed terminal
failure can use the single declared same-role replacement allowance only after
partial effects and predecessor state are checked; a timeout does not free a
slot.

Chief is intentionally thin. It retains the research or product intent,
non-goals, unresolved scientific or architectural decisions, assurance,
acceptance, and final synthesis. Substantive discovery goes to Scout,
cross-file organization or integration to Builder, a frozen edit-test loop to
Coder/Writer, and independent acceptance to Reviewer. Each return is compressed
to accepted evidence, current artifacts, remaining choices, verification, and
the next safe action. This reduces Chief context pressure without transferring
its accountability.

When task-kind selection makes Spark the candidate, the Codex adapter first
checks whether the actual worker API can launch its exact model/effort with the
needed permission and fork controls, then runs a fresh Spark-only quota
preflight immediately before each supported prospective launch,
using the host's authoritative usage receipt when available. It retains only a
normalized status and window summary. Missing telemetry remains `unknown`; it
is never rewritten as available or exhausted. A catalog/account Spark option
without worker-launch support is `unsupported`, not quota exhaustion. When
Spark is blocked or unsupported,
straightforward bounded code work uses Luna/medium and interacting state or
constraints use Terra/medium. Quota exhaustion does not justify a Sol/Astra
escalation, weaker scientific review, or an undeclared same-role replacement. After a
mid-task block, inspect partial writes and process state before a real handoff.
Do not interrupt a healthy fallback merely because Spark's reset time passes.
See [Spark preflight and fallback](.agents/skills/cost-efficient-orchestration/host-model-routing.md#spark-quota-preflight-and-fallback).

Reviewer is an independence contract. In this Codex package, both routine and
consequential Reviewer work starts at Sol/high; trivial objective checks should
run directly rather than create a cheaper pseudo-reviewer. An observed Luna or
Terra runtime cannot retroactively replace a planned Sol review. Any mismatch
stops that attempt and still consumes its attempt budget.
Astra remains an evidence-gated escalation inside the same Reviewer contract
only after a documented Sol/high cross-domain or cross-tool coherence shortfall;
ordinary defects, missing evidence, profile mismatch, and a generic `BLOCK`
return to repair first. It
does not have a separate role. An Astra Chief's self-review is not independent.

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
        ├── Luna: general evidence and mechanical work
        ├── Spark: frozen code mapping and narrow edit-test loops
        ├── Terra: system mapping, stable synthesis, coordinated implementation
        ├── Sol: ambiguous judgment and independent review
        └── Astra: exceptional cross-tool coherence or documented shortfall
                          ↓
                 compact accepted checkpoint
                          ↓
                 return to Terra, Spark, or Luna
```

Before non-review work starts on Sol or Astra, the dispatcher checks whether
stable scope and objective verification make Terra sufficient. If Astra remains
Chief, substantial independent implementation can run on a Terra Builder while
Scout and Reviewer retain their own slots and Coder remains available for a
frozen edit-test unit. Chief handles only the unresolved decision or acceptance
check. Known commands and
obvious micro-edits run directly. A frozen, separable edit-test loop leaves a
Sol or Astra Chief for Coder/Spark even when Chief has no parallel work; the
saving comes from retiring implementation context. A direct-work exception
records the actual handoff, tool, or availability cost; merely labeling a phase
"balanced" does not change its runtime model. General volume stays on Luna.
There is no required model share or quota-draining target.

Effort is selected per unit instead of copied from Chief: low for fixed-field
work, medium for ordinary bounded units, high for a justified reasoning or
review need. Higher supported settings require explicit user choice or evidence.
Resolve conflicting inputs before handoff and verify the real production entry
path early; a passing toy engine is not proof of a completed integration.

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

> **Policy reload required after an update.** Existing/open tasks do not become
> current-policy tasks merely because files were installed or the application
> restarted. Start or fork a new task after the update; its first nontrivial
> route receipt should report `Chief policy freshness: current`. Until then,
> classify older tasks as `stale` or `unknown`, and a new child of an old Chief
> as `mixed`. Do not include those cohorts in a claimed post-policy comparison.

If `codex doctor` reports that HTTPS works but the Responses WebSocket times out while macOS has an active manual HTTP(S) proxy, preview and then import that proxy into a marked Codex `.env` block:

```sh
./scripts/install-global.sh --dry-run --host codex --codex-proxy system
./scripts/install-global.sh --update --host codex --codex-proxy system
```

The proxy address is detected at installation time and is never stored in the repository or printed by the installer. Existing user-owned proxy variables cause a safe stop. Use `--codex-proxy remove` to remove only the managed block, and restart Codex after either change. The option is explicit because a local proxy may later stop or move; ordinary installations leave network settings unchanged. An HTTP-only custom provider was verified as a fallback but is intentionally not installed because changing provider identity is more invasive than repairing the existing WebSocket route.

The installer links Skill directories back to this clone, installs Codex role
TOMLs from the explicit [role manifest](install/codex-role-files.txt) as managed regular files, and updates marked global blocks. `--update`
migrates the previous repository-owned role links: Codex can display symlinked
profiles but its secure launch reader rejects them. Foreign links, unmanaged
files, and locally modified managed role files are preserved as conflicts.
The active adapter no longer supports the old dual profile set. An update
retires only provably unmodified managed Routed copies or exact repository-owned
links; foreign or modified aliases cause a safe stop rather than silent deletion.
Dry-run and status distinguish this cleanup from a current installed role.
Refresh the installation after changing role profiles; Skill links still follow
the checkout. The installer does not copy the repository into every project and
does not require Python.

`--status` checks files, not live routing. A successful child launch and separate
model/effort evidence are required before calling a route verified. Validate the
next suitable bounded task outside this source repository, whose project-local
profiles can otherwise hide a broken personal installation. A failed role launch
must not silently become an expensive Chief route or a weaker independent review.
On Codex, the orchestration Skill includes a read-only runtime probe that can
record the current Chief and direct-child model/effort from host thread state
without retaining local paths or thread IDs. A managed policy-state marker lets
the same probe compare task start with accepted deployment and report
`current`, `stale`, or `unknown`; it does not force an existing task to reload.
Other harnesses keep these fields unknown unless they provide an equivalent
receipt.

A working project normally keeps only its local instruction file, one `tasks/` record for consequential work, and truly necessary host overrides. The user starts a normal task; Chief performs the routing.

### Shared package versus local records

This repository versions reusable Skills and references, host adapters, the
installer, regression tests, current documentation, and `tasks/TEMPLATE.md`.
Historical task records, one-off smoke-test output, and personal usage analyses
are local working material, not package releases: `tasks/` (except its template),
`docs/usage-analysis/`, and generated test-output directories are ignored.
Keep consequential local task records when required, but do not force-add them
or link shared documentation to them. Promote only durable, relevant decisions
into the maintained package documentation.

Removing an already tracked record from Git does not erase earlier commits.
The cleanup preserves files in the checkout performing it; other clones receive
deletions on pull, so back up any records needed there before updating.

## Compatibility and current boundary

The portable core follows the open [Agent Skills specification](https://agentskills.io/specification). Compatible hosts can use `.agents/skills` directly; Claude Code receives links in its native Skill location; other systems may need a thin adapter. Codex remains the reference implementation because the execution-role profiles under `.codex/` are already configured. See the [harness landscape](docs/harness-landscape.md) for the exact boundary.

Version 0.6.4 checks actual worker-launch capabilities before quota, schedules
the four-role roster within the live host limit, and separates Chief goal
definition from Builder decomposition. It distinguishes deeper Sol reasoning
from evidence-gated Astra escalation and reports installed instruction/config
payload drift directly in `--status`. These are Chief routing instructions and
deployment checks; they do not switch an active Chief or expand host capacity.

Version 0.6.3 introduced a needs-based four-role
roster, one open thread per Scout, Builder, Coder/Writer, and Reviewer. It keeps
one active writing owner, starts Codex Reviewer work at Sol/high, and makes
Chief-minimal offloading an explicit contract without forcing every task to
launch all four roles. Version 0.6.2 added explicit policy-freshness receipts, a privacy-safe managed
deployment marker, stale/current/mixed usage cohorts, and a mandatory installer
warning that existing tasks do not automatically adopt an update. It also
separates all-machine from project-filtered statistics, actual launches from
planned routes, and launch counts from token consumption. Version 0.6.1 added a mandatory immediately-prelaunch Spark quota preflight,
privacy-minimized quota receipts, explicit `available`/`blocked`/`unknown`
semantics, and a non-retroactive Reviewer mismatch rule. It retains the
quota-aware task-shaped model and effort selection introduced in v0.6.0, with
four unpinned canonical profiles and no fixed-model compatibility set, plus the Astra-aware
hierarchical control plane, six research
method contracts, one discoverable mathematical entry with three on-demand
method modules, model and effort fields directly in `CHIEF DECISION`, compact
phase handoffs, a Terra opportunity gate, a Spark fast-code route, an optional
reversible Codex system-proxy adapter, thin host adapters, and a tested
installer with safe legacy-link migration and secure-readable role copies. The efficiency audit removes
duplicated route banners, clarifies fixed-profile precedence and actual lane
changes, and separates direct calculations from delegated implementation.
The Codex adapter can now resolve host-recorded Chief and child model/effort,
while code, configuration, workflow, and routing mutations start at S1.
Source and isolated-install checks do not establish that a running host exposes
the current unpinned profiles. After an authorized update, use a newly loaded task
and a suitable real work unit to verify advertised controls, the requested pair,
effective permissions, and the observed runtime receipt. Linked Skill files may
be read on a subsequent load before role files are refreshed; keep the missing-
profile fallback explicit and do not describe that partial state as deployment.
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
