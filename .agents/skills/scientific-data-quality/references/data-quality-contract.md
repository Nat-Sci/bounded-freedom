# Data-quality contract

Use this reference to make a dataset handoff inspectable without turning the task record into a row-level data dump. Keep stable identifiers local to the project and retain aggregate evidence whenever possible.

## Object set

| Object | Minimum fields | Meaning |
| --- | --- | --- |
| `DSET-*` source | version or digest, origin class, acquisition time or release, unit of analysis, privacy class | Immutable identity for an input snapshot |
| `DCT-*` contract | field, type/format, unit, allowed values/range, missing markers, key role, authority | Expected structure and semantics |
| `QCK-*` check | rule version, observed aggregate, threshold, evidence, state | One reproducible quality assertion |
| `EXC-*` exclusion | ordered rule, reason, before/after counts, reversible mapping, authority | Accountable population change |
| `TRN-*` transform | ordered inputs, operation, parameters, code/query identity, fitted-on scope, output | Reproducible derived-data step |
| `SPL-*` split | independence unit, strategy, grouping/time boundary, seed or rule, membership digest | Frozen evaluation boundary |
| `LKG-*` risk | information path, affected stage, evidence, severity, mitigation, residual state | One possible train/test or temporal leak |

Use project-native identifiers if they already exist. The prefixes above are fallback labels, not a required database.

## Data contract

For every field needed by the bounded task, record:

- physical name and scientific meaning;
- type and format, including date/time zone or categorical encoding;
- unit and measurement scale;
- allowed values, categories, or defensible range;
- all missing or sentinel encodings;
- primary, foreign, grouping, subject, site, visit, time, treatment, outcome, or derived role;
- uniqueness and nullability expectations;
- authority: project contract, instrument/source documentation, or proposed rule;
- unresolved ambiguity.

Validate primary-key uniqueness and nullability, foreign-key coverage, and consistent missing markers where applicable. A format-valid field can still be scientifically wrong.

## QC summary

Report only checks relevant to the purpose. Typical aggregate checks include:

- source count, row or entity count, and accounting across stages;
- duplicate keys and near-duplicate entity risk;
- missingness overall and by scientifically relevant group or time;
- type, category, unit, and range conformance;
- impossible sequences, timestamps, or cross-field combinations;
- referential integrity across tables;
- batch, site, instrument, or acquisition shifts that may affect the planned use;
- source-to-derived reconciliation and deterministic rerun identity.

Each check has one state:

- `pass`: frozen evidence satisfies the declared rule;
- `warning`: the issue is characterized and may be acceptable for this purpose;
- `fail`: evidence violates an acceptance rule;
- `unknown`: the required rule, authority, or evidence is missing.

Never average these states into one universal score.

## Exclusion ledger

Apply rules in recorded order because order can change counts. For each rule retain the version, scientific or operational reason, fields used, before/after entity and row counts, overlap with earlier rules, reversible membership mapping or digest, approving authority, and whether the rule was declared before outcome inspection.

Do not convert a proposed outlier heuristic into an exclusion rule automatically. Preserve the source snapshot and make every mutation reproducible into a new output identity.

## Leakage audit

Answer these questions before claiming an evaluation is held out:

1. What is the true independence unit: row, person, family, site, device, location, group, or time block?
2. Can the same or related entity appear across splits through duplicates, repeated visits, augmentation, windows, or linked tables?
3. Was the split frozen before inspecting held-out outcomes?
4. At prediction time, would every feature and timestamp actually be available?
5. Do any identifiers, proxies, post-outcome variables, labels, filenames, or collection artifacts reveal the target?
6. Were imputation, scaling, normalization, feature selection, embedding, harmonization, dimensionality reduction, augmentation policy, and hyperparameter tuning fit only on training data?
7. Were validation and test roles kept distinct across repeated experiments?
8. Does time-based evaluation prevent information from the future entering past predictions?
9. Are site or batch corrections fit without using held-out outcome information?
10. Can preprocessing caches or precomputed features cross the frozen split boundary?

Record every plausible information path as `LKG-*`, including evidence and residual uncertainty. “No issue found” means no issue was found within the audited boundary, not proof that leakage is impossible.

## Transformation lineage

Represent the handoff as an ordered chain:

```text
DSET source -> TRN step -> TRN step -> DSET derived
                     \-> QCK evidence
SPL boundary --------^ fitted-on scope
```

Each learned transform names the training scope used to fit it. Each derived dataset names all input identities, ordered operations, parameters, code or query version, environment-relevant dependency identity, validation checks, and creation time. Record derivation and generation links in project-native form; a graph database is optional.

## Minimal return template

```text
DATA QUALITY HANDOFF

entry and purpose:
dataset boundary and unit:
source identities:
contract state: pass | warning | fail | unknown
QC checks: passed / total, with failures and unknowns named
exclusions: count, rule versions, authority, and reversibility
leakage: split identity, risks, mitigations, and residual state
lineage: ordered source-to-output identities and fitted-on scopes
prohibited interpretations:
remaining uncertainty:
next owner and acceptance decision:
```
