---
name: mathematical-problem-mapping
description: Reconstruct and map mathematical problems already present in scientific papers, code, and data. Use to identify mathematical objects, implicit assumptions, claim-equation-code-data correspondence, inconsistencies, and the next specialized mathematical method; not to perform full statistical inference, redesign a model, implement code, or invent unsupported mathematics.
---

# Mathematical problem mapping

Recover the mathematical problem that existing scientific artifacts actually define. Make reported statements, observed implementation, and analyst inference distinguishable before recommending another method.

This Skill is the entry to the mathematical-method layer. It does not dispatch workers or load every mathematical Skill. Chief freezes its return, then selects at most one next method for a new bounded work unit.

Read [the problem-map contract](references/problem-map.md) for the detailed fields, status vocabulary, consistency checks, and handoff schema. Read only the sections needed for the current source types.

Read the shared [research-lineage contract](../cost-efficient-orchestration/research-lineage.md) when the map consumes or produces retained source, claim, hypothesis, study, run, finding, or artifact records. Pass only the bounded lineage slice.

## Select the entry

- **Paper:** recover variables, equations, objectives, assumptions, propositions, and claimed consequences from a supplied paper or bounded paper set.
- **Code:** reconstruct functions, tensor shapes, reductions, parameter coupling, gradients, constraints, and numerical approximations from an implementation.
- **Data:** identify mathematical objects implied by fields, units, indices, time, grouping, sampling, censoring, and labels without inferring scientific meaning from names alone.
- **Correspondence:** trace one retained claim through its mathematical expression, implementation, input data, and observable output.

## Work-unit guidance

| Work unit | Starting execution contract | Capability lane |
| --- | --- | --- |
| Locate equation, symbol, function, field, and configuration anchors in a large bounded source set | Scout | Fast and economical |
| Reconstruct a stable problem map from supplied anchors | Chief, direct | Balanced |
| Resolve ambiguous semantics, incompatible sources, identifiability, or a consequential mathematical claim | Chief, direct; Reviewer when assurance requires independence | Strong reasoning |
| Implement a frozen check derived from the map | Coder or Builder in a later bounded unit | Fast code or balanced, matched to scope |

Do not use source volume alone to escalate capability. Deterministic parsing, symbol search, shape inspection, and small numerical probes should precede expensive judgment when they can reduce the active context.

## Workflow

1. Freeze source identity, versions, target claim or question, permitted inference, and the evidence boundary. Preserve incoming lineage IDs.
2. Locate exact anchors in paper, code, configuration, and data. Mark unavailable or inaccessible sources rather than reconstructing them from memory.
3. Recover symbols, domains, shapes, units, indices, time scales, random quantities, functions, distributions, objectives, constraints, and observables.
4. Build the chain `claim -> mathematical statement -> code path -> data fields -> output`. Mark every link as `reported`, `observed`, `derived`, `inferred`, `proposed`, or `unknown`.
5. Surface implicit assumptions, parameter coupling, approximations, boundary conditions, independence structure, and required regularity. Test dimensions, shapes, limiting cases, and simple invariants where useful.
6. Identify missing definitions, contradictions, non-identifiability, ill-posedness, code-equation mismatches, and claims that are stronger than the mapped mathematics.
7. Classify the next bounded method as `statistical-model-analysis`, `neural-network-mathematical-analysis`, `loss-objective-optimization`, project-owned domain work, or `formal-proof-gap`.
8. Return a compact map and one recommended next method. Chief decides whether to stop, request human authority, or open the next phase.

## Required return

- frozen source, version, claim, and evidence boundary;
- source anchors and mathematical-object inventory;
- explicit and implicit problem statements;
- claim-equation-code-data-output correspondence with evidence status for every link;
- assumptions, approximations, invariants, identifiability, and well-posedness findings;
- inconsistencies, unknowns, and prohibited interpretations;
- one recommended next method, its minimal handoff, verification target, and stop condition;
- any strict proof obligation labeled `formal-proof-gap` rather than verified.

## Boundaries

- Start from supplied or discoverable artifacts. Do not silently replace an author's model with a cleaner one or invent a mathematical specification that lacks project authority.
- Keep an equation reported by a paper, behavior observed in code, and a reconstructed interpretation as separate evidence states.
- `paper-code-reproduction` owns source identity, execution protocol, and claim comparison. This Skill owns the mathematical semantics of the mapped correspondence.
- A dimensional check, symbolic simplification, numerical experiment, unit test, or absence of a counterexample is not a proof.
- Do not fit data, interpret p-values, select a preferred scientific hypothesis from outcomes, change code, or make clinical decisions under this Skill.
- Strict proof production and proof-assistant verification are not current capabilities. Record a precise proof obligation and stop or hand it to Future Work.
- Chief retains execution, model, reasoning effort, delegation, S0-S4 assurance, and final acceptance.

## Upstream adoption

- **Selected:** artifact-first reconstruction, typed claim-equation-code-data links, explicit evidence states, assumption and identifiability checks, compact method handoffs, and proof-gap disclosure.
- **Not selected now:** automatic equation extraction as truth, a universal mathematical ontology, one catch-all mathematics agent, recursive Skill execution, or formal proof certification.

The source-by-source decision is in the [adoption ledger](../../../docs/ecosystem-and-credits.md#adoption-ledger-by-local-skill).

## Influences and credits

This Skill is an original synthesis informed by paper-to-code mapping practice, scientific model criticism, symbolic and numerical checking workflows, and the open [Agent Skills specification](https://agentskills.io/specification). No mathematical runtime or external Skill collection is bundled. See [ecosystem, influences, and credits](../../../docs/ecosystem-and-credits.md).
