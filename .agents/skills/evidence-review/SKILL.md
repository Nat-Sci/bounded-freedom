---
name: evidence-review
description: Search, screen, read, and synthesize scientific literature for rapid scans, bounded evidence maps, systematic reviews, or novelty checks. Use when an answer depends on the research landscape rather than one supplied paper.
---

# Evidence review

Produce a review whose conclusion is no broader than its search and evidence.

## Choose the review mode

- **Rapid scan:** orient the user, find vocabulary and representative work, and expose obvious uncertainty. Never imply completeness.
- **Bounded evidence map:** default for a practical research question. Search a frozen boundary, compare included studies, and report likely omissions.
- **Systematic or novelty review:** use only when the user needs protocol-level screening, a defensible novelty claim, or a consequential evidence base.

Read [references/modes-and-schema.md](references/modes-and-schema.md) before systematic, novelty, or large-corpus work. It defines required artifacts, evidence fields, and stop conditions.

## Freeze before searching

Record:

- the exact question and key concepts;
- population, method, outcome, domain, or other relevant eligibility dimensions;
- sources, date range, language, publication types, and exclusions;
- the intended mode and stopping rule;
- what the review may and may not conclude.

If the boundary is supplied by the user, preserve it. If it is inferred, label it.

## Workflow

1. Expand concepts into auditable search terms, including important aliases and exclusions.
2. Keep an exact search log: source, query, filters, date searched, and hit count when available.
3. Separate records that were discovered, deduplicated, screened, retrieved, and included.
4. Read to the depth needed for the mode. Do not treat titles, abstracts, snippets, or generated summaries as full-text evidence.
5. Extract cited evidence into stable fields rather than prose memory.
6. Compare methods, samples, assumptions, results, limitations, and contradictory evidence.
7. State the supported conclusion, its boundary, confidence, unresolved conflicts, and remaining retrieval risk.

## Required return

- review mode and frozen boundary;
- search log and corpus counts appropriate to that mode;
- evidence table with source locations;
- agreements, conflicts, and plausible reasons for disagreement;
- conclusion with calibrated language;
- missing evidence, likely blind spots, and next search only if it could change the decision.

## Evidence boundaries

- Citation existence is not evidence that the cited passage supports the claim; verify the source location.
- Search volume, citation count, and majority vote do not establish truth.
- A database or paper-QA tool can retrieve from a corpus but cannot establish that the corpus is complete.
- Novelty is always bounded by the searched sources, dates, languages, terminology, and accessible full text.
- Keep model selection, delegation, and S0–S4 assurance in the Chief orchestration contract rather than in this Skill.

## Influences and credits

This Skill is an original synthesis informed especially by [scientific-research-skills](https://github.com/jxtse/scientific-research-skills) and the [systematic literature review Skill](https://github.com/yananlong/codex-skills/blob/main/research/research-systematic-literature-review/SKILL.md), together with established review guidance. It does not bundle either project. See [ecosystem, influences, and credits](../../../docs/ecosystem-and-credits.md).
