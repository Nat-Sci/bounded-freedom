# Harness landscape and integration boundary

Snapshot: 2026-09-01. This is a bounded catalog of the current mainstream and research-relevant systems, not a claim that every agent wrapper should become a BoundedFreedom dependency.

## Keep three objects separate

| Object | Owns | Examples |
| --- | --- | --- |
| Coding harness | Context, tools, permissions, sessions, file changes, and delegation | Codex, Claude Code, DeepSeek Harness, Gemini CLI, OpenCode |
| Agent framework or SDK | APIs for building a new application-level agent runtime | OpenAI Agents SDK, Claude Agent SDK, LangGraph, AutoGen |
| Model provider | Models, prices, context limits, and API behavior | OpenAI, Anthropic, DeepSeek, Google, local providers |

A model does not supply the working environment by itself. DeepSeek is a model provider and now also maintains a separate open-source DeepSeek Harness. The two uses should not be confused.

## Coding harnesses

| Harness | Useful control surfaces | BoundedFreedom fit |
| --- | --- | --- |
| [Codex](https://learn.chatgpt.com/docs/build-skills) | Layered `AGENTS.md`, open Agent Skills under `.agents/skills`, configurable subagents, permissions, worktrees, review, and a Responses-based provider seam | Reference adapter. `.codex/agents` packages execution-contract profiles with current default model bindings; the portable core does not equate those contracts with model names |
| [Claude Code](https://code.claude.com/docs/en/skills) | `CLAUDE.md`, open Agent Skills with Claude-only extensions, custom subagents, hooks, permissions, MCP, worktree isolation, and model aliases | Compatible through `CLAUDE.md` plus a safe Skill link into `.claude/skills`; keep Claude-only frontmatter out of the canonical Skill |
| [DeepSeek Harness](https://github.com/deepseek-ai/deepseek-harness) | Plugin-based agent loop, scoped tools and prompts, append-only session events, subagents, SDKs, and an optional Skill registry that scans `.agents/skills` | Strong architectural match but still developer preview. Treat its plugin composition as an experimental adapter, not the default runtime |
| [Gemini CLI](https://github.com/google-gemini/gemini-cli/blob/main/docs/cli/using-agent-skills.md) | Hierarchical `GEMINI.md`, `.agents/skills` alias, Skills consent, hooks, policies, checkpoints, and preview subagents | Portable Skill works directly; root `GEMINI.md` imports the shared contract |
| [OpenCode](https://v2.opencode.ai/docs/skills/) | `AGENTS.md`, `.agents/skills`, multi-provider models, per-agent permissions, custom agents, references, and commands | Direct fit for the portable contract and Skill; execution-contract/model files remain an optional OpenCode adapter |
| [OpenHands](https://docs.openhands.dev/overview/skills) | `AGENTS.md`, Agent Skills, sandboxed software-agent runtime, SDK, event streams, and file-based agents | Direct fit for the core; use its runtime only when isolated execution or a programmatic service is required |
| [Roo Code](https://github.com/RooCodeInc/Roo-Code/blob/main/apps/docs/docs/features/custom-instructions.md) | `AGENTS.md`, Agent Skills, permission-limited modes, sticky model choices, and Orchestrator/Boomerang subtasks | Core rules can travel; do not copy Roo's many modes into Chief. Use one bounded subtask only when it saves context |
| [Cline](https://github.com/cline/skills) | Multi-provider coding, rules, Agent Skills, tools, and SDK surfaces | Same Skill format, but native locations and team features vary by release; use a link or host installer rather than a duplicate Skill |
| [Cursor](https://prod.cursor.com/docs/skills) | Project rules, editor-native agents, direct `.agents/skills` discovery, model selection, and review UI | Portable Skill works directly. Keep any Cursor rules as a thin pointer to the shared contract rather than another source of truth |
| [GitHub Copilot CLI](https://api-docs.deepseek.com/quick_start/agent_integrations/copilot_cli/) | Terminal agent mode, Skills, MCP, and BYOK model providers | Useful provider-neutral host. Compatibility must be tested for the chosen provider and reasoning format |
| [Aider](https://aider.chat/docs/repomap.html) | Repository map, editable file set, conventions, git-aware changes, and broad model-provider support | Good lean execution reference, but no verified common Skill loader. Use explicit instructions or a small conventions adapter |

Other active clients such as Kilo Code, Pi, and Deep Code CLI can use DeepSeek or other providers and may support Agent Skills. They belong in the same adapter category; adding one more client must not change the portable contract.

## Programmatic frameworks

These are useful when building a service or a durable runtime. They are not required for ordinary work in an existing coding harness.

| Framework | Main contribution | When BoundedFreedom should use it |
| --- | --- | --- |
| [OpenAI Agents SDK](https://openai.github.io/openai-agents-python/agents/) | Agents, tools, manager-owned specialists, handoffs, guardrails, sessions, and tracing | When BoundedFreedom becomes an application or service with explicit runtime guardrails and observability |
| [Claude Agent SDK](https://code.claude.com/docs/en/agent-sdk/claude-code-features) | Programmatic access to Claude Code Skills, subagents, hooks, permissions, and MCP | When a Claude-backed workflow must run non-interactively with the same host controls |
| [LangGraph](https://docs.langchain.com/oss/python/langgraph/overview) | Durable execution, persistence, streaming, and human-in-the-loop state | Only when a long-running workflow truly needs resumable graph state beyond a task record |
| [AutoGen](https://microsoft.github.io/autogen/stable/user-guide/agentchat-user-guide/index.html) | High-level AgentChat plus an event-driven core for multi-agent systems | For controlled multi-agent experiments, not the cost-efficient default |
| [CrewAI](https://docs.crewai.com/en/concepts/crews) | Crews and flows for role-based application workflows | Only if a fixed business process needs its runtime; do not recreate Chief as a large standing crew |
| [OpenHands SDK](https://docs.openhands.dev/sdk/arch/sdk) and [DeepSeek Harness SDK](https://github.com/deepseek-ai/deepseek-harness/tree/master/python/sdk) | Embeddable software-agent runtimes with Skills and execution tools | When isolation, remote execution, or an owned product runtime is the actual goal |

## Research workflow references

The research repositories already inventoried are method, tool, system, benchmark, or domain references—not replacements for the coding host:

- [codex-PaperFactory](https://github.com/happystander/codex-PaperFactory) contributes resumable research state and evidence tracking, but its full state machine is too heavy for daily default use.
- [scientific-agents](https://github.com/K-Dense-AI/scientific-agents) contributes selective professional context, not a new Chief.
- [Scientific Agent Skills](https://github.com/K-Dense-AI/scientific-agent-skills) is a large catalog to mine selectively, not to load wholesale.
- [AI-Scientist](https://github.com/SakanaAI/AI-Scientist) and [open-coscientist](https://github.com/jataware/open-coscientist) are end-to-end autonomous-system references, not cost-efficient defaults.
- [ScienceAgentBench](https://github.com/OSU-NLP-Group/ScienceAgentBench) and [PaperBench](https://github.com/openai/frontier-evals/tree/main/project/paperbench) contribute evaluation boundaries: generated code, executed code, implemented method, and reproduced claim are different states.

The detailed repository inventory remains in `tasks/2026-09-01-research-capability-inventory.md`.

## Capabilities adopted now

BoundedFreedom takes the smallest useful common set:

1. **Progressive disclosure:** keep only Skill names and descriptions in standing context; load methods and resources on demand.
2. **Layered instructions:** stable constitution, portable workflow, thin host adapter, and local project rules.
3. **Chief accountability:** specialists return bounded evidence; the primary session keeps intent, integration, and the final decision.
4. **Four separate routing decisions:** choose task method, execution contract, model and reasoning effort, and S0–S4 assurance independently for each relevant work unit.
5. **Permission and scope boundaries:** read-only discovery, one writing worker, explicit ownership, stop conditions, and human gates.
6. **Provider separation:** a host may change from OpenAI to Anthropic, DeepSeek, Gemini, or local models without rewriting scientific contracts.
7. **Recoverable evidence:** actual diffs, tests, comparisons, task records, and explicit uncertainty; add an event store only when long-running recovery warrants it.
8. **Independent evaluation:** review evidence separately from the implementer's narrative, especially for scientific claims.

## Deliberately not adopted

- A new custom runtime before the existing harness is insufficient.
- One giant research Skill or hundreds of always-visible specialist descriptions.
- A permanent luxury/basic/minimal profile for whole tasks.
- Default agent teams, recursive delegation, or parallel writing.
- Host-specific frontmatter, tool names, model IDs, or credentials in portable Skills.
- A successful tool call as evidence of scientific validity.

This boundary lets the framework benefit from current systems without becoming another large system that must reimplement them.
