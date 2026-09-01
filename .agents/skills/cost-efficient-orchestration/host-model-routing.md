# Host and model routing

This file maps the portable role contracts to current host capabilities. It is a starting policy, not a benchmark result. Re-check model availability, price, tool reliability, and context behavior when a host changes.

## Route by limiting factor

Choose the least costly model that clears the bounded work unit's real limit:

| Limiting factor | Starting capability |
| --- | --- |
| Large volume, clear fields, reversible output | Fast and economical |
| Long context, multi-file coordination, stable synthesis | Balanced general reasoning |
| Ambiguous judgment, conflicting evidence, consequential independent review | Strongest available reasoning |

Escalate only after a lower-cost route shows a relevant failure: missed dependencies, unstable tool use, repeated invalid edits, unresolved evidence conflict, or insufficient judgment. Lower reasoning effort again when the next unit becomes mechanical.

## Current host mappings

Snapshot: 2026-09-01. Concrete names stay here instead of in the portable Skill.

| Host or provider | Fast bounded work | Coordinated work | Independent high-judgment review |
| --- | --- | --- | --- |
| Codex reference adapter | Luna / medium for Scout or Coder | Terra / medium for Builder | Sol / high for Reviewer |
| Claude Code | `haiku` for bounded Scout or Coder work | `sonnet` for Builder work | `opus` for consequential Reviewer work |
| DeepSeek models | V4 Flash for volume and bounded execution | V4 Pro when coordination or harder reasoning warrants it | V4 Pro with high reasoning; use `max` only after an unresolved consequential conflict |
| Gemini CLI | Current Flash-class model for bounded volume | Current Pro-class model for coordinated work | Strongest available Pro-class model with an independent prompt and evidence set |
| Provider-neutral hosts such as OpenCode, Cursor, Roo Code, Cline, or OpenHands | Select the provider's fast capable model | Select its balanced coding/reasoning model | Select its strongest reliable reasoning model |

The Chief session is not required to use the same model as a worker. Role files are defaults, not proof that a model remains the cheapest capable choice.

## Harness and provider are separate

- A harness owns context discovery, tools, permissions, session state, delegation, and verification surfaces.
- A provider supplies one or more models and API behavior.
- DeepSeek models can run inside Codex, Claude Code, OpenCode, or another compatible host; DeepSeek Harness is also a distinct plugin-based host.
- Changing providers does not change the task type or S0–S4 assurance gate.

Before relying on a new pair, run one bounded read task and one reversible edit with tool calls. Confirm instruction loading, Skill discovery, patch behavior, error reporting, and cost accounting. Do not infer scientific reliability from API compatibility.

## Official capability references

- [Codex Skills and locations](https://learn.chatgpt.com/docs/build-skills)
- [Codex subagents](https://learn.chatgpt.com/docs/agent-configuration/subagents)
- [Claude Code Skills](https://code.claude.com/docs/en/skills)
- [Claude Code subagent model selection](https://code.claude.com/docs/en/sub-agents)
- [DeepSeek Codex integration](https://api-docs.deepseek.com/quick_start/agent_integrations/codex/)
- [DeepSeek Claude Code integration](https://api-docs.deepseek.com/quick_start/agent_integrations/claude_code/)
- [Gemini CLI Agent Skills](https://github.com/google-gemini/gemini-cli/blob/main/docs/cli/using-agent-skills.md)
