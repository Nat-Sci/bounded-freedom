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

Read [references/search-and-citation.md](references/search-and-citation.md) when using seed papers, citation searching, a domain-specific search profile, or search repair. It defines how those methods are calibrated, logged, repaired, and stopped.

## Work-unit model guidance

| Work unit | Execution contract | Capability lane |
| --- | --- | --- |
| Query expansion, metadata, citation retrieval, deduplication, screening, and fixed-field extraction | Scout | Fast and economical |
| Domain profile, seed calibration, and search-repair diagnosis | Chief, direct | Balanced |
| Full-text evidence tables, method comparison, and stable synthesis | Chief, direct | Balanced |
| Novelty judgment, causal or statistical inference, and unresolved conflicting evidence | Chief, direct; Reviewer when independence is required | Strong reasoning |

A large corpus calls for bounded Scout work, not an automatic model upgrade. Escalate only for missed dependencies, unstable inclusion decisions, unresolved evidence conflict, or insufficient judgment. Use the general orchestration route for work not listed here.

## Freeze before searching

Record:

- the exact question and key concepts;
- population, method, outcome, domain, or other relevant eligibility dimensions;
- the domain profile and role of any seed set;
- sources, date range, language, publication types, and exclusions;
- the intended mode and stopping rule;
- what the review may and may not conclude.

If the boundary is supplied by the user, preserve it. If it is inferred, label it.

## Workflow

1. Build a domain profile and expand concepts into auditable search terms, including important aliases and exclusions.
2. Calibrate with a labeled seed set when useful, then freeze versioned, source-specific queries.
3. Keep an exact search log: source, query version, filters, date searched, and hit count when available.
4. Run declared backward or forward citation searches when they can materially improve coverage; keep their provenance separate from database results.
5. Separate records that were discovered, deduplicated, screened, retrieved, and included.
6. Repair a search only after recording the diagnostic failure and the smallest justified change.
7. Read to the depth needed for the mode. Do not treat titles, abstracts, snippets, or generated summaries as full-text evidence.
8. Extract cited evidence into stable fields rather than prose memory.
9. Compare methods, samples, assumptions, results, limitations, and contradictory evidence.
10. State the supported conclusion, its boundary, confidence, unresolved conflicts, and remaining retrieval risk.

## Required return

- review mode and frozen boundary;
- search log and corpus counts appropriate to that mode;
- seed, citation-search, and repair ledgers when those methods affected the corpus;
- evidence table with source locations;
- agreements, conflicts, and plausible reasons for disagreement;
- conclusion with calibrated language;
- missing evidence, likely blind spots, and next search only if it could change the decision.

## Evidence boundaries

- Citation existence is not evidence that the cited passage supports the claim; verify the source location.
- A seed paper calibrates discovery; it is not automatically included evidence and does not prove recall.
- Citation searching supplements a text or database search when completeness matters; citation links are not eligibility decisions.
- Search volume, citation count, and majority vote do not establish truth.
- A database or paper-QA tool can retrieve from a corpus but cannot establish that the corpus is complete.
- Novelty is always bounded by the searched sources, dates, languages, terminology, and accessible full text.
- These rows are starting points. Chief retains the final model, delegation, and S0–S4 decisions.

## Upstream adoption

- **Selected:** progressive skim-to-deep-read, tiered review modes, a frozen search boundary, domain profiles, labeled seed calibration, supplementary citation searching, versioned search repair, auditable screening, evidence tables, contradiction checks, and explicit stopping conditions.
- **Not selected now:** a default comprehensive review, a bundled database or paper-QA service, citation-only completeness claims, automatic query expansion without a change log, autonomous inclusion decisions, or treating retrieval from an available corpus as proof of completeness or novelty.

The full source-by-source decision is in the [adoption ledger](../../../docs/ecosystem-and-credits.md#adoption-ledger-by-local-skill).

## Influences and credits

This Skill is an original synthesis informed especially by [scientific-research-skills](https://github.com/jxtse/scientific-research-skills) and the [systematic literature review Skill](https://github.com/yananlong/codex-skills/blob/main/research/research-systematic-literature-review/SKILL.md), together with established review guidance. It does not bundle either project. See [ecosystem, influences, and credits](../../../docs/ecosystem-and-credits.md).
