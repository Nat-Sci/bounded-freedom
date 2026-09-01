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

## Freeze the target

Record the paper version, repository and commit, target claim, expected observable, data and license boundary, environment, hardware assumptions, seeds, metric definition, and permitted deviations. If any identity is unknown, keep the result provisional.

## Workflow

1. Build a claim map from paper locations to code and configuration locations.
2. Separate author-provided behavior from inferred or newly generated implementation.
3. Bind environment, data, checkpoint, preprocessing, split, metric, and evaluation identities before a run.
4. Use the least costly mode that answers the user's question.
5. Preserve commands, configs, diffs, logs, outputs, and failures needed to audit the status.
6. Compare against the paper or baseline using predeclared tolerances and explain deviations.
7. Report one or more explicit statuses without collapsing them.

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
- status, deviations, blockers, and next smallest decisive test.

## Boundaries

- Do not download restricted data, accept licenses, spend substantial compute, or publish results without the required authority.
- A smoke run validates plumbing, not numerical or scientific agreement.
- Reimplementation without author code may test a method description but cannot silently inherit the author's implementation identity.
- A failed reproduction does not by itself refute the paper; distinguish mismatch, missing information, environment failure, and genuine contradictory evidence.
- Chief retains model routing, S0–S4 assurance, and independent review decisions.

## Influences and credits

This Skill is an original synthesis informed by [research-paper-code-study](https://github.com/baizhanxu/research-paper-code-study-codex-skill) for understanding and mapping, and by [PaperBench](https://github.com/openai/frontier-evals/tree/main/project/paperbench) and [ScienceAgentBench](https://github.com/OSU-NLP-Group/ScienceAgentBench) for stronger execution and evaluation boundaries. No upstream implementation is bundled. See [ecosystem, influences, and credits](../../../docs/ecosystem-and-credits.md).
