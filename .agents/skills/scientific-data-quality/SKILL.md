---
name: scientific-data-quality
description: Inspect and document scientific data intake, schema, missingness, validity, exclusions, transformation provenance, split integrity, and leakage risk before analysis or modeling. Use for data contracts, QC summaries, exclusion ledgers, leakage audits, and remaining uncertainty; not for statistical inference, interpreting results, drawing final figures, or implementing an entire pipeline.
---

# Scientific data quality

Establish whether scientific data are structurally understood and safe to hand into a frozen analysis. Preserve observations, rules, and decisions as separate objects so that a plausible-looking cleaned dataset is never mistaken for validated evidence.

This Skill owns data-intake and pre-analysis quality method. Chief retains routing, model, delegation, S0–S4 assurance, and acceptance. The project owns scientific meaning, cohort rules, instruments, privacy policy, and the authoritative analysis plan.

Read [references/data-quality-contract.md](references/data-quality-contract.md) for the required fields, leakage questions, lineage states, and output templates. Use the smallest sections needed by the task.

Read the shared [research-lineage contract](../cost-efficient-orchestration/research-lineage.md) when the audited data or transformations feed a retained study, run, finding, or figure. Pass only identifiers and evidence needed by the next method.

## Select the entry

- **intake:** inventory files or tables, identities, provenance, units, keys, privacy class, and expected population before transformation.
- **schema:** compare observed fields, types, ranges, categories, keys, and missing-value encodings with an explicit data contract.
- **quality:** quantify missingness, duplicates, impossible or suspicious values, temporal consistency, and cross-table integrity without silently repairing them.
- **exclusions:** audit inclusion/exclusion rules, counts, reasons, order, and reversibility against the frozen study or project contract.
- **leakage:** inspect train/test, temporal, group, entity, outcome, preprocessing, feature-selection, and augmentation boundaries.
- **lineage:** map each retained dataset to source identity, ordered transformations, parameters, code or query identity, and validation evidence.

## Work-unit guidance

| Work unit | Starting execution contract | Capability lane |
| --- | --- | --- |
| Inventory datasets, schemas, provenance, and existing checks without mutation | Scout | Fast and economical |
| Add one frozen deterministic validator or report field | Coder | Fast and economical |
| Coordinate QC plumbing across schemas, transformations, and pipeline interfaces | Builder | Balanced |
| Decide scientific meanings, acceptable exclusions, split policy, or unresolved tradeoffs | Chief, direct | Strong reasoning when ambiguity or consequence requires it |
| Independently audit leakage or consequential exclusion evidence for S3/S4 | Reviewer | Strong reasoning and independent |

These are starting routes, not task-wide model profiles. Chief should work directly when paths and checks are already known. The presence of a large dataset does not by itself justify a stronger model; reduce or summarize inputs with deterministic tools first.

## Workflow

1. Select one entry and freeze the dataset boundary, scientific purpose, population or unit of analysis, authoritative project rules, permitted actions, and acceptance evidence.
2. Assign stable identities to source snapshots and record provenance without copying private local layout into retained artifacts.
3. Write the expected data contract before evaluating conformance. Mark each field or rule as project-declared, source-documented, or newly proposed.
4. Profile only the necessary aggregate properties. Keep direct observations separate from validation rules and from human or Chief decisions.
5. Record every exclusion, coercion, recode, imputation, aggregation, or derived feature as an ordered transformation. Do not alter source data in place.
6. Audit leakage before fitting or selecting on outcomes. Split by the true independence unit; fit learned preprocessing, imputation, selection, and tuning only on training data; apply frozen transforms to held-out data.
7. Verify row or entity accounting across stages, key constraints, missingness and validity checks, exclusion counts, lineage completeness, and split disjointness appropriate to the project.
8. Classify each issue as `pass`, `warning`, `fail`, or `unknown`. A warning accepted for one purpose remains visible and does not become a pass.
9. Return the bounded contract and uncertainty. Handoff to project analysis, study design, reproduction, figure, or software work only after Chief accepts the quality gate.

## Required return

- selected entry, dataset boundary, purpose, unit of analysis, and source identities;
- **data contract:** expected fields, types, units, allowed values or ranges, keys, missing-value rules, and project authority;
- **QC summary:** aggregate observations, checks, thresholds, evidence, and pass/warning/fail/unknown state;
- **exclusion ledger:** rule version, order, reason, affected count, reversibility, and approving authority;
- **leakage audit:** independence unit, split policy, feature time, target access, learned-transform fit boundary, and unresolved risks;
- **transformation lineage:** source-to-output steps, parameters, code/query identity, and validation receipt;
- remaining uncertainty, prohibited interpretations, and the next bounded owner.

## Boundaries

- Default to read-only inspection. Never delete, overwrite, exclude, coerce, impute, winsorize, deduplicate, or relabel data without an explicit project rule and authorized mutation scope.
- Do not infer scientific meaning from a column name alone. Units, sentinels, visit order, subject identity, outcome timing, and permissible ranges require project or source authority.
- Do not use the test set to choose features, thresholds, preprocessing, hyperparameters, stopping points, or subsets. Fit learned transformations on training data only.
- Random row splits are not valid when subjects, sites, families, devices, locations, or time create dependence; identify the real independence unit.
- Missingness, outliers, and exclusions are findings to characterize before they become cleaning actions.
- Data-format validity is not scientific validity, absence of detected leakage is not proof of independence, and passing QC is not evidence for a scientific claim.
- This Skill does not perform statistical inference, interpret p-values or effects, choose a preferred hypothesis after results, draw the final scientific figure, or own an end-to-end ETL/model/deployment pipeline.
- Do not retain raw sensitive values, row-level identifiers, credentials, message content, private host paths, or unnecessary samples in reports or worker returns.

## Upstream adoption

- **Selected:** explicit field and key contracts; source and transformation provenance; split-before-fit leakage discipline; group, entity, and temporal independence checks; reversible exclusion accounting; and honest unknown states.
- **Not selected now:** one universal quality score, automatic cleaning, mandatory validation framework, a data catalog or graph database, automatic causal or statistical conclusions, and a full pipeline runtime.

The source-by-source decision is in the [adoption ledger](../../../docs/ecosystem-and-credits.md#adoption-ledger-by-local-skill).

## Influences and credits

This Skill is an original synthesis informed by the [Frictionless Table Schema](https://specs.frictionlessdata.io/table-schema/), [scikit-learn guidance on data leakage](https://scikit-learn.org/stable/common_pitfalls.html), [W3C PROV-O](https://www.w3.org/TR/prov-o/), and Kapoor and Narayanan's analysis of leakage in machine-learning science ([DOI 10.1016/j.patter.2023.100804](https://doi.org/10.1016/j.patter.2023.100804)). Their software and schemas are not bundled.
