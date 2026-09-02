# Search strategy, seed papers, and citation searching

Read this reference only when an evidence review uses seed papers, citation searching, domain adaptation, or search repair. These are details inside `evidence-review`; they do not change Chief routing, execution contracts, model selection, or S0-S4 assurance.

## Keep four objects separate

| Object | Purpose | Must not silently change |
| --- | --- | --- |
| Review boundary | Defines what may be included and concluded | Question, eligibility, dates, languages, and evidence types |
| Domain profile | Translates the boundary into field-specific terms and sources | The review boundary itself |
| Seed set | Helps develop, test, or expand discovery | Inclusion decisions or evidence weight |
| Search strategy | Retrieves candidates from a named source | Eligibility criteria |

If search work suggests that the review boundary is wrong, pause and re-freeze it with the human. Do not disguise a scope change as query repair.

## Domain profile

Create a small profile before writing queries:

```text
question frame
core concepts and unstable concepts
free-text terms, acronyms, older names, spelling variants
controlled vocabulary or field ontology
source families and known coverage gaps
eligible evidence and version relationships
domain-specific false positives
```

Use a question frame that fits the field rather than forcing every topic into PICO.

| Domain | Useful concept frame | Coverage and vocabulary checks |
| --- | --- | --- |
| Clinical or biomedical | population/condition, intervention or exposure, comparator, design | Free text plus controlled vocabulary; clinical databases, registries, and grey literature as required by the boundary |
| AI or computer vision | task, data or modality, method family, supervision, benchmark, metric | Conference and journal versions, preprints, benchmark names, dataset aliases, code, and version lineage |
| Neuroimaging or neuroscience | population or species, modality, acquisition, preprocessing or analysis, anatomical target, outcome | Modality acronyms, atlas and dataset names, software or pipeline terms, biomedical indexes, citation indexes, and domain venues |
| Psychology or behavioral science | construct, population, paradigm or task, instrument or scale, outcome | Construct drift, measure names, PsycINFO-style vocabulary, registrations, and cross-disciplinary coverage |

The source families above are examples, not a universal database list. Freeze the actual database, platform, index, registry, repository, or venue and record known access or coverage limits. For systematic or novelty work, a domain expert or information specialist should review a profile whose omissions could change the conclusion.

## Seed set

A seed is a paper known before the final search and used to develop terms, test retrieval, or start citation searching. Maintain a seed ledger:

```text
seed_id and stable identifier
provenance
eligibility_status: confirmed | partial | ineligible-near-neighbor
use: term-development | retrieval-validation | citation-start | boundary-test
reason for selection
diversity tags
query versions that retrieved or missed it
```

Apply these constraints:

1. Confirmed seeds must meet the frozen eligibility criteria at the reading depth required by the review mode.
2. A partially relevant seed may teach vocabulary for one difficult concept, but it cannot validate the whole query or enter the evidence table as an included study.
3. An ineligible near-neighbor may test a confusing boundary or likely false positive; it is not negative scientific evidence.
4. Prefer seeds that span terminology, time, method, geography, venue, and evidence type relevant to the question. Citation count or fame alone is not a selection rule.
5. Record how every seed was found. A seed discovered only by the query being tested is useful for term development but is not independent validation of that query.
6. When enough seeds exist, separate development seeds from held-out validation seeds. If this is impossible, call the result calibration, not independent validation.
7. Do not force a fixed seed count. The set is sufficient only when it represents the important search difficulties inside the frozen boundary.

For a bounded, systematic, or novelty search, every confirmed validation seed must either be retrieved by the combined search or have a recorded explanation such as absent indexing, date coverage, document type, or source mismatch. An unexplained miss triggers repair.

## Versioned search strategy

Build a concept table before a Boolean string. Within a concept, combine accepted names, aliases, spelling variants, acronyms, legacy terms, and controlled vocabulary. Combine only essential concepts across blocks. Avoid fragile outcome terms, `NOT`, and language, date, document-type, or human-only filters unless the boundary requires them and seed checks show that they do not hide eligible work.

Translate the strategy for each database and platform; do not paste one source's syntax into another. Save the exact query as run rather than retyping it later.

```text
query_id and parent version
source and platform
concept table version
exact query and filters
date run and coverage date
raw hits and exported records
seed retrieval result
reason for the next change
```

Before freezing a query, check:

- retrieval of confirmed validation seeds or a documented coverage reason for each miss;
- whether a small result sample contains the intended concepts and exposes specific noise;
- whether every restriction is justified by the review boundary rather than the desired hit count;
- whether source-specific field tags, wildcards, proximity operators, and controlled terms behave as intended.

## Citation searching

Use clear terms:

- **Backward citation searching:** screen references cited by a seed.
- **Forward citation searching:** screen records that cite a seed.
- **Related, co-cited, or co-citing search:** optional discovery routes; report them separately.
- **Iteration:** one complete declared pass from the current seed set.

Citation searching is supplementary when the review aims for high recall. It must not replace a primary text or database search for a systematic or novelty conclusion.

| Review mode | Default use |
| --- | --- |
| Rapid scan | Optional one bounded pass from a few declared seeds; stop at the frozen budget and make no completeness claim |
| Bounded evidence map | Use when terminology is unstable, evidence spans fields, or a missed cluster could change the map; normally run one backward and forward pass, then decide from yield |
| Systematic or novelty | Plan it as a supplementary method when appropriate; normally start from all confirmed records included after the primary search, or document why and how a sample was selected |

Deduplicate citation-search results against the existing corpus before full screening, then apply the same eligibility criteria. If a round finds new eligible records, consider a further round using them as new seeds. Stop when one of these declared conditions is met:

- a complete round yields no new eligible records or novelty near-neighbors;
- the frozen iteration, time, or screening budget is reached and the residual omission risk is reported;
- a new cluster exposes a scope or eligibility problem that requires human re-freezing.

No-new-record yield supports a stopping decision but does not prove completeness. Do not stop merely because citation counts are low, duplicates are high, or the papers are highly cited.

Keep a citation-search ledger:

```text
parent_seed_id
direction or relationship
citation index or tool
search date
iteration
records found, unique, screened, and included
new seed ids
stop reason
```

`citationchaser` is a useful optional tool for batch forward and backward retrieval. It is not a dependency, an eligibility judge, or proof that one citation index is complete.

## Controlled search repair

**Search repair** is BoundedFreedom's local term for a versioned correction within a frozen review boundary. It is not a separate review type.

Repair is triggered by observable evidence:

- a confirmed validation seed is missed without a source-coverage explanation;
- citation searching finds an eligible paper that the primary query should reasonably have found;
- a field expert or peer review identifies a missing term, source, or indexing route;
- a source translation, field tag, filter, wildcard, proximity rule, or date limit behaves incorrectly;
- the retrieved corpus lacks a domain or evidence cluster that the frozen profile requires;
- pilot screening shows a specific ambiguity that makes the search unusably noisy.

Diagnose before changing the query. Classify the cause as a vocabulary gap, over-constrained concept, syntax or field error, source-coverage gap, filter or date problem, version-lineage problem, or eligibility ambiguity. Then:

1. Save the failed query and diagnostic evidence.
2. Make the smallest explained change; change one cause at a time when feasible.
3. Re-run seed checks and the affected source.
4. Compare new and lost records, not only total hits.
5. Freeze the new version or revert it, with a reason.

Reasonable repairs include adding verified terms or controlled vocabulary, relaxing an unreliable concept block, correcting source syntax, adding a source already allowed by the domain profile, splitting an ambiguous query, or adding a declared manual/citation route. Do not change eligibility, silently remove a difficult seed, or narrow a query only to reduce workload.

Cost limits are mode-specific:

- **Rapid scan:** normally one targeted repair, then report the remaining gap.
- **Bounded evidence map:** default to at most two query-version changes; extend only when evidence shows that another repair could change the decision.
- **Systematic or novelty:** an arbitrary low repair cap cannot justify a strong conclusion. Resolve material misses, obtain information-specialist review, narrow and re-freeze the claim, or return `indeterminate`.

A later rerun for new publications or changed indexing is a **search update**, not a repair. Preserve the old strategy and record the new date, vocabulary, source, and syntax changes.

## Selected method and boundaries

- **Selected:** domain profiles, labeled and diverse seeds, held-out validation when feasible, source-specific query versions, supplementary backward and forward citation searching, provenance ledgers, and minimal diagnostic repair.
- **Not selected:** famous-paper-only seeds, seed inclusion by assumption, citation-only completeness, fixed databases for every field, unlogged autonomous query expansion, or changing eligibility to make the search look successful.

## Method sources

- [Campbell guidance on searching for studies](https://onlinelibrary.wiley.com/doi/full/10.1002/cl2.1433) for domain-specific sources, diverse seed sets, term harvesting, retrieval tests, and versioned updates.
- [TARCiS statement](https://www.bmj.com/content/385/bmj-2023-078384) for citation-searching terms, seed selection, iteration, deduplication, reporting, and the boundary against citation-only comprehensive search.
- [PRISMA-S](https://www.prisma-statement.org/prisma-search) for reproducible reporting of databases, platforms, full strategies, limits, dates, citation searching, and updates.
- [Cochrane Handbook, Chapter 4](https://www.cochrane.org/authors/handbooks-and-manuals/handbook/current/chapter-04) for sensitive searches, concept construction, free text plus controlled vocabulary, and source selection.
- [PRESS guideline](https://www.cda-amc.ca/sites/default/files/attachments/2023-06/PRESS%20Peer%20Review%20Electronic%20Search%20Strategies_%202015%20Guideline%20Explanation%20and%20Elaboration%20%28PRESS%20E%26E%29.pdf) for independent review of consequential electronic search strategies.
- [citationchaser](https://github.com/nealhaddaway/citationchaser) as an optional retrieval tool, not a review protocol.
