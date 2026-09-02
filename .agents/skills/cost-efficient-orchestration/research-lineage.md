# Research lineage contract

Read this reference when work crosses research Skills, when a scientific claim may be reused in a paper, figure, or software artifact, or when a project needs a durable research history.

## Purpose

Research lineage preserves how a result was reached without preserving hidden reasoning. It connects sources, extracted evidence, claims, gaps, hypotheses, tests, findings, and deliverables so that each later artifact can point back to the records that justify it.

The relationships are traceable **many-to-many**, not one-to-one:

- one source can report several pieces of evidence;
- one claim can depend on several sources or findings;
- one item of evidence can support, contradict, or contextualize several claims;
- one finding can update several hypotheses and appear in several deliverables.

The ledger is the canonical record. A knowledge graph or network diagram is an optional view derived from it, not a required database or a new source of truth.

## Minimal objects

Use stable project-local IDs. Prefixes are examples, not a required naming system.

| Object | Meaning | Example prefix | Primary owner |
| --- | --- | --- | --- |
| Source | A paper, dataset, repository, protocol, registry entry, or other citable object | `SRC` | `evidence-review` or the project |
| Evidence | A reported observation, result, measurement, or directly inspected behavior at a source location | `EVD` | `evidence-review`, reproduction, or the project |
| Claim | A bounded proposition that evidence may support, contradict, or contextualize | `CLM` | Chief with the relevant method Skill |
| Gap | A bounded missing, conflicting, weakly tested, or non-transferable part of the current knowledge state | `GAP` | Chief or `hypothesis-study-design` |
| Observation | A project result or pattern recorded before interpretation | `OBS` | The project or `hypothesis-study-design` |
| Hypothesis | A candidate explanation or relationship to test | `HYP` | `hypothesis-study-design` |
| Prediction | An observable implication that may distinguish hypotheses | `PRD` | `hypothesis-study-design` |
| Study | A frozen experiment or analysis contract | `STD` | `hypothesis-study-design` and the project |
| Run | An identified analysis, simulation, or reproduction execution | `RUN` | The executing project or `paper-code-reproduction` |
| Finding | A result interpreted only within a frozen study, run, and evidence boundary | `FND` | Chief and the project |
| Artifact | A manuscript statement, figure, code component, dataset release, or software release | `ART` | The producing task or Skill |

Each retained object needs only the fields that preserve identity and interpretation:

```text
id
type_and_subtype
short_statement_or_label
status
version
scope_or_evidence_boundary
provenance_or_location
```

## Typed relationships

Record relationships explicitly rather than implying them through prose order.

```text
from_id
relation
to_id
basis_or_source_location
status_or_uncertainty
record_version
```

Use a small vocabulary and extend it only when a real task needs another distinction:

```text
extracts_from
supports | contradicts | contextualizes
reveals_gap
motivates
predicts
tests
produces
updates | weakens | leaves_indeterminate
states | visualizes | implements
depends_on | supersedes
```

Example lineage:

```text
SRC-012 -> EVD-031 -> CLM-008 -> GAP-004 -> HYP-003
HYP-003 -> PRD-006 -> STD-002 -> RUN-014 -> FND-009
FND-009 -> ART-FIG-002 | ART-MANUSCRIPT-005 | ART-SOFTWARE-003
```

## Stage handoff

Chief passes a bounded lineage slice, not the entire network or full source texts:

```text
handoff_id
input_ids
records_created_or_updated
task_question
permitted_relation_changes
required_output_ids
verification_and_stop_condition
human_decision_required
```

This is a provenance interface, not a model router. The receiving Skill describes the method; Chief still selects execution contract, model capability, and S0-S4 assurance separately.

## Scientific rules

- Keep a source, its reported evidence, the reviewer's synthesis claim, and a new hypothesis as separate objects.
- A gap means “not resolved within this recorded boundary,” not “nothing exists.” Preserve the search or data cutoff that makes the gap meaningful.
- Record whether a hypothesis was proposed before or after inspecting the target result. A hypothesis generated or refined from preliminary data remains exploratory on those data; confirmation requires untouched data, a new sample, or independent replication.
- Do not overwrite a frozen claim, hypothesis, study, or finding. Create a new version and link it with `supersedes`.
- A figure communicates a claim or finding; it is not additional evidence. Passing software tests verifies engineering behavior, not the scientific claim implemented by the software.
- Human owners freeze primary hypotheses, confirmatory outcomes, major scientific claims, ethics decisions, and public release decisions.

## Storage and scale

- For one bounded task, a Markdown table or structured section in the project record is sufficient.
- Use CSV, JSON, JSONL, a citation manager, or a graph store only when project scale and repeated queries justify it.
- A personal research network may index project-approved lineage exports, but unpublished, sensitive, or restricted records stay under the project's data and privacy rules.
- Do not copy full papers, datasets, or large logs into the lineage ledger. Retain stable identifiers, source locations, compact statements, and artifact hashes or versions where useful.
- A dedicated scientific-writing Skill is not created by this contract. Until that capability is reviewed separately, a writing task may consume lineage by mapping each consequential manuscript statement and caption to its supporting `CLM` or `FND` IDs.
