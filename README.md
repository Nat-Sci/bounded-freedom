# BoundedFreedom

> **Boundaries turn capability into reliable action.**

![BoundedFreedom research cover showing MRI anatomy, cortical networks, evidence verification, and human judgment](docs/assets/bounded-freedom-neuro-research-cover.png)

Modern AI models can already do a great deal. The harder problem is making their work reliable, affordable, recoverable, and true to human intent over long tasks.

BoundedFreedom treats this as an environment-design problem. The model sets what may be possible, context sets what it can see, and the harness sets what it may do, what it must protect, how it gets feedback, and how its work is checked. Clear boundaries do not only limit action; they make useful action dependable.

BoundedFreedom is a constraint-first, cost-aware harness layer for AI-assisted research and engineering. The current primary session acts as **Chief**: it frames the task, loads only the needed method, chooses the least costly capable worker, checks the evidence, and keeps final accountability.

## Four small layers

| Layer | Purpose | Where it lives |
| --- | --- | --- |
| Constitution | Stable human, scientific, privacy, and evidence boundaries | `CONSTITUTION.md` |
| Portable Skills | Methods loaded only when a task needs them | `.agents/skills/` |
| Host adapter | Instruction discovery, agents, tools, permissions, and model syntax | `AGENTS.md`, `CLAUDE.md`, `GEMINI.md`, `.codex/` |
| Project contract | Local data, scientific, execution, and acceptance rules | The working project's own instruction files |

The first two layers are intended to travel across compatible harnesses. Host files remain thin adapters. Project facts stay with the project instead of being copied into this repository.

## How it works

```text
User request
    ↓
Chief frames intent and identifies the task type
    ↓
Load one matching Skill when specialized method is needed
    ↓
Freeze scope and set the S0–S4 evidence gate
    ↓
Chief works directly, or delegates one bounded unit
    ↓
Verify actual evidence
    ↓
Independent review when the consequence requires it
    ↓
Decision, record, and remaining uncertainty
```

Three decisions stay separate:

1. **Task route:** general work, evidence review, hypothesis and study design, paper-code reproduction, scientific figure, research software, or another specific method.
2. **Model capability:** choose a model for each bounded unit from workload, context, ambiguity, coding depth, and required judgment.
3. **Assurance:** S0–S4 controls evidence, independent review, and human acceptance. It is not a task label or a model tier.

## Roles without prestige

| Role | Normal capability need | Use only when |
| --- | --- | --- |
| Scout | Fast, economical reading and retrieval | Discovery would consume substantial Chief context |
| Coder | Fast, reliable execution | A narrow, low-ambiguity edit is already frozen |
| Builder | Balanced coding and long-context reasoning | Logic, interfaces, or related files must change together |
| Reviewer | Strong independent judgment | The result needs a genuinely separate assessment |

These are work contracts, not permanent model identities. Concrete model names belong to a host adapter and may change as models, prices, and evidence change. See the [host routing reference](.agents/skills/cost-efficient-orchestration/host-model-routing.md).

## Research methods on demand

| Skill | Loaded when the task needs |
| --- | --- |
| [`evidence-review`](.agents/skills/evidence-review/SKILL.md) | Literature search, screening, synthesis, or novelty review |
| [`hypothesis-study-design`](.agents/skills/hypothesis-study-design/SKILL.md) | Competing hypotheses, discriminating tests, or a study plan |
| [`paper-code-reproduction`](.agents/skills/paper-code-reproduction/SKILL.md) | Paper-code mapping, smoke execution, or claim-level reproduction |
| [`scientific-figure`](.agents/skills/scientific-figure/SKILL.md) | Data figures, architecture diagrams, method schematics, or domain visualization |
| [`research-software-lifecycle`](.agents/skills/research-software-lifecycle/SKILL.md) | Proportionate scripts, packages, public software, or HPC pipelines |

Chief sees only these descriptions until a task matches. The selected Skill supplies the method; orchestration supplies model and assurance decisions; the working project supplies local scientific constraints.

## Harness compatibility

The portable core uses the open [Agent Skills specification](https://agentskills.io/specification). Canonical Skills are stored once under `.agents/skills/`.

- Codex, Gemini CLI, OpenCode, OpenHands, Cursor, and DeepSeek Harness can discover `.agents/skills` directly, subject to each host's trust and enablement settings.
- Claude Code follows the same Skill standard but discovers `.claude/skills`; the installer creates safe links to the canonical Skills.
- Roo Code, Cline, GitHub Copilot, Aider, and programmatic agent SDKs expose useful but different instruction, agent, permission, and model surfaces. They need a thin adapter; they are not separate copies of the framework.
- DeepSeek can be either the model provider inside another harness or the model used by DeepSeek Harness. Model provider and harness are separate choices.

Codex remains the reference implementation in this repository because its role definitions are already configured under `.codex/`. The core contract is no longer Codex-only. The [harness landscape](docs/harness-landscape.md) records the current compatibility boundary and the ideas adopted from each system.

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
