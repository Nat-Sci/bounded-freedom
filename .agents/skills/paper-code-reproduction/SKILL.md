---
name: paper-code-reproduction
description: Map scientific paper claims to code and run staged reproduction work. Use to understand paper-code correspondence, perform a low-cost smoke reproduction, or test a result at claim level; not to equate generated or runnable code with reproduced findings.
---

# Paper-code reproduction

Trace a claim from paper text to executable behavior and report the strongest status actually demonstrated.

## Choose the mode

- **Understanding map:** connect concepts, equations, claims, and experimental settings to files, classes, functions, configs, data, and outputs. Read-only by default.
- **Smoke reproduction:** establish the environment and run the smallest representative path to detect missing dependencies, data, checkpoints, or configuration.
- **Claim-level reproduction:** recreate the protocol needed to compare a named claim, metric, table, or figure within frozen tolerances.

Read [references/reproduction-contract.md](references/reproduction-contract.md) before mutation, execution, or a claim-level result.

Read the shared [research-lineage contract](../cost-efficient-orchestration/research-lineage.md) when the target comes from an evidence map or hypothesis record, or when the result will feed a finding, figure, manuscript, or software artifact. Preserve incoming claim, hypothesis, prediction, and study IDs rather than recreating them.

## Work-unit model guidance

| Work unit | Execution contract | Capability lane |
| --- | --- | --- |
| Paper and repository navigation, claim mapping, and dependency inventory | Scout | Fast and economical |
| Frozen environment, config, or smoke-script fixes | Coder | Fast and economical |
| Coordinated implementation or claim-level run construction across files | Builder | Balanced |
| Protocol equivalence, unexplained numerical discrepancy, or claim-status judgment | Chief, direct; Reviewer when independence is required | Strong reasoning |

Running longer or using more compute is not a reason to raise model capability. Escalate when mapping, implementation, or scientific interpretation exceeds the current lane. Use the general orchestration route for work not listed here.

## Freeze the target

Record the paper version, repository and commit, target claim, expected observable, data and license boundary, environment, hardware assumptions, seeds, metric definition, and permitted deviations. If any identity is unknown, keep the result provisional.

## Workflow

1. Build a claim map from paper locations to code and configuration locations, preserving any incoming lineage IDs.
2. Separate author-provided behavior from inferred or newly generated implementation.
3. Bind environment, data, checkpoint, preprocessing, split, metric, and evaluation identities before a run.
4. Use the least costly mode that answers the user's question.
5. Preserve commands, configs, diffs, logs, outputs, and failures needed to audit the status.
6. Compare against the paper or baseline using predeclared tolerances and explain deviations.
7. Report one or more explicit statuses without collapsing them.
8. When the run informs later research, create an identified run and finding receipt linked to the tested claim, hypothesis, prediction, or study; do not silently update those upstream records.

## Status vocabulary

```text
mapped
environment-ready
code-runs
method-implemented
claim-reproduced
not-reproduced
indeterminate
```

`code-runs`, `method-implemented`, and `claim-reproduced` are different claims. State evidence for each status used.

## Required return

- frozen target and selected mode;
- claim-to-code map with exact source locations;
- environment, data, config, checkpoint, and metric identities;
- executed commands and observable outputs, or a read-only mapping receipt;
- comparison against expected behavior;
- status, deviations, blockers, and next smallest decisive test;
- run, finding, and artifact relationships when the result enters the project research lineage.

## Boundaries

- Do not download restricted data, accept licenses, spend substantial compute, or publish results without the required authority.
- A smoke run validates plumbing, not numerical or scientific agreement.
- Reimplementation without author code may test a method description but cannot silently inherit the author's implementation identity.
- A failed reproduction does not by itself refute the paper; distinguish mismatch, missing information, environment failure, and genuine contradictory evidence.
- A reproduction finding may update confidence in a bounded claim, but successful execution or software tests do not create new scientific evidence by themselves.
- These rows are starting points. Chief retains the final model, delegation, and S0–S4 decisions.

## Upstream adoption

- **Selected:** claim-to-code mapping, staged understanding/smoke/claim modes, frozen identities, stable upstream IDs, run and finding receipts, a cost ladder, explicit evidence states, and independent grading for consequential claims.
- **Not selected now:** automatic paper-to-code generation as proof, a bundled GPU or container runtime, automatic claim extraction, required knowledge-graph infrastructure, or a single score that hides failure type.

The full source-by-source decision is in the [adoption ledger](../../../docs/ecosystem-and-credits.md#adoption-ledger-by-local-skill).

## Influences and credits

This Skill is an original synthesis informed by [research-paper-code-study](https://github.com/baizhanxu/research-paper-code-study-codex-skill) for understanding and mapping, and by [PaperBench](https://github.com/openai/frontier-evals/tree/main/project/paperbench) and [ScienceAgentBench](https://github.com/OSU-NLP-Group/ScienceAgentBench) for stronger execution and evaluation boundaries. No upstream implementation is bundled. See [ecosystem, influences, and credits](../../../docs/ecosystem-and-credits.md).
