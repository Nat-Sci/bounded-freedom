# Host and model routing

This file maps portable execution contracts and capability lanes to current host models. It is a starting policy, not a benchmark result. Re-check model availability, price, tool reliability, and context behavior when a host changes.

An **execution contract** controls scope, permissions, ownership, and independence. A **capability lane** controls model family and reasoning effort. Either can vary without changing the other.

## Routing order

Use a matching Skill's work-unit execution contract and capability lane first, then map them to a host model here. Use the general tables only when no Skill row matches, and escalate only after relevant failure, ambiguity, conflict, or consequence.

The S0–S4 gate may add review; it does not upgrade the executor. A Markdown Skill cannot switch Chief: work directly, delegate under a configured execution contract, or recommend an explicit switch.

## Route by limiting factor

Choose the least costly model that clears the bounded work unit's real limit:

| Limiting factor | Starting capability |
| --- | --- |
| Large volume, clear fields, reversible output | Fast and economical |
| Long context, multi-file coordination, stable synthesis | Balanced general reasoning |
| Ambiguous judgment, conflicting evidence, consequential independent review | Strongest available reasoning |

Escalate only after a lower-cost route shows a relevant failure: missed dependencies, unstable tool use, repeated invalid edits, unresolved evidence conflict, or insufficient judgment. Lower reasoning effort again when the next unit becomes mechanical.

## Execution contract and capability lane

| Execution contract | Fast and economical | Balanced | Strong reasoning |
| --- | --- | --- | --- |
| Scout: read-only discovery | Default for bulk search, inventory, and fixed-field extraction | Long-context mapping or evidence synthesis that remains read-only | Rare: unresolved evidence conflict; judgment still returns to Chief or Reviewer |
| Coder: narrow frozen write | Default for mechanical, reversible edits | Tricky but bounded edits with stable interfaces | Rare: if judgment can change scope, Chief must freeze it first |
| Builder: coordinated write | Rare: small coordination with clear logic | Default for related logic, interfaces, or files | High-ambiguity architecture only when the build boundary is already frozen |
| Reviewer: independent read-only audit | Usually unnecessary; Chief can run routine checks | Ordinary independent implementation or evidence review | Default for consequential, conflicting, or S3/S4 review |

This table is a constraint matrix, not a required team. Most tasks need Chief alone or one cell. Reviewer is separated by independence, not by model prestige.

## Current host mappings

Snapshot: 2026-09-02. Concrete names stay here instead of in the portable Skill.

| Host or provider | Fast bounded work | Coordinated work | Independent high-judgment review |
| --- | --- | --- | --- |
| Codex reference adapter | `gpt-5.6-luna` / medium for Scout or Coder | `gpt-5.6-terra` / medium for Builder | `gpt-5.6-sol` / high for Reviewer |
| Claude Code | `haiku` for bounded Scout or Coder work | `sonnet` for Builder work | `opus` for consequential Reviewer work |
| DeepSeek models | V4 Flash for volume and bounded execution | V4 Pro when coordination or harder reasoning warrants it | V4 Pro with high reasoning; use `max` only after an unresolved consequential conflict |
| Gemini CLI | Current Flash-class model for bounded volume | Current Pro-class model for coordinated work | Strongest available Pro-class model with an independent prompt and evidence set |
| Provider-neutral hosts such as OpenCode, Cursor, Roo Code, Cline, or OpenHands | Select the provider's fast capable model | Select its balanced coding/reasoning model | Select its strongest reliable reasoning model |

For mixed Codex work, the practical starting pattern is Terra / medium Chief, Luna / medium Scout or Coder, Terra / medium Builder, and Sol / high Reviewer. If the main output itself needs unresolved high-ambiguity reasoning, start or switch Chief to Sol explicitly; a Skill cannot do that silently. These defaults are not proof that a model remains the cheapest capable choice.

The current Codex `.toml` profiles package each execution contract with one conservative default model to keep the reference adapter simple. That fixed packaging is an adapter choice, not the meaning of Scout, Coder, Builder, or Reviewer and not a platform requirement. Decoupling those defaults dynamically should follow measured behavior and cost tests rather than a documentation-only change.

## Harness and provider are separate

- A harness owns context discovery, tools, permissions, session state, delegation, and verification surfaces.
- A provider supplies one or more models and API behavior.
- DeepSeek models can run inside Codex, Claude Code, OpenCode, or another compatible host; DeepSeek Harness is also a distinct plugin-based host.
- Changing providers does not change the task method or S0–S4 assurance gate.

Before relying on a new pair, run one bounded read task and one reversible edit with tool calls. Confirm instruction loading, Skill discovery, patch behavior, error reporting, and cost accounting. Do not infer scientific reliability from API compatibility.

## Official capability references

- [Codex Skills and locations](https://learn.chatgpt.com/docs/build-skills)
- [Codex subagents](https://learn.chatgpt.com/docs/agent-configuration/subagents)
- [Claude Code Skills](https://code.claude.com/docs/en/skills)
- [Claude Code subagent model selection](https://code.claude.com/docs/en/sub-agents)
- [DeepSeek Codex integration](https://api-docs.deepseek.com/quick_start/agent_integrations/codex/)
- [DeepSeek Claude Code integration](https://api-docs.deepseek.com/quick_start/agent_integrations/claude_code/)
- [Gemini CLI Agent Skills](https://github.com/google-gemini/gemini-cli/blob/main/docs/cli/using-agent-skills.md)
