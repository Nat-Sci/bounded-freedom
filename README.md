# BoundedFreedom

> **Boundaries turn capability into reliable action.**

![BoundedFreedom research cover showing MRI anatomy, cortical networks, evidence verification, and human judgment](docs/assets/bounded-freedom-neuro-research-cover.png)

Modern AI models can already do a great deal. The harder problem is making their work reliable, affordable, recoverable, and true to human intent over long tasks.

BoundedFreedom treats this as an environment-design problem. The model sets what may be possible, context sets what it can see, and the harness sets what it may do, what it must protect, how it gets feedback, and how its work is checked. Clear boundaries do not only limit action; they make useful action dependable.

BoundedFreedom is a constraint-first, cost-aware harness layer for AI-assisted research and engineering. The current primary session acts as **Chief**: it frames the task, loads only the needed method, chooses the least costly capable worker, checks the evidence, and keeps final accountability.

## Small repository layout

| Part | Purpose | Where it lives |
| --- | --- | --- |
| Constitution | Stable human, scientific, privacy, and evidence boundaries | `CONSTITUTION.md` |
| Portable Skills | Methods loaded only when a task needs them | `.agents/skills/` |
| Host adapter | Instruction discovery, agents, tools, permissions, and model syntax | `AGENTS.md`, `CLAUDE.md`, `GEMINI.md`, `.codex/` |
| Project contract | Local data, scientific, execution, and acceptance rules | The working project's own instruction files |

The first two parts are intended to travel across compatible harnesses. Host files remain thin adapters. Project facts stay with the project instead of being copied into this repository.

## How it works

```text
User request
    ↓
Chief frames intent and identifies the task method
    ↓
Load one matching Skill when specialized method is needed
    ↓
Freeze scope and work units
    ↓
Use its work-unit execution and model guidance; otherwise use the general route
    ↓
Set the S0–S4 evidence gate separately
    ↓
Chief works directly, or delegates one bounded unit
    ↓
Verify actual evidence
    ↓
Independent review when the consequence requires it
    ↓
Decision, record, and remaining uncertainty
```

Four decisions stay separate:

1. **Task method:** general work or one matching Skill. This decides *how* the work is done.
2. **Execution contract:** direct, Scout, Coder, Builder, or Reviewer. This decides scope, write access, ownership, and independence.
3. **Model and effort:** fast, balanced, or strong reasoning for each bounded unit. This decides how much capability the unit needs.
4. **Assurance:** S0–S4 controls evidence, independent review, and human acceptance. It does not name the task, worker, or model.

## Execution contract is not intelligence

| Execution contract | Owns | Must not | Current Codex default |
| --- | --- | --- | --- |
| Scout | Read-only discovery and evidence collection | Write or make the final decision | Luna / medium |
| Coder | A narrow, frozen, reversible edit | Widen scope or redesign interfaces | Luna / medium |
| Builder | Coordinated implementation across logic or files | Grade its own work as independent evidence | Terra / medium |
| Reviewer | Independent read-only assessment | Implement the correction it reviews | Sol / high |

Chief is the accountable primary session, not a fifth worker. The table shows simple defaults currently packaged in the Codex adapter; it does not define the contracts. A Scout may need a balanced model for long-context discovery, while a narrow Coder task may remain fast. See the full [execution-contract × capability matrix](.agents/skills/cost-efficient-orchestration/host-model-routing.md#execution-contract-and-capability-lane).

## One dispatcher, specialized methods

| Task method | Chief | Scout, usually fast | Coder, usually fast | Builder, usually balanced | Reviewer, usually strong |
| --- | --- | --- | --- | --- | --- |
| General repository work | Frame, route, integrate, decide | Locate files and dependencies | Make a frozen narrow edit | Coordinate logic and interfaces | Audit consequential evidence |
| [`evidence-review`](.agents/skills/evidence-review/SKILL.md) | Freeze boundary and synthesize | Search, deduplicate, screen, extract | Fixed ledger or export only | Retrieval tooling moves to software work | Audit systematic or novelty claims |
| [`hypothesis-study-design`](.agents/skills/hypothesis-study-design/SKILL.md) | Compare hypotheses and freeze decisions | Extract evidence, assumptions, confounders | Frozen calculation scripts only | Simulations use the general build route | Audit causal and statistical logic |
| [`paper-code-reproduction`](.agents/skills/paper-code-reproduction/SKILL.md) | Freeze protocol and assign status | Map claims, code, data, dependencies | Repair environment or smoke path | Build coordinated claim-level execution | Grade protocol and claim evidence |
| [`scientific-figure`](.agents/skills/scientific-figure/SKILL.md) | Freeze the visual argument | Locate data, assets, provenance | Make a narrow plotting edit | Build panels or editable schematics | Audit scientific and visual meaning |
| [`research-software-lifecycle`](.agents/skills/research-software-lifecycle/SKILL.md) | Choose maturity and tradeoffs | Inventory interfaces and environments | Edit tests, docs, packaging, config | Build API, CI, container, or HPC flow | Audit reliability and public boundary |

This is a routing map, not a team that must all run. Chief normally works alone or selects one cell. A matching Skill supplies the method and starting route; unmatched units use the general row. S0–S4 may add independent review but does not upgrade every executor.

When research crosses methods, the lightweight [research-lineage contract](.agents/skills/cost-efficient-orchestration/research-lineage.md) connects sources, evidence, claims, gaps, hypotheses, studies, findings, and downstream artifacts with stable IDs. These links are many-to-many, and a knowledge graph is only an optional view. Chief passes the next Skill only the relevant lineage slice, preserving traceability without loading the whole research history.

Today the repository provides the control plane, five research-method contracts, thin host adapters, and an installer. Scientific databases, plotting libraries, reproduction runtimes, and benchmarks remain optional external capabilities; they are selected by a real project rather than bundled into Chief. The [adoption ledger](docs/ecosystem-and-credits.md#adoption-ledger-by-local-skill) records exactly what each local Skill takes from earlier work and what it leaves out.

## Harness compatibility

The portable core uses the open [Agent Skills specification](https://agentskills.io/specification). Canonical Skills are stored once under `.agents/skills/`.

- Codex, Gemini CLI, OpenCode, OpenHands, Cursor, and DeepSeek Harness can discover `.agents/skills` directly, subject to each host's trust and enablement settings.
- Claude Code follows the same Skill standard but discovers `.claude/skills`; the installer creates safe links to the canonical Skills.
- Roo Code, Cline, GitHub Copilot, Aider, and programmatic agent SDKs expose useful but different instruction, agent, permission, and model surfaces. They need a thin adapter; they are not separate copies of the framework.
- DeepSeek can be either the model provider inside another harness or the model used by DeepSeek Harness. Model provider and harness are separate choices.

Codex remains the reference implementation in this repository because its execution-contract profiles are already configured under `.codex/`. The core contract is no longer Codex-only. The [harness landscape](docs/harness-landscape.md) records the current compatibility boundary and the ideas adopted from each system.

## Install or update

Preview first. The default installs the Codex reference adapter:

```sh
./scripts/install-global.sh --dry-run
```

Choose a target when needed:

```sh
./scripts/install-global.sh --host portable --dry-run
./scripts/install-global.sh --host claude --dry-run
./scripts/install-global.sh --host all --dry-run
```

Then replace `--dry-run` with `--install`. After pulling repository updates, run the same command with `--update`. Use `--status` to inspect without changing anything.

The installer never copies the whole repository into every project. It creates links back to this clone, updates only marked instruction blocks, and refuses to replace conflicting user files. `portable` installs all shared Skills. `claude` also links them into Claude Code's native Skill directory. `all` installs the portable Skills plus the Codex and Claude adapters. The installer is shell-only; no Python environment is involved.

## Use in a project

A working project normally keeps only:

```text
AGENTS.md / CLAUDE.md / GEMINI.md   Local rules for the active host
tasks/                              One record for consequential work
host config                         Only local overrides that are truly needed
```

Start a normal task. For nontrivial work, Chief emits a short `CHIEF DECISION`, loads a matching Skill if one exists, selects zero or one worker by default, and verifies returned evidence. S3/S4 work receives independent review; S4 conclusions still require explicit human acceptance.

The user does not choose a luxury/basic/minimal profile or manually assemble an agent chain. Routing is part of Chief's job.

## Cost discipline

- Start with no subagent.
- Load method detail only after a task match.
- Delegate only when the bounded result saves more context or effort than the handoff costs.
- Use one worker at a time by default and only one writing worker.
- Escalate capability after evidence of ambiguity, failure, conflict, or judgment need.
- Do not use maximum reasoning by default.
- Stronger claims require stronger evidence and review, not uniformly stronger implementation models.

The source landscape and adoption boundaries are recorded in [the research capability inventory](tasks/2026-09-01-research-capability-inventory.md). Its useful methods are now represented by the five on-demand Skills above without turning Chief's standing prompt into a research encyclopedia.

## Ecosystem and credits

BoundedFreedom builds on existing research methods, tools, benchmarks, domain libraries, and agent harnesses. The [ecosystem, influences, and credits](docs/ecosystem-and-credits.md) page explains what each related project contributes, what this repository adopts, and what remains separate. Each Skill also keeps a short provenance note close to the method it uses.

Upstream projects are watched for useful changes, but never merged into a Skill automatically. Stars are a human acknowledgement; releases and scheduled reviews are the update signal.

The public [Wiki](https://github.com/Nat-Sci/bounded-freedom/wiki) is the shorter, navigable entry point. Versioned documentation remains in this repository.

Read [CONSTITUTION.md](CONSTITUTION.md) for non-negotiable boundaries and the [orchestration Skill](.agents/skills/cost-efficient-orchestration/SKILL.md) for the live selection algorithm. Original Bootstrap materials remain under [docs/design-history](docs/design-history/).
