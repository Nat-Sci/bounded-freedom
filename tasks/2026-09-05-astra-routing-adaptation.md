# Task record: GPT-6 Astra routing adaptation

## Intent

- Objective: Integrate GPT-6 Astra into the cost-efficient Codex routing model as an explicit frontier escalation while preserving the existing Luna, Terra, and Sol cost ladder.
- Non-goals: Do not make Astra a task-wide default, replace the conservative role profiles, infer scientific validity from model capability, add an API client, or claim unmeasured cost or quality gains.
- Assumptions and uncertainty: The current Codex host exposes Astra and the documented reasoning levels. Per-task cost efficiency still requires real workload measurement, so the routing boundary is policy rather than a benchmark result.

## Chief decision

- Task method: `skill-creator`, using a completed official OpenAI documentation check as the bounded evidence input.
- Assurance: S1 because routing behavior can change while scientific meaning and numerical outputs should remain unchanged.
- Execution contract: Chief direct.
- Model and capability lane: Current Chief; direct contract synthesis without a delegated model route.
- Planned workers: 0 distinct workers, 0 initial spawn attempts, and 0 planned retries.
- Actual workers: 0 distinct workers, 0 spawn attempts, 0 worker retries, and no worker lifecycle states.
- Worker-budget rationale: The scope is a small coordinated policy and documentation change; a handoff would cost more than direct completion.
- Owned scope: The orchestration entrypoint and host mapping, routing evaluations, portable and installed instruction sources, public overview, and this task record.
- Verification: Confirm official and host model capabilities; validate the changed Skill; review routing positives and boundaries; run installer regression and installed-state checks; resolve local Markdown targets; inspect the diff; scan changed text for private machine identifiers.
- Stop conditions: Do not change scientific contracts, promote Astra without an escalation gate, create a fifth execution role, or alter unrelated model defaults.

## Evidence and execution

- Relevant evidence: Official OpenAI model and migration guidance identifies `gpt-6-astra` as the most capable model for difficult end-to-end work, supports reasoning effort from low through max, and documents model-specific initiative, instruction sensitivity, delegation, and verification behavior. The current Codex model catalog also exposes Astra locally and adds a host-specific `ultra` automatic-delegation mode.
- Changes or artifacts: Added a portable frontier capability lane, a four-lane host mapping, an Astra-specific cost and behavior boundary, positive and negative routing prompts, matching global instructions, and a concise public explanation. Existing Luna, Terra, and Sol role profiles remain unchanged.
- Checkpoint: Scope, implementation, validation, and the managed local deployment are complete. This record is included in the coherent publication milestone; a new host session is the next safe point for routine use.
- Retries: One multi-file patch failed its context check before changing any file. A read-only diff confirmed no partial effect, and the idempotent edit was split into focused patches and applied once. Each of two ephemeral Astra evaluations encountered five automatic stream retries before the same invocation succeeded through its HTTP fallback; no evaluation was manually duplicated.
- Elapsed time: Approximately 14 minutes.
- Deviations: One safe patch retry was required despite a planned retry allowance of zero. An initial prompt-load diagnostic was too verbose and emitted host context to transient console; no such content was retained in repository artifacts, and the final check used a boolean-only filter.

## Verification and review

- Checks and comparisons: The orchestration Skill passed structural validation; shell syntax and all 26 installer regressions passed; the current Codex catalog reported Astra with medium as its default effort and low, medium, high, xhigh, max, and host-specific ultra levels; two fresh read-only Astra routing evaluations selected Astra / medium after a documented Sol shortfall and Sol / high Reviewer for a clear S4 review boundary; managed installation and prompt loading passed; the diff has no whitespace errors.
- Evidence coverage: 8 of 8 declared acceptance checks passed: official capability, host availability, Skill structure, routing positive, routing boundary, installer regression and status, managed prompt loading, and diff/privacy inspection.
- Privacy and portability check: A corrected scan of every changed and untracked text artifact found no machine-specific absolute path, account name, private hostname, local environment name, or file URI.
- Reviewer verdict when required: Not required for S1.
- Human acceptance when required: Not required for S1.

## Decision

- Outcome: Complete. Astra is available as an evidence-gated frontier lane, the cost ladder and execution-role defaults are preserved, and the managed Codex instructions are deployed locally.
- Alternatives rejected: Replacing the Reviewer default with Astra would spend frontier capacity on ordinary reviews; adding an Astra-named execution role would couple model identity back to ownership; making Astra the global Chief default would collapse the per-work-unit router.
- Remaining uncertainty: Local workload measurements have not yet established the break-even point between Sol and Astra.
