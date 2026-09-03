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

## Hardening increment: deterministic safe updates

### Frozen increment

- Entry and pressure: `harden`; repeated `--update` calls added separator whitespace, and a destination conflict discovered late in the install plan could leave earlier links behind.
- Previous accepted baseline: The installer defaulted to dry-run, preserved ordinary conflicting paths, and changed only repository links and marked instruction blocks.
- In scope: Byte-idempotent managed-block refresh, complete destination preflight before mutation, clearer unsafe-target status, and one isolated Shell regression script.
- Out of scope: A new installer runtime, automatic repository pulls, global installation during development, Skill or model-routing changes, and transaction recovery from external filesystem races after preflight.
- Compatibility: Existing commands, host modes, managed markers, exit `3` for a user-owned Codex `[agents]` table, and repository-link layout remain unchanged.
- Acceptance evidence: Clean and dry-run behavior, all-host links, status, repeated-update byte comparison, user-content preservation, zero partial writes for a late conflict, configuration conflict, managed-file symlink refusal, and malformed-marker refusal.

### Implementation and evidence

- The installer now validates every planned directory, repository source, link destination, and managed file before the first directory, link, or block is written.
- Managed blocks place their visual separator inside the markers, so removing and recreating a block does not accumulate bytes outside the managed region.
- Managed-file symbolic links and incomplete or duplicate marker pairs fail closed; `--status` reports these states explicitly.
- `scripts/test-install-global.sh` keeps all writes under a validated temporary root and exercises 26 regression assertions without touching the active user installation.

### Repository verification

- Accepted: Installer regression assertions `26/26`; installer and test syntax under `sh`, Bash, Dash, and KornShell; six Skill validators; six TOML parses; 37 tracked Markdown files with 52 local targets; whitespace, privacy, and Git integrity checks.
- Codex integration: `config.load` passed; the project contract and all six Skill catalog entries are model-visible, while full Skill bodies remain on-demand; all three configured model families are present in the local catalog.
- Host readiness: An all-host user-scope dry-run found no conflicts and made no changes; status still reports the portable, Codex, and Claude adapters as uninstalled.
- Environment limits: The wider Codex doctor result remains non-green because the noninteractive terminal reports `TERM=dumb` and two network reachability probes warn. These do not originate in this repository or invalidate `config.load`.
- State: Accepted as the new installer baseline. No real user-scope installation or external publication was performed.
