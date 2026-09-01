# Hypothesis and study card

Use this schema for a consequential study design. Omit fields only when they genuinely do not apply, and state why.

## Hypothesis card

```text
id
claim
mechanism
scope_conditions
prior_evidence_for
prior_evidence_against
distinctive_predictions
shared_predictions
falsifying_or_weakening_observations
alternative_explanations
key_confounders_or_biases
measurement_requirements
```

Include at least two credible competitors when the scientific question permits it. A superficial null that no informed researcher would defend does not count as a useful competitor.

## Study card

```text
research_question
exploratory_or_confirmatory
target_population_and_sampling
unit_of_observation_and_unit_of_analysis
exposure_intervention_or_predictor
comparator
primary_and_secondary_outcomes
measurement_timing
estimand
design_and_identification_assumptions
allocation_blinding_or_masking
confounder_strategy
sample_size_or_precision_target
missing_data
multiplicity
model_and_diagnostics
sensitivity_and_negative_controls
data_split_and_leakage_controls
decision_rule_and_indeterminate_region
ethics_privacy_and_feasibility
human_freeze_point
```

## Discrimination matrix

Before choosing a study, compare candidate observations or interventions:

| Candidate test | Expected under H1 | Expected under H2 | Expected under null or artifact | Main confounder | Feasibility |
| --- | --- | --- | --- | --- | --- |

Prefer tests with meaningfully different predictions, not merely more measurements.

## Neuroimaging and behavioral checks

- Freeze subject-level splits before feature selection, harmonization, augmentation, or model tuning that could leak information.
- Distinguish repeated measurements from independent participants.
- Record image space, atlas, acquisition, preprocessing, motion and quality-control choices when they affect the estimand.
- Separate ROI-confirmatory analyses from whole-brain or exploratory analyses.
- Preserve raw behavioral distributions and uncertainty rather than relying only on thresholded categories.

## Reference systems

[Scientific Agent Skills](https://github.com/K-Dense-AI/scientific-agent-skills), [HypoGeniC and HypoRefine](https://github.com/ChicagoHAI/hypothesis-generation), [ResearchAgent](https://github.com/JinheonBaek/ResearchAgent), and [CKM-HypoGen](https://github.com/TaoJinkai/ckm-hypogen) are useful catalogs, research systems, or evaluation references. They do not replace the evidence boundary, discriminating design, statistical review, or human freeze defined here.
