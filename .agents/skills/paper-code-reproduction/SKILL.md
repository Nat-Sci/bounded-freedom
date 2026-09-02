---
name: paper-code-reproduction
description: Map scientific paper claims to code, identify the implementation source, and run staged reproduction work. Use to understand paper-code correspondence, perform a low-cost smoke run, repair or reimplement a method, or test a named claim; not to equate runnable code with reproduced findings.
---

# Paper-code reproduction

Trace a claim from paper text to executable behavior and report the strongest status actually demonstrated.

## Choose two axes

Select implementation source and evidence depth separately.

**Implementation source**

- **Author code, unmodified:** use an author-associated repository and pinned commit without behavioral edits.
- **Author code, repaired:** preserve the intended method while making disclosed environment, compatibility, or defect corrections.
- **Adapted implementation:** reuse code while changing a protocol or method surface; do not present it as the original implementation.
- **Independent implementation:** implement from the paper contract without reusing author code for the core behavior.

**Evidence depth**

- **Map:** connect concepts, equations, claims, and experimental settings to files, functions, configs, data, and outputs. Read-only by default.
- **Smoke:** establish the environment and run the smallest representative path to expose missing dependencies, data, checkpoints, or configuration.
- **Claim:** compare a named metric, table, figure, or other observable against a frozen protocol and tolerance.

For example, `author code, repaired + smoke` and `independent implementation + claim` are different routes and support different conclusions. New-data, new-population, or new-condition replication belongs in study design and project execution rather than silently becoming a fourth source route.

Read [references/reproduction-contract.md](references/reproduction-contract.md) before mutation, execution, or a claim-level result.

Read the shared [research-lineage contract](../cost-efficient-orchestration/research-lineage.md) when the target comes from an evidence map or hypothesis record, or when the result will feed a finding, figure, manuscript, or software artifact. Preserve incoming claim, hypothesis, prediction, and study IDs rather than recreating them.

## Work-unit model guidance

| Work unit | Execution contract | Capability lane |
| --- | --- | --- |
| Paper and repository discovery, source checks, claim mapping, and dependency inventory | Scout | Fast and economical |
| Frozen environment, config, or smoke-script fixes | Coder | Fast and economical |
| Coordinated adaptation, reimplementation, or claim-level run construction across files | Builder | Balanced |
| Protocol equivalence, implicit assumptions, unexplained discrepancy, or claim judgment | Chief, direct; Reviewer when independence is required | Strong reasoning |

Running longer or using more compute is not a reason to raise model capability. Escalate when mapping, implementation, or scientific interpretation exceeds the current lane. Use the general orchestration route for work not listed here.

## Freeze the target

Record the paper version, candidate and selected repositories, source evidence, commit, implementation source, evidence depth, target claim, expected observable, data and license boundary, environment, hardware assumptions, seeds, metric definition, and permitted deviations. If any identity is unknown, keep the result provisional.

## Workflow

1. Select the implementation source and evidence depth, preserving any incoming lineage IDs.
2. Confirm why the selected repository is author-associated or record it as an external reference; do not infer identity from a similar name alone.
3. Turn each target claim into explicit implementation requirements. Keep paper statements, code behavior, external reference evidence, and reviewer inference separate.
4. Bind environment, data, checkpoint, preprocessing, split, metric, and evaluation identities before a run.
5. Check data, permission, compute, time, and expected decision value before climbing the cost ladder.
6. Preserve commands, effective configs, changes, logs, outputs, and failures needed to audit the status. Classify every repair by its effect on implementation identity.
7. Compare against the paper or baseline using predeclared tolerances and explain deviations.
8. Report progress and claim comparison separately rather than collapsing them into one success label.
9. When the run informs later research, create an identified run and finding receipt linked to the tested claim, hypothesis, prediction, or study; do not silently update those upstream records.

## Status vocabulary

**Progress:** `mapped`, `environment-ready`, `code-runs`, `method-implemented`.

**Claim comparison:** `matched`, `mismatched`, `blocked`, `indeterminate`.

Progress does not imply a claim result. `mismatched` requires a sufficiently matched protocol; missing data or an unresolved identity is `blocked` or `indeterminate`, not evidence that the paper is false.

## Required return

- frozen target, implementation source, and evidence depth;
- claim-to-code map with exact source locations;
- implementation requirements, reference evidence, and unresolved assumptions;
- environment, data, config, checkpoint, and metric identities;
- resource decision and classified change record when execution or repair occurs;
- executed commands and observable outputs, or a read-only mapping receipt;
- comparison against expected behavior;
- progress, claim comparison, deviations, blockers, and next smallest decisive test;
- run, finding, and artifact relationships when the result enters the project research lineage.

## Boundaries

- Do not download restricted data, accept licenses, spend substantial compute, or publish results without the required authority.
- A smoke run validates plumbing, not numerical or scientific agreement.
- A repair that changes protocol or method moves the route to `adapted`; it cannot silently retain author-code identity.
- Independent implementation may test a paper specification but cannot inherit the author's implementation identity.
- A failed reproduction does not by itself refute the paper; distinguish mismatch, missing information, environment failure, and genuine contradictory evidence.
- Do not tune toward reported values or silently downscale a retained claim. Change the target explicitly or report it as blocked.
- A reproduction finding may update confidence in a bounded claim, but successful execution or software tests do not create new scientific evidence by themselves.
- These rows are starting points. Chief retains the final model, delegation, and S0–S4 decisions.

## Upstream adoption

- **Selected:** separate implementation-source and evidence-depth axes, claim-to-code requirements, source and repair records, frozen identities, resource gates, stable upstream IDs, run and finding receipts, a cost ladder, explicit comparison states, and independent grading for consequential claims.
- **Not selected now:** automatic paper-to-code generation as proof, a bundled reproduction runtime, automatic claim extraction, required knowledge-graph infrastructure, benchmark-specific adapters, or a single score that hides failure type.

The full source-by-source decision is in the [adoption ledger](../../../docs/ecosystem-and-credits.md#adoption-ledger-by-local-skill).

## Influences and credits

This Skill is an original synthesis informed by [research-paper-code-study](https://github.com/baizhanxu/research-paper-code-study-codex-skill) for understanding and mapping, [ReproAgent](https://arxiv.org/abs/2608.24291) for persistent implementation requirements and separate reference evidence, and [Veritas](https://github.com/ChicagoHAI/veritas) and [PaperBench](https://github.com/openai/frontier-evals/tree/main/project/paperbench) for execution and grading boundaries. No upstream implementation is bundled. See [ecosystem, influences, and credits](../../../docs/ecosystem-and-credits.md).
