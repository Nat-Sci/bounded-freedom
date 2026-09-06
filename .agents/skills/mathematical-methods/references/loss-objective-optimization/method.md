# Loss, objective, and optimization analysis module

State precisely what the implemented objective optimizes, where its gradients flow, and whether the surrogate and training procedure align with the frozen scientific or engineering target.

Read [the loss and optimization contract](loss-contract.md) for component fields, gradient and scale checks, failure modes, and acceptance evidence.

The parent Skill supplies the accepted problem and network maps, bounded lineage slice, execution route, and assurance level. This module owns only the objective and optimization method and return contract.

## Select the entry

- **Reconstruct:** recover the effective objective from code, configuration, schedules, reductions, masks, sampling, teacher updates, and paper definitions.
- **Audit:** test a named claim about gradients, balance, robustness, calibration, convergence behavior, or mechanism against the effective objective.
- **Design:** propose the smallest objective-level change for a frozen target, with explicit alternatives, failure cases, and acceptance checks.

## Work-unit guidance

| Work unit | Starting execution contract | Capability lane |
| --- | --- | --- |
| Locate loss modules, weights, schedules, reductions, detach points, and optimizer configuration | Scout | Fast and economical |
| Reconstruct a stable objective or run frozen gradient and limiting-case probes | Chief direct or Coder for a narrow probe | Balanced or fast code, matched to scope |
| Resolve surrogate alignment, coupled objectives, degeneracy, unstable optimization, or consequential method claims | Chief, direct; Reviewer when assurance requires independence | Strong reasoning |
| Implement one frozen objective change and its tests | Coder when narrow; Builder when coordinated | Fast code or balanced |

Keep network-wide architectural redesign in the [neural-network mathematical analysis module](../neural-network-mathematical-analysis/method.md). This module may freeze the loss-facing interface a later network unit must preserve.

## Workflow

1. Freeze the target quantity or behavior, target claim, relevant network boundary, data and label access, code and configuration identity, and permitted objective changes.
2. Consume the mathematical problem and network maps when available. Otherwise reconstruct only the operators and dependencies needed by the objective.
3. Write the effective scalar or constrained objective, including every component, coefficient, schedule, expectation, sample weight, mask, reduction denominator, regularizer, and optimizer-facing transformation.
4. Map forward values, gradient paths, detach boundaries, shared parameters, teacher or moving-average updates, and data-dependent weights. Distinguish direct gradients from coupled influence.
5. Analyze units and scale, sign, boundedness, invariances, limiting cases, class or group weighting, stochastic estimators, bias and variance, conflicting gradients, degeneracy, and numerical stability.
6. Compare the optimized surrogate with the frozen target metric or decision. State where consistency is known, assumed, empirically suggested, or absent.
7. For design, include a null or simpler alternative, predicted failure modes, hyperparameter meaning, schedules, and the smallest synthetic oracle, baseline, and ablation that can distinguish the proposed mechanism.
8. Freeze code acceptance checks: exact-value cases, reduction and mask accounting, finite gradients, detach behavior, invariance or monotonicity where justified, and targeted optimization behavior.
9. Record theorem-like convergence, optimality, boundedness, or consistency
   statements as proof obligations. If acceptance requires strict proof, return
   `formal-proof-gap`.
10. Return the objective contract and next bounded action. Implementation, full training, statistical inference, and clinical evaluation remain separately routed work units.

## Required return

- selected entry, frozen target, network boundary, data and label access, code/config identity, and lineage;
- complete mathematical objective and component-to-code map;
- reduction, weighting, schedule, gradient, state-update, and optimizer correspondence;
- scale, boundedness, degeneracy, surrogate, conditioning, and numerical findings;
- competing objective or mechanism explanations;
- proposed change, hyperparameter interpretation, failure cases, and decisive tests when designing;
- proof obligations and explicit `formal-proof-gap` status when strict proof is required;
- supported claim, prohibited claims, remaining uncertainty, and next owner.

## Boundaries

- Do not reconstruct the objective from a displayed scalar alone; reduction, masks, sampling, schedules, shared parameters, and update timing can change its meaning.
- Loss reduction and class weighting are not automatically equivalent to a population estimand, calibrated probability, fairness criterion, or clinical utility.
- Training loss decreasing does not prove convergence to a useful or unique solution, generalization, causal mechanism, or scientific validity.
- Numerical gradient checks and finite examples verify sampled behavior, not a universal theorem.
- Do not tune objective weights on held-out evaluation data or report post hoc ablations as confirmatory.
- Do not change network architecture, data contract, target label, clinical threshold, or primary hypothesis without a separately frozen and authorized work unit.
- Chief retains execution, model, reasoning effort, delegation, S0-S4 assurance, module transitions, and final acceptance.
- Return to the parent `mathematical-methods` Skill after this bounded module; do not invoke another module recursively.
