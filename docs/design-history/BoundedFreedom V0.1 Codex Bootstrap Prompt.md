# BoundedFreedom V0.1 Bootstrap Prompt

## Objective

Create the V0.1 scaffold for a repository named `bounded-freedom`.

The repository is a cost-efficient, constraint-first agent collaboration harness for AI-assisted research and engineering.

Do not build a full application, plugin marketplace package, or domain-specific research system. V0.1 should consist of documentation, Codex configuration, custom agent contracts, one orchestration skill, templates, examples, and lightweight validation code.

# Architecture

Preserve this top-level architecture:

```text
Thinking Space
    ↓
Research Brief
    ↓
Freeze Gate
    ↓
Execution Space
    ↓
Classification
    ↓
Routing
    ↓
Execution
    ↓
Verification
    ↓
Scientific Review when required
    ↓
Decision Record
```

Thinking Space is part of the framework, but V0.1 implements only its interfaces:

- Research Brief
- Frozen Task Specification

The main implementation focus is the cost-efficient Execution Space.

# Required Repository Structure

Create exactly this initial structure:

```text
bounded-freedom/
├── README.md
├── CONSTITUTION.md
├── ARCHITECTURE.md
├── AGENTS.md
├── LICENSE
│
├── .codex/
│   ├── config.toml
│   └── agents/
│       ├── architect.toml
│       ├── scout.toml
│       ├── builder.toml
│       ├── qa.toml
│       └── scientific-reviewer.toml
│
├── .agents/
│   └── skills/
│       └── cost-efficient-orchestration/
│           ├── SKILL.md
│           └── references/
│               ├── routing.md
│               ├── role-contracts.md
│               ├── scientific-risk.md
│               └── return-schemas.md
│
├── docs/
│   ├── thinking-space.md
│   ├── execution-space.md
│   ├── model-routing.md
│   └── roadmap.md
│
├── templates/
│   ├── research-brief.md
│   ├── frozen-task-spec.md
│   ├── worker-spec.md
│   ├── qa-report.md
│   ├── scientific-review.md
│   └── decision-record.md
│
├── examples/
│   ├── discover/
│   │   └── README.md
│   ├── patch/
│   │   └── README.md
│   └── scientific-change/
│       └── README.md
│
├── scripts/
│   └── validate_repo.py
│
└── tests/
    └── test_repository_contract.py
```

# Codex Configuration

Create `.codex/config.toml` with these defaults:

```toml
[agents]
enabled = true
max_concurrent_threads_per_session = 2
default_subagent_model = "gpt-5.6-luna"
default_subagent_reasoning_effort = "low"
```

Do not set the primary-session model in this repository configuration.

Document three launch profiles:

```text
Micro:
Luna or Spark parent

Economy:
Terra / Medium parent

Critical:
Sol / High parent
```

# Custom Agent Requirements

Every custom agent TOML must define:

```text
name
description
model
model_reasoning_effort
sandbox_mode
developer_instructions
```

## architect.toml

```text
Model: gpt-5.6-sol
Reasoning: high
Sandbox: read-only
```

Contract:

- resolve material ambiguity;
- compare no more than two solutions;
- identify engineering and scientific risks;
- produce an implementation specification;
- define stop conditions;
- never edit code;
- never spawn another agent.

## scout.toml

```text
Model: gpt-5.6-luna
Reasoning: medium
Sandbox: read-only
```

Contract:

- locate relevant files and symbols;
- trace actual execution paths;
- collect evidence;
- cite file paths and symbols;
- avoid broad repository dumps;
- do not implement;
- do not propose unrelated redesigns;
- never spawn another agent.

Document GPT-5.3 Codex Spark as an optional manual replacement for fast code exploration, but do not make V0.1 depend on Spark availability.

## builder.toml

```text
Model: gpt-5.6-terra
Reasoning: medium
Sandbox: workspace-write
```

Contract:

- implement only an approved frozen specification;
- modify only explicitly owned files;
- preserve interfaces unless authorized;
- run requested local checks;
- stop if assumptions or schemas differ;
- make at most two materially distinct attempts;
- never silently change scientific intent;
- never spawn another agent.

## qa.toml

```text
Model: gpt-5.6-luna
Reasoning: medium
Sandbox: workspace-write
```

Contract:

- run specified tests and comparisons;
- inspect outputs and numerical sanity;
- do not modify tracked source files;
- return compressed evidence;
- include raw logs only for unresolved failures;
- never redesign the implementation;
- never spawn another agent.

## scientific-reviewer.toml

```text
Model: gpt-5.6-sol
Reasoning: high
Sandbox: read-only
```

Contract:

- review the frozen specification, actual diff, outputs, and QA report;
- check leakage, independence, statistical inference, preprocessing assumptions, interpretation, and claim support;
- never implement corrections;
- return exactly one verdict:

```text
ACCEPT
FIX_FIRST
RETHINK
INSUFFICIENT_EVIDENCE
```

- list findings by severity;
- state remaining uncertainty;
- never spawn another agent.

# Orchestration Skill

Create:

```text
.agents/skills/cost-efficient-orchestration/SKILL.md
```

The skill must:

1. Require a route declaration before task tools are used.
2. Classify:
   - task clarity;
   - read/write scope;
   - engineering complexity;
   - scientific risk S0–S4.
3. Select one of:
   - DIRECT;
   - DISCOVER;
   - PATCH;
   - ARCHITECT;
   - SCIENTIFIC_CHANGE;
   - CRITICAL_RESEARCH.
4. Default to zero or one auxiliary agent.
5. Allow at most two concurrent subagents.
6. Allow only one writing agent at a time.
7. Prohibit nested delegation.
8. Require explicit worker file ownership.
9. Require QA after implementation.
10. Require Scientific Reviewer for S3 and S4.
11. Require human approval for S4.
12. Require a Decision Record for every nontrivial task.
13. Prevent raw logs from entering the primary thread unless needed for unresolved diagnosis.
14. Prevent duplicated work between parent and worker.
15. Enforce the two-attempt stop rule.

Use progressive disclosure:

- keep `SKILL.md` concise;
- place detailed routing, contracts, risk definitions, and return schemas in `references/`.

# Route Declaration

Require this format before task tools:

```text
BOUNDED ROUTE

profile: micro | economy | critical
route: DIRECT | DISCOVER | PATCH | ARCHITECT | SCIENTIFIC_CHANGE | CRITICAL_RESEARCH
scientific-risk: S0 | S1 | S2 | S3 | S4
agents: <selected roles or none>
rationale: <one concise task-specific sentence>
```

# Worker Return Schemas

Define concise schemas.

## Scout Report

```text
Relevant files
Execution path
Evidence
Unknowns
Recommended next step
```

## Builder Report

```text
Files changed
Implementation summary
Tests run
Deviations
Unresolved issues
```

## QA Report

```text
Checks run
Pass/fail
Numerical comparison
Artifacts
Failures
Confidence
```

## Scientific Review

```text
Verdict
Critical findings
Major findings
Minor findings
Scientific uncertainty
Required next action
```

## Decision Record

```text
Goal
Profile and route
Scientific risk
Evidence
Alternatives considered
Decision
Rejected alternatives
Verification
Remaining uncertainty
Human approval if required
```

# Scientific Risk Definitions

Implement:

```text
S0:
presentation-only

S1:
engineering change expected to preserve scientific meaning

S2:
may affect numerical results

S3:
may affect statistical inference

S4:
may affect primary scientific claims, clinical interpretation, or ethical implications
```

Scientific-risk classification overrides code-change size.

# AGENTS.md

Keep root `AGENTS.md` short.

It must act as a map, not an encyclopedia.

It should point to:

- `CONSTITUTION.md`
- `ARCHITECTURE.md`
- orchestration skill
- role contracts
- validation command

Include these repository-development rules:

```text
Do not weaken the Constitution for convenience.
Do not add new agents without a documented role gap.
Do not add external dependencies in V0.1.
Keep custom agents narrow and non-overlapping.
Keep SKILL.md concise and move details into references.
Run validation after modifying configuration or contracts.
```

# Validation Code

Implement `scripts/validate_repo.py` using only the Python standard library.

It must verify:

- all required files exist;
- all TOML files parse using `tomllib`;
- each custom agent has required fields;
- sandbox modes match role expectations;
- all referenced documentation paths exist;
- `SKILL.md` includes `name` and `description` metadata;
- required templates exist;
- no placeholder such as `TODO`, `TBD`, or `<fill>` remains in required files.

Return exit code `0` on success and nonzero on failure.

Implement `tests/test_repository_contract.py` with `unittest`.

# Examples

Create three concise worked examples:

## discover

A read-only repository investigation using Scout.

## patch

A bounded implementation using Scout → Builder → QA.

## scientific-change

An S3 task using Freeze → Architect → Builder → QA → Scientific Reviewer → Decision Record.

Do not include domain-specific dMRI content yet.

# Constraints

- Do not build a web UI.
- Do not create a Python package.
- Do not add third-party dependencies.
- Do not package a plugin yet.
- Do not add recursive delegation.
- Do not add token-accounting APIs.
- Do not add CI in this first pass.
- Do not create more agent roles than specified.
- Do not invent unsupported Codex configuration fields.
- Prefer documentation and deterministic validation over abstraction-heavy code.
- Keep README concise.
- Keep role responsibilities non-overlapping.

# Verification

Run:

```bash
python scripts/validate_repo.py
python -m unittest discover -s tests -v
```

Both commands must pass.

# Final Return

Return only:

```text
1. Repository tree
2. Files created
3. Key architectural decisions
4. Validation commands and results
5. Remaining assumptions
```
