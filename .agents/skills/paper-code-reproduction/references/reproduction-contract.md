# Reproduction contract

Read before changing code, executing a paper workflow, or judging a reproduction claim.

## Incoming lineage target

Keep only applicable fields:

```text
handoff_id
source_id
claim_id
hypothesis_id
prediction_id
study_id
expected_observable
requested_implementation_source
requested_evidence_depth
acceptance_and_indeterminate_rules
```

## Select two independent axes

**Implementation source**

- `author_unmodified`: an author-associated release or pinned commit with no behavioral edits.
- `author_repaired`: author code with disclosed environment, compatibility, wrapper, or defect corrections intended to preserve method and protocol.
- `adapted`: reused code with a changed data path, protocol, metric, runtime behavior, or method surface that affects identity.
- `independent`: core behavior implemented from the paper contract without reusing author code; other repositories remain reference evidence.

An author-like repository name is not source evidence. Use paper, supplement, project-page, author-organization, release, or maintainer evidence. If the relationship remains uncertain, record `unknown`.

**Evidence depth**

- `map`: static paper-to-code or paper-to-requirement correspondence.
- `smoke`: the smallest representative execution needed to validate plumbing and expose blockers.
- `claim`: a frozen comparison of a named observable against declared acceptance rules.

| Source | `map` | `smoke` | `claim` |
| --- | --- | --- | --- |
| `author_unmodified` | Pinned author-code correspondence | Bounded author path runs | Named claim is computationally reproduced under frozen identities |
| `author_repaired` | Correspondence plus repair points | Repaired path runs | Named claim is compared with every repair disclosed |
| `adapted` | Correspondence plus divergence | Adapted path runs | Result applies to the adapted protocol, not silently to the original |
| `independent` | Paper-derived implementation contract | New implementation runs | Named claim receives an independent test under the frozen protocol |

New-population, new-dataset, or new-condition replication belongs in study design and project execution. Link it here without hiding it inside the source axis.

## Core receipts

Keep the receipts small, but preserve the fields that determine interpretation:

| Receipt | Required fields |
| --- | --- |
| Repository source | candidate ID; paper version; repository or project handle; `author-associated`, `external-reference`, or `unknown`; relationship evidence; commit or release; license and access; selection or rejection reason |
| Implementation requirement | requirement and claim IDs; paper location; obligation type (`data`, `preprocessing`, `model`, `training`, `evaluation`, `metric`, or `artifact`); explicit or inferred; required behavior; expected code surface and artifact; acceptance evidence; unresolved assumption; status |
| Reference evidence | evidence and requirement IDs; source relationship; repository, commit, and location; what it establishes; license boundary; limitation or conflict |
| Claim map | claim and requirement IDs; paper location; expected observable; source-receipt IDs; implementation source; existing or planned code surface; config, data, checkpoint, and evaluation paths; direct evidence; inference or gap |
| Resource gate | target claim and decision; data and permission availability; compute, hardware, time, network, and API needs; cost class; lowest decisive cost-ladder step; planned scale; permitted downscale; stop or downgrade condition |
| Change record | change ID and location; reason; semantic class; affected requirement and claim IDs; expected or observed effect; implementation source after change; verification |

Paper statements, target-code behavior, external reference evidence, and reviewer inference remain separate. An inferred requirement stays an assumption until an authoritative source resolves it. Related repositories may explain a convention, but do not prove that the paper used it.

Use these change classes instead of severity labels:

- `environment-only`: installation or system change with no intended code or protocol effect.
- `compatibility`: interface or version repair intended to preserve behavior.
- `code-defect-correction`: correction to author code that may affect behavior and needs explicit justification.
- `protocol-changing`: data, preprocessing, training, evaluation, metric, or scale change; route as `adapted`.
- `method-changing`: core scientific-method change; route as `adapted` or `independent`.

Judge the source route by scientific effect, not diff size.

## Evidence requirements

| Depth | Minimum evidence | Completion boundary |
| --- | --- | --- |
| `map` | Paper identity, source receipts, requirements, traced or planned code surfaces, and gaps | Correspondence or obligations, not execution |
| `smoke` | Frozen environment, minimal permitted data and config, representative run, and output sanity checks | One bounded path runs |
| `claim` | Protocol, data, seeds, preprocessing, metric, baseline, tolerance, repeated runs when needed, and fresh comparison | Agreement or disagreement only for the named claim and source route |

Before interpreting output, bind paper and supplement version; repository receipt, commit, dirty state, and changes; implementation source and evidence depth; runtime and hardware; data release, preprocessing, order, and split; model, initialization, checkpoint, and training state; effective configuration; and metric, aggregation, uncertainty, and tolerance.

If the frozen claim needs a scale the available budget cannot support, redefine the target and acceptance rule before execution or report it as `blocked`. Do not silently shrink a retained protocol and compare it with a full-scale paper value.

## Comparison states

- `matched`: the frozen observable falls within tolerance under sufficiently matched identities.
- `mismatched`: a valid matched comparison falls outside tolerance.
- `blocked`: a named dependency, permission, data, compute, or documentation gap prevents comparison.
- `indeterminate`: execution happened, but identity or evidence is too weak to decide.

Do not choose tolerances after seeing results without labeling the analysis exploratory. Do not tune toward a reported value and then present that value as independent verification.

## Run and finding receipt

When a result enters the research record, retain:

```text
run_id
tested_ids
implementation_source
evidence_depth
source_requirement_reference_and_change_ids
resource_gate_decision
protocol_and_environment_identity
observable_and_result
comparison_state
uncertainty_and_deviations
finding_id
supports_weakens_contradicts_or_indeterminate_for_ids
produced_artifact_ids
next_smallest_decisive_test
```

Link these records through the shared [research-lineage contract](../../cost-efficient-orchestration/research-lineage.md). Preserve the frozen claim or hypothesis; update it only through a versioned relationship.

For S3/S4 claims, keep execution and grading independent. When practical, grade artifacts from a clean checkout or equivalent isolated replay rather than the executor's narrative.

## Cost ladder

1. Static claim map, source check, and config resolution.
2. Import, compile, unit, or dry-run checks.
3. Tiny synthetic or documented example.
4. Small real-data or checkpoint evaluation.
5. Full baseline or ablation.
6. Claim-level repeated run.

Climb only when the lower step cannot answer the frozen question. Record a downgrade and its reason instead of relabeling weaker evidence as a stronger result.

## Sources and optional systems

- [research-paper-code-study](https://github.com/baizhanxu/research-paper-code-study-codex-skill): concept-to-runtime mapping.
- [paperReproductAgent](https://github.com/Winter-And-You-Gone/paperReproductAgent): repository discovery, runnable checks, staged fallback, and downgrade reasons.
- [ReproAgent](https://arxiv.org/abs/2608.24291): persistent requirements and a separate reference-evidence channel.
- [Veritas](https://github.com/ChicagoHAI/veritas): source routes, change assessment, resource estimation, and independent claim grading.
- [AutoExperiment](https://github.com/j1mk1m/AutoExperiment) and [SocSci-Repro-Bench](https://github.com/malizad/SocSci-Repro-Bench): supplied-code conditions and domain breadth.
- [xKG](https://github.com/zjunlp/xKG), [Paper2Code](https://github.com/going-doer/Paper2Code), and [DeepCode](https://github.com/HKUDS/DeepCode): experimental mapping or builder references, not reproduction proof.
- [PaperBench](https://github.com/openai/frontier-evals/tree/main/project/paperbench), [ScienceAgentBench](https://github.com/OSU-NLP-Group/ScienceAgentBench), and [SciReplicate-Bench](https://github.com/xyzCS/SciReplicate-Bench): evaluation references, not default runtime dependencies.
