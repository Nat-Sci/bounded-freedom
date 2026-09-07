# Skill coordination

BoundedFreedom has one dispatcher, six research-method Skills, and one
discoverable `mathematical-methods` Skill. They are not a permanent team and do
not all run for every request. Chief keeps accountability, activates one method
for the current bounded work unit, verifies its return, and then decides
whether another method is needed. The mathematical Skill first uses its
problem-mapping reference unless an accepted map already exists, then loads at
most one statistical, neural-network, or loss/objective method module if a
further question remains. A mapping-only request ends with the accepted map.

```text
mathematical-methods/
├── SKILL.md                              discoverable entry
└── references/
    ├── problem-map.md                    default mapping stage
    ├── statistical-model-analysis/
    │   └── method.md                     on-demand module
    ├── neural-network-mathematical-analysis/
    │   └── method.md                     on-demand module
    └── loss-objective-optimization/
        └── method.md                     on-demand module
```

The three module directories contain `method.md`, not `SKILL.md`, so they do
not compete for discovery or trigger independently.

## Layers and precedence

| Layer | Owns | Does not own |
| --- | --- | --- |
| Constitution | Human authority, scientific integrity, privacy, and evidence priority | Task-specific procedure or host syntax |
| Chief orchestration | Intent, work units, execution contract, model and effort, S0–S4, handoffs, verification, and final decision | Specialist method details or project facts |
| Active Skill | The method and output contract for one bounded work unit | Chief accountability, host model IDs, or local scientific truth |
| Project contract | Data, cohort, split, atlas, compute, ethics, analysis, and acceptance rules | Portable routing policy |
| External capability | Search, plotting, statistics, execution, storage, or another operation | Scientific judgment or acceptance |

When instructions disagree, follow the Constitution first, then the project-owned scientific facts and human decisions. Chief resolves routing and assurance; the active Skill controls method inside that frozen boundary.

## Phase hierarchy and compact handoffs

The Astra Edition keeps one Chief while allowing a long request to move through lower-cost phases:

```text
admit and bound
    -> activate one method
    -> choose one execution contract and capability lane
    -> verify the observable
    -> retain a compact checkpoint
    -> lower, escalate, change method, or stop
```

Each phase carries the frozen objective, accepted evidence, active project rules, relevant files or source slice, verification, and stop condition. Completed logs, inactive Skill bodies, superseded plans, and unrelated history stay outside the next phase's context. If a frontier phase resolves a hard architecture or evidence conflict, its stable implementation returns to balanced capability, narrow code iteration returns to the host's fast-code route, and general mechanical follow-up returns to fast general capability.

A handoff records the planned and actual route, whether balanced capability was
eligible, the outcome, any escalation evidence, and the next safe action. For
nontrivial work, one combined `CHIEF DECISION / ROUTE START`, material
`ROUTE CHANGE`, and final `ROUTE END` make this control state visible. Profile
and launch settings describe configured values; supplied UI values remain
UI-selected. Authoritative host runtime metadata establishes the host-recorded
model and effort, not a hidden backend snapshot or billing. Missing values stay `unknown`. The receipt exposes decisions, not
hidden reasoning. Method lineage remains separate from execution telemetry.

Method tables describe suitable work, not mandatory agent launches. Existing
calculations and checks run directly. Bounded read-only synthesis can use a
Scout contract with balanced capability, while coordinated writing uses
Builder. Chief accepts the result in either case. A method's "direct" row
does not bypass the orchestration balanced gate or change Chief's runtime
model. The current four profiles are unpinned and require explicit model/effort
controls while preserving their permissions; stale loaded settings are not a
second supported configuration.

The task-kind matrix in the [host routing adapter](../.agents/skills/cost-efficient-orchestration/host-model-routing.md#canonical-task-kind-matrix)
is the single model/effort starting policy. Code mapping, general evidence, and
system mapping can all use Scout with different models; changing to code edits
changes the execution contract and cannot silently grant write permissions to
a Scout. The four canonical profiles are explicit-pair host adapters, not new
specialist Skills or additional worker slots. A launch ticket binds the task
kind, contract, assurance, profile, requested pair, scope, checks, and remaining
budget; actual controls and observed receipts establish whether it was honored.
Reserve required review before discovery so a three-worker chain is not implied.
Known Spark quota blocks select the matrix's fitting Luna/Terra alternative
before launch. Confirm terminal state and inspect side effects before mid-task
handoff; neither quota failure nor a passed reset time expands the worker budget.

## Method ownership

| Decision being made | Active method | Output handed forward | Boundary |
| --- | --- | --- | --- |
| What is known within a declared search boundary? | `evidence-review` | Sources, evidence, claims, gaps, and uncertainty | It does not design one preferred story or execute a project study |
| Which competing explanations and tests should be frozen? | `hypothesis-study-design` | Hypotheses, predictions, study contract, statistical plan, and human freeze points | It does not relabel post hoc interpretation as confirmation |
| What mathematical problem do existing papers, code, and data actually define? | `mathematical-methods` problem-mapping stage | Mathematical objects, assumptions, claim-equation-code-data links, inconsistencies, and one next module | It reconstructs before proposing and does not perform the downstream analysis |
| Which statistical model answers one frozen cross-sectional, longitudinal, developmental, or clinical-prediction question? | `mathematical-methods` / statistical module | Estimand, dependence and observation model, code correspondence, diagnostics, uncertainty, sensitivity, and supported claim boundary | It does not clean data, select a hypothesis post hoc, or make a clinical decision |
| What does a neural network compute and which structural or optimization claims can it support? | `mathematical-methods` / network module | Operator and dependency maps, property checks, counterexamples, redesign contract, and proof obligations | Numerical checks are not universal proof and implementation is a later work unit |
| Does the implemented loss express the intended objective and produce the intended gradients? | `mathematical-methods` / loss and optimization module | Objective ledger, reductions, weights, gradient paths, degeneracy checks, and a frozen redesign | It does not own the whole architecture, training run, or scientific conclusion |
| Are data structurally understood, traceable, and safe to hand into the frozen analysis? | `scientific-data-quality` | Data contract, QC summary, exclusion ledger, leakage audit, transformation lineage, and uncertainty | It does not perform statistical inference, interpret results, or own the whole pipeline |
| Does a paper's code implement or reproduce a named claim? | `paper-code-reproduction` | Source and requirement map, run receipt, comparison state, and finding | New populations or conditions return to study design and project execution |
| How should a retained claim or finding be communicated visually? | `scientific-figure` | Figure contract, editable source, render, caption inputs, and QA state | A figure is not new evidence and may not invent values or anatomy |
| How should accepted capabilities accumulate in durable software? | `research-software-lifecycle` | Baseline, bounded increment, migration or release receipt, and known limits | Packaging and tests do not establish scientific validity |
| What ordinary repository or execution work remains? | General route | Frozen implementation or verification result | General work does not silently substitute for a missing scientific method |

## Common handoffs

```text
Question or OBS
    ├─→ evidence-review ─→ SRC / EVD / CLM / GAP
    │                         ↓
    └────────────────→ hypothesis-study-design ─→ HYP / PRD / STD
                                               ├─→ targeted evidence update
                                               ├─→ mathematical-methods
                                               ├─→ paper-code-reproduction
                                               └─→ project-owned execution

paper + code + data + CLM/HYP/STD
    └─→ mathematical-methods ─→ problem map
                                   ├─→ statistical module
                                   ├─→ network mathematics module
                                   ├─→ loss and optimization module
                                   └─→ formal-proof-gap

data source + STD or mathematical rules
    └─→ scientific-data-quality ─→ DSET / QCK / SPL
                                      ├─→ mathematical-methods / statistical module
                                      └─→ project-owned execution

paper-code or project RUN ─→ FND
                               ├─→ scientific-figure ─→ ART-FIG
                               └─→ research-software-lifecycle ─→ accepted capability
```

This is a route map, not a mandatory linear pipeline. A task may enter at any node, loop back after new evidence, or stop when the frozen question has been answered. Each transition uses a bounded lineage handoff rather than copying the entire literature corpus, run history, or Skill text.

## Overlap rules

- **Search versus reproduction:** `evidence-review` finds and evaluates the landscape; `paper-code-reproduction` freezes one paper, implementation source, and observable for mapping or execution.
- **Study design versus result interpretation:** the study Skill freezes hypotheses and analysis choices. Project execution records observations and findings. New post-result explanations remain exploratory and create a new version.
- **Study design versus data quality:** study design owns estimands, populations, and planned analysis. `scientific-data-quality` tests data contracts, exclusions, transformation lineage, and leakage against that frozen authority; it does not revise the study after seeing outcomes.
- **Hypothesis versus mathematical formulation:** hypothesis design owns competing explanations and the human freeze point. The `mathematical-methods` problem-mapping stage reconstructs the mathematics already present in retained artifacts; it does not choose the most attractive hypothesis.
- **Paper-code mapping versus mathematical mapping:** reproduction owns source identity, protocol, execution, and claim comparison. Mathematical mapping owns the symbols, operators, assumptions, and code-data correspondence inside that frozen source boundary.
- **Data quality versus pipeline implementation:** the data-quality Skill defines checks and evidence. General or lifecycle work implements a broader ETL, training, deployment, or monitoring pipeline.
- **Data quality versus statistical inference:** schema validity, missingness, exclusions, and leakage are preconditions, not estimates or scientific conclusions. The `mathematical-methods` statistical module consumes the accepted contract and owns the bounded model, uncertainty, diagnostics, and claim-support analysis.
- **Network mathematics versus loss mathematics:** network analysis owns functional structure, information paths, parameter coupling, and architecture-level properties. Loss analysis owns scalarization, reductions, weights, surrogate meaning, and resulting gradient incentives. A coupled problem is split at a frozen interface rather than loading both full Skills at once.
- **Mathematical analysis versus implementation:** the mathematical Skill returns a frozen problem or change contract. Coder, Builder, reproduction, or lifecycle work implements and tests it in a later unit; passing code checks does not retroactively validate the mathematics.
- **Mathematical analysis versus proof:** algebra, symbolic manipulation, automatic differentiation, numerical probes, and counterexample search provide bounded evidence. They do not certify a universal theorem.
- **Analysis versus figure:** analysis code owns values and scientific geometry; the figure Skill owns visual argument, assembly, and QA. Visual polish cannot change the analysis.
- **Project code versus software lifecycle:** general project work executes the current contract. The lifecycle Skill is activated only when accepting a durable capability, changing the frame, hardening, or releasing it.
- **Skill versus tool:** a Skill defines method and evidence. Databases, RAG systems, plotting libraries, runtimes, and scaffolds remain optional capabilities selected for a frozen need.
- **Execution contract versus intelligence:** Scout, Coder, Builder, and Reviewer describe ownership and independence. Model family and reasoning effort are selected separately for the concrete task kind; eligible coordinated work starts balanced before non-review strong or frontier execution. A fast-code model may back a read-only Scout or a writing Coder; the selected profile must preserve that distinction rather than equate the model with a role.
- **Method versus assurance:** S0–S4 controls the evidence and review gate. It neither names the task nor automatically upgrades every executor.

## Future Work: formal proof verification

Strict proof production and machine-checked verification remain an explicit
capability gap. The current mathematical Skill and its modules may state definitions, assumptions,
lemmas, proof obligations, informal derivations, numerical evidence, and
counterexamples, but they must return `formal-proof-gap` when acceptance
requires a proof-assistant-checked theorem.

Add an independent `formal-proof-verification` Skill only after real tasks
repeatedly require it and the repository can freeze:

- the supported theorem language and proof assistant;
- the translation contract from paper/code objects into formal definitions;
- trusted assumptions, imported libraries, environment identity, and build
  command;
- the machine-checked artifact and kernel verification receipt;
- the boundary between proof of a formal statement and applicability to the
  scientific or clinical system.

Lean is a plausible future adapter, not a current dependency or certification
claim. Scientific writing also remains a separate unimplemented method. These
gaps are not permission for another Skill to expand silently.
