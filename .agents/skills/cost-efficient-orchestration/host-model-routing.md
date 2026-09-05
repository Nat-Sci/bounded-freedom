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
| Ambiguous judgment, conflicting evidence, consequential independent review | Strong reasoning |
| Hardest end-to-end work across tools or domains, or a documented strong-lane shortfall | Frontier escalation |

Escalate only after a lower-cost route shows a relevant failure: missed dependencies, unstable tool use, repeated invalid edits, unresolved evidence conflict, or insufficient judgment. Lower reasoning effort again when the next unit becomes mechanical.

## Execution contract and capability lane

| Execution contract | Fast and economical | Balanced | Strong reasoning | Frontier escalation |
| --- | --- | --- | --- | --- |
| Scout: read-only discovery | Default for bulk search, inventory, and fixed-field extraction | Long-context mapping or evidence synthesis that remains read-only | Rare: unresolved evidence conflict; judgment still returns to Chief or Reviewer | Do not use for volume alone; Chief must identify an exceptional cross-domain discovery limit |
| Coder: narrow frozen write | Default for mechanical, reversible edits | Tricky but bounded edits with stable interfaces | Rare: if judgment can change scope, Chief must freeze it first | Not a normal Coder route; reframe as Chief or Builder work before escalating |
| Builder: coordinated write | Rare: small coordination with clear logic | Default for related logic, interfaces, or files | High-ambiguity architecture only when the build boundary is already frozen | Hardest multi-system implementation when end-to-end coherence is the demonstrated limit |
| Reviewer: independent read-only audit | Usually unnecessary; Chief can run routine checks | Ordinary independent implementation or evidence review | Default for consequential, conflicting, or S3/S4 review | Material conflict or uncertainty that remains after a capable independent strong review |

This table is a constraint matrix, not a required team. Most tasks need Chief alone or one cell. Reviewer is separated by independence, not by model prestige.

## Current host mappings

Snapshot: 2026-09-05. Concrete names stay here instead of in the portable Skill.

| Host or provider | Fast bounded work | Coordinated work | Strong judgment or review | Frontier escalation |
| --- | --- | --- | --- | --- |
| Codex reference adapter | `gpt-5.6-luna` / medium for Scout or Coder | `gpt-5.6-terra` / medium for Builder | `gpt-5.6-sol` / high for Reviewer or ambiguous Chief work | `gpt-6-astra` / medium for the hardest end-to-end Chief or Builder work, or unresolved independent review; raise effort only with evidence |
| Claude Code | `haiku` for bounded Scout or Coder work | `sonnet` for Builder work | `opus` for consequential Reviewer work | Use a newer frontier tier only after verifying its host behavior and cost |
| DeepSeek models | V4 Flash for volume and bounded execution | V4 Pro when coordination or harder reasoning warrants it | V4 Pro with high reasoning; use `max` only after an unresolved consequential conflict | No separate mapped tier until a distinct model and measured need exist |
| Gemini CLI | Current Flash-class model for bounded volume | Current Pro-class model for coordinated work | Strongest reliable Pro-class model with an independent prompt and evidence set | Use a distinct frontier tier only after host verification and a documented lower-lane limit |
| Provider-neutral hosts such as OpenCode, Cursor, Roo Code, Cline, or OpenHands | Select the provider's fast capable model | Select its balanced coding/reasoning model | Select its strong reliable reasoning model | Select a distinct frontier model only when the provider offers one and the escalation gate is met |

For mixed Codex work, the practical starting pattern remains Terra / medium Chief, Luna / medium Scout or Coder, Terra / medium Builder, and Sol / high Reviewer. Start or switch Chief to Sol when the main output needs unresolved high-ambiguity reasoning. Select Astra explicitly when the task is among the hardest end-to-end workflows across code, browsing, computer use, research, or documents, or when Sol has exposed a material shortfall. A Skill cannot switch Chief silently. These defaults are not proof that a model remains the cheapest capable choice.

## Terra opportunity gate

The Codex adapter keeps the untyped subagent fallback on Luna / low, maps bounded coordinated Builder work to Terra / medium, and reserves Sol / high for independent review or unresolved judgment. Increasing Terra use means moving eligible work down from Sol or Astra, not moving mechanical work up from Luna.

Before selecting Sol or Astra for non-review execution, start with Terra / medium when the unit is reversible, its interfaces or evidence boundary are stable, acceptance is objectively checkable, and a failure will be visible before consequential use. Examples include a coordinated change across related files, stable synthesis from a frozen evidence set, implementation of a frozen architecture, and the first bounded repair of a verifiable workflow.

Do not select Terra merely to satisfy a global model-share target. For a new or materially changed adapter, use a declared calibration window instead: the default pilot is 30 eligible balanced units, with at least 20 starting on Terra unless route evidence excludes them. Record exclusions, first-pass acceptance, rework, escalation, elapsed time, evidence coverage, and authoritative quota or billing data when available. Promote the route only from accepted outcomes; never estimate cost from incomplete token fields.

## GPT-6 Astra boundary

Astra is a frontier capability lane, not a fifth execution contract and not a replacement for the Luna, Terra, and Sol cost ladder. Selecting it does not widen scope, authority, worker budget, assurance, or acceptance requirements. When Astra is selected, use it as a thin control phase for the hard dependency or judgment boundary, then route stable downstream work back to the least costly capable lane.

- Start at medium effort. Raise to high, xhigh, or max only when the task's ambiguity, failed evidence, or consequence justifies the additional reasoning. The Codex host may expose `ultra` as an automatic-delegation mode; do not use it unless the declared worker budget and user intent explicitly allow that behavior.
- Keep fixed-field extraction and narrow reversible edits on Luna, coordinated implementation on Terra, and ordinary high-judgment or independent review on Sol while those lanes remain capable.
- Do not route to Astra merely because the context is long, the task is S3/S4, or Astra is newer. An S3/S4 gate adds independent evidence and human acceptance where required; it does not select a model.
- Give Astra a compact phase packet: intent and non-goals, accepted evidence, unresolved dependencies, the active project and Skill rules, expected output, and stop condition. Keep raw discovery, completed logs, and inactive Skill bodies outside the standing context.
- Require an exit decision. Once Astra freezes an architecture, evidence boundary, or cross-tool plan, send predictable implementation to Terra and mechanical follow-up to Luna; retain Sol for independent review when assurance requires it.
- Astra may ask for clarification earlier, delegate less often, and test more broadly. Continue authorized reversible work, state the exact delegation budget, and keep verification proportional to the accepted claim.
- Where the host supports changing reasoning without rebuilding the prompt prefix, lower effort after the difficult phase. Otherwise create a compact checkpoint and continue the next work unit through the appropriate lower lane.

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
- [GPT-6 Astra model](https://developers.openai.com/api/docs/models/gpt-6-astra)
- [GPT-6 Astra migration and prompting guidance](https://developers.openai.com/api/docs/guides/latest-model)
- [Claude Code Skills](https://code.claude.com/docs/en/skills)
- [Claude Code subagent model selection](https://code.claude.com/docs/en/sub-agents)
- [DeepSeek Codex integration](https://api-docs.deepseek.com/quick_start/agent_integrations/codex/)
- [DeepSeek Claude Code integration](https://api-docs.deepseek.com/quick_start/agent_integrations/claude_code/)
- [Gemini CLI Agent Skills](https://github.com/google-gemini/gemini-cli/blob/main/docs/cli/using-agent-skills.md)
