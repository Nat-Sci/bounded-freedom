# Loss and optimization contract

Use this contract for one bounded objective or coupled objective system. Reconstruct the effective implementation before proposing changes.

## Identity and target

```text
objective_id_and_version
paper_claim_or_hypothesis_ids
network_boundary
repository_commit_code_and_config_anchors
checkpoint_training_stage_and_mode
data_label_teacher_and_future-information_access
target_behavior_metric_or_estimand
permitted_change
```

## Effective objective

Write a mathematical expression that includes:

```text
component_terms
signs_coefficients_and_units
sample_class_group_region_or_time_weights
masks_and_validity_indicators
sum_mean_batch_element_or_custom_reductions
normalization_denominators
expectations_and_sampling_distributions
regularizers_penalties_and_constraints
weight_and_temperature_schedules
stop-gradient_or_detach_operators
teacher_moving-average_memory_or_queue_updates
optimizer_gradient_transform_clipping_and_precision
```

The reported paper equation, code expression, logged scalar, and effective gradient objective may differ. Keep their correspondence and evidence states explicit.

## Analysis questions

### Meaning and alignment

- What quantity is minimized or maximized under the actual sampling distribution?
- Does the surrogate align with the target metric or estimand, and under which assumptions?
- Do weights change the target population, error tradeoff, gradient scale, or only estimator variance?
- Does a clinical or fairness interpretation require information outside the objective?

### Gradient and coupling

- Which parameter groups receive direct gradients from each term?
- Which branches interact through shared parameters, normalization, teachers, moving averages, memories, or data-dependent weights?
- Are detach, no-gradient, alternating, or delayed updates consistent with the described optimization problem?
- Do component gradients conflict, dominate, vanish, explode, or become undefined in relevant regimes?

### Scale and limiting cases

- Are component units and normalizations comparable?
- What happens when masks are empty or full, classes are absent, predictions are exact, logits saturate, variance approaches zero, or a coefficient approaches zero or infinity?
- Is the objective bounded where claimed? Are logarithms, divisions, roots, norms, or inverse operations numerically protected without changing semantics?
- Can a constant, collapsed, copied, leaked, or otherwise trivial solution achieve a low value?

### Optimization and evidence

- Is the optimizer, schedule, clipping, precision, or accumulation part of the claimed method?
- Are observed changes attributable to the objective rather than training budget, sampling, initialization, parameter count, or data access?
- Which baseline, ablation, synthetic oracle, or intervention could discriminate the mechanism?

## Code acceptance checks

Choose relevant checks:

- exact scalar values on hand-computed examples;
- component and denominator accounting under masks and missing groups;
- finite-difference or framework gradient comparison on a small smooth case;
- explicit zero and nonzero gradient expectations at detach boundaries;
- permutation, scale, symmetry, monotonicity, or limiting-case checks when the claim requires them;
- empty, single-element, imbalanced, saturated, and degenerate inputs;
- equivalence of reported and effective reductions;
- optimizer-step behavior on a minimal synthetic problem;
- regression against the frozen previous objective.

Record tolerances, seeds, precision, and the difference between deterministic and stochastic expectations.

## Completion states

- `reconstructed`: the effective objective and gradient dependencies are mapped.
- `adequate-within-boundary`: the frozen checks support the named use.
- `misaligned`: the objective and target quantity differ materially.
- `degenerate`: a relevant trivial or unintended solution exists.
- `redesign-specified`: a bounded proposal and decisive evaluation are frozen.
- `indeterminate`: current evidence cannot decide the claim.
- `blocked`: a required definition, code path, configuration, or observable is absent.
