# BoundedFreedom

> **Boundaries turn capability into reliable action.**

Current package: **v0.8.0 — Astra Edition**.

Version 0.8.0 consolidates routing through conditional references, records service-tier provenance, shares the portable fingerprint helper, and selects the newest numeric runtime-state generation without older fallback. These changes reduce the common instruction surface; they do not establish token or cost savings.

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

The [orchestration dispatcher](.agents/skills/cost-efficient-orchestration/SKILL.md) separates task method, execution contract, model/effort, and S0–S4 assurance. Chief retains intent and acceptance; Scout supplies facts, Builder coordinates accepted boundaries, Coder owns narrow edit-test-repair, and Reviewer supplies independent evidence.

It owns the visible START/CHANGE/END and pre-final resource receipts, with conditional references for:
- [Canonical task kinds, subtypes, pairs, effort, launch permissions and quota](.agents/skills/cost-efficient-orchestration/host-model-routing.md#canonical-task-kind-matrix).
- [Roster, single-writer budgets, recovery, policy freshness and usage cohorts](.agents/skills/cost-efficient-orchestration/operations-and-lifecycle.md).
- [Implementation ownership, direct exceptions, targeted production verification and artifact-state review](.agents/skills/cost-efficient-orchestration/hierarchical-routing.md#balanced-gate-and-direct-work).
- [Scientific assurance](.agents/skills/cost-efficient-orchestration/scientific-risk.md).

## Astra Edition: a thin frontier and a strong middle

Route phases by their bounded output and least adequate capability, then return stable work down. The [host matrix](.agents/skills/cost-efficient-orchestration/host-model-routing.md) owns current model policies and the [frontier boundary](.agents/skills/cost-efficient-orchestration/host-model-routing.md#gpt-6-astra-boundary); these starting policies make no measured savings or quality claim. Host controls cannot be replaced by routing prose.

## Seal milestones: turn history into reusable assets

Before expansion, seal the prior boundary with acceptance evidence or record blockers. Carry a compact artifact/evidence index, scoped decisions, and next handoff instead of raw histories. The [milestone protocol](.agents/skills/cost-efficient-orchestration/operations-and-lifecycle.md#milestone-consolidation) owns retention, reopening, and conditional tool extraction.

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

> **Policy reload required after an update.** Installed files do not reload open tasks. Start/fork a new task after deployment; [freshness/cohort rules](.agents/skills/cost-efficient-orchestration/operations-and-lifecycle.md#policy-freshness-and-usage-cohorts) distinguish current, stale, unknown, and mixed usage.

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
Only the current four roles are managed; files outside the role manifest are
left untouched.
Refresh the installation after changing role profiles; Skill links still follow
the checkout. The installer does not copy the repository into every project and
does not require Python.

`--status` checks files, not live routing. Verify the next suitable real task outside this source repository, where local profiles cannot mask a broken personal installation. [Launch verification](.agents/skills/cost-efficient-orchestration/host-model-routing.md#a-named-role-is-visible-but-cannot-start) covers effective permissions, pair evidence, and failed launches; [entry receipts](.agents/skills/cost-efficient-orchestration/SKILL.md#one-visible-start-receipt) govern Codex runtime/freshness probes and other-host unknowns.

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

Current routing policies live in the [canonical host matrix](.agents/skills/cost-efficient-orchestration/host-model-routing.md#canonical-task-kind-matrix). Earlier releases introduced the four unpinned roles, task-kind/subtype selection, explicit launch controls, freshness/cohort receipts, quota distinctions, secure-readable role copies, optional proxy adapter, and conditional method/hierarchical routing. Historical fixtures and usage retain their recorded models.

Installation, successful child launch, and configured/runtime pair verification remain distinct. Use a newly loaded task and suitable real unit outside this source repository after updates; linked Skills without refreshed profiles are partial deployment. See [launch adapter verification](.agents/skills/cost-efficient-orchestration/host-model-routing.md#a-named-role-is-visible-but-cannot-start).

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
