# Task record: research capability inventory

## Intent

- Objective: Understand and classify existing research-agent repositories before designing BoundedFreedom research Skills.
- Non-goals: Install third-party projects, copy their prompts, freeze a Skill layout, or assign one model to an entire research task.
- Assumptions and uncertainty: Repository popularity is only a discovery signal. Scientific fitness depends on methods, evidence, domain constraints, maintenance, licensing, and actual use.

## Chief decision

- Risk: S1. This is a public-source landscape review and does not make a project-level scientific claim.
- Execution: direct.
- Workers and model rationale: None. Keeping one reader avoids duplicated repository interpretation and cross-agent aggregation cost.
- Owned scope: Literature review and hypothesis work, paper-code study and reproduction, scientific figures, research software lifecycle, and closely related standards and benchmarks.
- Verification: Read primary repository documentation and official method or reporting guidance; separate methods, runnable tools, agent systems, benchmarks, and domain libraries.
- Stop conditions: Do not turn the inventory into a routing contract until the user has reviewed the classification.

## Classification used in this inventory

The following objects are related, but they are not interchangeable:

| Object | Main question |
| --- | --- |
| Method Skill | How should the agent reason and what evidence must it preserve? |
| Runnable tool | What operation can software perform on papers, code, data, or figures? |
| Agent system | How are many steps and persistent state coordinated end to end? |
| Benchmark | How is an agent or reproduction graded? |
| Domain library or standard | Which established implementation or scientific rule should the work use? |

A repository can span more than one row, but it still needs one primary identity. Stars and recent pushes are recorded only to help discovery; they do not establish scientific quality.

## The five repositories that started the review

| Repository | Primary identity | What it actually contributes | Boundary for BoundedFreedom |
| --- | --- | --- | --- |
| [scientific-research-skills](https://github.com/jxtse/scientific-research-skills) | Small Skill collection | Search, three-level paper reading, related-work survey, full-text harvest, Zotero, and a PaperBanana adapter | Reuse its progressive reading and survey methods selectively; do not install every adapter by default |
| [research-systematic-literature-review](https://github.com/yananlong/codex-skills/blob/main/research/research-systematic-literature-review/SKILL.md) | High-rigor method Skill with validators | Rapid, bounded, critical, novelty, and comprehensive profiles; search logs, corpus freeze, screening, evidence tables, recall audits, and explicit assurance verdicts | Strong source for review modes and evidence boundaries; the full artifact set is too heavy for ordinary review |
| [research-paper-code-study](https://github.com/baizhanxu/research-paper-code-study-codex-skill) | Paper-code understanding Skill | Traces paper concept to runtime path and separates paper claims, code behavior, and inference; plans low-cost reproduction checks | Fits an understanding/mapping mode; it is not a claim-level reproduction engine or benchmark |
| [codex-PaperFactory](https://github.com/happystander/codex-PaperFactory) | End-to-end research harness | A persistent `.research/` state machine for survey, baselines, method design, experiments, evidence, writing, review, recovery, and a web UI | Earlier classification as a figure project was wrong. It is useful as an advanced-system reference, but too broad and operationally heavy for the default Chief path; licensing and host-access behavior need separate review |
| [scientific-agents](https://github.com/K-Dense-AI/scientific-agents) | Profession-specific `AGENTS.md` profiles | Standing context for how roles such as a research software engineer, neuroscientist, or ML researcher frame and stress-test work | Use selected profile knowledge at project or specialist scope; do not replace Chief or load a whole professional persona for every task |

## Extended landscape

### Evidence review and hypothesis work

| Repository or source | Type | Useful role | Important limit | Current disposition |
| --- | --- | --- | --- | --- |
| [PaperQA2](https://github.com/Future-House/paper-qa) | Runnable paper RAG/QA tool | Index local papers, retrieve evidence, answer with citations, and expose fast versus higher-quality settings | It answers over an available corpus; it does not by itself establish search completeness or novelty | Optional tool adapter |
| [ASReview](https://github.com/asreview/asreview) | Active-learning screening tool | Prioritize records while preserving human screening decisions and simulation support | It does not replace an independent screener or a review protocol | Optional tool adapter for large corpora |
| [STORM](https://github.com/stanford-oval/storm) | Knowledge-curation and report system | Multi-perspective question generation, web retrieval, outline creation, and cited long-form reports | Its own README says output is not publication ready; it is not a systematic-review method | Reference or optional drafting tool |
| [Scientific Agent Skills](https://github.com/K-Dense-AI/scientific-agent-skills) | Large Skill catalog | Current Skills for literature review, hypothesis generation, experimental design, statistics, databases, and scientific communication | Loading or installing 150+ Skills wholesale conflicts with progressive context; each Skill and dependency needs individual review | Catalog to mine selectively |
| [HypoGeniC / HypoRefine](https://github.com/ChicagoHAI/hypothesis-generation) | Research framework and benchmark code | Generates and refines hypotheses from data and, in HypoRefine, literature | It evaluates a particular automated method; it is not a general scientific judgment protocol | Evaluation reference |
| [ResearchAgent](https://github.com/JinheonBaek/ResearchAgent) | Literature-grounded idea system | Starts from seed papers, retrieves related work and entities, and iteratively reviews ideas, methods, and experiments | Specialized pipeline and data setup; generated ideas still require novelty, design, and human gates | Research reference |
| [CKM-HypoGen](https://github.com/TaoJinkai/ckm-hypogen) | New framework, Skill bundle, and benchmark | Tests predictive hypotheses against papers published after a frozen literature window | Promising evaluation design but very new and lightly adopted | Watch and learn from benchmark design |
| [open-coscientist](https://github.com/jataware/open-coscientist) and [AI-Scientist](https://github.com/SakanaAI/AI-Scientist) | End-to-end agent systems | Broad autonomous ideation, experimentation, and writing architectures | Large multi-agent surfaces and high runtime cost; not suitable as default evidence-review execution | Architecture references only |

Method anchors should remain external and authoritative: [PRISMA 2020](https://www.prisma-statement.org/prisma-2020) is a reporting guideline, the [Cochrane Handbook](https://www.cochrane.org/authors/handbooks-and-manuals/handbook/current) provides review methods, [OSF registration](https://help.osf.io/article/330-welcome-to-registrations) provides time-stamped protocols, and [EQUATOR](https://www.equator-network.org/) routes to study-specific reporting guidance. None should be reduced to a prompt checklist without domain review.

### Paper-code understanding and reproduction

| Repository | Type | Useful role | Important limit | Current disposition |
| --- | --- | --- | --- | --- |
| [research-paper-code-study](https://github.com/baizhanxu/research-paper-code-study-codex-skill) | Method Skill | Understand and map paper claims to real code paths | Does not prove that results were reproduced | Candidate method source |
| [xKG](https://github.com/zjunlp/xKG) | Executable knowledge layer | Links paper techniques to code-bearing nodes and supplies implementation evidence to coding agents | Requires corpus building, models, APIs, and optional Docker verification; early adoption | Experimental adapter |
| [Paper2Code](https://github.com/going-doer/Paper2Code) | Paper-to-repository builder | Planning, analysis, modular code generation, and model-based evaluation | Generated code is not equivalent to executed or numerically matched results | Builder reference |
| [DeepCode](https://github.com/HKUDS/DeepCode) | Broad coding agent with Paper2Code workflow | Builds inspectable systems from papers, documents, URLs, and reference code | Large system and strong self-reported results require independent evaluation | Advanced builder reference |
| [paperReproductAgent](https://github.com/Winter-And-You-Gone/paperReproductAgent) | First-pass reproduction pipeline | Repository discovery, environment setup, smoke tests, selected lightweight benchmarks, metric parsing, and explicit result statuses | Recent, task-family-limited, and explicitly not full paper reproduction | Watch as a practical staged-execution example |
| [PaperBench](https://github.com/openai/frontier-evals/tree/main/project/paperbench) | End-to-end replication benchmark | Separates agent rollout, fresh-container reproduction, and rubric grading; includes a lower-cost code-only variant | Focuses on a fixed set of AI papers and needs substantial container/GPU infrastructure | Primary claim-level evaluation reference |
| [SciReplicate-Bench](https://github.com/xyzCS/SciReplicate-Bench) | Algorithmic reproduction benchmark | Evaluates paper and code agents on algorithmic reproduction | Benchmark code, not an everyday reproduction workflow | Secondary evaluation reference |
| [ScienceAgentBench](https://github.com/OSU-NLP-Group/ScienceAgentBench) | Scientific coding benchmark | Tests 102 expert-validated data-driven tasks and records program, result, and cost metrics | Evaluates workflow tasks rather than full paper replication | Primary unit-task evaluation reference |

The inventory therefore uses three separate statuses: **code runs**, **method is implemented**, and **paper claim is reproduced**. They must never collapse into one success label.

### Scientific figures

Figure work also contains different objects:

- Exact data, statistical, and result figures must be code-first. Models may write or edit plotting code, but may not invent numeric values, axes, significance marks, anatomy, or labels.
- AI/CV architecture diagrams should prefer editable vector output such as SVG, LaTeX, Draw.io, or PowerPoint. [PlotNeuralNet](https://github.com/HarisIqbal88/PlotNeuralNet) is a popular classic with older maintenance; [NN-SVG](https://github.com/alexlenail/NN-SVG) remains a simple editable SVG route.
- Method illustrations can use [PaperVizAgent](https://github.com/google-research/papervizagent) for reference-driven multi-agent drafts, [AutoFigure-Edit](https://github.com/ResearAI/AutoFigure-Edit) for editable SVG reconstruction, or [LiveFigure](https://github.com/tsinghua-fib-lab/LiveFigure) for editable PowerPoint output. These remain drafting systems; labels, topology, provenance, and scientific meaning need independent checks.
- [Scientific-Figure-Design](https://github.com/qhy991/Scientific-Figure-Design) is a very new claim-first Draw.io Skill. Its figure-contract and editable-source ideas fit BoundedFreedom, but adoption and licensing are not yet established.
- K-Dense's [scientific-schematics](https://github.com/K-Dense-AI/scientific-agent-skills/tree/main/skills/scientific-schematics) is convenient for raster drafts, but its PNG-only route is a poor default for exact or heavily edited paper figures.

Domain libraries are execution targets, not independent agent roles:

| Domain need | Established routes |
| --- | --- |
| MRI/fMRI volume and surface maps | [Nilearn](https://github.com/nilearn/nilearn), [surfplot](https://github.com/danjgale/surfplot), [pycortex](https://github.com/gallantlab/pycortex) |
| Gradients, map comparison, and spatial nulls | [BrainSpace](https://github.com/MICA-MNI/BrainSpace), [neuromaps](https://github.com/netneurolab/neuromaps) |
| Network neuroscience | [netplotbrain](https://github.com/wiheto/netplotbrain) |
| EEG, MEG, iEEG, and ECoG | [MNE-Python](https://github.com/mne-tools/mne-python), including its publication-figure examples |
| Region-level brain statistics in R | [ggseg](https://github.com/ggsegverse/ggseg) |
| Psychology, behavioral distributions, and model diagnostics | [ggdist](https://github.com/mjskay/ggdist), [raincloudplots](https://github.com/jorvlan/raincloudplots), [see](https://github.com/easystats/see) |

For neuroimaging projects, figure routing must also respect [BIDS](https://github.com/bids-standard/bids-specification) inputs and relevant [COBIDAS](https://github.com/ohbm/cobidas-mri) reporting fields. A visually correct brain image can still be scientifically wrong because of space, hemisphere, atlas, threshold, interpolation, or statistical-map mistakes.

### Research software lifecycle

| Repository or source | Type | Useful role | Important limit | Current disposition |
| --- | --- | --- | --- | --- |
| [scientific-agents: Research Software Engineer](https://github.com/K-Dense-AI/scientific-agents) | Expert context profile | Connects tests, CI, packaging, containers, HPC, citation, SemVer, and FAIR4RS | Too much standing context for one-off scripts | Selective reference profile |
| [The Turing Way](https://github.com/the-turing-way/the-turing-way) | Community handbook | Reproducible, ethical, collaborative research and project design | Broad guidance rather than an executable scaffold | Method anchor |
| [CodeRefinery](https://coderefinery.org/lessons/) | Course collection | Version control, dependencies, environments, workflows, testing, modular code, documentation, and responsible AI-assisted coding | Teaching material; practices still need project-level selection | Method anchor |
| [pyOpenSci Python Package Guide](https://github.com/pyOpenSci/python-package-guide) | Reviewed package guide | Beginner-friendly package, metadata, tests, CI, docs, and maintenance guidance | Python-specific | Primary guide for public Python packages |
| [Scientific Python cookie](https://github.com/scientific-python/cookie) | Scaffold and repository checker | Modern package template plus `sp-repo-review` | Explicitly not a minimal tutorial; excessive for small analyses | Use only after software-level decision |
| [showyourwork](https://github.com/showyourwork/showyourwork) | Reproducible article workflow | Connects article build, analysis dependencies, CI, and LaTeX | Best fit for open computational papers, not every project | Optional workflow adapter |
| [FAIR4RS](https://github.com/force11/FAIR4RS) | Community standard | Findable, accessible, interoperable, and reusable research software principles | Principles, not a quality score or build system | Standard anchor |
| [RSQKit](https://github.com/EVERSE-ResearchSoftware/RSQKit) | Quality guidance collection | Curated research-software quality practices | Still evolving | Supplementary reference |
| [Publishing Research Code](https://github.com/paperswithcode/releasing-research-code) | ML release checklist | Dependencies, training, evaluation, pretrained models, and exact result commands | Useful classic, but last pushed in 2023 and ML-specific | Classic checklist |
| [JOSS criteria](https://github.com/openjournals/joss/blob/main/docs/submitting.md) | External review gate | Defines when code has become maintainable, documented, tested, openly developed research software | Intended for mature public software, not experimental scripts | Maturity target, never a default requirement |

The key lifecycle decision comes before scaffolding: **one-off analysis**, **internal reusable package**, **public research software**, or **HPC/pipeline system**. The required tests, CI, documentation, releases, containers, DOI, and FAIR work should grow with that target.

## Popularity and maintenance snapshot

Snapshot from the public GitHub API on 2026-09-01. Counts are rounded and may change.

| Repository | Stars | Last push | Interpretation |
| --- | ---: | --- | --- |
| K-Dense Scientific Agent Skills | 40.9k | 2026-08-31 | Large, current catalog; size argues for selective loading |
| STORM | 31.2k | 2025-09-30 | Very popular knowledge-curation system, not a systematic-review protocol |
| PlotNeuralNet | 25.0k | 2023-08-21 | Classic architecture-figure project with older maintenance |
| DeepCode | 16.5k | 2026-08-28 | Popular and active builder; still needs independent replication evidence |
| AI-Scientist | 14.5k | 2025-12-19 | Influential end-to-end reference, not a cost-efficient default |
| PaperQA2 | 9.1k | 2026-08-26 | Mature candidate for cited paper QA and corpus exploration |
| NN-SVG | 5.7k | 2026-06-02 | Popular lightweight vector architecture route |
| Paper2Code | 4.9k | 2026-03-25 | Important paper-to-code builder and benchmark source |
| AutoFigure-Edit | 4.2k | 2026-07-25 | Fast-growing editable-figure system |
| MNE-Python | 3.5k | 2026-08-31 | Active, established domain library |
| The Turing Way | 2.2k | 2026-08-26 | Active community method source |
| Nilearn | 1.4k | 2026-08-31 | Active, established neuroimaging library |
| ASReview | 1.0k | 2026-08-31 | Active specialized screening tool |

Small-star resources can still be important standards, benchmarks, or domain libraries. Popularity must not decide the route by itself.

## What this inventory already resolves

Task type, model capability, and scientific risk are three separate decisions:

1. **Task route:** recognize evidence review, hypothesis/study design, paper-code reproduction, scientific figure, or research software lifecycle, then load only the relevant Skill.
2. **Work capability:** choose a model for the bounded unit of work according to search breadth, context length, ambiguity, coding depth, and required judgment. A task may use different models at different steps.
3. **Risk and assurance:** apply S0-S4 to evidence, independent review, and human acceptance. S0-S4 does not name the task and does not choose one model for the whole task.

Chief therefore needs a small task index, not all research knowledge in its standing prompt. Rich methods, tools, and domain routes should be loaded only after a task match. Project `AGENTS.md` remains responsible for local data, cohort, split, ROI, compute, ethics, and acceptance boundaries.

## Decision

- Outcome: The repository landscape is organized by actual function rather than by the word “agent.” The original five repositories remain useful at different layers. After human review, their smallest common methods were implemented as five on-demand Skills; see [the V0.1 implementation record](2026-09-01-research-skills-v0.1.md).
- Alternatives rejected: One giant research Skill; treating every GitHub project as an installable Skill; treating star count as quality; using S0-S4 as a task taxonomy; treating code generation, successful execution, and reproduced claims as the same outcome.
- Remaining uncertainty: Which third-party tools deserve runnable adapters and the measured model/cost matrix for each bounded action. These require real tasks and should not be guessed from repository descriptions.
