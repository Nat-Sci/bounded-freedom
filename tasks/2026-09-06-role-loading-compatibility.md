# Task record: custom-role loading compatibility

## Intent

- Objective: explain and reproduce the named-role launch failure, repair the
  installer incompatibility, and keep fallback evidence honest.
- Non-goals: change scientific code or conclusions, interrupt other tasks,
  change user-selected Chief settings, bypass host file protections, or infer billing.
- Evidence scope: the two requested projects, the previously frozen five-hour
  audit window, installed role file metadata, and upstream role-loading code.
  No raw conversations, commands, private paths, or row-level identifiers are retained.

## Chief decision

- Package version and edition: v0.4.2 Astra Edition at admission; v0.4.3 after repair.
- Task method: `openai-docs` for the host diagnosis, then `skill-creator` for a
  narrow recovery-rule update; orchestration retains execution and assurance.
- Assurance: S1; installation and routing compatibility, no scientific changes.
- Chief planned capability lane: UI-selected
- Chief planned model: UI-selected
- Chief planned reasoning effort: UI-selected
- Chief runtime model: unknown
- Chief runtime reasoning effort: unknown
- Chief metadata source: unknown
- Execution: direct diagnosis; one Builder owns the installer and its regression tests.
- Worker configured model/effort: Terra / medium, from the named Builder profile;
  runtime-observed model/effort: unknown; no independent runtime receipt available.
- Planned workers: one distinct worker, one initial launch, zero retries;
  ceiling remains two distinct workers. No nested delegation or concurrent writing workers.
- Balanced opportunity: eligible; installer behavior and file ownership are frozen,
  while Chief independently verifies source evidence and recovery boundaries.
- Owned scope: installer, installer tests, host-routing reference and evaluation
  cases, README/version metadata, and this record. Existing unrelated work is preserved.
- Verification: symlink-versus-regular secure-open comparison, safe migration and
  conflict tests, update/idempotency checks, syntax, routing-case review, and privacy scan.
- Stop: accepted bounded checks complete; do not label unrelated live tasks repaired
  without a successful launch and model/effort evidence in those task environments.

## Evidence and execution

- Frozen history showed five Builder launch failures and one Reviewer failure with
  `agent type is currently not available`. Their advertised profiles were present.
  The two Chief contexts were Astra / max; the only successful fallback child was
  explorer / Luna / low. No Spark launch was observed in that window.
- All four installed personal role files were exact repository symlinks. Ordinary
  reads succeeded; an OS open with `O_RDONLY | O_NONBLOCK | O_NOFOLLOW` returned
  `ELOOP` for all four. The four repository-local regular files passed the same open.
- Upstream [role loading and tool description generation](https://github.com/openai/codex/blob/ac192cd7937b0d73edc6dffe009940ae53782dd4/codex-rs/core/src/agent/role.rs)
  use different reads: the display path follows links; the launch path calls
  `read_sensitive_file_to_string` and maps load errors to the observed generic error.
  The [secure reader](https://github.com/openai/codex/blob/ac192cd7937b0d73edc6dffe009940ae53782dd4/codex-rs/exec-server/src/regular_file.rs)
  explicitly rejects a symlink at the final path component.
- This reproduces the underlying file-loading incompatibility without inference
  calls. It is not a new end-to-end launch inside either affected task.
- A read-only app-server configuration probe could not initialize under the
  sandbox's state-store restrictions. It was stopped without escalating access to
  the live state store. No task was started through that probe.
- The available log store did not supply the underlying role-load warning for
  these launches; the upstream call path and local secure-open result are separate
  corroborating evidence, not a recovered historical stack trace.
- Route receipts: combined start, then a material change from direct to one
  Builder / Terra / medium. Named Builder launch accepted in the current repository;
  that alone does not validate personal-role loading in another project.
- Changes: roles now use atomic managed regular copies with a payload checksum;
  exact legacy links migrate, while foreign links, unmanaged files, and changed
  managed payloads stop in preflight. Skills remain linked. Status explicitly
  separates file installation from launch/model validation. Recovery guidance
  preserves model, permission, budget, and consequential-review boundaries.
- Checkpoint: implementation and local deployment complete. Four personal role
  files passed secure reading and TOML comparison against their repository sources.
  No scientific project code was changed or active task interrupted.

## Verification and decision

- Status: compatibility patch implemented and deployed locally; cross-project
  end-to-end routing remains explicitly unverified.
- Checks: 97 installer assertions passed, including secure-open behavior against
  all four installer-produced role files; shell syntax passed; Skill validation
  passed; whitespace and privacy checks passed. Chief inspected actual diffs and
  reviewed the three new failure-path evaluation cases; those are a policy review,
  not three executed model-routing experiments.
- Evidence coverage: all declared installer/static checks and the post-deployment
  secure-open/TOML checks passed. Live launch and effective model/effort evidence
  in each of the two affected task environments remains missing; installation
  evidence does not count toward those two end-to-end checks.
- Actual deployed configuration: Scout Luna/medium, Coder Spark/medium, Builder
  Terra/medium, Reviewer Sol/high. These are file-level configured values only.
- Retry count: zero launch or deployment retries. One review follow-up reused
  the same Builder to connect the regression to real installer outputs and
  distinguish SKIP from PASS; no additional worker was created.
- Worker lifecycle: one distinct Builder completed; final return accepted after
  diff review. Host state reports completed; `host_close=unsupported`. No user
  task was archived and no process closure is claimed.
- Elapsed time: the final implementation/deployment check completed at 10:18 UTC;
  precise per-phase elapsed timing was not captured.
- Next safe action: verify the next authorized bounded worker in each affected
  host environment, recording launch success and configured/observed model and
  effort separately. Do not interrupt ongoing scientific work for a smoke test.
- Cost: unknown; no billing conclusion from token fields or model counts.

## Publication handoff

- The user authorized commit and push of this accepted v0.4.3 patch and is
  independently validating on another machine. Do not interrupt or claim the
  outcome of that validation.
- Publication route: direct Git commands, zero new workers, S1. Chief planned
  capability/model/effort remain UI-selected; runtime model/effort and metadata
  source remain unknown. Existing implementation evidence is unchanged.
- Scope: the eight repair/documentation files in this task. Check remote main
  before publishing; use an ordinary push, never overwrite concurrent work.
- Verification: reuse the 97 accepted installer assertions; check the publication
  diff, whitespace, privacy, and matching local/remote commit identities. Git
  references and the user-visible push receipt establish the publication result.
