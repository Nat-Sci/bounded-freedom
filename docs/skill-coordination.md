# Skill coordination

BoundedFreedom has one dispatcher and six research-method Skills. They are not a permanent team and do not all run for every request. Chief keeps accountability, activates one method for the current bounded work unit, verifies its return, and then decides whether another method is needed.

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

Each phase carries the frozen objective, accepted evidence, active project rules, relevant files or source slice, verification, and stop condition. Completed logs, inactive Skill bodies, superseded plans, and unrelated history stay outside the next phase's context. If a frontier phase resolves a hard architecture or evidence conflict, its stable implementation returns to balanced capability and mechanical follow-up returns to fast capability.

A handoff records the planned and actual route, whether balanced capability was eligible, the outcome, any escalation evidence, and the next safe action. This receipt supports cost evaluation without retaining prompts, private paths, or raw message and command bodies. Method lineage remains separate from execution telemetry.

## Method ownership

| Decision being made | Active method | Output handed forward | Boundary |
| --- | --- | --- | --- |
| What is known within a declared search boundary? | `evidence-review` | Sources, evidence, claims, gaps, and uncertainty | It does not design one preferred story or execute a project study |
| Which competing explanations and tests should be frozen? | `hypothesis-study-design` | Hypotheses, predictions, study contract, statistical plan, and human freeze points | It does not relabel post hoc interpretation as confirmation |
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
                                               ├─→ paper-code-reproduction
                                               └─→ project-owned execution

data source + STD rules ─→ scientific-data-quality ─→ DSET / QCK / SPL
                                                            ↓
                                                    project-owned execution

paper-code or project RUN ─→ FND
                               ├─→ scientific-figure ─→ ART-FIG
                               └─→ research-software-lifecycle ─→ accepted capability
```

This is a route map, not a mandatory linear pipeline. A task may enter at any node, loop back after new evidence, or stop when the frozen question has been answered. Each transition uses a bounded lineage handoff rather than copying the entire literature corpus, run history, or Skill text.

## Overlap rules

- **Search versus reproduction:** `evidence-review` finds and evaluates the landscape; `paper-code-reproduction` freezes one paper, implementation source, and observable for mapping or execution.
- **Study design versus result interpretation:** the study Skill freezes hypotheses and analysis choices. Project execution records observations and findings. New post-result explanations remain exploratory and create a new version.
- **Study design versus data quality:** study design owns estimands, populations, and planned analysis. `scientific-data-quality` tests data contracts, exclusions, transformation lineage, and leakage against that frozen authority; it does not revise the study after seeing outcomes.
- **Data quality versus pipeline implementation:** the data-quality Skill defines checks and evidence. General or lifecycle work implements a broader ETL, training, deployment, or monitoring pipeline.
- **Data quality versus statistical inference:** schema validity, missingness, exclusions, and leakage are preconditions, not estimates or scientific conclusions. Statistical interpretation remains project-owned until a dedicated method is justified.
- **Analysis versus figure:** analysis code owns values and scientific geometry; the figure Skill owns visual argument, assembly, and QA. Visual polish cannot change the analysis.
- **Project code versus software lifecycle:** general project work executes the current contract. The lifecycle Skill is activated only when accepting a durable capability, changing the frame, hardening, or releasing it.
- **Skill versus tool:** a Skill defines method and evidence. Databases, RAG systems, plotting libraries, runtimes, and scaffolds remain optional capabilities selected for a frozen need.
- **Execution contract versus intelligence:** Scout, Coder, Builder, and Reviewer describe ownership and independence. Model family and reasoning effort are selected separately for the work unit; eligible coordinated work starts balanced before non-review strong or frontier execution.
- **Method versus assurance:** S0–S4 controls the evidence and review gate. It neither names the task nor automatically upgrades every executor.

## Known gaps

Cross-domain statistical analysis and post-result inference do not yet have one local method Skill. Project contracts and frozen study plans currently own that work. Scientific writing also has no local Skill. These are explicit gaps, not permission for another existing Skill to expand silently; repeated real tasks should establish a stable contract before either becomes a new directory.
