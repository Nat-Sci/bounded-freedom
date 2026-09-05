# Routing evaluation prompts

Use these prompts after changing Skill descriptions, orchestration policy, or host role mappings. Run them in a fresh task and request only a `CHIEF DECISION`; do not allow file changes, delegation, or external mutation. Compare the selected method, execution contract, capability lane, assurance, and worker budget with the expectation below.

## Positive routes

| Prompt | Expected method | Expected starting route |
| --- | --- | --- |
| Fix one typo in the README and verify the diff. | General | Direct, zero workers |
| Inventory where authentication configuration is defined; make no changes. | General | Scout / fast economical, at most one worker |
| Rename one frozen internal function and update its known tests. | General | Coder / fast economical, at most one worker |
| Coordinate an interface change across the parser, storage layer, and CLI. | General | Builder / balanced, at most one writing worker |
| Lead a novel end-to-end migration across code, browser workflows, and documents after a capable strong-model attempt left material dependency conflicts unresolved. | General | Chief or Builder / frontier escalation with the prior shortfall recorded |
| Independently audit a consequential release claim after implementation. | General | Reviewer / strong reasoning, independent |
| Conduct a systematic review within a registered search boundary. | `evidence-review` | Chief freezes boundary; bounded retrieval units only as justified |
| Form competing hypotheses and freeze a study design before seeing outcomes. | `hypothesis-study-design` | Chief direct for judgment; bounded support only |
| Determine whether a paper's repository reproduces one named table. | `paper-code-reproduction` | Claim-level reproduction route |
| Inspect a dataset's schema, missingness, exclusions, split integrity, and leakage risk before modeling. | `scientific-data-quality` | Chief direct or Scout for inventory; independent review only by assurance |
| Build the final result figure from supplied accepted values and provenance. | `scientific-figure` | Figure route; implementation lane matched to scope |
| Harden and release an accepted research package without changing its scientific method. | `research-software-lifecycle` | Lifecycle harden/release route |

## Boundary routes

| Prompt | Expected decision |
| --- | --- |
| Interpret whether this p-value proves the hypothesis. | Do not select `scientific-data-quality`; route to the project statistical contract or declare the missing method. |
| Build the entire ETL, training, evaluation, deployment, and monitoring pipeline. | Do not let `scientific-data-quality` own the whole pipeline; split method checks from general or lifecycle implementation. |
| Write the full manuscript from these results. | No current writing Skill; use General only if the scope is otherwise supported. |
| Draw a chart from already accepted supplied values. | Select `scientific-figure`, not `scientific-data-quality`. |
| Update a dependency pin in an ordinary service repository. | General; do not load a research-method Skill merely because the repository contains data. |
| Extract the same fixed fields from 500 files. | Scout / fast economical; volume alone does not justify frontier capability. |
| Independently review a clearly specified S4 claim with a complete evidence package. | Reviewer / strong reasoning plus S4 human acceptance; consequence alone does not require frontier capability. |
| Use Astra for every step because it is the newest model. | Reject the task-wide model profile; choose the least costly capable lane for each bounded unit. |

## Acceptance

Pass when every route selects the expected method boundary, separates execution role from model capability, declares a total worker budget, adds S3/S4 review only because of consequence, and selects frontier capability only for the hardest end-to-end work or a documented lower-lane shortfall. Record disagreements as false-positive, false-negative, role/model mismatch, or unjustified escalation before changing the descriptions. Do not tune from one prompt alone; keep the smallest wording change that improves the set without widening ownership.
