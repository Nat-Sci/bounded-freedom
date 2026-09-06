# Task record: Spark routing and Codex network setup

## Intent

- Objective: Keep the two-worker ceiling, route eligible narrow code work through Codex-Spark, and make the locally verified system-proxy fix available as a safe installation option.
- Non-goals: Do not raise the worker budget, force model usage to consume a quota, make Spark a general-purpose worker, silently change provider identity, enable TUN mode, store a machine-specific proxy address in the repository, or overwrite user-owned configuration.
- Assumptions and uncertainty: Codex-Spark availability depends on the signed-in plan and current product rollout. A system proxy can become unavailable, so importing it must be explicit and reversible rather than a package default.

## Chief decision

- Package version and edition: BoundedFreedom v0.3.0, Astra Edition.
- Task method: `skill-creator`, with `openai-docs` supplying current product evidence and `cost-efficient-orchestration` retaining routing and assurance.
- Assurance: S1 because host routing and user-scope installation behavior change, while scientific methods and accepted research outputs remain unchanged.
- Current phase and active context slice: Final verification and publication; accepted official model and subagent documentation, the cited reconnecting article, redacted A/B results, the verified diff, installation status, and publication state. Raw diagnostics and command output are retired.
- Execution contract: Direct.
- Planned route: Chief direct for one coordinated contract change; no delegated capability lane.
- Actual route: Chief direct; no escalation or delegated lane.
- Balanced opportunity: Not applicable because the current Chief owns one tightly coupled policy and installer change and no worker is needed.
- Planned workers: 0 distinct workers, 0 initial spawn attempts, and 0 retry allowance. The installed ceiling and default total task budget remain 2.
- Actual workers: 0 distinct workers, 0 spawn attempts, 0 retries, and no worker lifecycle states.
- Worker-budget rationale: A second writing context would add coordination risk without reducing the bounded implementation cost.
- Owned scope: Version, orchestration routing and evaluations, Codex Coder profile and defaults, installer proxy option and tests, public coordination and compatibility documentation, and this task record.
- Verification: Confirm official Spark and subagent support; run one minimal Spark request; compare WebSocket diagnostics without and with the active system proxy; validate every Skill; run shell syntax and installer regressions; resolve repository-local Markdown links; inspect the diff; scan changed text for local identifiers; deploy the managed adapter; and verify the installed state and a fresh WebSocket diagnostic.
- Stop conditions: Preserve at most two workers and one writer; do not embed proxy endpoints, credentials, private paths, prompts, or raw logs; do not select the HTTP-only provider as a default; stop rather than overwrite an unmanaged proxy configuration.

## Evidence and execution

- Relevant evidence: Official OpenAI documentation describes Codex-Spark as a separate, lower-capability, near-real-time coding model with its own usage limits and shows it in custom agent profiles at medium effort. Official configuration documentation exposes custom-provider WebSocket support. The cited community article proposes proxy environment variables first and an HTTP-only provider second. Current aggregate diagnostics showed HTTPS reachable, no proxy variables, an active system proxy, and a 15-second WebSocket handshake timeout.
- Changes or artifacts: Released the Spark-backed Coder route while retaining Luna for general fast work, Terra for coordinated implementation, Sol for review and unresolved judgment, and Astra for evidence-gated frontier work. Added positive and boundary routing evaluations, v0.3.0 documentation, and an explicit `--codex-proxy system|remove` installer flow that detects the active macOS HTTP(S) proxy, preserves or refuses user-owned `.env` state, never prints the endpoint, writes a private managed block, and leaves the default installation unchanged.
- Checkpoint: Sources and managed local adapters match. A temporary process-level proxy A/B changed the WebSocket check from a 15-second timeout to success in about two seconds. A minimal HTTP-only request returned the exact expected Spark result without reconnect events, but that provider route remains deliberately uninstalled. The managed proxy import is deployed; fresh processes reported the three managed proxy variables and completed WebSocket handshakes in about 1.9–2.6 seconds. The next safe action is a final remote divergence check, commit, and authorized push.
- Retries: One route-evaluation command used a global CLI flag in the wrong position and exited before inference or mutation. After correction, a piped read-only evaluation returned no retained result; process state showed no orphan, and one shorter read-only retry succeeded. The repository activity check initially found no Node executable on the shell path; the bundled runtime was resolved and the check passed. No mutation or model task was duplicated ambiguously.
- Elapsed time: Approximately 30 minutes through implementation, validation, and local deployment.
- Cost or quota evidence: Official documentation and the authoritative signed-in usage surface confirm separate Spark short and weekly windows. Personal percentages and reset identifiers are not retained in the repository, and no cost is inferred from local token fields.
- Deviations: The planned retry allowance was zero; one read-only routing evaluation retry was required after an observable empty result, with no side effects to duplicate.

## Verification and review

- Checks and comparisons: Official Spark, custom-agent, model-effort, concurrency, and provider configuration pages were fetched; one minimal Spark request passed; WebSocket diagnostics passed with both a temporary process proxy and the installed `.env`; the routing evaluation selected Coder / Spark for a frozen one-file fix and Scout / Luna for non-code bulk extraction; all seven Skills passed structural validation; 51 isolated installer regressions and 20 repository-activity checks passed; 23 repository-local Markdown targets resolved; shell syntax, diff whitespace, installed links, version reporting, the two-worker ceiling, managed-block status, Coder source identity, and owner-only `.env` permissions passed.
- Evidence coverage: 12 of 12 declared checks passed: official evidence, baseline diagnosis, temporary proxy A/B, HTTP-only fallback probe, Spark route behavior, Skill validation, installer regression, unrelated repository regression, Markdown resolution, diff and privacy scan, local deployment identity, and fresh-process WebSocket verification.
- Route evidence: Chief completed the change directly with no worker, no model escalation, and no worker lifecycle leftovers. The behavior evaluation preserved task-shaped routing instead of optimizing model counts: eligible narrow code selected Spark, while non-code volume remained on Luna.
- Privacy and portability check: Changed repository text contains no machine-specific absolute path, account name, private hostname, local proxy endpoint, file URI, credential, prompt body, raw diagnostic log, or raw usage record. Proxy values exist only in the private local managed `.env` block.
- Reviewer verdict when required: Not required for S1.
- Human acceptance when required: Not required for S1.

## Decision

- Outcome: Complete and ready for the authorized commit and push. BoundedFreedom v0.3.0 keeps the two-worker ceiling, routes eligible Coder work through Spark, and deploys the reversible system-proxy repair locally.
- Alternatives rejected: Raising worker concurrency would not improve this model route; making Spark the untyped default would misroute non-code work; automatically importing a proxy on every installation could leave stale machine state; making the HTTP-only provider the default would change provider identity; TUN mode is too broad for a repository installer; creating work to consume Spark allowance would optimize counts rather than accepted outcomes.
- Remaining uncertainty: The already-running desktop process still requires a restart to inherit the new `.env`. A future Codex version may change `.env` loading or transport behavior, and the optional desktop asset CDN remained unreachable during diagnostics even though inference HTTPS and the Responses WebSocket were usable.
