# Hypothesis and study card

Use this schema for a consequential study design. Omit fields only when they genuinely do not apply, and state why.

## Lineage header

```text
lineage_or_project_id
evidence_boundary_id_and_cutoff
input_claim_ids
input_gap_ids
input_observation_ids
record_version
exploratory_or_confirmatory
human_owner
```

An optional preliminary observation record uses:

```text
observation_id
data_snapshot_and_analysis_version
population_sample_and_measurement
observed_pattern_and_uncertainty
known_confounders_or_processing_choices
whether_target_results_were_already_seen
status: exploratory
```

## Hypothesis card

```text
hypothesis_id
version_and_status: candidate | human_frozen | tested | revised | retired
hypothesis_statement
claim_type: descriptive | associational | predictive | causal | mechanistic
mechanism
scope_conditions
derived_from_claim_ids
derived_from_gap_ids
derived_from_observation_ids
prior_evidence_ids_for
prior_evidence_ids_against
prediction_ids
distinctive_predictions
shared_predictions
falsifying_or_weakening_observations
alternative_explanations
key_confounders_or_biases
measurement_requirements
novelty_status_and_search_boundary
```

Include at least two credible competitors when the scientific question permits it. A superficial null that no informed researcher would defend does not count as a useful competitor.

## Study card

```text
study_id_and_version
hypothesis_ids
prediction_ids
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

## Finding update

After an identified run, preserve the result without rewriting the original hypothesis:

```text
finding_id
study_id
run_or_analysis_id
observed_result_and_uncertainty
data_protocol_and_metric_identity
supports_weakens_contradicts_or_indeterminate_for_ids
deviations_and_limitations
status_and_version
human_interpretation_or_freeze
```

## Next-action handoff

Emit only the route needed for the next bounded task:

```text
handoff_id
route: evidence-review | paper-code-reproduction | project-execution
target_claim_hypothesis_prediction_or_study_ids
question_or_expected_observable
mode_or_scope
acceptance_and_indeterminate_rules
stop_condition
human_decision_required
```

Use the shared [research-lineage contract](../../cost-efficient-orchestration/research-lineage.md) when these records will feed later findings, manuscript claims, figures, or software artifacts.

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
