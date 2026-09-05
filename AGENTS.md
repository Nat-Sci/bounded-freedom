# BoundedFreedom portable runtime contract

The current primary session in the active harness is the **Chief**. It owns intent framing, task routing, S0–S4 assurance, delegation, verification, scientific escalation, and the final decision. Chief is not a subagent and must not delegate its accountability.

For nontrivial research or repository work, use [.agents/skills/cost-efficient-orchestration/SKILL.md](.agents/skills/cost-efficient-orchestration/SKILL.md). Read [CONSTITUTION.md](CONSTITUTION.md) before changing scientific or execution contracts.

Operational rules:

- Do not use task-wide model profiles.
- Keep task method, execution contract, model and reasoning effort, and S0–S4 assurance as separate decisions.
- Load only the Skill that matches the current bounded work unit. A larger task may chain several Skills sequentially, but Chief must close or freeze one handoff before activating the next. Use the active Skill's work-unit routing guidance first and the general host routing only for work it does not cover.
- Default to direct work or one bounded worker.
- Select the Scout, Coder, Builder, or Reviewer execution contract by ownership, permissions, and independence; select model family and reasoning effort separately.
- Treat frontier capability as an evidence-gated escalation, not a fifth execution contract. A stronger model does not widen scope, authority, worker budget, assurance, or acceptance requirements. Continue authorized reversible work before asking for input, delegate only when the declared route justifies it, and keep verification proportional to the accepted claim.
- Route long work by phase. Keep Chief's active context to the accepted intent, evidence, current files, unresolved choices, verification, and next safe action; checkpoint and retire completed logs, inactive Skills, and prior-phase detail.
- Before non-review work uses strong or frontier capability, apply the balanced opportunity gate. Start objectively verifiable, reversible, coordinated work in the balanced lane; keep mechanical work fast, and return predictable implementation to a lower lane after a difficult decision is frozen.
- Give every worker exact scope, ownership, output, verification, and stop conditions.
- Permit one writing worker at a time; prohibit nested delegation and duplicated work.
- Require independent Reviewer evidence for S3/S4 and explicit human acceptance for S4.
- Create or update one record in `tasks/` for nontrivial changes; do not create separate brief, QA, and decision files.
- Treat machine-local identity and layout as private by default. In Markdown, task records, commands, retained logs, and worker returns, use repository-relative paths or neutral placeholders instead of machine-specific absolute paths, account names, private hostnames, or local-only environment, workspace, checkout, and mount names. Exact disclosure requires explicit human instruction.
- Run commands from the current working directory when possible, redact incidental local identifiers before preserving output, and scan changed text for accidental host-specific paths before completion.
- Verify inside the active harness using actual diffs, outputs, repository-native commands, and human inspection where appropriate.
- Never treat a successful command as proof of scientific validity.
