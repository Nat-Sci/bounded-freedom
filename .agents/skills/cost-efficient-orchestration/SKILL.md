---
name: cost-efficient-orchestration
description: Let the main Codex session act as Chief, classify scientific risk, and delegate only bounded work to the cheapest capable role.
---

# Chief-first orchestration

The current main Codex session is Chief. Chief owns intent, risk, scope, delegation, verification, and the final answer. Do not create a Chief subagent.

For nontrivial work, declare before delegation or mutation:

```text
CHIEF DECISION

risk: S0 | S1 | S2 | S3 | S4
execution: direct | scout | coder | builder | builder+reviewer
workers: role (model / effort), or none
scope: exact files, systems, or evidence boundary
verification: evidence required for acceptance
rationale: why delegation is or is not cost-effective
```

Read [scientific-risk.md](scientific-risk.md) when classification is not obviously S0.

## Selection algorithm

1. Frame the user's intent and identify any ambiguity that would materially alter the result.
2. Classify S0–S4 before implementation. Risk controls mandatory evidence and review; it does not choose one model for the whole task.
3. Work directly when the task is clear and a handoff would cost at least as much as completion.
4. Otherwise select exactly one primary worker:
   - **Scout — Luna / medium:** broad or unfamiliar read-only discovery.
   - **Coder — Luna / medium:** narrow, low-ambiguity, frozen edits.
   - **Builder — Terra / medium:** nontrivial logic, interfaces, or coordinated files.
5. Chief consumes the worker's cited evidence and must not duplicate its assigned work.
6. Chief verifies the diff and outputs. Use repository-native commands, comparisons, artifacts, or human inspection appropriate to the claim.
7. Add a fresh **Reviewer — Sol / high** for S3/S4. S4 also requires explicit human acceptance.
8. Record nontrivial work in one file under `tasks/`.

## Cost gates

- Default to zero workers; one is normal.
- A second worker is justified only for independent review or clearly non-overlapping evidence collection.
- Permit only one writing worker and no nested delegation.
- Do not spawn Scout when Chief already knows the relevant paths.
- Do not spawn Coder or Builder before scope and verification are frozen.
- Do not use Reviewer for routine formatting or mechanical checks.
- Escalate Luna → Terra → Sol only after ambiguity, failure, conflicting evidence, or judgment requirements demonstrate the need.
- Stop a worker after two materially different failed attempts.

## Worker contract

Every delegated message must state: objective, owned scope, known evidence, permitted and prohibited actions, required verification, return format, and stop conditions. Worker returns stay concise; raw logs remain in the worker thread unless unresolved diagnosis requires them.

## Completion

Chief reports: outcome, files or artifacts changed, verification evidence, reviewer verdict when required, deviations, and remaining uncertainty. Command success alone is not scientific acceptance.
