# Task record: ecosystem, credits, and upstream watch policy

## Intent

- Objective: Explain the related research-agent ecosystem, credit concrete influences on BoundedFreedom Skills, and define a safe way to monitor upstream work.
- Scope: One canonical ecosystem page, concise provenance notes in the six Skills, a README entry, and a Wiki mirror of the canonical page.
- Non-goals: Vendor third-party code, install upstream projects, claim endorsement, auto-merge upstream changes, star repositories on a human account, or rewrite the research capability inventory.

## Chief decision

- Risk: S1. This changes public documentation and attribution, not scientific data or conclusions.
- Execution: Direct, with no worker.
- Verification: Check direct links, distinguish influence from dependency, inspect Skill provenance statements, validate Skill structure, scan for private machine identifiers, and compare the Wiki mirror with the canonical page.
- Stop conditions: Do not copy upstream content beyond a short descriptive summary; do not publish images intended only for social channels.

## Decision

- `docs/ecosystem-and-credits.md` is the versioned source of truth. It classifies related work, states what BoundedFreedom adds, and supplies the upstream watch policy.
- The public Wiki provides a concise Home page plus navigable mirrors for the ecosystem and harness landscape. The main repository remains canonical.
- Each Skill states its closest influences and links to the canonical page. This keeps credit near the adapted method without repeating the full landscape.
- Upstream changes are reviewed and selectively adopted. They never update a Skill automatically.
- Stars remain a human choice. Release watching or a scheduled review, not starring, supplies update signals.

## Verification and remaining uncertainty

- Verification passed: all six Skills pass the repository Skill validator; changed Markdown has valid local links and no machine-local identity; the diff has no whitespace errors.
- Wiki publication passed: the public Home page was created after explicit confirmation, then the ecosystem, harness landscape, and sidebar mirrors were committed and pushed from their canonical sources.
- Remaining uncertainty: the most useful monitoring interval should be chosen after observing upstream update frequency and the maintenance burden.
