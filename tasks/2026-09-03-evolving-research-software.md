# Evolving research software container

## Intent

- Objective: Reframe `research-software-lifecycle` as a long-lived research software container that starts small, gains verified capabilities during research, and can change its own frame through reviewed migrations.
- Non-goals: Add another dispatcher, standing software agents, a persistent runtime, executable scaffolds, automatic migrations, or mandatory external tools.
- Assumptions and uncertainty: The contract should remain portable across harnesses and project types. Its field size and adapter choices still need calibration in real projects.

## Chief decision

- Assurance: S1. This changes a portable execution method but does not make or alter a scientific claim.
- Execution: Chief direct; no worker.
- Workers and model rationale: None. The affected files and frozen design are small enough that delegation would add handoff cost.
- Owned scope: The Skill entrypoint, its existing on-demand reference, the README capability row, the ecosystem adoption ledger, and this task record.
- Verification: Skill validation, local Markdown links, focused diff inspection, whitespace checks, and a scan for machine-local identifiers.
- Stop conditions: Do not add a new Skill, orchestrator, script, dependency, template tree, or external mutation.

## Evidence and execution

- Relevant evidence: Research-compendium structure from `rrtools`; reviewed scaffold updates from Copier and Cruft; durable research state from `research-lab-notebook`; bounded engineering iterations from UW-SSEC RSE plugins; selective Research Software Engineer context from `scientific-agents`; and optional workflow/data routes from Kedro, Snakemake, DVC, and DataLad. Only concepts and routing choices were synthesized; no upstream code, prompt text, or template was copied.
- Changes or artifacts: Added `init`, `extend`, `reshape`, `harden`, and `audit/release` entries; separated purpose/reuse from execution shape; defined continuous accepted baselines, bounded capability increments, reviewed frame migrations, and optional tool routing; retained Chief and S0-S4 boundaries.
- Deviations: The existing reference filename remains `maturity-contract.md` to avoid breaking its public path, although its title and content now cover the broader evolving-container contract.

## Verification and review

- Checks and comparisons: The Skill validator passed; all changed local Markdown targets resolved; the installer shell syntax and an isolated all-host dry-run passed; whitespace and focused diff checks passed.
- Privacy and portability check: Changed public text was scanned for machine-local paths, account names, private hosts, and local-only environment identifiers; none were found.
- Reviewer verdict when required: Not required for S1.
- Human acceptance when required: Not required by the assurance level; the user requested this rewrite directly.

## Decision

- Outcome: Accepted as the next portable Skill baseline. The Skill now governs an evolving research-software container without changing the general Chief dispatcher.
- Alternatives rejected: A new `research-software-container` Skill; a fixed comprehensive directory tree; automatic upstream-template merging; mandatory DVC, DataLad, Kedro, Snakemake, containers, or HPC; and a second Chief or software crew.
- Remaining uncertainty: Real projects must show whether the minimal baseline fields are sufficient and when each optional adapter saves more work than it adds.
