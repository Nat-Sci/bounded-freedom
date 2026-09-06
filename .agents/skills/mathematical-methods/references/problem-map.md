# Problem-mapping contract

Use the smallest fields that preserve the target mathematical meaning and its evidence. Omit sections that do not apply; do not fill unknowns with plausible guesses.

## Identity and scope

```text
map_id_and_version
target_question_or_claim_ids
paper_or_document_versions
repository_and_code_identity
data_snapshot_or_schema_identity
permitted_inference
evidence_boundary
```

## Source anchors

Record stable locations without copying large source bodies:

| Source | Useful anchor |
| --- | --- |
| Paper or document | section, equation, proposition, table, figure, appendix, or short bounded passage |
| Code | repository-relative file, symbol, configuration key, test, or observed runtime path |
| Data | project-local field or schema identifier, unit, index, grouping key, time field, or label authority |
| Output | metric, tensor, table, figure, checkpoint, log event, or other observable with provenance |

## Mathematical-object inventory

```text
symbols_and_meanings
domains_shapes_and_units
indices_and_grouping
time_origin_scale_and_order
observed_latent_and_random_quantities
functions_operators_and_distributions
parameters_and_parameter_sharing
objectives_constraints_and_regularizers
boundary_initial_and_stopping_conditions
approximations_and_numerical_conventions
```

For each object, record its authority as `source-defined`, `implementation-observed`, `project-declared`, `analyst-inferred`, or `unknown`.

## Correspondence table

| Field | Meaning |
| --- | --- |
| Claim | The bounded proposition being mapped |
| Mathematical statement | Equation, inequality, distribution, optimization problem, algorithm, or qualitative property |
| Code path | Function or operation that purports to implement it |
| Data binding | Fields, indices, units, time points, labels, or sampling units consumed |
| Observable | Output that would expose agreement or disagreement |
| Link state | `reported`, `observed`, `derived`, `inferred`, `proposed`, `contradicted`, or `unknown` |
| Evidence | Source anchor, deterministic check, or bounded derivation |

Do not collapse `reported` and `observed`: documentation can disagree with executable behavior. Use `derived` only when the derivation and assumptions are shown. Use `proposed` for a repair or alternative rather than rewriting the mapped source.

## Consistency checks

- definitions are complete enough to evaluate the claimed property;
- symbol meanings, tensor shapes, axes, reductions, and units agree across sources;
- stochastic and deterministic interpretations are not conflated;
- population, sample, observation, subject, site, and time indices match the data structure;
- loss signs, normalizations, masking, weighting, stopping gradients, and update timing agree with prose;
- approximations and limiting cases preserve the intended quantity;
- parameter sharing and information access do not introduce an undeclared path;
- claimed identifiability, uniqueness, convergence, invariance, or optimality has sufficient assumptions;
- the observable can distinguish the target explanation from a null, artifact, or implementation shortcut.

## Problem classes and handoff

If the map answers the bounded request, return its completion state and stop.
Only when a further question remains, recommend one primary next method; the
recommendation does not itself authorize execution:

| Problem class | Next method |
| --- | --- |
| Model, estimand, sampling, dependence, uncertainty, or statistical code | Statistical model analysis module |
| Network function, tensor dependency, representation, invariance, stability, or theorem-like architecture claim | Neural-network mathematical analysis module |
| Loss, regularization, multi-objective weighting, gradients, or constrained training objective | Loss, objective, and optimization analysis module |
| A machine-checked theorem or strict proof is required | `formal-proof-gap` |
| The mathematical target depends on an unresolved scientific or clinical definition | Return to project authority or `hypothesis-study-design` |

The handoff contains only the map ID, relevant source anchors, accepted object definitions, unresolved issue, permitted change, expected verification, and stop condition.

## Completion states

- `mapped`: the problem and correspondence are sufficiently explicit for the bounded question.
- `mapped-with-unknowns`: useful structure exists, but named uncertainties constrain the next method.
- `contradictory`: sources define incompatible mathematical behavior.
- `blocked`: required source, definition, or authority is missing.
- `formal-proof-gap`: a strict proof is required and current capabilities cannot certify it.
