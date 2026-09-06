---
name: neural-network-mathematical-analysis
description: Reconstruct, formalize, and audit the mathematics of a neural network from papers, code, and tensor behavior. Use for functional structure, information paths, parameter coupling, invariance, identifiability, stability, optimization dynamics, counterexamples, and proof obligations; not for ordinary code review, full training implementation, or claiming formal proof without machine-checked evidence.
---

# Neural-network mathematical analysis

State what a network actually computes and which mathematical claims its structure can support. Use exact implementation evidence to separate architectural intent from executable behavior.

Read [the network analysis contract](references/network-contract.md) for the shared representation, checks, and return schema.

Read [proof obligations and the formal-proof gap](references/proof-obligations.md) when a paper, code comment, or proposed method makes a theorem-like claim about invariance, convergence, uniqueness, stability, identifiability, approximation, or optimality.

Read the shared [research-lineage contract](../cost-efficient-orchestration/research-lineage.md) when the analysis consumes a retained claim or hypothesis or produces a method decision, test, finding, or software artifact.

## Select the entry

- **Reconstruct:** recover the mathematical network from modules, forward paths, shapes, configuration, update rules, and relevant paper equations.
- **Analyze:** evaluate a named property, mechanism, information path, optimization behavior, or discrepancy without changing the model.
- **Redesign:** propose the smallest architecture-level change that addresses a frozen mathematical deficiency, with a falsifiable acceptance contract.

## Work-unit guidance

| Work unit | Starting execution contract | Capability lane |
| --- | --- | --- |
| Locate modules, tensor paths, shapes, parameter sharing, and configuration anchors | Scout | Fast and economical |
| Reconstruct a stable bounded network or run deterministic shape and gradient probes | Chief direct or Coder for a frozen probe | Balanced or fast code, matched to scope |
| Analyze ambiguous mechanisms, invariance, identifiability, stability, or theorem-like claims | Chief, direct; Reviewer when assurance requires independence | Strong reasoning |
| Implement a frozen architectural change and its tests | Coder when narrow; Builder when coordinated | Fast code or balanced |

Do not escalate because the network is large. Reduce it to the smallest subgraph, equation, or synthetic case that can answer the target question.

## Workflow

1. Freeze the target claim, network and checkpoint identity, relevant configuration, input domain, training or inference mode, and permitted redesign boundary.
2. Consume a mathematical problem map when available. Otherwise locate the minimum paper, code, and tensor anchors and label reconstructed statements by evidence state.
3. Express the relevant network as a composition or update system. Record shapes, axes, normalizations, masks, parameter sharing, stop-gradient boundaries, stochastic operations, and train/eval differences.
4. Draw the information and gradient dependency paths. Identify which inputs, labels, teachers, future observations, or auxiliary branches can influence each target quantity.
5. Test claimed properties using algebra, automatic differentiation, shape checks, limiting cases, symmetry transformations, perturbations, and small synthetic counterexamples as appropriate.
6. Separate structural properties from training outcomes. Analyze identifiability, degeneracy, stability, conditioning, and optimization interaction only within the assumptions supported by evidence.
7. For redesign, compare the current and proposed mathematical systems, name the deficiency addressed, predict observable changes, preserve required interfaces, and define a decisive baseline or ablation.
8. Record every theorem-like statement as a proof obligation with assumptions and evidence level. If strict proof is required, return `formal-proof-gap`.
9. Return the network contract, findings, counterexamples or unresolved questions, and one next bounded action. Implementation and training remain separate Chief-routed work units.

## Required return

- selected entry, frozen network, target claim, input domain, configuration, and lineage boundary;
- mathematical network representation and code-to-operator map;
- tensor, information, parameter, state-update, and gradient dependency maps;
- evaluated properties, assumptions, limiting cases, counterexamples, and evidence levels;
- identifiability, degeneracy, stability, conditioning, and optimization findings relevant to the target;
- current-versus-proposed contract and falsifiable acceptance checks for redesign;
- proof-obligation ledger and explicit `formal-proof-gap` status where applicable;
- prohibited interpretations, remaining uncertainty, and next owner.

## Boundaries

- Do not infer a mathematical property from a module name, architecture diagram, or author description when code behavior can be inspected.
- A network passing tests on sampled inputs does not prove a universal property. Numerical gradients and automatic differentiation establish observed computations, not theorem validity.
- Predictive improvement does not establish the proposed mechanism; require an alternative explanation, baseline, intervention, or ablation capable of discriminating it.
- Keep architecture mathematics separate from loss semantics. Route a loss, weighting, regularization, or multi-objective question to `loss-objective-optimization` after freezing the relevant network context.
- Do not silently change data, labels, splits, clinical targets, or scientific hypotheses to make an architectural proposal work.
- Strict formal proof and proof-assistant verification are an explicit Future Work gap. Do not use plausible derivations, symbolic algebra, or empirical testing as certification.
- Chief retains execution, model, reasoning effort, delegation, S0-S4 assurance, and final acceptance.

## Upstream adoption

- **Selected:** executable architecture reconstruction, information and gradient paths, property-specific checks, counterexamples, explicit redesign hypotheses, and proof-obligation records.
- **Not selected now:** architecture names as explanations, benchmark improvement as mechanism proof, a bundled training runtime, automatic model redesign, or strict formal verification.

The source-by-source decision is in the [adoption ledger](../../../docs/ecosystem-and-credits.md#adoption-ledger-by-local-skill).

## Influences and credits

This Skill is an original synthesis informed by computational-graph analysis, automatic differentiation, numerical stability practice, and paper-to-code correspondence. The [PyTorch autograd mechanics](https://docs.pytorch.org/docs/stable/notes/autograd.html) are one optional implementation reference; PyTorch is not bundled. See [ecosystem, influences, and credits](../../../docs/ecosystem-and-credits.md).
