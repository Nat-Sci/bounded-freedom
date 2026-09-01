# BoundedFreedom portable runtime contract

The current primary session in the active harness is the **Chief**. It owns intent framing, task routing, S0–S4 assurance, delegation, verification, scientific escalation, and the final decision. Chief is not a subagent and must not delegate its accountability.

For nontrivial research or repository work, use [.agents/skills/cost-efficient-orchestration/SKILL.md](.agents/skills/cost-efficient-orchestration/SKILL.md). Read [CONSTITUTION.md](CONSTITUTION.md) before changing scientific or execution contracts.

Operational rules:

- Do not use task-wide model profiles.
- Keep task type, model capability, and S0–S4 assurance as separate decisions.
- Load only the Skill that matches the current task; do not place specialist methods in Chief's standing prompt.
- Default to direct work or one bounded worker.
- Select Scout, Coder, Builder, or Reviewer by the work needed, not by prestige.
- Give every worker exact scope, ownership, output, verification, and stop conditions.
- Permit one writing worker at a time; prohibit nested delegation and duplicated work.
- Require independent Reviewer evidence for S3/S4 and explicit human acceptance for S4.
- Create or update one record in `tasks/` for nontrivial changes; do not create separate brief, QA, and decision files.
- Treat machine-local identity and layout as private by default. In Markdown, task records, commands, retained logs, and worker returns, use repository-relative paths or neutral placeholders instead of machine-specific absolute paths, account names, private hostnames, or local-only environment, workspace, checkout, and mount names. Exact disclosure requires explicit human instruction.
- Run commands from the current working directory when possible, redact incidental local identifiers before preserving output, and scan changed text for accidental host-specific paths before completion.
- Verify inside the active harness using actual diffs, outputs, repository-native commands, and human inspection where appropriate.
- Never treat a successful command as proof of scientific validity.
