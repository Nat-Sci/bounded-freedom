# Proof obligations and formal-proof gap

Use this reference when a claim contains words such as `prove`, `guarantee`, `always`, `converges`, `unique`, `identifiable`, `invariant`, `stable`, `optimal`, `bounded`, or an equivalent theorem-like statement.

## Proof-obligation record

```text
obligation_id_and_version
exact_proposition
quantifiers_and_domain
definitions
assumptions_and_regularities
excluded_or_boundary_cases
proof_standard_required
source_claim_and_code_identity
available_derivation_or_reference
counterexamples_checked
status
```

Use one status:

- `source-proof-cited`: a source supplies a proof; its applicability still requires mapping assumptions to the current implementation.
- `derived-under-assumptions`: a reviewable informal or conventional derivation is available, but no proof assistant has certified it.
- `numerically-supported`: tests support sampled cases only.
- `counterexample-found`: the proposition fails within its declared domain.
- `unverified`: evidence is insufficient.
- `formal-proof-gap`: the accepted claim requires strict or machine-checked proof that the current package cannot provide.

## Current capability boundary

The mathematical layer may:

- make propositions, domains, assumptions, and quantifiers explicit;
- check algebraic consistency and dimensional or tensor constraints;
- construct conventional derivations;
- search small or structured cases for counterexamples;
- compare implementation behavior with a cited theorem's preconditions;
- generate candidate tests and a proof-assistant handoff specification.

It may not claim that symbolic simplification, random testing, automatic differentiation, a language-model derivation, or a cited theorem with unmatched assumptions is a strict proof.

## Future Work: `formal-proof-verification`

BoundedFreedom does not currently include an independent `formal-proof-verification` Skill, a proof-assistant toolchain, verified translations from scientific code to formal definitions, or a trusted proof artifact review protocol.

A future capability must define at least:

- supported proof systems and pinned versions;
- translation and equivalence evidence from paper or code objects to formal definitions;
- treatment of floating-point computation, randomness, tensors, automatic differentiation, and library axioms;
- trusted computing base and permitted axioms;
- compilation or kernel-check evidence;
- proof artifact identity, review, maintenance, and version migration;
- separation of theorem correctness from whether the theorem models the scientific system of interest.

The official [Theorem Proving in Lean 4](https://docs.lean-lang.org/theorem_proving_in_lean4/) is a candidate reference, not a bundled capability or evidence that Lean is the final selected backend.

Until that work is accepted, return the precise obligation with status `formal-proof-gap`. Do not silently lower a requested strict proof to empirical validation.
