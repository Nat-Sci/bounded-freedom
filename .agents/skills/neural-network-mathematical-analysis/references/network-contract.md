# Neural-network analysis contract

Use this contract for one bounded network, subgraph, branch, update rule, or claimed property. Prefer a small exact representation over a complete architecture dump.

## Identity and target

```text
network_or_subgraph_id_and_version
paper_claim_or_hypothesis_ids
repository_commit_and_code_anchors
configuration_and_checkpoint_identity
training_or_inference_mode
input_domain_and_allowed_perturbations
target_property_or_deficiency
permitted_redesign_boundary
```

## Mathematical representation

Record the smallest sufficient system:

```text
inputs_outputs_and_latent_states
domains_shapes_axes_and_units
function_composition_or_graph
parameter_sets_and_sharing
normalization_masking_and_reductions
stochastic_operations_and_expectations
state_teacher_or_moving-average_updates
stop-gradient_and_detach_boundaries
initial_boundary_and_stopping_conditions
train_eval_and_export_differences
```

Map every operator to a code anchor and evidence state. Treat framework defaults, mixed precision, numerical clipping, batching, and reduction order as part of the effective model when they change the target property.

## Dependency maps

Build only the dependencies needed by the question:

- forward information path from each relevant input or label to the output;
- gradient path from each objective term to each relevant parameter group;
- update path for teachers, moving averages, memories, queues, or recurrent state;
- cross-sample path introduced by batches, normalization, contrastive queues, or graph construction;
- time or future-information path in longitudinal and sequence models;
- stochastic path through sampling, augmentation, dropout, or latent variables.

An absent direct gradient does not imply no influence when a parameter changes through a coupled update or shared state. A shared parameter can make nominally separate branches interact.

## Property checks

Select only properties named by the target claim:

| Property | Useful evidence |
| --- | --- |
| Shape and domain consistency | symbolic shape trace, runtime assertions, boundary inputs |
| Invariance or equivariance | transformation definition, algebraic derivation, paired tests, counterexample search |
| Identifiability | parameter symmetries, equivalent solutions, observation map, constraints |
| Stability or robustness | perturbation bounds, Jacobian or spectral evidence, finite perturbation tests |
| Monotonicity or ordering | derivative sign under named domain, exact constraints, counterexamples |
| Optimization behavior | gradient norms and directions, conditioning, scale, curvature approximations, update timing |
| Mechanism claim | intervention on the path, alternative mechanism, decisive ablation or synthetic oracle |
| Approximation or convergence | theorem assumptions, error metric, domain, asymptotic regime, empirical support boundary |

Label each result `source-proof-cited`, `derived-under-assumptions`,
`numerically-supported`, `counterexample-found`, `unverified`, or
`formal-proof-gap`.

## Redesign comparison

For a proposed change, preserve:

```text
frozen_deficiency
current_system
proposed_system
new_and_removed_information_paths
new_and_removed_parameters_or_constraints
expected_benefit_and_competing_explanation
failure_and_regression_risks
decisive_synthetic_test_baseline_and_ablation
implementation_scope_and_acceptance_tolerance
```

Do not recommend a larger network when a smaller change can isolate the same hypothesis.

## Completion states

- `reconstructed`: the target network behavior is mapped to evidence.
- `supported-within-boundary`: the named property has bounded derivational or empirical support.
- `counterexample`: the stated property fails within the declared domain.
- `redesign-specified`: a proposed change and decisive evaluation are frozen.
- `indeterminate`: current evidence cannot decide the claim.
- `formal-proof-gap`: strict certification is required but unavailable.
