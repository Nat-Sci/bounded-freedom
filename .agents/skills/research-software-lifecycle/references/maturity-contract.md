# Evolving research software contract

Use only the sections needed by the selected entry. This contract keeps the container continuous while allowing both its capabilities and its frame to change.

## Minimal persistent container

Keep these fields in the project's existing source of truth when possible. The schema does not require a new file.

```text
goal_and_non_goals
intended_users_and_reuse_boundary
maintenance_owner_and_expected_lifetime
execution_shape_and_compute_environment
data_sensitivity_and_external_authority
frame_id_and_version
accepted_baseline_id
accepted_capabilities_and_interfaces
scientific_and_software_invariants
known_limits_and_unsupported_conditions
selected_tool_adapters_and_versions
bounded_research_lineage
next_pressure_or_increment
```

The project contract owns local scientific and software intent. A scaffold or upstream template owns only its common frame. Template changes may propose a migration, but they never outrank project-owned logic.

## Continuous accepted baseline

An accepted baseline is the last state supported by the required engineering and, when applicable, scientific evidence. Give it a stable local identity such as `B0`, `B1`, or a project version.

Retain the smallest useful baseline receipt:

- source revision and dirty state;
- frame version and accepted capability IDs;
- supported input, output, configuration, and interface identities;
- environment and selected tool versions;
- input data or manifest identity without protected paths;
- commands, seeds, and known nondeterminism when relevant;
- acceptance checks and key comparisons;
- known deviations, unsupported conditions, and bounded lineage links.

`B0` may be a minimal runnable shell. A later baseline replaces it only after the new increment passes; a failed or incomplete increment remains outside the accepted baseline.

## Capability increment

One increment adds or changes one coherent capability. Freeze this before implementation:

```text
increment_id
entry: init | extend | reshape | harden | audit | release
user_or_research_need
in_scope_and_out_of_scope
implemented_method_study_or_finding_ids
affected_interfaces_and_invariants
compatibility_expectation
acceptance_evidence
permitted_changes_and_stop_conditions
```

Use explicit states:

```text
proposed -> frozen -> implemented -> verified -> accepted
                            |             |
                            +-> failed    +-> unverified | blocked
```

Verification must cover the new behavior and the smallest relevant non-regression boundary. If an increment changes a scientific method, data definition, statistical assumption, or result interpretation, surface that change and apply the appropriate scientific Skill and S0–S4 gate before acceptance.

## Frame migration

Use `reshape` only when repeated friction or a new requirement shows that the current frame is no longer adequate—for example, incompatible interfaces, duplicated domain logic, a real package boundary, a workflow dependency graph, or a new compute environment.

Freeze and check:

```text
old_frame_id_and_version
new_frame_id_and_version
migration_pressure_and_alternatives
old_to_new_module_interface_and_artifact_map
scientific_logic_changed: yes | no
compatibility_and_deprecation_policy
data_config_and_result_migration
rehearsal_and_non_regression_checks
rollback_or_recovery_path
template_or_tool_source_version_and_license
```

- Keep content evolution and frame evolution visible as separate change records, even when they share a task.
- If scientific logic changes, treat it as a separate capability increment with its own evidence.
- Preserve the last accepted baseline and a recovery path until the migrated baseline is accepted.
- Never regenerate or auto-merge an upstream template over project changes without inspecting the diff and resolving ownership explicitly.

## Purpose and reuse

| Target | Minimum useful engineering |
| --- | --- |
| One analysis | Reproducible entry, environment identity, result receipt, and key numerical check |
| Internal reuse | Stable inputs and outputs, focused unit and integration checks, environment capture, examples, and ownership |
| Maintained public product | Supported API or CLI, compatibility policy, CI, user and contributor documentation, license, versioning, citation and release practice as justified |

Choose the lowest target that meets the present commitment. Promotion is an explicit increment, not an assumption that every useful script should become public software.

## Execution shape

| Shape | Additional concerns when selected |
| --- | --- |
| Notebook or command | Order, parameters, environment, input and output receipt |
| Callable package or CLI | Interface stability, configuration precedence, error semantics, tests and install path |
| Workflow or pipeline | Explicit stages and dependencies, idempotence, restart, partial outputs, provenance and guarded publication |
| Container | Image and dependency identity, data mounts, permissions, portability and security checks |
| HPC system | Scheduler and site overrides, CPU/GPU/memory/wall-time/storage expectations, failure recovery and bounded logs |

These shapes can coexist. They do not define scientific importance or automatically require public release.

## Optional tool routing

First inspect the project's existing tools. Add a new adapter only when it solves a named bottleneck, fits the execution environment, has an acceptable license and maintenance cost, and can be removed or migrated without obscuring the scientific logic.

| Demonstrated need | Candidate routes | Selection boundary |
| --- | --- | --- |
| Minimal initial research layout | [Cookiecutter Data Science](https://github.com/drivendataorg/cookiecutter-data-science), [rrtools](https://github.com/benmarwick/rrtools) | Borrow or generate only the directories the project has earned; rrtools is R-oriented |
| Track and review later scaffold changes | [Copier](https://github.com/copier-org/copier), [Cruft](https://github.com/cruft/cruft) | Keep template identity and inspect the migration diff; never auto-accept project-owned changes |
| Public Python package frame and checks | [Scientific Python cookie](https://github.com/scientific-python/cookie), [pyOpenSci](https://github.com/pyOpenSci/python-package-guide) | Use only after choosing a maintained public Python product |
| Modular data or computation workflow | [Kedro](https://github.com/kedro-org/kedro), [Snakemake](https://github.com/snakemake/snakemake) | Adopt when a real catalog or dependency graph exceeds simple project-native code |
| Large data, model, or experiment lineage | [DVC](https://github.com/treeverse/dvc), [DataLad](https://github.com/datalad/datalad) | Use when Git alone cannot manage the required identities and storage; DataLad is especially relevant to distributed scientific data |
| Reproducible computational article | [showyourwork](https://github.com/showyourwork/showyourwork) | Use when an article build genuinely owns the analysis dependency graph |
| Durable Agent-facing research state | [research-lab-notebook](https://github.com/osteele/agent-skills) | Borrow a small status and experiment/findings model; do not copy all state files by default |
| Plan, implement, validate, and hand off an increment | [UW-SSEC RSE plugins](https://github.com/uw-ssec/rse-plugins) | Borrow the bounded loop, not another dispatcher or permanent team |
| Long-running paper-production state machine | [codex-PaperFactory](https://github.com/happystander/codex-PaperFactory) | Architecture reference only unless a project proves the full runtime is worth its overhead |

Record candidates considered, why one was selected or rejected, the source version and license when adopted, and the exit or migration cost. A listed project is an option, not a dependency or endorsement.

## Interface and failure contract

For any accepted reusable capability, define the applicable fields:

```text
supported_inputs_and_schema
outputs_and_provenance
configuration_and_precedence
scientific_invariants
failure_and_partial_output_semantics
compatibility_boundary
resource_and_runtime_expectations
security_privacy_and_license
acceptance_tests
```

Use the shared [research-lineage contract](../../cost-efficient-orchestration/research-lineage.md) only for scientific objects the software actually implements or produces. Packaging, tests, releases, and citations establish engineering identity and behavior; they do not independently establish a linked claim.

## Release and quality references

- [scientific-agents](https://github.com/K-Dense-AI/scientific-agents) for selective Research Software Engineer context.
- [The Turing Way](https://github.com/the-turing-way/the-turing-way) and [CodeRefinery](https://coderefinery.org/lessons/) for reproducible and collaborative practice.
- [Publishing Research Code](https://github.com/paperswithcode/releasing-research-code) for a classic ML release checklist.
- [FAIR4RS](https://github.com/force11/FAIR4RS), [RSQKit](https://github.com/EVERSE-ResearchSoftware/RSQKit), and [JOSS criteria](https://github.com/openjournals/joss/blob/main/docs/submitting.md) as maturity references, not default requirements.
