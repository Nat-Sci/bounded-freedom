# Task record: local deployment and routing smoke audit

## Intent and boundary

- Objective: update one anonymous host to the current `main`, deploy the Codex adapter, and determine whether the installed dispatcher has observable method, role, model, or lifecycle routing defects.
- Non-goals: change scientific methods, redesign the dispatcher, claim model-quality or token savings, delete historical task state, or publish a new release.
- Accepted source: repository commit `28e3d4c`, package v0.4.2.
- Assurance: S2. The installation changes future execution routing; no project data or scientific result was changed. Configuration/source equality, isolated regression tests, and a fresh planning-only route are the acceptance evidence.

## Chief decision and route

- Task method: General deployment audit using `cost-efficient-orchestration`; official Codex setup behavior checked with `openai-docs`.
- Execution: direct Chief work; zero workers, zero spawn attempts, and no independent Reviewer requirement.
- Chief planned capability lane: balanced.
- Chief planned model: inherited.
- Chief planned reasoning effort: inherited.
- Chief runtime model: unknown.
- Chief runtime reasoning effort: unknown.
- Chief metadata source: inherited; the active backend pair is not exposed authoritatively.
- Scope: repository synchronization, installer and adapter state, top-level Skill triggers, execution-role profiles, host model mapping, one planning-only route, and connectivity needed by that route.
- Stop conditions: user-owned configuration conflict, unsafe link replacement, scientific-contract change, ambiguous external mutation, or a request to delete local history.

## Deployment evidence

- `main` fast-forwarded by ten remote commits to `28e3d4c`; existing untracked publicity assets and drafts were preserved.
- The initial real-host status showed no portable Skill links, no Codex role links, and no managed Codex instruction or configuration blocks.
- Installer regression suite: 75/75 passed. Repository activity suite: 38/38 passed. Eight discoverable Skill entrypoints have valid name and description fields.
- The Codex deployment linked eight portable Skills and four fixed role profiles, refreshed the managed global instructions and agent configuration, and left user-owned content intact.
- Real-host verification found 8/8 Skill links and 4/4 role links. The two managed blocks match their repository sources byte-for-byte; the managed proxy file has owner-only permissions.
- Codex CLI v0.153.4 loaded the configuration successfully with multi-agent support enabled. Official documentation confirms the installed user Skill location, symlink support, agent defaults, and concurrency setting names.
- The first fresh planning-only request encountered five WebSocket sampling timeouts before HTTPS fallback. `codex doctor` confirmed the transport failure. A dry-run found a valid system HTTP(S) proxy with no user-owned proxy conflict; the installer then added its reversible managed proxy block. A new doctor run passed the WebSocket handshake with HTTP 101. Desktop update/runtime CDN reachability remains unavailable and is separate from request routing.
- Retry accounting: one read-only managed-block comparison was rejected by host command policy before execution; one hash-based read-only retry passed. The fresh Codex process performed five internal safe sampling retries before HTTPS fallback. No mutating operation was retried.

## Routing findings

### Accepted

- One dispatcher, one active method per bounded work unit, four execution contracts, independent model/effort selection, and S0-S4 assurance remain conceptually separate across the entry Skill, coordination guide, README, and host profiles.
- The six research methods and the single discoverable mathematical entry have explicit ownership and overlap rules. Mathematical leaf modules are references rather than competing Skills.
- The fresh data-quality case exposed one `scientific-data-quality` catalog entry, selected that method, selected no second method, and did not delegate or mutate state. No duplicate same-source Skill was observed on this host.
- Fixed Codex profiles match the documented economical routes: Luna Scout, Spark Coder, Terra Builder, and Sol Reviewer. The two-worker concurrency ceiling and no-nesting depth are installed.

### Problems and gaps

1. **Route-receipt conformance is not reliable in the fast lane.** The fresh Luna/low response selected the correct method but wrote the method name into `Chief planned capability lane`, left explicitly configured model and effort as `unknown`, and used an undeclared metadata-source value. The host printed the launch configuration outside the response, but the model did not receive or use it as authoritative metadata. Method routing passed; execution telemetry failed its schema.
2. **Two documented model routes lack a fixed permission-preserving profile.** Balanced read-only synthesis calls for a Terra Scout contract, while frontier implementation permits an Astra Builder. The installed named Scout is fixed to Luna/read-only and Builder to Terra/workspace-write. The documentation says to use a supported unpinned route or report it unsupported, but the adapter does not define or verify such a route. A prompt-only read-only promise is not an enforced sandbox.
3. **`--status` cannot detect stale copied blocks.** Skill and role links follow repository updates, but global instruction and configuration blocks are copied. Status currently checks marker validity and presence, not content hash or installed package version. After a future pull it can report “managed block present” while the dispatcher instructions or defaults are older than the linked Skills.
4. **Operational state is large but not proven to be a routing defect.** Doctor reported 116 active rollout files using about 3.13 GB. State and database consistency passed; no deletion or performance claim is authorized from this snapshot.

The planning-only request reported 10,552 total tokens. That number includes host, catalog, project, and prompt context and is not attributable to BoundedFreedom alone; no cost-saving claim follows from one run.

## Decision and next safe action

- Deployment is accepted for a newly started Codex task. The WebSocket issue is repaired for the current system-proxy state.
- Core method selection and Skill cooperation passed the bounded smoke test. The repository still has two material adapter gaps and one status-observability gap; these should be fixed before calling dynamic model routing fully implemented.
- Smallest follow-up: add a machine-checkable route-receipt schema/example, define an honest fallback for unsupported unpinned routes without adding a standing role hierarchy, and make `--status` compare managed block content or a persisted installed version. Re-run only the affected routing and installer cases after those changes.

## Paired v0.4.3 role-loading regression

### Scope and remote change

- This follow-up is S1 and compares the same fresh, read-only named-Builder task before and after one fast-forward pull. It does not alter scientific data or claims.
- Old baseline: commit `28e3d4c`, package v0.4.2. Remote target: commit `21ce979`, package v0.4.3. The pull was a one-commit fast-forward; no incoming path collided with preserved untracked work.
- The remote patch addresses Codex named-role loading: user-level role TOMLs change from repository symlinks to checksum-marked, owner-readable managed regular files. It also adds safe migration, conflict protection, drift checks for role payloads, and explicit separation of file installation from live launch/model validation.

### Before pull

- All four user-level Codex role TOMLs were repository symlinks.
- A named Builder smoke task inside this source repository passed because the project-level regular role file took precedence. It therefore did not test the faulty user-level installation and is not accepted as cross-project evidence.
- The identical task in a neutral directory with no project-level role file failed. Codex logged a symlink secure-read error (`os error 62`) and returned `agent type is currently not available`. No fallback role was allowed or launched.
- The old installer also reproduced the separate status gap: after changing text inside an otherwise valid managed instruction block in an isolated target, `--status` still reported `managed block present`.

### Pull, deployment, and after-pull evidence

- The updated installer passed all 97 assertions before deployment. The checks cover exact-link migration, managed regular-role creation, safe-open behavior, conflict atomicity, role-payload drift, idempotency, proxy handling, and managed-block preservation.
- Deployment migrated Scout, Coder, Builder, and Reviewer to owner-only managed regular files. Each installed payload matches its repository source after removing the two installer metadata lines; `--status` reports all four as `managed regular file (current)`.
- The same fresh named-Builder command, with the same parent model, effort, sandbox, prompt, and neutral working directory, then returned `LAUNCH_PASS`. This accepts the role-loading fix on this host.
- Builder remains configured as Terra / medium at file level. The smoke run provides launch and exact-return evidence but no authoritative child runtime model/effort receipt, so runtime pair matching remains unknown.
- The accepted old cross-project failure used 11,728 reported tokens; the accepted post-update success used 22,379. A successful child necessarily did more work than a launch rejected before execution, so this pair measures compatibility, not cost efficiency. The source-repository control run used 49,558 and is another reason not to use full child launches as routine status checks.

### Remaining boundaries

- The same planning-only data-quality task improved from an invalid method-name capability lane to `balanced`, while still choosing the correct Skill and no second method. Because the v0.4.3 diff did not change the core route-receipt instruction, this one-sample response difference is not attributed to the patch.
- Route metadata remains incomplete: explicit CLI model/effort were still reported as `unknown`, and `none supplied; runtime not inferred` is outside the declared metadata-source vocabulary. The returned Scout contract with zero workers/direct planning is also ambiguous.
- v0.4.3 detects a modified managed role payload, but it still does not compare copied `AGENTS.md` or `config.toml` block contents with their sources. The isolated instruction-block sentinel continued to report `managed block present`.
- Fresh CLI runs also emitted unrelated skill-icon, rollout-state, model-refresh, or hook-path warnings. They did not block this bounded launch test and are not claimed fixed here.

### Decision

- **Resolved on this host:** the remote named-role file-loading incompatibility. The before/after cross-project task changed from the exact launch failure to an exact successful Builder return after migration to regular files.
- **Not yet verified:** authoritative child runtime model/effort matching and behavior on the other machine.
- **Not resolved by this commit:** copied managed-block drift detection and fully conformant route-receipt metadata.
- No commit or push was requested for this local audit record. The repository is aligned with `origin/main`; preserved untracked work remains untouched.

## Coder and fast-code routing follow-up

### Pre-change evidence

- The v0.4.3 installation uses an owner-only managed regular Coder file whose payload matches the repository profile and configures Codex-Spark / medium. A fresh cross-project named-Coder smoke task returned `CODER_LAUNCH_PASS`; role loading therefore works, while the child runtime model remains unobserved.
- A realistic isolated code task was then run without forcing a role: a Sol / high Chief received one frozen implementation file, immutable failing tests, and a known test command. Chief kept the task direct, changed the implementation, and passed 3/3 tests. Its stated reason was that one clear file and no concurrent Chief work made delegation unnecessary.
- This locates the reported symptom in policy rather than installation. The general direct-work rule overrode the documented Spark edit-test route, and the balanced-worker concurrency requirement was implicitly applied to fast-code work.

### Accepted change boundary

- Keep deterministic commands and obvious micro-edits direct.
- Add one fast-code gate: when interface, checks, and narrow ownership are frozen and no unresolved scientific or architectural decision remains, a separable edit-test loop leaves a strong/frontier Chief for named Coder. Context retirement is sufficient value; concurrent Chief work is not required.
- Keep Builder/Terra for coupled interfaces, migrations, or coordinated responsibilities. Do not route work to Spark merely because the request mentions code, and do not claim runtime model identity from configuration alone.
- Update only the orchestration entry, host and hierarchical routing references, global/project instructions, one routing-eval case, concise README wording, version metadata, and this record. Verify with the same isolated code task after installation plus repository-native checks.

### Installation design clarification

- Skill directories remain repository symlinks. Codex officially supports linked Skill directories, and this gives immediate source updates without copying each Skill.
- Codex role TOMLs are different: the secure launch reader rejects a symlink at the final file component. On update, the installer accepts only an exact legacy link to this repository, creates a private temporary regular file containing a management marker, payload checksum, and source payload, then atomically replaces that link. Foreign links, unmanaged files, and modified managed payloads stop in preflight rather than being overwritten.
- The resulting role files are owner-only regular files. Their checksum allows safe source refresh and local-modification detection. Copied global instruction/config blocks remain a separate mechanism and still need content-drift detection.

### Post-change evidence and decision

- The local package is now v0.4.4. Skill validation passed and all 97 installer assertions passed before deployment; installed role status remained current and the managed global instruction block was refreshed.
- The same isolated fixture was restored to the same three failing tests and run again with the same Sol / high Chief, sandbox, scope, and prompt. This time Chief selected one named Coder, cited the installed Codex-Spark / medium profile, and the completed implementation passed 3/3 tests under Chief verification.
- The first shared-history launch in the ephemeral test process was rejected with `no thread with id` before a child existed. One compact-fresh launch of the same profile then succeeded. This is a test-harness lifecycle warning, not a Coder-role fallback or evidence that ordinary persisted sessions require the same retry.
- The before task reported 32,988 total tokens; the after task reported 38,586. Those aggregate counts mix Chief and child context and do not provide authoritative billed cost or per-model attribution. The change proves automatic Coder activation, not Token savings. Keep obvious micro-edits direct and calibrate the fast-code gate on accepted real tasks before making a savings claim.
- Configured Coder identity is Spark / medium; runtime-observed child model and effort remain unknown without an authoritative receipt. The routing objective is accepted, while runtime attribution and cost efficiency remain open measurements.
- Verification accounting: one final read-only summary command was accidentally launched from the disposable fixture rather than the repository root, so repository-relative checks were unavailable there. One safe root-corrected retry passed Skill validation, whitespace and privacy checks, installed-state inspection, and routing-text presence. No mutation was retried.
- The user subsequently authorized one v0.4.4 commit and an ordinary push to `main`. The publication scope is limited to the routing, version, concise documentation, and this audit record; pre-existing untracked publicity work remains outside the change.
