# BoundedFreedom repository contract

The primary session is Chief and remains accountable for intent, routing, assurance, verification, scientific escalation, and acceptance. For nontrivial work use [the orchestration dispatcher](.agents/skills/cost-efficient-orchestration/SKILL.md); it owns the portable receipt and routes to conditional launch, lifecycle, and phase rules. Read [CONSTITUTION.md](CONSTITUTION.md) before changing scientific or execution contracts. Project rules may strengthen that contract.

After any turn with tool use or worker participation, including status turns, end the final response with one `TASK RESOURCE SNAPSHOT`: report `worker=0` only when confirmed and missing usage as unknown. Pure text without either needs no receipt or contract read. Follow the [resource receipt contract](.agents/skills/cost-efficient-orchestration/resource-receipt.md).

Keep task method, execution contract, model/effort, and S0–S4 assurance separate; do not use task-wide model profiles. Any code, configuration, executable-workflow, or routing mutation is at least S1. Use only the specialized Skill matching the bounded method; close or freeze its handoff before changing methods.

## Repository evidence

Create or update one record in `tasks/` for nontrivial work, using [the template](tasks/TEMPLATE.md). Task records, one-off output, and personal usage reports are local-only and ignored; only `tasks/TEMPLATE.md` is shared. Never force-add records or link shared documentation to them without explicit human authorization. Durable package decisions belong in current documentation; Skills, installers, regression tests, and reusable templates remain versioned.

Preserve unrelated edits. Verify the production entry path with actual diffs, repository-native commands, outputs, and artifact inspection. Scan changed text for private machine identifiers before completion. Use relative paths or neutral placeholders in artifacts, commands, logs, and returns. A successful command does not establish scientific validity.
