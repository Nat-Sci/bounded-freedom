# BoundedFreedom

> **Boundaries turn capability into reliable action.**

Modern AI models can already do a great deal. The harder problem is making their work reliable, affordable, easy to recover, and true to human intent over long tasks.

BoundedFreedom treats this as a problem of how the working environment is designed. The model sets what may be possible, context sets what it can see, and the harness sets what it may do, what it must protect, how it gets feedback, and how its work is checked. Clear boundaries do not just limit action; they give the model room to act without losing control.

BoundedFreedom is a constraint-first, cost-aware harness for AI-assisted research and engineering. The main Codex session acts as the **Chief**: it defines the task, judges risk, works directly or assigns the least costly model that can do the job, checks the evidence, and records important decisions. Model choice is made for each role and decision, so more compute is used only when it is likely to improve the result.

## How it works

```text
User request
    ↓
Chief: frame intent → classify S0–S4 → freeze nontrivial scope
    ↓
Chief works directly, or delegates one bounded job
    ↓
Scout / Coder / Builder
    ↓
Chief verifies evidence
    ↓
Independent Reviewer when S3/S4 requires it
    ↓
Decision and remaining uncertainty
```

The Chief is not another agent configuration. It is the current Codex session and retains responsibility for scope, delegation, verification, and the final answer.

## Worker portfolio

| Role | Default model | Use only when |
|---|---|---|
| Scout | Luna / medium | Repository discovery would consume substantial Chief context |
| Coder | Luna / medium | A narrow, explicit, low-ambiguity edit is already frozen |
| Builder | Terra / medium | Implementation spans logic, interfaces, or several related files |
| Reviewer | Sol / high | Independent judgment is required, especially for S3/S4 |

These are defaults, not task profiles. The Chief may escalate a worker when evidence shows the assigned model is insufficient, but must state why.

## Install once for all Codex projects

BoundedFreedom is the single source of truth. Do not copy the whole framework into every project.

From a clone of this repository, first preview the changes:

```sh
./scripts/install-global.sh --dry-run
```

Then install explicitly:

```sh
./scripts/install-global.sh --install
```

The installer:

- creates safe symbolic links for `Scout`, `Coder`, `Builder`, and `Reviewer` under `~/.codex/agents/`;
- creates a symbolic link for the orchestration skill under `~/.agents/skills/`;
- adds or refreshes only its marked block in `~/.codex/AGENTS.md`;
- adds the BoundedFreedom `[agents]` defaults only when no other `[agents]` table exists;
- refuses to replace conflicting files, links, or user-owned configuration.

Restart Codex after the first installation. When this repository is updated, the linked agents and skill update immediately; run the update command to refresh the managed global instruction and configuration blocks:

```sh
git pull --ff-only
./scripts/install-global.sh --update
```

Use `./scripts/install-global.sh --status` to inspect the installation without changing anything. The installer is shell-only; no Python environment is involved.

## Use inside a research project

Each project keeps only its local rules and evidence:

```text
AGENTS.md             Project data, scientific, and verification boundaries
tasks/                Consequential task records when useful
.codex/config.toml    Only project-specific overrides, if needed
```

For example, an SCD project `AGENTS.md` can define cohort, ROI, split, and external-validation constraints; an RMT-D project can define manuscript and figure verification rules. The global Chief contract and worker portfolio are inherited automatically.

Start a normal Codex task. For nontrivial work, the Chief emits a short `CHIEF DECISION`, selects zero or one worker by default, and verifies the returned evidence. S3/S4 work receives an independent Reviewer, and S4 conclusions remain subject to explicit human acceptance. Consequential work is recorded in `tasks/` using [the task record](tasks/TEMPLATE.md).

Example request:

```text
Inspect the failing preprocessing stage, fix it if the intended behavior is clear,
run the relevant checks, and record any scientific uncertainty.
```

The user does not choose a profile or manually assemble an agent chain. That is the Chief's job.

## Cost discipline

- Start with no subagent.
- Delegate only when the worker's bounded output saves more Chief effort than the handoff costs.
- Use one worker at a time by default and only one writing worker.
- Do not make Scout rediscover what the Chief already inspected.
- Do not make the Chief repeat a worker's search; consume its cited evidence.
- Stop after two materially different failed attempts.
- Escalate model capability only with evidence.
- Stronger scientific claims require stronger review, not uniformly stronger implementation models.

Read [AGENTS.md](AGENTS.md) for the live Codex contract, [CONSTITUTION.md](CONSTITUTION.md) for non-negotiable boundaries, and the [orchestration skill](.agents/skills/cost-efficient-orchestration/SKILL.md) for the selection algorithm.

The original Bootstrap materials are preserved under [docs/design-history](docs/design-history/).
