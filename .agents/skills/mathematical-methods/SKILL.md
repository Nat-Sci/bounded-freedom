---
name: mathematical-methods
description: Map and analyze the mathematics already present in scientific papers, code, and data. Use for claim-equation-code-data correspondence, statistical models for cross-sectional or longitudinal data, neural-network structure and properties, or machine-learning losses and optimization; not for ordinary code review, data cleaning, unrestricted implementation, clinical decisions, or claiming strict proof.
---

# Mathematical methods

Recover the mathematical problem defined by existing artifacts, then apply one bounded mathematical method. Keep source statements, executable behavior, analyst derivation, and proposed changes distinguishable.

This is the only discoverable entry to the mathematical-method layer. The files below are on-demand references, not independently discoverable Skills and not recursive agents.

## Start with the problem map

Read [the problem-mapping contract](references/problem-map.md) when the mathematical objects, assumptions, or paper-code-data correspondence have not already been accepted. It recovers:

- variables, domains, shapes, units, indices, functions, distributions, objectives, and constraints;
- the chain `claim -> mathematical statement -> code path -> data fields -> output`;
- implicit assumptions, approximations, identifiability, well-posedness, inconsistencies, and unknowns;
- one bounded method recommendation or a stop condition.

An accepted and versioned problem map may be reused. Do not remap an unchanged source boundary merely to invoke a module.

## Select one method module

After the problem map is accepted, read exactly one primary module for the current work unit:

| Bounded question | On-demand module |
| --- | --- |
| Which statistical model answers a frozen cross-sectional, longitudinal, developmental, normative, diagnostic, or prognostic question? | [Statistical model analysis](references/statistical-model-analysis/method.md) |
| What does a neural network compute, and what can be established about its information paths, invariance, identifiability, stability, or optimization dynamics? | [Neural-network mathematical analysis](references/neural-network-mathematical-analysis/method.md) |
| What objective is actually optimized, where do its gradients flow, and are its reductions, weights, constraints, and surrogate aligned with the target? | [Loss, objective, and optimization analysis](references/loss-objective-optimization/method.md) |

If none matches, return to project authority or another discoverable Skill. If strict or machine-checked proof is required, record `formal-proof-gap`; `formal-proof-verification` remains Future Work.

Use one primary module at a time. A larger request may change modules only after Chief accepts a compact checkpoint containing the map identity, source anchors, frozen definitions, accepted findings, unresolved issue, next verification, and stop condition. Do not load all module bodies into standing context.

Read the shared [research-lineage contract](../cost-efficient-orchestration/research-lineage.md) when the work consumes or produces retained source, claim, hypothesis, study, run, finding, or artifact records. Pass only the bounded lineage slice.

## Work-unit guidance

| Work unit | Starting execution contract | Capability lane |
| --- | --- | --- |
| Locate bounded equation, symbol, function, tensor, field, and configuration anchors | Scout | Fast and economical |
| Reconstruct a stable map or apply a well-defined module | Chief, direct | Balanced |
| Run a frozen deterministic calculation, shape check, gradient probe, or diagnostic | Coder in a later bounded unit | Fast code when narrow; balanced when coordinated |
| Resolve ambiguous semantics, identifiability, model incompatibility, mechanism, or consequential interpretation | Chief, direct; Reviewer when assurance requires independence | Strong reasoning |
| Implement a frozen model, network, or objective change | Coder or Builder in a later bounded unit | Fast code or balanced, matched to scope |

Source volume alone does not justify stronger capability. Deterministic search, parsing, dimensional checks, shape inspection, and small numerical probes should reduce the active context before expensive judgment.

## Required return

- selected stage and, when applicable, one primary method module;
- frozen source, version, question or claim, permitted inference, and evidence boundary;
- mathematical objects, assumptions, correspondence, and evidence states required by the problem map;
- module-specific contract, checks, supported conclusion, prohibited conclusions, and remaining uncertainty;
- one bounded next owner, verification target, handoff, and stop condition;
- every theorem-like obligation and explicit `formal-proof-gap` status when strict proof is required.

## Boundaries

- Start from supplied or discoverable artifacts. Do not silently replace an author's model, invent unsupported mathematics, or redefine a clinical or scientific target.
- Keep `reported`, `observed`, `derived`, `inferred`, `proposed`, `contradicted`, and `unknown` evidence states distinct.
- `paper-code-reproduction` owns source identity, execution protocol, and claim comparison. This Skill owns the mathematical semantics inside that boundary.
- `scientific-data-quality` owns schema, exclusions, transformation provenance, split integrity, and leakage. Passing QC does not validate a statistical or mathematical claim.
- Algebra, symbolic manipulation, automatic differentiation, diagnostics, numerical probes, unit tests, and absence of a counterexample do not certify a universal theorem.
- Analysis does not authorize unrestricted implementation, training, clinical thresholds, individual diagnosis, treatment, or deployment.
- Chief retains execution, model, reasoning effort, delegation, S0-S4 assurance, module transitions, and final acceptance. A method module cannot switch Chief's active model.

## Upstream adoption

- **Selected:** one discoverable mathematical entry, artifact-first reconstruction, progressive on-demand module loading, explicit evidence states, compact checkpoints, and proof-gap disclosure.
- **Not selected now:** recursive Skill discovery, independently triggerable mathematical leaves, a catch-all mathematics agent that loads every method, automatic model selection, bundled numerical runtimes, or formal proof certification.

The source-by-source decision is in the [adoption ledger](../../../docs/ecosystem-and-credits.md#adoption-ledger-by-local-skill).

## Influences and credits

This Skill is an original synthesis informed by paper-to-code mapping, statistical model criticism, computational-graph analysis, optimization practice, and the open [Agent Skills specification](https://agentskills.io/specification). Mathematical runtimes remain optional project capabilities. See [ecosystem, influences, and credits](../../../docs/ecosystem-and-credits.md).
