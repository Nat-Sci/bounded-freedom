# Review modes and evidence schema

Read only for systematic, novelty, or large-corpus review, or when a bounded map needs a stable evidence table.

## Mode contracts

| Mode | Minimum search | Required evidence | Permitted completion claim |
| --- | --- | --- | --- |
| Rapid scan | Several high-yield sources or one bounded corpus; query notes | Representative citations and explicit gaps | “Representative scan within these sources” |
| Bounded evidence map | Frozen sources, queries, dates, eligibility, deduplication | Search log, corpus ledger, evidence table, contradictions | “Evidence map within the stated boundary” |
| Systematic review | Protocol, reproducible multi-source search, screening decisions, exclusions, recall checks | Full search and screening records, structured extraction, study-quality or bias assessment | “Systematic review under this protocol” |
| Novelty review | Bounded systematic search plus terminology expansion, backward/forward citation checks, related methods, code and preprints where relevant | Claim-to-prior-work comparison and near-neighbor table | “No matching prior work found within the stated boundary” |

Do not call a review systematic merely because it has many papers.

## Corpus ledger

Track stable identifiers where possible and keep these states separate:

```text
discovered -> deduplicated -> screened -> retrieved -> included
```

For exclusions that matter to the conclusion, retain an exclusion reason. Do not silently drop inaccessible or non-English records; record how they affect coverage.

## Evidence row

Use the fields that change interpretation:

```text
source_id
full_citation
source_location: page, section, table, figure, or repository path
study_question
design_and_sample
method_or_intervention
comparator
outcomes_and_metrics
main_result
uncertainty
limitations_or_bias
relevance_to_review_question
supports_conflicts_or_contextualizes
reviewer_notes
```

Never merge a paper's reported result with the reviewer's inference in the same field.

## Novelty checks

Translate the proposed contribution into independently searchable parts:

- task or phenomenon;
- population or data type;
- mechanism or method;
- supervision, loss, architecture, or analysis choice;
- outcome or claimed advantage;
- unusual combinations and near synonyms.

Search the whole combination and the parts. Compare the closest work by actual contribution, not title similarity. Include relevant preprints, code repositories, benchmarks, patents, or trial registries only when they are part of the frozen boundary.

## Stop conditions

Stop and return `indeterminate` rather than widening scope silently when:

- the question changes during screening;
- key databases, full texts, or dates are unavailable;
- inclusion decisions cannot be made consistently;
- conflicting evidence cannot be traced to design or measurement differences;
- a novelty claim depends on an unsearched language, field, or proprietary corpus.

## Method and tool sources

- [scientific-research-skills](https://github.com/jxtse/scientific-research-skills) for progressive skim, targeted read, and deep-read routing.
- [research-systematic-literature-review](https://github.com/yananlong/codex-skills/blob/main/research/research-systematic-literature-review/SKILL.md) for bounded and protocol-level artifact ideas.
- [PaperQA2](https://github.com/Future-House/paper-qa) for cited QA over an available paper corpus.
- [ASReview](https://github.com/asreview/asreview) for human-controlled prioritization in large screening sets.
- [STORM](https://github.com/stanford-oval/storm) for multi-perspective discovery and cited drafting, not as a systematic-review protocol.
- [PRISMA 2020](https://www.prisma-statement.org/prisma-2020), the [Cochrane Handbook](https://www.cochrane.org/authors/handbooks-and-manuals/handbook/current), [OSF registration](https://help.osf.io/article/330-welcome-to-registrations), and [EQUATOR](https://www.equator-network.org/) as external method or reporting anchors. Apply only the guidance relevant to the study type.
