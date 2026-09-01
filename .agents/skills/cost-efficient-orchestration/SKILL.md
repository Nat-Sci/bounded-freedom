---
name: cost-efficient-orchestration
description: Use when nontrivial research or repository work needs Chief-led task routing, per-work-unit model choice, bounded delegation, scientific-risk gates, verification, or independent review.
---

# Chief-first orchestration

The current primary session is Chief. Chief owns intent, task routing, risk, scope, delegation, verification, and the final answer. Do not create a Chief subagent.

For nontrivial work, declare before delegation or mutation:

```text
CHIEF DECISION

task route: direct | <matching-skill>
risk: S0 | S1 | S2 | S3 | S4
execution: direct | scout | coder | builder | builder+reviewer
workers: role (host model / effort), or none
scope: exact files, systems, or evidence boundary
verification: evidence required for acceptance
rationale: why this route and delegation are cost-effective
```

Read [scientific-risk.md](scientific-risk.md) when classification is not obviously S0. Read [host-model-routing.md](host-model-routing.md) before choosing a worker model or adapting this Skill to another harness.

## Make three decisions separately

1. **Task route:** Match the request against available Skill descriptions. Load only a clearly relevant Skill; otherwise continue with general repository work. Chief needs the catalog, not every specialist method in standing context.
2. **Work capability:** Choose a model for each bounded unit from search volume, context length, ambiguity, coding depth, tool reliability, and judgment. Do not assign one model profile to the whole task.
3. **Assurance:** Classify S0–S4 by the highest plausible consequence. Risk sets evidence, independent review, and human acceptance; it does not name the task or automatically choose the model.

When a specialized Skill is loaded, use its work-unit capability first, then resolve it through the host mapping. Use the general policy only for an unmatched unit. This is one refined dispatcher, not a task-wide model profile. The S0–S4 gate may add review; it does not automatically upgrade the executor.

The Skill owns method and capability guidance; orchestration owns final model choice, delegation, and assurance; project instructions own local facts. Do not duplicate these layers.

## Selection algorithm

1. Frame the user's intent and identify ambiguity that would materially alter the result.
2. Select a matching Skill only when specialized method or output contracts are needed.
3. Freeze scope, permitted actions, verification, stop conditions, and unresolved uncertainty.
4. For each work unit, use the selected Skill's starting capability when listed; otherwise use the general limiting-factor policy.
5. Classify S0–S4 before consequential mutation.
6. Work directly when the task is clear and a handoff would cost at least as much as completion.
7. Otherwise select one primary role:
   - **Scout:** read-only discovery that would otherwise flood Chief's context.
   - **Coder:** narrow, explicit, low-ambiguity edits inside frozen ownership.
   - **Builder:** nontrivial implementation across logic, interfaces, or coordinated files.
8. Map the required capability and role to the least costly capable host model, then adjust only when evidence supports it.
9. Chief consumes the worker's cited evidence and does not repeat the assigned discovery.
10. Chief verifies actual diffs, outputs, comparisons, artifacts, or human inspection appropriate to the claim.
11. Add a fresh independent **Reviewer** for S3/S4. S4 also requires explicit human acceptance.
12. Record nontrivial work in one file under `tasks/`.

## Capability and cost gates

- Default to zero workers; one is normal.
- A second worker is justified only for independent review or clearly non-overlapping evidence collection.
- Permit only one writing worker and no nested delegation.
- Do not spawn Scout when Chief already knows the relevant paths.
- Do not spawn Coder or Builder before scope and verification are frozen.
- Do not use Reviewer for routine formatting or mechanical checks.
- Use a fast economical model for high-volume, bounded, reversible work only when its tool use and output reliability are sufficient.
- Use a balanced model when long context, coordinated implementation, or stable synthesis is the limiting factor.
- Use the strongest available reasoning model for high-ambiguity judgment, conflicting evidence, or consequential independent review.
- Do not make maximum reasoning the default. Escalate after ambiguity, failure, conflict, or consequence demonstrates value.
- Stop a worker after two materially different failed attempts.

## Worker contract

Every delegated message states: objective, owned scope, known evidence, permitted and prohibited actions, required verification, return format, and stop conditions. A worker must know that other work may exist, must preserve unrelated changes, and must not recursively delegate.

Worker returns stay concise. Raw logs remain in the worker context unless unresolved diagnosis requires them. A successful command is engineering evidence, not proof of a scientific claim.

## Host boundary

Keep this Skill within the open Agent Skills fields and plain Markdown. Put model IDs, agent-file schemas, permissions, hooks, and provider credentials in host adapters. A different harness may lack subagents or enforce different tool names; in that case Chief works directly while preserving the same scope and evidence contract.

## Privacy and portability gate

Chief and every worker treat machine-local identity and layout as private by default. Repository artifacts, Markdown, task records, command text, retained logs, and worker returns use repository-relative paths or neutral placeholders instead of machine-specific absolute paths, account names, private hostnames, or local-only environment, workspace, checkout, and mount names. Run from the current working directory when possible, redact incidental local identifiers before preserving evidence, and scan changed text before completion. Exact disclosure requires explicit human instruction.

## Completion

Chief reports: outcome, files or artifacts changed, verification evidence, reviewer verdict when required, deviations, and remaining uncertainty.

## Influences and credits

This Skill is an original integration informed by the open [Agent Skills specification](https://agentskills.io/specification) and the control surfaces compared in the [harness landscape](../../../docs/harness-landscape.md). Its separation of task route, work capability, and assurance is the local BoundedFreedom contract. See [ecosystem, influences, and credits](../../../docs/ecosystem-and-credits.md) for the attribution and reuse policy.
