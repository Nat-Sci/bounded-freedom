# BoundedFreedom README draft

> **Boundaries make exploration safe. Constraints make freedom sustainable.**

BoundedFreedom is a cost-efficient, constraint-first harness for AI-assisted research and engineering.

It separates open-ended scientific thinking from controlled execution, routes work to models with appropriate capability and cost, and requires verification and auditability before acceptance.

## Core Workflow

```text
THINK
  ↓
FRAME
  ↓
FREEZE
  ↓
CLASSIFY
  ↓
ROUTE
  ↓
EXECUTE
  ↓
VERIFY
  ↓
REVIEW
  ↓
RECORD
```

BoundedFreedom contains two first-class spaces:

### Thinking Space

Used to clarify questions, examine evidence, develop hypotheses, compare explanations, and produce a Research Brief.

### Execution Space

Used to implement frozen specifications through bounded agents, explicit routing, verification, scientific review, and Decision Records.

V0.1 focuses on the Execution Space. Thinking Space remains part of the architecture but initially contributes only the Research Brief and Frozen Task Specification interfaces.

## Execution Profiles

### Micro

For narrow, repeatable, low-risk tasks.

Typical models:

```text
Luna
Codex Spark when available
```

### Economy

The default profile.

```text
Coordinator: Terra / Medium
Scout: Luna / Medium
Builder: Terra / Medium
QA: Luna / Low or Medium
Architect: Sol / High when required
Scientific Reviewer: Sol / High when required
```

### Critical

For high-ambiguity or high-scientific-risk tasks.

```text
Chief: Sol / High
Scout: Luna
Builder: Terra
QA: Luna
Scientific Reviewer: fresh Sol / High
Human approval: mandatory
```

## Roles

### Coordinator

Classifies the task, selects the route, writes worker specifications, integrates evidence, and records the decision.

### Architect

Resolves ambiguity and designs the plan. Architect is read-only and does not implement.

### Scout

Finds relevant files, execution paths, dependencies, logs, and evidence. Scout is read-only.

### Builder

Implements an approved, bounded specification within explicit file ownership.

### QA

Runs verification and returns concise evidence. QA does not redesign methods or edit source code.

### Scientific Reviewer

Independently evaluates scientific validity, statistical inference, leakage, interpretation, and agreement between evidence and claims.

## Routes

```text
DIRECT
Coordinator → Verify → Record

DISCOVER
Coordinator → Scout → Record

PATCH
Coordinator → Scout → Builder → QA → Record

ARCHITECT
Coordinator → Architect → Builder → QA → Record

SCIENTIFIC_CHANGE
Freeze → Architect → Builder → QA
       → Scientific Reviewer → Human Acceptance → Record
```

## Scientific Risk

| Level | Meaning |
|---|---|
| S0 | Presentation only |
| S1 | Behavior-preserving engineering |
| S2 | May affect numerical results |
| S3 | May affect statistical inference |
| S4 | May affect primary claims or clinical interpretation |

S3 and S4 require independent scientific review.

## Cost Rules

1. Use the cheapest capable model.
2. Default to zero or one auxiliary agent.
3. Run no more than two subagents concurrently.
4. Allow only one writing agent at a time.
5. Do not allow nested delegation in V0.1.
6. Keep raw logs inside subagent threads.
7. Return concise structured summaries.
8. Stop after two materially different failed attempts.
9. Escalate only when evidence justifies it.
10. Never silently change scientific intent.

## Repository Layout

```text
.codex/agents/
    Custom Codex role configurations

.agents/skills/
    Reusable orchestration skills

docs/
    Architecture and operating policies

templates/
    Briefs, specifications, reviews, and decision records

examples/
    Demonstrated routing workflows

scripts/
    Repository validation

tests/
    Mechanical checks for repository contracts
```

## V0.1 Scope

V0.1 implements:

- Constitution;
- Execution Space architecture;
- Micro, Economy, and Critical profiles;
- Architect, Scout, Builder, QA, and Scientific Reviewer roles;
- cost-efficient orchestration skill;
- task and review templates;
- repository validation;
- three example routes.

V0.1 does not yet implement:

- domain-specific dMRI skills;
- scientific-writing workflows;
- figure-generation workflows;
- plugin marketplace packaging;
- recursive agent hierarchies;
- automatic token accounting.

## Development Principle

BoundedFreedom is not an agent swarm.

It is a controlled collaboration system.

> Use fewer agents, give each agent a narrower role, reserve strong models for high-value decisions, and require evidence before acceptance.
