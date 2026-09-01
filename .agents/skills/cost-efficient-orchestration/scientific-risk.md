# Scientific-risk gates

| Level | Meaning | Minimum handling |
|---|---|---|
| S0 | Presentation, wording, organization, or read-only work that cannot affect interpretation or a consequential decision | Verify the requested artifact or answer |
| S1 | Engineering change expected to preserve scientific meaning | Freeze scope and run behavior-relevant checks |
| S2 | May change numerical outputs | Add numerical or baseline comparison and record the result |
| S3 | May change statistical inference | S2 evidence plus an independent Reviewer using a model capable of consequential judgment |
| S4 | May change primary claims, clinical interpretation, ethics, or irreversible decisions | S3 gates plus explicit human acceptance |

Classify the highest plausible consequence, not the apparent size of the diff. When uncertain between adjacent levels, state the uncertainty and use the higher gate until evidence resolves it.

Scientific risk and implementation complexity are independent. For example, a mechanically simple covariate change can be S3, while a large documentation reorganization can remain S0.
