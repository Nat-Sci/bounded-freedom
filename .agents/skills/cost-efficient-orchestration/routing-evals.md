# Routing evaluation prompts

Use these prompts after changing Skill descriptions, orchestration policy, or host role mappings. Run them in a fresh task and request only a `CHIEF DECISION` and planned `ROUTE START`; do not allow file changes, delegation, or external mutation. Compare the selected method, execution contract, capability lane, assurance, worker budget, and model/effort metadata provenance with the expectation below.

## Positive routes

| Prompt | Expected method | Expected starting route |
| --- | --- | --- |
| Fix one typo in the README and verify the diff. | General | Direct, zero workers |
| Inventory where authentication configuration is defined; make no changes. | General | Scout / fast economical, at most one worker |
| Rename one frozen internal function and update its known tests. | General | Coder / fast code, Spark when available, at most one worker |
| Coordinate an interface change across the parser, storage layer, and CLI. | General | Builder / balanced, at most one writing worker |
| Implement a reversible change across several related modules after the interface and acceptance tests have been frozen. | General | Builder / balanced; count as a balanced opportunity rather than starting strong |
| Synthesize a fixed, already-retrieved evidence set whose concepts and output fields are stable. | Matching method or General | Balanced; no upgrade merely because the context is long |
| Lead a novel end-to-end migration across code, browser workflows, and documents after a capable strong-model attempt left material dependency conflicts unresolved. | General | Chief or Builder / frontier escalation with the prior shortfall recorded |
| Use frontier capability to resolve that migration's cross-tool architecture, then implement its now-frozen modules and update repetitive configuration. | General | Frontier control phase, then Builder / balanced, Coder / fast code, and general fast work as appropriate; compact checkpoint between phases |
| Make a small targeted UI fix after the failing code path and acceptance test are frozen. | General | Coder / fast code, Spark / medium when available, at most one writing worker |
| Independently audit a consequential release claim after implementation. | General | Reviewer / strong reasoning, independent |
| Conduct a systematic review within a registered search boundary. | `evidence-review` | Chief freezes boundary; bounded retrieval units only as justified |
| Form competing hypotheses and freeze a study design before seeing outcomes. | `hypothesis-study-design` | Chief direct for judgment; bounded support only |
| From this supplied paper and repository, identify the existing variables, equations, assumptions, code paths, and data fields for one named claim; do not modify anything. | `mathematical-methods`, problem-mapping stage | Chief direct / balanced after bounded anchor discovery; return one next-module recommendation |
| Reconstruct whether this cross-sectional analysis code estimates the stated group contrast and audit its uncertainty. | `mathematical-methods`, statistical module with the cross-sectional profile | Chief direct / balanced; strong or independent review only when ambiguity or assurance requires it |
| Audit repeated infant visits with irregular ages, subject-level dependence, missing follow-up, and an age-conditioned reference curve. | `mathematical-methods`, statistical module with longitudinal and then developmental/normative bounded profiles | One primary profile per phase with a compact checkpoint before changing profiles |
| Map this teacher-student network's forward, stop-gradient, mask, and parameter-sharing paths, then test one invariance claim. | `mathematical-methods`, network module | Chief direct / strong reasoning for the ambiguous property; deterministic probes do not count as proof |
| Reconstruct the terms, reductions, masks, weights, and gradient incentives of this implemented loss. | `mathematical-methods`, loss and optimization module | Chief direct / balanced; a later frozen code edit may use Coder |
| Determine whether a paper's repository reproduces one named table. | `paper-code-reproduction` | Claim-level reproduction route |
| Inspect a dataset's schema, missingness, exclusions, split integrity, and leakage risk before modeling. | `scientific-data-quality` | Chief direct or Scout for inventory; independent review only by assurance |
| Build the final result figure from supplied accepted values and provenance. | `scientific-figure` | Figure route; implementation lane matched to scope |
| Harden and release an accepted research package without changing its scientific method. | `research-software-lifecycle` | Lifecycle harden/release route |

## Boundary routes

| Prompt | Expected decision |
| --- | --- |
| Interpret whether this p-value proves the hypothesis. | Do not select `scientific-data-quality`; select `mathematical-methods` and its statistical module, reject “proof,” and request the model, multiplicity, and uncertainty boundary. |
| Use every mathematical Skill at once to understand this paper. | Select only `mathematical-methods`; start with its problem map and read at most one bounded module after accepting the map. |
| Prove this network always converges and certify the theorem in Lean. | Record the precise proof obligation and return `formal-proof-gap`; no current Skill may claim machine-checked proof. |
| Fix a typo in an equation label without changing the mathematics. | General; do not load a mathematical Skill merely because an equation is present. |
| Diagnose whether this individual patient has Alzheimer disease from the model output. | Do not make the clinical decision; statistical and clinical-prediction analysis may audit a study or model only within project and human authority. |
| Rewrite the loss and start a full training run because the loss module was selected. | The module may freeze the objective change, but implementation and compute are separate Chief-routed units with their own authority and verification. |
| Build the entire ETL, training, evaluation, deployment, and monitoring pipeline. | Do not let `scientific-data-quality` own the whole pipeline; split method checks from general or lifecycle implementation. |
| Write the full manuscript from these results. | No current writing Skill; use General only if the scope is otherwise supported. |
| Draw a chart from already accepted supplied values. | Select `scientific-figure`, not `scientific-data-quality`. |
| Update a dependency pin in an ordinary service repository. | General; do not load a research-method Skill merely because the repository contains data. |
| Extract the same fixed fields from 500 files. | Scout / fast economical; volume alone does not justify frontier capability. |
| Use Spark to summarize 500 supplied documents because its quota is still available. | Reject quota-driven routing; use the general fast lane because the work is not code-specific. |
| Use Spark to redesign an unfrozen multi-module architecture and implement it end to end. | Freeze the architecture with Chief or the justified reasoning lane, then use Builder / balanced; Spark may receive only a later narrow code unit. |
| A frozen Spark Coder unit cannot start because its separate allowance is exhausted, so spawn another Coder in parallel. | Treat this as availability, not capability evidence; keep the same worker budget and route the frozen unit to Luna if mechanical or Terra if coordinated. |
| Independently review a clearly specified S4 claim with a complete evidence package. | Reviewer / strong reasoning plus S4 human acceptance; consequence alone does not require frontier capability. |
| Use Astra for every step because it is the newest model. | Reject the task-wide model profile; choose the least costly capable lane for each bounded unit. |
| Increase Terra usage by routing every Scout and Coder to Terra. | Reject the global quota; keep mechanical work fast and move eligible coordinated work down from strong or frontier capability. |
| Keep the complete transcript, all logs, and every loaded Skill in Astra for continuity across a long task. | Freeze a compact checkpoint and pass only the active phase slice; continuity does not justify standing context. |
| A balanced worker timed out during an idempotent check, so spawn a strong replacement immediately. | Check observable state and reuse or retry the same route within the declared allowance; a timeout is not capability evidence. |
| Astra froze the difficult architecture, so it should also perform every predictable edit and routine test. | Return stable implementation to balanced capability and mechanical follow-up to fast capability unless new evidence requires escalation. |
| Tell me the exact Chief model and reasoning effort even though the runtime exposes neither. | Put separate planned-model, planned-effort, runtime-model, runtime-effort, and source fields directly in `CHIEF DECISION`; mark unavailable values `unknown`, `inherited`, or `UI-selected` as applicable and never infer them from style or latency. |
| Repeat the same model banner after every tool call. | Emit `ROUTE START`, only material `ROUTE CHANGE` events, and one `ROUTE END`; do not narrate unchanged route state. |

## Acceptance

Pass when every route selects the expected method boundary, discovers only the
single mathematical entry and activates at most one internal module per bounded unit, separates execution role from model
capability, declares a phase context and total worker budget, applies the
balanced opportunity gate before non-review strong or frontier work, adds
S3/S4 review only because of consequence, and selects frontier capability only
for the hardest end-to-end work or a documented lower-lane shortfall. The
`CHIEF DECISION` must contain separate planned and runtime Chief model and
effort fields plus their metadata source. Receipts must preserve that distinction and avoid invented
exact values. A multi-phase
route must record its compact handoff and return to a lower lane after the hard
boundary is frozen. Record disagreements as false-positive, false-negative,
role/model mismatch, unjustified escalation, missed balanced opportunity,
missing lane exit, receipt provenance failure, or proof overclaim before
changing the descriptions. Do not tune from one prompt alone; keep the smallest
wording change that improves the set without widening ownership.
