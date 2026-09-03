---
name: research-software-lifecycle
description: Grow research analyses into an evolving software container through accepted baselines, bounded capability increments, reviewed frame migrations, and proportionate tooling. Use when starting, extending, reshaping, hardening, auditing, or releasing research software; not for ordinary edits with no lifecycle decision.
---

# Research software lifecycle

Treat research software as a living container for validated capabilities, not as a package created only after the research is finished. Start with the smallest useful frame, extend it one accepted increment at a time, and reshape the frame only through an explicit migration.

This Skill owns the software-evolution method. Chief remains the only dispatcher and retains the final execution contract, model, delegation, assurance, and acceptance decisions.

## Select the entry

- **init:** freeze the goal and create the smallest frame that can run and be checked.
- **extend:** add one research-driven capability without silently widening the product.
- **reshape:** migrate interfaces, modules, layout, execution structure, or shared infrastructure because the current frame no longer fits.
- **harden:** improve tests, reproducibility, documentation, recovery, security, or operations around already accepted capabilities.
- **audit/release:** assess an accepted baseline for internal reuse, public release, citation, FAIR, container, or HPC needs; external publication still requires authority.

Read [references/maturity-contract.md](references/maturity-contract.md) for the persistent container fields, baseline and increment states, migration checks, proportionate maturity requirements, and optional tool routes. Load the sections needed by the selected entry rather than treating every route as required work.

Read the shared [research-lineage contract](../cost-efficient-orchestration/research-lineage.md) only when the software implements retained methods or studies, produces identified runs or findings, or ships with a paper. Preserve the bounded links; do not make the software repository a second evidence database.

## Keep four decisions separate

1. **Purpose and reuse:** one analysis, internal reuse, or a maintained public product.
2. **Execution shape:** notebook or command, callable package or CLI, workflow or pipeline, container, or HPC system.
3. **Accepted baseline:** the capabilities, interfaces, identities, evidence, and known limits currently trusted.
4. **Next increment:** the one proposed change and the evidence required to accept it.

HPC or pipeline is an execution shape, not a higher maturity tier. Public release is a reuse and maintenance commitment, not a reason to add every possible tool.

## Work-unit guidance

| Work unit | Starting execution contract | Capability lane |
| --- | --- | --- |
| Inventory the current baseline, interfaces, environments, history, and possible tool fit | Scout | Fast and economical |
| Add one frozen, local capability or hardening change | Coder | Fast and economical |
| Establish an initial multi-file frame, coordinate a cross-module increment, or execute a reviewed migration | Builder | Balanced |
| Decide ambiguous product boundaries, migration tradeoffs, or consequential release claims | Chief, direct; Reviewer only when independence is required | Strong reasoning |

The word “software” and the age of a project do not justify a stronger model. Match capability to the bounded work unit, then apply S0–S4 assurance separately. Use the general orchestration route only for work not covered here.

## Workflow

1. Select one entry and state the concrete pressure that justifies it.
2. Locate the existing product or project contract. If none exists, record the minimum persistent fields in an existing project document or task record; do not create a document set merely to satisfy this Skill.
3. Freeze purpose and reuse, execution shape, current accepted baseline, scientific and software invariants, and the next increment.
4. For `extend` or `harden`, define one capability boundary, affected interfaces, acceptance evidence, lineage slice, compatibility expectation, and stop condition.
5. For `reshape`, freeze the old and proposed frame, migration reason, mapping, compatibility and rollback plan, and separate any scientific change into its own increment.
6. Choose an optional scaffold, workflow, data-version, article-build, packaging, container, or HPC tool only when a demonstrated need outweighs its adoption and maintenance cost.
7. Implement the smallest coherent change. Preserve the previous accepted baseline until the new increment passes its checks.
8. Verify the changed capability and relevant non-regression boundary in a clean or representative environment. A command succeeding is not scientific validation.
9. Mark the increment `accepted` only when its frozen evidence passes; otherwise retain the prior baseline and report `failed`, `blocked`, or `unverified` honestly.
10. Update the baseline, frame version when applicable, compatibility and provenance receipt, bounded research lineage, known limits, and next pressure.

## Required return

- selected entry and reason;
- purpose/reuse and execution-shape decisions;
- previous accepted baseline and proposed capability increment;
- increment state and acceptance or non-acceptance evidence;
- frame migration and compatibility evidence when `reshape` is used;
- optional tools considered, selected, deferred, or rejected, with the reason;
- implemented surface, intentionally omitted machinery, and bounded research lineage when relevant;
- remaining software, maintenance, operational, and scientific risks.

## Boundaries

- The Skill completes one increment; it does not declare the software permanently complete.
- Do not combine a frame migration with an unmarked scientific-method change.
- Do not accept a new baseline by overwriting or deleting the last known-good state.
- Do not turn every experiment script into a package or every repository into a platform.
- Do not introduce a scaffold, pipeline engine, data-version system, container, registry, DOI, or release process without a present need.
- Reproducible does not automatically mean maintainable, citable, FAIR, secure, scientifically valid, or HPC-ready.
- Project tests establish engineering behavior; they do not by themselves support a scientific claim.
- Do not add hosted services, publish releases, or mutate external systems without the required authority.
- Do not create a second Chief, standing software crew, persistent agent runtime, or competing S0–S4 system.

## Upstream adoption

- **Selected:** the research-compendium view of a repository as a durable research container; template identity, diff, and reviewed update concepts; small persistent research state; bounded plan–implement–validate–handoff increments; proportionate maturity; and optional execution or data-lineage adapters.
- **Not selected now:** one mandatory scaffold, automatic template merging, a large `.research/` state machine, standing agents, a duplicate evidence database, or mandatory package, public-release, FAIR, container, workflow, data-version, or HPC machinery.

The source-by-source decision is in the [adoption ledger](../../../docs/ecosystem-and-credits.md#adoption-ledger-by-local-skill).

## Influences and credits

This Skill is an original synthesis informed by [rrtools](https://github.com/benmarwick/rrtools), [Copier](https://github.com/copier-org/copier), [Cruft](https://github.com/cruft/cruft), [research-lab-notebook](https://github.com/osteele/agent-skills), [UW-SSEC RSE plugins](https://github.com/uw-ssec/rse-plugins), [scientific-agents](https://github.com/K-Dense-AI/scientific-agents), [The Turing Way](https://github.com/the-turing-way/the-turing-way), and the optional tools listed in the reference. Their software and templates are not bundled. See [ecosystem, influences, and credits](../../../docs/ecosystem-and-credits.md).
