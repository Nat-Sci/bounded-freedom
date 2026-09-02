# Research software maturity contract

Use this reference to decide what to add and, equally importantly, what not to add.

## Proportionate requirements

| Concern | One-off analysis | Internal reuse | Public software | HPC or pipeline |
| --- | --- | --- | --- | --- |
| Entry point | Documented command or notebook order | Stable callable or CLI | Supported public API or CLI | Explicit runner and stages |
| Environment | Captured versions | Locked or reproducible environment | Supported versions and install path | Modules, container, or site-aware environment contract |
| Tests | Smoke and key numerical check | Unit plus integration around contracts | CI, regression, compatibility, examples | Stage, restart, failure, provenance, and integration checks |
| Documentation | Purpose and exact run receipt | Inputs, outputs, examples, limitations | User, API, contributor, release, and governance docs as needed | Operations, resources, recovery, scheduling, and site overrides |
| Versioning | Commit or snapshot | Internal version or changelog when useful | Semantic or declared version policy | Code, config, data, container, and workflow identities |
| Citation and FAIR | Usually unnecessary | Optional internal metadata | License, citation metadata, archive/DOI when stable | Add only if distributed as a reusable research product |
| Deployment | None | Optional local automation | Package index, container, or release only when justified | Scheduler, storage, resource, monitoring, and recovery contracts |

The table is a decision aid, not a requirement to fill every cell.

## Interface contract

```text
users_and_use_cases
implemented_claim_hypothesis_prediction_or_study_ids
supported_inputs_and_schema
outputs_and_provenance
produced_run_finding_or_artifact_ids
configuration_and_precedence
scientific_invariants
failure_and_partial_output_semantics
compatibility_boundary
resource_and_runtime_expectations
security_privacy_and_license
maintenance_owner_and_lifetime
acceptance_tests
```

Use the shared [research-lineage contract](../../cost-efficient-orchestration/research-lineage.md) only for the scientific objects this software actually implements or produces. Package metadata, tests, and releases establish engineering identity and behavior; they do not independently establish the linked scientific claim.

## Reproducibility receipt

Retain the smallest useful set:

- source revision and dirty state;
- command, configuration, and environment identity;
- input data or manifest identity without exposing protected paths;
- random seeds and nondeterminism when relevant;
- output identity and key comparison;
- known deviations and unsupported conditions.

## HPC and pipeline checks

- fixed or explicit stage order and dependencies;
- idempotence, restart, partial-output, and fail-closed behavior;
- CPU, memory, GPU, wall-time, scratch, and storage expectations;
- scheduler and site configuration separated from scientific logic;
- manifest-based inputs and provenance;
- atomic or guarded publication of outputs;
- bounded logs without protected data or machine-local identifiers.

## Method and maturity sources

- [scientific-agents](https://github.com/K-Dense-AI/scientific-agents) for selective Research Software Engineer context.
- [The Turing Way](https://github.com/the-turing-way/the-turing-way) and [CodeRefinery](https://coderefinery.org/lessons/) for reproducible and collaborative practice.
- [pyOpenSci Python Package Guide](https://github.com/pyOpenSci/python-package-guide) and [Scientific Python cookie](https://github.com/scientific-python/cookie) for public Python package paths.
- [showyourwork](https://github.com/showyourwork/showyourwork) for reproducible computational articles when that workflow fits.
- [Publishing Research Code](https://github.com/paperswithcode/releasing-research-code) as a classic ML release checklist when models and result commands are being shared.
- [FAIR4RS](https://github.com/force11/FAIR4RS), [RSQKit](https://github.com/EVERSE-ResearchSoftware/RSQKit), and [JOSS criteria](https://github.com/openjournals/joss/blob/main/docs/submitting.md) as maturity references, not default requirements.
