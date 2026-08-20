# Task record: global installation and update path

## Intent

- Objective: Make the Chief-first framework installable once at user scope and safely refreshable from this repository.
- Non-goals: Overwriting existing Codex configuration, installing a plugin, automatically pulling Git changes, or copying the full framework into every project.
- Assumptions and uncertainty: The user installs from a local clone and restarts Codex after the first installation; projects may already own an `[agents]` configuration table.

## Chief decision

- Risk: S1.
- Execution: builder.
- Workers and model rationale: No auxiliary worker; the installer is security-sensitive local configuration work, so the Chief retains the complete context.
- Owned scope: README deployment guidance, installation sources, shell installer, risk wording, and this record.
- Verification: Shell syntax check; isolated dry-run, install, status, and update; inspect managed markers, links, and configuration conflicts.
- Stop conditions: Stop before writing to the actual user home directory or replacing any user-owned path.

## Evidence and execution

- Relevant evidence: Codex supports personal custom agents under `~/.codex/agents/`, personal skills under `~/.agents/skills/`, layered `AGENTS.md`, and trusted project overrides.
- Changes or artifacts: An explicit shell installer with default dry-run and a README installation/update path.
- Deviations: No installer action is performed against the actual user home directory in this task.

## Verification and review

- Checks and comparisons: `sh -n` passes; an isolated target-root dry-run leaves no files; install creates four agent links, one skill link, and both managed blocks; status reports every target; update preserves the same links and refreshes only managed blocks; the active project configuration still passes Codex `config.load` without startup warnings.
- Reviewer verdict when required: Not required for S1.
- Human acceptance when required: Not required.

## Decision

- Outcome: Accepted for user-level installation after explicit user invocation.
- Alternatives rejected: Copying the full framework into every project; overwriting global configuration; a Python installer.
- Remaining uncertainty: The role/model defaults should still be tuned from real task records.
