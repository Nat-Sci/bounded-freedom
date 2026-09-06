---
name: statistical-model-analysis
description: Reconstruct, design, or audit statistical models from a frozen scientific question, data contract, analysis code, or reported result. Use for cross-sectional or longitudinal dependence, estimands, model specification, uncertainty, diagnostics, sensitivity, and claim support; not for data cleaning, unrestricted pipeline implementation, or treating statistical output as clinical truth.
---

# Statistical model analysis

Determine which statistical model existing data and code define, whether that model answers the frozen question, and what evidence is required for a defensible inference. Keep design, implementation, observed output, and interpretation separate.

Read [the statistical model contract](references/statistical-contract.md) for the shared schema and model-comparison rules.

Then read only the relevant profile:

- [cross-sectional analysis](references/cross-sectional.md) for one-time, grouped, clustered, paired, survey, or case-control structures;
- [longitudinal analysis](references/longitudinal.md) for repeated measures, trajectories, irregular follow-up, time-varying quantities, censoring, or dropout;
- [developmental and normative analysis](references/developmental-normative.md) for infant or child development, age-conditioned reference curves, milestones, or individual deviation;
- [clinical prediction analysis](references/clinical-prediction.md) for diagnostic, prognostic, staging, screening, or decision-support models.

Multiple profiles may be relevant across a larger request, but use one primary profile for the current bounded work unit and checkpoint before changing profiles.

Read the shared [research-lineage contract](../cost-efficient-orchestration/research-lineage.md) when the model consumes a retained hypothesis or study, produces a finding, or supports a paper, figure, or software artifact.

## Select the entry

- **Reconstruct:** recover the actual estimand, likelihood or estimating equation, predictors, dependence structure, missing-data behavior, fitting procedure, and uncertainty calculation from code or a report.
- **Design:** compare candidate model families against a frozen question and data contract before confirmatory outcome inspection.
- **Audit:** test whether the implemented model, diagnostics, uncertainty, and stated conclusion agree with the frozen design and observed data structure.

## Work-unit guidance

| Work unit | Starting execution contract | Capability lane |
| --- | --- | --- |
| Inventory analysis files, variables, model calls, and fixed output fields | Scout | Fast and economical |
| Reconstruct or compare a stable bounded model specification | Chief, direct | Balanced |
| Implement one frozen model check or diagnostic | Coder | Fast code when narrow; balanced when coordinated |
| Resolve estimand ambiguity, model incompatibility, missingness assumptions, or consequential interpretation | Chief, direct; Reviewer when assurance requires independence | Strong reasoning |
| Independently audit inference that may alter a retained scientific conclusion | Reviewer | Strong reasoning and independent |

An S3 inference requires independent review because of consequence, not because a particular model family is prestigious or complex.

## Workflow

1. Freeze the question, claim type, population, unit of analysis, time boundary, outcome access, data identity, and whether the work is exploratory or confirmatory.
2. Consume an accepted mathematical problem map when available. Otherwise reconstruct the minimum statistical objects and label their authority.
3. Select one entry and the smallest relevant profile. Inspect the actual code and data contract before relying on prose descriptions.
4. State the target quantity or estimand, sampling and dependence structure, observation model, predictors, interactions, transformations, missingness or censoring assumptions, and uncertainty target.
5. For design, compare plausible model families by estimand alignment, dependence, flexibility, identifiability, sample support, diagnostics, interpretability, and failure visibility. Do not select by hoped-for significance.
6. For reconstruction or audit, map each mathematical component to code, data fields, fitted objects, diagnostics, and reported tables or figures. Surface defaults and preprocessing that change the effective model.
7. Specify validation, residual or posterior checks, calibration when predictive, multiplicity handling, robustness, sensitivity analysis, and conditions that would invalidate the conclusion.
8. Separate numerical observations from interpretation. State the strongest supported claim and the claims that remain unavailable.
9. If code changes are authorized, freeze one implementation contract and let Chief route that later unit to Coder or Builder. Re-audit the resulting observable before accepting inference.

## Required return

- selected entry and profile, frozen question, claim type, lineage, and data boundary;
- statistical model contract, including estimand and independence unit;
- reconstruction map or candidate-model comparison with explicit selection criteria;
- assumptions, identifiability, missingness, censoring, and multiplicity handling;
- diagnostics, validation, uncertainty, robustness, and sensitivity requirements;
- code-to-model-to-output correspondence when implementation exists;
- supported interpretation, prohibited interpretations, unknowns, and next bounded owner;
- independent Reviewer status when S3 or S4 applies.

## Boundaries

- `hypothesis-study-design` owns competing hypotheses, discriminating studies, and the human freeze point. This Skill owns the detailed statistical model for one frozen question.
- `scientific-data-quality` owns schema, exclusions, transformations, split integrity, and leakage. Passing data QC does not validate a model; a statistical model must not silently redefine the data contract.
- Association, prediction, diagnosis, prognosis, intervention, mediation, and causal identification are different claims. Do not move among them because the same model syntax can be used.
- Do not use a test set, future visit, outcome-derived feature, or post hoc subgroup to design a confirmatory model.
- A p-value, posterior probability, confidence interval, cross-validation score, or AUC does not by itself establish practical importance, causality, transportability, or clinical utility.
- Do not provide individual clinical diagnosis or treatment decisions. Clinical targets and thresholds require project and human authority.
- A successful model fit or converged optimizer is not proof that assumptions, identifiability, or scientific interpretation are valid.
- If acceptance requires a strict theorem about identifiability, consistency,
  convergence, or another universal property, record the proposition and
  assumptions and return `formal-proof-gap`; statistical diagnostics do not
  discharge it.
- Chief retains execution, model, reasoning effort, delegation, S0-S4 assurance, and final acceptance.

## Upstream adoption

- **Selected:** artifact-first reconstruction, explicit estimands and independence units, profile-specific dependence checks, model comparison before outcome-driven selection, uncertainty and sensitivity requirements, and bounded claim interpretation.
- **Not selected now:** one universal statistical recipe, automatic model selection, significance-driven optimization, a bundled statistical runtime, causal conclusions from predictive performance, or clinical deployment authority.

The source-by-source decision is in the [adoption ledger](../../../docs/ecosystem-and-credits.md#adoption-ledger-by-local-skill).

## Influences and credits

This Skill is an original synthesis informed by established statistical-model criticism, longitudinal and hierarchical modeling practice, clinical-prediction guidance, and the [Stan User's Guide](https://mc-stan.org/docs/stan-users-guide/index.html). Statistical software remains an optional project capability rather than a bundled dependency. See [ecosystem, influences, and credits](../../../docs/ecosystem-and-credits.md).
