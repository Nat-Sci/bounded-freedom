# BoundedFreedom

> **Boundaries turn capability into reliable action.**

![BoundedFreedom research cover showing MRI anatomy, cortical networks, evidence verification, and human judgment](docs/assets/bounded-freedom-neuro-research-cover.png)

Modern AI models can already do a great deal. In long research tasks, the bottleneck is often not access to a stronger model but using available capability well. Packing retrieval, paper reading, coding, and scientific judgment into one strongest-model context can increase token use while blurring ownership and verification.

BoundedFreedom is a small, constraint-first control layer for AI-assisted research and engineering. Its **Chief** keeps the goal and final judgment, sends ordinary work through the General route, loads one specialized research Skill only when needed, and selects execution scope and model effort separately for each bounded unit.

The model sets what may be possible, context sets what it can see, and the harness sets what it may do, what it must protect, how it gets feedback, and how its work is checked. Sources, evidence, claims, hypotheses, code, figures, and software remain linked so the work can be reviewed and recovered. BoundedFreedom does not replace scientific tools or project-owned rules.

## Repository activity

[![Repository activity since the first commit](https://raw.githubusercontent.com/Nat-Sci/bounded-freedom/repository-activity/repository-activity.svg)](.github/workflows/update-repository-activity.yml)

The card runs from the first commit to the refresh date and adapts its interval to repository age. It updates after `main` changes and once daily on a separate branch. Activity is a maintenance signal, not a research-quality score.

## The small portable core

| Layer | Source of truth |
| --- | --- |
| Human, scientific, privacy, and evidence boundaries | `CONSTITUTION.md` |
| Chief routing and six on-demand research methods | `.agents/skills/` |
| Host discovery, roles, permissions, and model syntax | `AGENTS.md`, `CLAUDE.md`, `GEMINI.md`, `.codex/` |
| Data, methods, execution, and acceptance for a real study | The working project's own instructions |

The Constitution and Skills are portable. Host files stay thin, and project facts remain with the project.

## One dispatcher, four separate decisions

```text
request -> Chief -> General or one Skill -> direct work or one execution role
        -> model and effort -> S0-S4 evidence gate -> verification -> decision
```

| Decision | Question |
| --- | --- |
| Task method | Is General enough, or does this unit need one specialist Skill? |
| Execution contract | Who owns the unit, what may it change, and must it be independent? |
| Model and effort | How much context, coding ability, and reasoning does this unit need? |
| Assurance | What evidence, review, or human acceptance does the consequence require? |

Scout, Coder, Builder, and Reviewer are execution contracts, not intelligence levels. S0–S4 controls assurance, not task type or model choice.

| Execution contract | Owns | Current Codex default |
| --- | --- | --- |
| Scout | Bounded read-only discovery | Luna / medium |
| Coder | Narrow, frozen, reversible edits | Luna / medium |
| Builder | Coordinated implementation across logic or files | Terra / medium |
| Reviewer | Independent read-only assessment | Sol / high |

These are host defaults, not fixed identities. Chief uses the least costly capable model for each unit and escalates after ambiguity, failure, conflicting evidence, or consequential judgment demonstrates the need.

## General and six research Skills

| Task method | Chief | Scout, usually fast | Coder, usually fast | Builder, usually balanced | Reviewer, usually strong |
| --- | --- | --- | --- | --- | --- |
| General repository work | Frame, route, integrate, decide | Locate files and dependencies | Make a frozen narrow edit | Coordinate logic and interfaces | Audit consequential evidence |
| [`evidence-review`](.agents/skills/evidence-review/SKILL.md) | Freeze boundary and synthesize | Search, deduplicate, screen, extract | Fixed ledger or export only | Retrieval tooling moves to software work | Audit systematic or novelty claims |
| [`hypothesis-study-design`](.agents/skills/hypothesis-study-design/SKILL.md) | Compare hypotheses and freeze decisions | Extract evidence, assumptions, confounders | Frozen calculation scripts only | Simulations use the general build route | Audit causal and statistical logic |
| [`scientific-data-quality`](.agents/skills/scientific-data-quality/SKILL.md) | Freeze data purpose, contract, and acceptance | Inventory schema, provenance, and checks | Add one deterministic validator | Coordinate QC and lineage plumbing | Audit consequential leakage or exclusions |
| [`paper-code-reproduction`](.agents/skills/paper-code-reproduction/SKILL.md) | Freeze protocol and assign status | Map claims, code, data, dependencies | Repair environment or smoke path | Build coordinated claim-level execution | Grade protocol and claim evidence |
| [`scientific-figure`](.agents/skills/scientific-figure/SKILL.md) | Freeze the visual argument | Locate data, assets, provenance | Make a narrow plotting edit | Build panels or editable schematics | Audit scientific and visual meaning |
| [`research-software-lifecycle`](.agents/skills/research-software-lifecycle/SKILL.md) | Grow a verified software container | Inventory baseline and tool fit | Add one frozen capability | Coordinate increments or frame migration | Audit baseline, migration, and release boundary |

This is a routing map, not a standing team. Chief normally works alone or selects one cell. One bounded work unit has one active method Skill; larger tasks chain methods through explicit handoffs. S3/S4 require independent review, and S4 also requires human acceptance. Detailed ownership and overlap rules live in [Skill coordination](docs/skill-coordination.md).

Research handoffs retain only the needed slice of a shared lineage:

```text
source -> evidence -> claim -> gap -> hypothesis -> study
data source -> contract / QC / leakage gate ---------> run -> finding
                                                               -> code / figure / software
```

The [research-lineage contract](.agents/skills/cost-efficient-orchestration/research-lineage.md) preserves traceability without loading an entire project history into every task.

## Install and use

Preview the default Codex installation:

```sh
./scripts/install-global.sh --dry-run
```

Select `--host portable`, `claude`, or `all` when needed, then replace `--dry-run` with `--install`. After pulling updates, use `--update`; use `--status` for a read-only check.

The installer links back to this clone, updates only marked global blocks, and refuses to replace conflicting user files. It does not copy the repository into every project and does not require Python.

A working project normally keeps only its local instruction file, one `tasks/` record for consequential work, and truly necessary host overrides. The user starts a normal task; Chief performs the routing.

## Compatibility and current boundary

The portable core follows the open [Agent Skills specification](https://agentskills.io/specification). Compatible hosts can use `.agents/skills` directly; Claude Code receives links in its native Skill location; other systems may need a thin adapter. Codex remains the reference implementation because the execution-role profiles under `.codex/` are already configured. See the [harness landscape](docs/harness-landscape.md) for the exact boundary.

Today this repository provides the control plane, six method contracts, thin host adapters, and a tested installer. Databases, plotting libraries, reproduction runtimes, and benchmarks remain optional. Token, latency, quality, and scientific benefits still need repeated real-task measurement rather than promotional percentages.

## Documentation and credits

- [Constitution](CONSTITUTION.md): non-negotiable boundaries.
- [Orchestration Skill](.agents/skills/cost-efficient-orchestration/SKILL.md): live selection algorithm.
- [Skill coordination](docs/skill-coordination.md): ownership, handoffs, and known gaps.
- [Harness landscape](docs/harness-landscape.md): host compatibility and adopted control ideas.
- [Ecosystem and credits](docs/ecosystem-and-credits.md): related work and the selected, deferred, and excluded ledger.
- [Public Wiki](https://github.com/Nat-Sci/bounded-freedom/wiki): shorter navigable introduction.

Upstream work is credited and reviewed, never merged automatically. Stars acknowledge useful work; releases and scheduled reviews are the update signal.
