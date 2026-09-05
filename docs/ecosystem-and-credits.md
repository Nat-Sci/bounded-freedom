# Ecosystem, influences, and credits

BoundedFreedom did not begin from a blank page. Research methods, agent Skills, scientific tools, benchmarks, and coding harnesses already solve important parts of the problem. This page explains what those projects do, what BoundedFreedom learns from them, and where the boundary remains.

A link here means **influence or interoperability**, not bundled code, endorsement, or automatic trust. The v0.2.0 Astra Edition Skills are an original synthesis. Third-party repositories are not vendored or installed by default.

## What the repository owns

| Area | Question | Current BoundedFreedom boundary |
| --- | --- | --- |
| Control plane | Who may do what, with which model, evidence, and human gate? | Owned here: Constitution, Chief, execution contracts, model routing, S0–S4, task records, and installer |
| Method plane | What disciplined process should this task follow? | Owned here: six small research Skills loaded on demand |
| Capability plane | Which database, library, runtime, or external service performs the work? | Selected per project; not bundled into Chief or installed by default |
| Evaluation plane | How are quality, cost, reproduction, and failure types measured? | Route receipts define accepted outcomes, rework, escalation, time, and evidence coverage; authoritative cost calibration is still needed |
| Project plane | Which data, cohort, split, atlas, compute, ethics, and acceptance rules apply? | Owned by the working project's instruction and task files |

This repository is deliberately strongest in the first two layers. It should route good external capabilities and project rules, not compete with broad Skill catalogs or rebuild every scientific tool.

## The related-work map

### Research methods and Skill collections

| Project | What it contributes | How BoundedFreedom uses the idea |
| --- | --- | --- |
| [scientific-research-skills](https://github.com/jxtse/scientific-research-skills) | Practical search and progressive paper-reading methods | Supports the distinction between a quick orientation and a deeper evidence review; adapters are not loaded by default |
| [systematic literature review Skill](https://github.com/yananlong/codex-skills/blob/main/research/research-systematic-literature-review/SKILL.md) | Review modes, corpus freeze, search records, evidence tables, and assurance checks | Informs `evidence-review`; BoundedFreedom keeps a lighter bounded evidence map as the normal mode |
| [research-paper-code-study](https://github.com/baizhanxu/research-paper-code-study-codex-skill) | Mapping a paper concept to files, classes, functions, and configuration | Informs the understanding mode of `paper-code-reproduction`; runnable code is still not treated as reproduced evidence |
| [scientific-agents](https://github.com/K-Dense-AI/scientific-agents) | Profession-specific context, including research software engineering | Used selectively at project or specialist scope; it does not replace Chief with a permanent persona |
| [Scientific Agent Skills](https://github.com/K-Dense-AI/scientific-agent-skills) | A broad catalog of research Skills and scientific data routes | A source to inspect selectively, not a catalog to install or load wholesale |
| [BioSkills](https://github.com/nggsam/bioskills) | A biology-focused path from hypothesis and literature through analysis, validation, review, and reporting | Useful method and validation reference; its domain workflow and subagent structure are not the general Chief default |
| [sci-using-kit](https://github.com/keithhegit/sci-using-kit) | Evidence-bounded manuscript planning, claim support, reviewer preflight, and submission workflow | A writing-stage method reference; not yet promoted to a local Skill or dependency |

### Research systems, tools, and evaluation

| Project | Main role | Boundary in BoundedFreedom |
| --- | --- | --- |
| [codex-PaperFactory](https://github.com/happystander/codex-PaperFactory) | Persistent end-to-end research state and recovery | Advanced system reference; too much machinery for the default path |
| [PaperQA2](https://github.com/Future-House/paper-qa) | Cited question answering over an available paper corpus | Optional retrieval tool; cannot establish that the corpus is complete |
| [ASReview](https://github.com/asreview/asreview) | Active-learning support for large screening sets | Optional screening tool; human decisions and protocol evidence remain necessary |
| [SciAtlas](https://github.com/zjunlp/SciAtlas) | Executable paper search, review, and idea workflows with quick and deeper modes | Useful adapter and artifact pattern; its services and runtime are not required by the portable method |
| [SciAgent](https://github.com/smestern/sciagent) | A scientific-analysis runtime with planning, data quality, code scanning, bounds checking, and validation | Useful execution and guardrail ideas; BoundedFreedom does not adopt its fixed crew or full runtime by default |
| [Paper2Code](https://github.com/going-doer/Paper2Code) and [DeepCode](https://github.com/HKUDS/DeepCode) | Building code from papers and other technical sources | Builder references; generated code is not evidence that a scientific claim was reproduced |
| [paperReproductAgent](https://github.com/Winter-And-You-Gone/paperReproductAgent) | Finding likely author repositories and running staged first-pass checks with explicit fallback | Informs source discovery, runnable checks, and downgrade records; its runtime and task-family adapters are not bundled |
| [ReproAgent](https://arxiv.org/abs/2608.24291) | A persistent paper-to-code contract with separate implementation requirements and reference evidence | Informs the distinction between paper obligations, external implementation clues, and unresolved assumptions; its multi-stage runtime is not adopted |
| [Veritas](https://github.com/ChicagoHAI/veritas) | Claim-level reproduction with execution separated from evidence grading | Supports explicit per-claim evidence and an independent grader; its runtime is not bundled |
| [PaperBench](https://github.com/openai/frontier-evals/tree/main/project/paperbench), [AutoExperiment](https://github.com/j1mk1m/AutoExperiment), [SciReplicate-Bench](https://github.com/xyzCS/SciReplicate-Bench), [SocSci-Repro-Bench](https://github.com/malizad/SocSci-Repro-Bench), [ScienceAgentBench](https://github.com/OSU-NLP-Group/ScienceAgentBench), and [CORE-Bench](https://github.com/siegelz/core-bench) | Evaluation of author-code replay, partial or independent implementation, and scientific coding across different domains | Support separate code-source and evidence-depth decisions, explicit failure states, cost measurement, controlled tasks, and independent grading; benchmarks are evaluation inputs, not everyday workflows |
| [AI Scientist](https://github.com/SakanaAI/AI-Scientist) and [open-coscientist](https://github.com/jataware/open-coscientist) | End-to-end autonomous research systems | Architecture references, not the cost-efficient default execution model |

CORE-Bench now directs users to the Holistic Agent Leaderboard because its original harness is no longer actively maintained. It remains useful as a benchmark and dataset reference, not as a runtime dependency.

### Scientific figures and domain tools

| Route | Useful projects | Boundary in BoundedFreedom |
| --- | --- | --- |
| Claim-first editable design | [Scientific Figure Design](https://github.com/qhy991/Scientific-Figure-Design), [SciPlot](https://github.com/SciToolsmith/sci-plot) | Design the evidence and panel roles before selecting a renderer; style examples remain optional priors |
| Editable AI/CV diagrams | [PlotNeuralNet](https://github.com/HarisIqbal88/PlotNeuralNet), [NN-SVG](https://github.com/alexlenail/NN-SVG) | Prefer editable vector output and verify labels and topology |
| Method illustrations | [PaperVizAgent](https://github.com/google-research/papervizagent), [AutoFigure-Edit](https://github.com/ResearAI/AutoFigure-Edit), [LiveFigure](https://github.com/tsinghua-fib-lab/LiveFigure) | Drafting routes only; a figure contract and visual review still control the claim |
| Rebuild and figure-suite control | [FigRecipe](https://github.com/scitex-ai/figrecipe), [scientific-figure-skills](https://github.com/adjurtime/scientific-figure-skills) | Keep reproducible data/code separate from editable layout, route per panel, and audit Figure 1-N; these runtimes are optional rather than bundled |
| Neuroimaging and neuroscience | [Nilearn](https://github.com/nilearn/nilearn), [MNE-Python](https://github.com/mne-tools/mne-python), [BrainSpace](https://github.com/MICA-MNI/BrainSpace), [neuromaps](https://github.com/netneurolab/neuromaps), [netplotbrain](https://github.com/wiheto/netplotbrain), [ggseg](https://github.com/ggsegverse/ggseg) | Established execution libraries; projects must still bind space, atlas, orientation, threshold, and provenance |
| Psychology and behavioral science | [ggdist](https://github.com/mjskay/ggdist), [raincloudplots](https://github.com/jorvlan/raincloudplots), [see](https://github.com/easystats/see) | Code-first result figures from real data, not image-model reconstruction |

### Research software practice

| Source | What it contributes | Boundary in BoundedFreedom |
| --- | --- | --- |
| [rrtools](https://github.com/benmarwick/rrtools) | A research compendium that keeps research code, writing, environment, and outputs together | Informs the durable-container concept; its R package layout is not mandatory |
| [Copier](https://github.com/copier-org/copier) and [Cruft](https://github.com/cruft/cruft) | Traceable scaffold identity, drift checks, diffs, and downstream updates | Informs reviewed frame migration; upstream changes are never accepted automatically |
| [research-lab-notebook](https://github.com/osteele/agent-skills) | Durable Agent-facing state for plans, experiments, findings, and publication claims | Informs a small persistent baseline; its full file set is not required |
| [UW-SSEC RSE plugins](https://github.com/uw-ssec/rse-plugins) | Bounded planning, implementation, experiments, validation, and handoff | Informs the capability-increment loop without adding a second dispatcher or standing team |
| [The Turing Way](https://github.com/the-turing-way/the-turing-way) | Reproducible, ethical, and collaborative research practice | Broad method anchor, applied in proportion to the project |
| [pyOpenSci Python Package Guide](https://github.com/pyOpenSci/python-package-guide) | Practical public-package guidance | Used after a project has actually chosen a public-software target |
| [Scientific Python cookie](https://github.com/scientific-python/cookie) | A modern package scaffold and repository checks | Not the default for one-off analyses or small internal scripts |
| [Kedro](https://github.com/kedro-org/kedro), [Snakemake](https://github.com/snakemake/snakemake), [DVC](https://github.com/treeverse/dvc), and [DataLad](https://github.com/datalad/datalad) | Optional modular execution and data or experiment lineage | Routed only after a project demonstrates the relevant workflow or identity problem |
| [FAIR4RS](https://github.com/force11/FAIR4RS) | FAIR principles for research software | A maturity goal, not a claim that every script is FAIR or release-ready |

Coding harnesses and application-level agent frameworks are cataloged separately in the [harness landscape](harness-landscape.md). The fuller research inventory, including standards and additional experimental projects, is recorded in the [research capability inventory](../tasks/2026-09-01-research-capability-inventory.md).

## Adoption ledger by local Skill

This is the control surface for upstream influence. **Selected** means the idea is represented in the current contract. **Deferred** identifies a useful gap that needs evidence or an adapter. **Excluded** records a deliberate boundary, not unfinished work.

| Local Skill | Upstream examples | Selected now | Deferred or excluded |
| --- | --- | --- | --- |
| `cost-efficient-orchestration` | [Agent Skills](https://agentskills.io/specification), [Codex subagents](https://learn.chatgpt.com/docs/agent-configuration/subagents), [OpenAI Astra model guidance](https://developers.openai.com/api/docs/guides/latest-model?model=gpt-6-astra), [DeepSeek Harness](https://github.com/deepseek-ai/deepseek-harness), [SciAgent](https://github.com/smestern/sciagent), [open-coscientist](https://github.com/jataware/open-coscientist) | Chief accountability, progressive Skill loading, bounded execution contracts, compact phase handoffs, a balanced opportunity gate, evidence-gated frontier control, lane exit decisions, route receipts, per-unit model choice, independent review, a portable host boundary, and bounded research-lineage handoffs | **Deferred:** measured routing thresholds, authoritative cost telemetry, durable event state, and cross-project lineage synchronization. **Excluded:** task-wide luxury/basic profiles, forced model-share quotas, standing crews, recursive delegation, required graph infrastructure, and automatic merging of upstream changes |
| `evidence-review` | [scientific-research-skills](https://github.com/jxtse/scientific-research-skills), [systematic review Skill](https://github.com/yananlong/codex-skills/blob/main/research/research-systematic-literature-review/SKILL.md), [TARCiS](https://www.bmj.com/content/385/bmj-2023-078384), [citationchaser](https://github.com/nealhaddaway/citationchaser), [PaperQA2](https://github.com/Future-House/paper-qa), [ASReview](https://github.com/asreview/asreview), [STORM](https://github.com/stanford-oval/storm), [SciAtlas](https://github.com/zjunlp/SciAtlas) | Progressive reading, rapid/bounded/systematic modes, domain profiles, labeled seed calibration, versioned queries and repair, supplementary citation searching, source-evidence-claim IDs, bounded gaps, contradiction checks, conclusion bounds, and stopping rules | **Deferred:** database, citationchaser, PaperQA2, ASReview, SciAtlas, and graph-view adapters. **Excluded:** comprehensive mode as the daily default, citation-only or corpus-QA completeness claims, unlogged query expansion, and graph structure or generated reports as scientific evidence |
| `hypothesis-study-design` | [ResearchAgent](https://github.com/JinheonBaek/ResearchAgent), [HypoGeniC/HypoRefine](https://github.com/ChicagoHAI/hypothesis-generation), [CKM-HypoGen](https://github.com/TaoJinkai/ckm-hypogen), [BioSkills](https://github.com/nggsam/bioskills), [Scientific Agent Skills](https://github.com/K-Dense-AI/scientific-agent-skills) | Competing hypotheses, null or artifact alternatives, falsifiable and discriminating predictions, confounders, estimand and statistical-plan fields, stable evidence and observation links, versioned findings, bounded downstream handoffs, and a human freeze point | **Deferred:** measured scoring or refinement loops and domain-specific study adapters. **Excluded:** one attractive story, coherence or graph position as evidence, required persistent workspaces, and autonomous ethics or irreversible study decisions |
| `scientific-data-quality` | [Frictionless Table Schema](https://specs.frictionlessdata.io/table-schema/), [scikit-learn data-leakage guidance](https://scikit-learn.org/stable/common_pitfalls.html), [W3C PROV-O](https://www.w3.org/TR/prov-o/), and [Kapoor and Narayanan](https://doi.org/10.1016/j.patter.2023.100804) | Explicit field, key, and missing-value contracts; aggregate QC states; reversible exclusion accounting; split-before-fit discipline; group, entity, and temporal leakage questions; ordered source-to-transform lineage; and honest remaining uncertainty | **Deferred:** adapters for validation frameworks, catalogs, and project pipelines. **Excluded:** one quality score, automatic cleaning, statistical inference, result interpretation, and ownership of an end-to-end pipeline |
| `paper-code-reproduction` | [research-paper-code-study](https://github.com/baizhanxu/research-paper-code-study-codex-skill), [paperReproductAgent](https://github.com/Winter-And-You-Gone/paperReproductAgent), [ReproAgent](https://arxiv.org/abs/2608.24291), [xKG](https://github.com/zjunlp/xKG), [Paper2Code](https://github.com/going-doer/Paper2Code), [DeepCode](https://github.com/HKUDS/DeepCode), [Veritas](https://github.com/ChicagoHAI/veritas), [AutoExperiment](https://github.com/j1mk1m/AutoExperiment), [SocSci-Repro-Bench](https://github.com/malizad/SocSci-Repro-Bench), [PaperBench](https://github.com/openai/frontier-evals/tree/main/project/paperbench), [ScienceAgentBench](https://github.com/OSU-NLP-Group/ScienceAgentBench), and [CORE-Bench](https://github.com/siegelz/core-bench) | Separate implementation-source and evidence-depth axes; repository source receipts; paper-derived requirements and separate reference evidence; frozen identities; semantic repair records; resource gates; stable lineage inputs; run and finding receipts; a cost ladder; distinct claim states; and independent grading | **Deferred:** automatic claim extraction, external knowledge-graph infrastructure, container/GPU runtime, benchmark adapters, and measured routing calibration. **Excluded:** generated or runnable code as reproduction proof, silent protocol downscaling, undisclosed repair identity, and one aggregate score as the whole truth |
| `scientific-figure` | [Scientific Figure Design](https://github.com/qhy991/Scientific-Figure-Design), [SciPlot](https://github.com/SciToolsmith/sci-plot), [scientific-figure-skills](https://github.com/adjurtime/scientific-figure-skills), [FigRecipe](https://github.com/scitex-ai/figrecipe), [PaperVizAgent](https://github.com/google-research/papervizagent), [AutoFigure-Edit](https://github.com/ResearAI/AutoFigure-Edit), [LiveFigure](https://github.com/tsinghua-fib-lab/LiveFigure), [PlotNeuralNet](https://github.com/HarisIqbal88/PlotNeuralNet), [NN-SVG](https://github.com/alexlenail/NN-SVG), and the domain libraries above | Two-stage design/build; create, revise, rebuild, audit, and suite-audit entries; panel manifests and routing; stable semantic object and label/icon/connector bindings; separate analysis/display transforms; data-code and layout authorities; scientific/visual change records; Figure 1-N semantic contracts; editable sources; three-state QA; lineage and domain checks | **Deferred:** manifest validators, format inspectors, executable adapters, reusable templates, and tested domain recipes. **Excluded:** a standing figure-agent crew, one mandatory authoring format, PDF as the only source, raster-first exact figures, image models inventing data or anatomy, pixel similarity or visual polish as scientific validity |
| `research-software-lifecycle` | [rrtools](https://github.com/benmarwick/rrtools), [Copier](https://github.com/copier-org/copier), [Cruft](https://github.com/cruft/cruft), [research-lab-notebook](https://github.com/osteele/agent-skills), [UW-SSEC RSE plugins](https://github.com/uw-ssec/rse-plugins), [scientific-agents](https://github.com/K-Dense-AI/scientific-agents), [The Turing Way](https://github.com/the-turing-way/the-turing-way), [CodeRefinery](https://github.com/coderefinery/documentation), [pyOpenSci](https://github.com/pyOpenSci/python-package-guide), [Scientific Python cookie](https://github.com/scientific-python/cookie), [Kedro](https://github.com/kedro-org/kedro), [Snakemake](https://github.com/snakemake/snakemake), [DVC](https://github.com/treeverse/dvc), [DataLad](https://github.com/datalad/datalad), [showyourwork](https://github.com/showyourwork/showyourwork), [FAIR4RS](https://github.com/force11/FAIR4RS), and [JOSS](https://github.com/openjournals/joss) | A living research-software container with a continuous accepted baseline; one bounded capability increment at a time; explicit separation of purpose/reuse from execution shape; reviewed frame migration; proportionate engineering; optional tool routing; reproducibility receipts; and bounded research-lineage links | **Deferred:** executable scaffold, migration, workflow, data-lineage, release, container, and HPC adapters until real projects justify them. **Excluded:** automatic template merging, a large persistent state machine, a second evidence database, standing software agents, packaging every script, and mandatory public, FAIR, workflow, data-version, container, or HPC machinery |

An item moves from **deferred** to **selected** only after a real task shows value, the smallest useful contract or adapter is identified, licensing is checked, and cost and verification evidence are recorded. This prevents the repository from measuring progress by Skill count.

## Known gaps, not placeholder Skills

- Statistical analysis and post-result inference do not yet have one cross-domain Skill; project rules and the hypothesis/study contract currently carry that boundary.
- Literature databases, plotting libraries, reproduction runtimes, and software scaffolds do not yet have tested adapters.
- Scientific writing and claim-to-evidence tracing are represented only by upstream references, not a local Skill.
- Cost, token, latency, and quality savings remain unmeasured claims; route receipts now define the forward data contract, but repeated accepted-work calibration and an authoritative cost source are still needed.

These are candidates for evidence-driven additions. They should not become folders until repeated use shows a stable method that is not already owned by a project or external tool.

## What BoundedFreedom adds

The projects above are often strongest at one part of the lifecycle. BoundedFreedom adds a small coordination layer across them:

1. **Separate four decisions.** Task method chooses the process; execution contract sets ownership and permissions; model and effort supply capability; S0-S4 sets evidence, independent review, and human acceptance.
2. **Keep Chief accountable.** A specialist Skill or worker may return evidence, but the primary session keeps intent, integration, verification, and the final decision.
3. **Load methods only when needed.** Six focused research Skills replace a giant standing prompt or a permanent team of agents.
4. **Route phases through a cost ladder.** Keep frontier capability on the hard control boundary, prefer balanced capability for stable coordinated work, and return mechanical follow-up to the fast lane through a compact checkpoint.
5. **Name the evidence state honestly.** Search coverage is bounded; code running is not method implementation; method implementation is not claim reproduction; visual polish is not scientific validity.
6. **Let software grow in accepted increments.** Keep purpose and reuse, execution shape, the accepted baseline, and the next increment separate; add machinery only when a present need earns it.

These are design choices and working contracts. Their real cost and quality benefits still need evidence from repeated use, not only repository documentation.

## Credit and reuse policy

- Credit conceptual influences with a direct link and a short statement of what was learned.
- Before copying or adapting text, code, prompts, templates, icons, or data, record the exact source version and review its license. Preserve any required notices.
- Keep third-party tools optional unless a frozen task needs them. A useful upstream project does not automatically become a dependency or a Skill.
- Do not imply that an upstream author endorses BoundedFreedom.
- Record substantial source adoption or replacement in one task record, together with verification and remaining uncertainty.

## Upstream watch policy

This page is also the human-readable watchlist. Review it before a substantial Skill change and on a light periodic schedule.

For each relevant update, check:

- release notes or important default-branch changes;
- method, interface, or evaluation changes that affect a local contract;
- license or attribution changes;
- maintenance status and reproducible evidence, not star count alone;
- whether the smallest useful idea should be adopted, deferred, or rejected.

Upstream changes should create a review item, not an automatic merge. Chief records the reviewed version, the local effect, verification, and the decision. **GitHub Star** is useful for acknowledgement and discovery; **Watch releases** or a scheduled review is the update signal.

Snapshot reviewed: 2026-09-05. Links and project status may change.
