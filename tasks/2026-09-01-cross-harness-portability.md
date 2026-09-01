# Task record: cross-harness portability

## Intent

- Objective: Separate BoundedFreedom's portable workflow from host and model details, document the current harness landscape, and make installation usable for Codex, Claude Code, or a portable Skills-only setup.
- Non-goals: Build a new agent runtime, install third-party harnesses, configure provider credentials, duplicate every host's agent files, or create the deferred research Skills.
- Assumptions and uncertainty: Harness features and model catalogs change quickly. Compatibility means that instructions and Skills can be loaded; it does not prove equal tool behavior, cost, or scientific reliability across hosts.

## Chief decision

- Risk: S1. The change affects execution guidance and installation behavior but no scientific result.
- Execution: direct.
- Workers and model rationale: None. One owner keeps the portability boundary and public wording consistent and avoids unnecessary coordination cost.
- Owned scope: `README.md`, portable runtime contracts, the orchestration Skill and references, thin Claude/Gemini project adapters, the host landscape, global installer sources, and `scripts/install-global.sh`.
- Verification: Validate every Skill; check shell syntax; exercise dry-run, install, update, status, conflict, and host-selection paths in isolated temporary roots; inspect the diff and scan public artifacts for machine-local identifiers.
- Stop conditions: Do not add host SDK dependencies, credentials, runtime plugins, or research Skill scaffolds.

## Evidence and execution

- Open [Agent Skills](https://agentskills.io/specification) defines the portable `SKILL.md` core; `.agents/skills` is a cross-client convention rather than a location mandated by the file-format specification.
- [Codex](https://learn.chatgpt.com/docs/build-skills), [Gemini CLI](https://github.com/google-gemini/gemini-cli/blob/main/docs/cli/using-agent-skills.md), [OpenCode](https://v2.opencode.ai/docs/skills/), [OpenHands](https://docs.openhands.dev/overview/skills), [Cursor](https://prod.cursor.com/docs/skills), and [DeepSeek Harness](https://github.com/deepseek-ai/deepseek-harness/blob/master/docs/subsystems/skills.md) document direct or shared `.agents/skills` discovery.
- [Claude Code](https://code.claude.com/docs/en/skills) follows the same open Skill standard, uses `.claude/skills`, and supports directory symlinks. Its `CLAUDE.md` can import `AGENTS.md`.
- [DeepSeek's Responses API](https://api-docs.deepseek.com/guides/responses_api/) and [Codex integration](https://api-docs.deepseek.com/quick_start/agent_integrations/codex/) confirm that current DeepSeek models can be a provider inside Codex. [DeepSeek Harness](https://github.com/deepseek-ai/deepseek-harness) is separately a plugin-based developer-preview harness.
- Changes or artifacts: Portable constitution and runtime contract; host-neutral orchestration Skill; separate model-routing reference; Codex, Claude Code, and Gemini adapters; harness landscape; and a conflict-safe multi-host installer.
- Deviations: None.

## Verification and review

- Checks and comparisons: Skill validation, shell syntax, whitespace checks, and isolated portable, Codex, Claude, and combined-host install paths passed. Dry-run, install, update, status, unsupported-host, and user-owned configuration conflict behavior were exercised.
- Privacy and portability check: Public changed text was scanned for machine-local paths and private identifiers. Installer output uses semantic labels and preserves conflicting user files.
- Reviewer verdict when required: Not required for S1.
- Human acceptance when required: Not required for S1.

## Decision

- Outcome: The BoundedFreedom core is host-neutral. Codex remains the configured reference implementation; compatible hosts can load the canonical open Skills directly, while Claude Code uses safe links and a thin instruction adapter.
- Alternatives rejected: A Codex-only constitution; copied Skills per host; one permanent task-wide model profile; a new custom runtime; installing every research or agent framework as a dependency.
- Remaining uncertainty: Real cost and quality mappings must be calibrated through bounded host/model trials. DeepSeek Harness is in developer preview, and host-specific adapters beyond Codex and Claude remain documentation-level until actual use justifies configuration files.
