# Statistical model contract

Use this contract to reconstruct, design, or audit one bounded statistical analysis. Record declared, observed, inferred, and proposed fields separately.

## Core fields

```text
analysis_id_and_version
entry: reconstruct | design | audit
profile
question_and_claim_type
lineage_ids
exploratory_or_confirmatory_status
population_and_sampling_frame
unit_of_analysis_and_independence_unit
time_origin_scale_and_horizon
outcome_and_observation_process
target_quantity_or_estimand
predictors_exposures_confounders_and_effect_modifiers
model_family_and_equation
link_likelihood_or_estimating_equation
dependence_and_hierarchical_structure
transformations_interactions_and_regularization
missingness_censoring_and_competing_events
fitting_tuning_and_selection_procedure
uncertainty_target_and_computation
validation_and_diagnostics
multiplicity_and_sensitivity_plan
implementation_and_output_anchors
supported_and_prohibited_claims
```

## Model comparison

Compare only models that address the same frozen target. Use criteria that expose scientific and numerical fit:

- alignment with the estimand and intended interpretation;
- agreement with the true independence, sampling, clustering, and time structure;
- ability to represent scientifically plausible nonlinearity, heterogeneity, censoring, or measurement error;
- identifiability and effective information relative to flexibility;
- calibration and uncertainty behavior, not discrimination alone, when predicting probabilities or risks;
- diagnostics and failure observability;
- stability under reasonable perturbations and resampling;
- transportability boundary and dependence on site, instrument, or population;
- implementation complexity and reproducibility after scientific adequacy is established.

Do not use one in-sample fit statistic, one cross-validation average, or the most complex model as the selection rule.

## Reconstruction evidence states

| State | Meaning |
| --- | --- |
| `declared` | Frozen by study, protocol, or project authority |
| `reported` | Stated in a paper, report, or documentation |
| `observed` | Directly present in code, configuration, data schema, or output |
| `derived` | Follows from a shown derivation under named assumptions |
| `inferred` | Plausible interpretation not directly established |
| `proposed` | Candidate repair or alternative for review |
| `unknown` | Evidence or authority is absent |

## Minimum diagnostics

Select diagnostics based on the model rather than treating this as a universal checklist:

- design and sample accounting against the declared population and unit;
- residual, predictive, posterior, or estimating-equation checks;
- functional-form and interaction checks;
- influential observations and cluster or subject contribution;
- convergence and numerical stability, including multiple initializations when relevant;
- uncertainty calibration or coverage through simulation or resampling when feasible;
- out-of-sample discrimination, calibration, and utility for predictive work;
- sensitivity to missingness, censoring, exclusions, transformations, priors, thresholds, and alternative plausible specifications;
- subgroup and site behavior only when supported and predeclared or clearly labeled exploratory.

## Completion states

- `specified`: the model is frozen but not yet implemented or evaluated.
- `reconstructed`: effective code and model behavior are mapped.
- `adequate-within-boundary`: declared checks support the bounded use.
- `rework`: a correctable mismatch or unsupported choice remains.
- `indeterminate`: evidence cannot decide adequacy.
- `blocked`: a required definition, data authority, implementation, or output is unavailable.

These states describe the analysis contract, not the truth of the scientific claim.
