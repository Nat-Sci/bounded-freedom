---
name: research-software-lifecycle
description: Turn research analyses or results into software with proportionate tests, packaging, documentation, CI, releases, citation, containers, or HPC support. Use when deciding how far to engineer a script, package, public tool, or scientific pipeline; not to overbuild a one-off analysis.
---

# Research software lifecycle

Choose the software target before choosing the scaffold.

## Classify the target

- **One-off analysis:** reproducible execution and a clear receipt, without package ceremony.
- **Internal reusable component:** stable inputs and outputs, focused tests, environment capture, and concise usage documentation.
- **Public research software:** supported interface, tests, CI, documentation, versioning, license, citation, contribution and release practices.
- **HPC or pipeline system:** explicit stages, restartability, provenance, resource controls, failure semantics, portability, and operational documentation.

Read [references/maturity-contract.md](references/maturity-contract.md) before adding packaging, CI, containers, release automation, DOI/citation metadata, or pipeline infrastructure.

Read the shared [research-lineage contract](../cost-efficient-orchestration/research-lineage.md) when software implements a retained method or study, produces identified analyses or findings, or is released with a paper. Preserve those scientific links without making the software repository a second evidence database.

## Work-unit model guidance

| Work unit | Execution contract | Capability lane |
| --- | --- | --- |
| Inventory scripts, interfaces, documentation, tests, and environments | Scout | Fast and economical |
| Make a narrow frozen packaging, test, documentation, or configuration edit | Coder | Fast and economical |
| Coordinate package APIs, CI, containers, or HPC pipeline changes | Builder | Balanced |
| Resolve cross-cutting API, FAIR, security, or operational reliability tradeoffs | Chief, direct; Reviewer when independence is required | Strong reasoning |

The word “software” is not a reason to use a stronger model. Match capability to the bounded change and maturity target. Use the general orchestration route for work not listed here.

## Workflow

1. Freeze intended users, lifetime, reuse boundary, compute environment, data sensitivity, and maintenance owner.
2. Select the lowest maturity target that satisfies those needs.
3. Define inputs, outputs, configuration, invariants, failure states, acceptance tests, and any claim, study, analysis, or finding IDs the software implements or produces before reorganizing code.
4. Separate domain logic from environment and orchestration only where reuse or testing benefits.
5. Add the minimum tests, documentation, environment capture, and automation required by the target.
6. Verify from a clean or representative environment, including a documented example or smoke path.
7. Record version, provenance, compatibility, limitations, ownership expectations, and bounded software-to-research lineage when applicable.

## Required return

- selected maturity target and rationale;
- user and maintenance assumptions;
- frozen interface, data, configuration, and failure contracts;
- implemented engineering surface and intentionally omitted features;
- test, reproducibility, documentation, and deployment evidence;
- implemented method or study IDs and produced run, finding, or release relationships when scientific lineage is in scope;
- release, citation, FAIR, HPC, or container status only when relevant;
- remaining maintenance and scientific risks.

## Boundaries

- Do not turn every experiment script into a public package.
- Reproducible does not automatically mean maintainable, citable, FAIR, secure, or HPC-ready.
- Containers do not replace data provenance, tests, version identities, or operational checks.
- A passing test suite does not validate the scientific assumptions or result.
- A software artifact may implement a study or produce a run, but it does not support a scientific claim merely because it is packaged, tested, cited, or released.
- Do not add hosted services, registries, releases, or external publications without the required authority.
- These rows are starting points. Chief retains the final model, delegation, and S0–S4 decisions; project rules retain scientific and infrastructure constraints.

## Upstream adoption

- **Selected:** choose maturity first, then add proportionate interfaces, tests, documentation, CI, releases, citation, containers, or HPC controls with a reproducibility receipt and bounded links to the research objects implemented or produced.
- **Not selected now:** one mandatory scaffold, a second evidence database inside the software repository, packaging every script, or requiring public-release, FAIR, DOI, container, and HPC machinery for every analysis.

The full source-by-source decision is in the [adoption ledger](../../../docs/ecosystem-and-credits.md#adoption-ledger-by-local-skill).

## Influences and credits

This Skill is an original synthesis informed by the research software engineer profile in [scientific-agents](https://github.com/K-Dense-AI/scientific-agents), [The Turing Way](https://github.com/the-turing-way/the-turing-way), the [pyOpenSci Python Package Guide](https://github.com/pyOpenSci/python-package-guide), and [FAIR4RS](https://github.com/force11/FAIR4RS). These sources guide proportionate practice; none is bundled. See [ecosystem, influences, and credits](../../../docs/ecosystem-and-credits.md).
