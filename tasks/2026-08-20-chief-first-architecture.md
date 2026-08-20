# Task record: Chief-first architecture

## Intent

- Objective: Replace task-wide model profiles with a Chief-led, per-role model-selection strategy and make the repository directly usable in Codex.
- Non-goals: Domain-specific research skills, automatic token accounting, a web UI, or a standalone software package.
- Assumptions and uncertainty: The main Codex session can read repository instructions and invoke configured custom agents; real-world task evidence will be needed to tune the role/model defaults.

## Chief decision

- Risk: S1, because orchestration behavior changes while scientific intent remains unchanged.
- Execution: direct.
- Workers and model rationale: No auxiliary worker; the current high-capability Chief performed the architecture review and implementation to avoid circular delegation.
- Owned scope: Repository contracts, Codex configuration, custom agents, onboarding, design-history organization, and task records.
- Verification: Inspect the final tree, parse TOML through Codex-compatible tooling, confirm models against the local Codex catalog, and check internal links and obsolete terminology.
- Stop conditions: Stop if the local Codex runtime contradicts required configuration fields or source drafts cannot be preserved.

## Evidence and execution

- Relevant evidence: The local Codex model catalog exposes Sol, Terra, Luna, and Codex Spark with distinct capability/cost positions.
- Changes or artifacts: Chief-first skill; Scout, Coder, Builder, and Reviewer contracts; single lifecycle task record; simplified onboarding.
- Deviations: Python validation and separate QA/brief/review templates were removed because daily validation belongs in the Codex task flow.

## Verification and review

- Checks and comparisons: `codex doctor --json` reports `config.load: ok` with no startup warnings; `codex debug models` confirms all four configured model families; `codex debug prompt-input` confirms both `AGENTS.md` and the orchestration skill enter the model-visible context; obsolete profile and route terminology is absent from active files.
- Reviewer verdict when required: Not required for S1; Chief performs final verification.
- Human acceptance when required: Not required.

## Decision

- Outcome: Accepted for practical V0.1 use in Codex.
- Alternatives rejected: Task-wide Micro/Economy/Critical profiles and mandatory multi-agent chains.
- Remaining uncertainty: Optimal model assignments must be refined from recorded task outcomes rather than assumed in advance.
