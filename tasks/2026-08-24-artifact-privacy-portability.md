# Task record: artifact privacy and portability

## Intent

- Objective: Prevent machine-local identity, paths, and private naming conventions from leaking into repository artifacts, command examples, retained logs, or worker returns.
- Non-goals: Hiding public project names, weakening reproducibility, rewriting unrelated historical material, or blocking exact local disclosure when a human explicitly requests it.
- Assumptions and uncertainty: Repository-relative paths and neutral placeholders provide enough operational context for normal documentation and verification.

## Chief decision

- Risk: S1.
- Execution: direct.
- Workers and model rationale: None; this is a bounded privacy-contract and installer-output change whose handoff would cost more than direct implementation.
- Owned scope: Constitution, global and project runtime contracts, orchestration skill, task template, README, installer output, and this record.
- Verification: Review the diff, exercise installer modes in an isolated target, refresh the installed managed block, and scan changed text and command output for host-specific identifiers.
- Stop conditions: Stop before rewriting unrelated documents or removing operational evidence required for reproducibility.

## Evidence and execution

- Relevant evidence: The existing repository Markdown did not contain common host-specific absolute-path patterns, but installer status and conflict messages printed raw local destinations and link targets.
- Changes or artifacts: Added a privacy-and-portability contract, a completion scan requirement, semantic installer status output, documentation, and this single task record.
- Deviations: None.

## Verification and review

- Checks and comparisons: Shell syntax passed; isolated dry-run, install, status, and update passed; all five links resolved; both installed managed blocks matched their repository sources; conflict behavior remained fail-safe; the current global installation refreshed and reported healthy semantic status. ShellCheck was not installed, so no ShellCheck result was available.
- Privacy and portability check: Installer success and conflict output contained neither the repository location, isolated target location, nor local account name. Repository Markdown, shell, and TOML files matched neither common host-specific absolute-path patterns nor the local account name.
- Reviewer verdict when required: Not required for S1.
- Human acceptance when required: Not required.

## Decision

- Outcome: Accepted and refreshed into the current global Codex installation.
- Alternatives rejected: Relying only on manual redaction; banning all project names, including public interface names; exposing raw paths for diagnostic convenience.
- Remaining uncertainty: Historical artifacts in other repositories require their own audit or cleanup; this global rule governs new work after installation refresh and Codex restart.
