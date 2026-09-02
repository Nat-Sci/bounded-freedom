# Ecosystem, influences, and credits

BoundedFreedom did not begin from a blank page. Research methods, agent Skills, scientific tools, benchmarks, and coding harnesses already solve important parts of the problem. This page explains what those projects do, what BoundedFreedom learns from them, and where the boundary remains.

A link here means **influence or interoperability**, not bundled code, endorsement, or automatic trust. The current V0.1 Skills are an original synthesis. Third-party repositories are not vendored or installed by default.

## What the repository owns

| Area | Question | Current BoundedFreedom boundary |
| --- | --- | --- |
| Control plane | Who may do what, with which model, evidence, and human gate? | Owned here: Constitution, Chief, execution contracts, model routing, S0–S4, task records, and installer |
| Method plane | What disciplined process should this task follow? | Owned here: five small research Skills loaded on demand |
| Capability plane | Which database, library, runtime, or external service performs the work? | Selected per project; not bundled into Chief or installed by default |
| Evaluation plane | How are quality, cost, reproduction, and failure types measured? | External benchmarks are references; local calibration is still needed |
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
| [Veritas](https://github.com/ChicagoHAI/veritas) | Claim-level reproduction with execution separated from evidence grading | Supports explicit per-claim evidence and an independent grader; its runtime is not bundled |
| [PaperBench](https://github.com/openai/frontier-evals/tree/main/project/paperbench), [SciReplicate-Bench](https://github.com/xyzCS/SciReplicate-Bench), [ScienceAgentBench](https://github.com/OSU-NLP-Group/ScienceAgentBench), and [CORE-Bench](https://github.com/siegelz/core-bench) | Evaluation of replication or scientific coding work | Support explicit evidence states, cost measurement, containerized tasks, and independent grading; benchmarks are evaluation inputs, not everyday workflows |
| [AI Scientist](https://github.com/SakanaAI/AI-Scientist) and [open-coscientist](https://github.com/jataware/open-coscientist) | End-to-end autonomous research systems | Architecture references, not the cost-efficient default execution model |

CORE-Bench now directs users to the Holistic Agent Leaderboard because its original harness is no longer actively maintained. It remains useful as a benchmark and dataset reference, not as a runtime dependency.

### Scientific figures and domain tools

| Route | Useful projects | Boundary in BoundedFreedom |
| --- | --- | --- |
| Editable AI/CV diagrams | [PlotNeuralNet](https://github.com/HarisIqbal88/PlotNeuralNet), [NN-SVG](https://github.com/alexlenail/NN-SVG) | Prefer editable vector output and verify labels and topology |
| Method illustrations | [PaperVizAgent](https://github.com/google-research/papervizagent), [AutoFigure-Edit](https://github.com/ResearAI/AutoFigure-Edit), [LiveFigure](https://github.com/tsinghua-fib-lab/LiveFigure) | Drafting routes only; a figure contract and visual review still control the claim |
| Neuroimaging and neuroscience | [Nilearn](https://github.com/nilearn/nilearn), [MNE-Python](https://github.com/mne-tools/mne-python), [BrainSpace](https://github.com/MICA-MNI/BrainSpace), [neuromaps](https://github.com/netneurolab/neuromaps), [netplotbrain](https://github.com/wiheto/netplotbrain), [ggseg](https://github.com/ggsegverse/ggseg) | Established execution libraries; projects must still bind space, atlas, orientation, threshold, and provenance |
| Psychology and behavioral science | [ggdist](https://github.com/mjskay/ggdist), [raincloudplots](https://github.com/jorvlan/raincloudplots), [see](https://github.com/easystats/see) | Code-first result figures from real data, not image-model reconstruction |

### Research software practice

| Source | What it contributes | Boundary in BoundedFreedom |
| --- | --- | --- |
| [The Turing Way](https://github.com/the-turing-way/the-turing-way) | Reproducible, ethical, and collaborative research practice | Broad method anchor, applied in proportion to the project |
| [pyOpenSci Python Package Guide](https://github.com/pyOpenSci/python-package-guide) | Practical public-package guidance | Used after a project has actually chosen a public-software target |
| [Scientific Python cookie](https://github.com/scientific-python/cookie) | A modern package scaffold and repository checks | Not the default for one-off analyses or small internal scripts |
| [FAIR4RS](https://github.com/force11/FAIR4RS) | FAIR principles for research software | A maturity goal, not a claim that every script is FAIR or release-ready |

Coding harnesses and application-level agent frameworks are cataloged separately in the [harness landscape](harness-landscape.md). The fuller research inventory, including standards and additional experimental projects, is recorded in the [research capability inventory](../tasks/2026-09-01-research-capability-inventory.md).

## Adoption ledger by local Skill

This is the control surface for upstream influence. **Selected** means the idea is represented in the current contract. **Deferred** identifies a useful gap that needs evidence or an adapter. **Excluded** records a deliberate boundary, not unfinished work.

| Local Skill | Upstream examples | Selected now | Deferred or excluded |
| --- | --- | --- | --- |
| `cost-efficient-orchestration` | [Agent Skills](https://agentskills.io/specification), [Codex subagents](https://learn.chatgpt.com/docs/agent-configuration/subagents), [DeepSeek Harness](https://github.com/deepseek-ai/deepseek-harness), [SciAgent](https://github.com/smestern/sciagent), [open-coscientist](https://github.com/jataware/open-coscientist) | Chief accountability, progressive Skill loading, bounded execution contracts, per-unit model choice, independent review, and a portable host boundary | **Deferred:** measured router, cost telemetry, durable event state. **Excluded:** task-wide luxury/basic profiles, standing crews, recursive delegation, and automatic merging of upstream changes |
| `evidence-review` | [scientific-research-skills](https://github.com/jxtse/scientific-research-skills), [systematic review Skill](https://github.com/yananlong/codex-skills/blob/main/research/research-systematic-literature-review/SKILL.md), [PaperQA2](https://github.com/Future-House/paper-qa), [ASReview](https://github.com/asreview/asreview), [STORM](https://github.com/stanford-oval/storm), [SciAtlas](https://github.com/zjunlp/SciAtlas) | Progressive reading, rapid/bounded/systematic modes, search and corpus freeze, evidence tables, contradiction checks, conclusion bounds, and stopping rules | **Deferred:** database, PaperQA2, ASReview, and SciAtlas adapters. **Excluded:** comprehensive mode as the daily default, corpus QA as completeness proof, and generated reports as systematic or novelty evidence |
| `hypothesis-study-design` | [ResearchAgent](https://github.com/JinheonBaek/ResearchAgent), [HypoGeniC/HypoRefine](https://github.com/ChicagoHAI/hypothesis-generation), [BioSkills](https://github.com/nggsam/bioskills), [Scientific Agent Skills](https://github.com/K-Dense-AI/scientific-agent-skills) | Competing hypotheses, null or artifact alternatives, falsifiable and discriminating predictions, confounders, estimand and statistical-plan fields, and a human freeze point | **Deferred:** measured scoring or refinement loops and domain-specific study adapters. **Excluded:** one attractive story, coherence as evidence, and autonomous ethics or irreversible study decisions |
| `paper-code-reproduction` | [research-paper-code-study](https://github.com/baizhanxu/research-paper-code-study-codex-skill), [xKG](https://github.com/zjunlp/xKG), [Paper2Code](https://github.com/going-doer/Paper2Code), [DeepCode](https://github.com/HKUDS/DeepCode), [Veritas](https://github.com/ChicagoHAI/veritas), [PaperBench](https://github.com/openai/frontier-evals/tree/main/project/paperbench), [ScienceAgentBench](https://github.com/OSU-NLP-Group/ScienceAgentBench), [CORE-Bench](https://github.com/siegelz/core-bench) | Understanding/smoke/claim modes, claim-to-code mapping, frozen identities, a cost ladder, distinct evidence states, numerical comparison, and independent grading | **Deferred:** claim extraction, knowledge graph, container/GPU runtime, and benchmark adapters. **Excluded:** generated or runnable code as reproduction proof and one aggregate score as the whole truth |
| `scientific-figure` | [PaperVizAgent](https://github.com/google-research/papervizagent), [AutoFigure-Edit](https://github.com/ResearAI/AutoFigure-Edit), [LiveFigure](https://github.com/tsinghua-fib-lab/LiveFigure), [PlotNeuralNet](https://github.com/HarisIqbal88/PlotNeuralNet), [NN-SVG](https://github.com/alexlenail/NN-SVG), and the domain libraries above | Figure contract, code-first result figures, editable sources, route-specific tools, provenance, render inspection, and scientific/domain checks | **Deferred:** executable adapters, reusable templates, and tested domain recipes. **Excluded:** raster-first exact figures, image models inventing data or anatomy, and visual polish as validity |
| `research-software-lifecycle` | [scientific-agents](https://github.com/K-Dense-AI/scientific-agents), [The Turing Way](https://github.com/the-turing-way/the-turing-way), [CodeRefinery](https://github.com/coderefinery/documentation), [pyOpenSci](https://github.com/pyOpenSci/python-package-guide), [Scientific Python cookie](https://github.com/scientific-python/cookie), [showyourwork](https://github.com/showyourwork/showyourwork), [FAIR4RS](https://github.com/force11/FAIR4RS), [JOSS](https://github.com/openjournals/joss) | A maturity decision before engineering, proportionate interfaces/tests/docs/CI/releases/citation/containers/HPC, and a reproducibility receipt | **Deferred:** scaffolds, automated checkers, release/DOI, container, and HPC adapters. **Excluded:** packaging every script and requiring public, FAIR, container, or HPC machinery by default |

An item moves from **deferred** to **selected** only after a real task shows value, the smallest useful contract or adapter is identified, licensing is checked, and cost and verification evidence are recorded. This prevents the repository from measuring progress by Skill count.

## Known gaps, not placeholder Skills

- Scientific data analysis and post-result inference do not yet have one cross-domain Skill; project rules and the hypothesis/study contract currently carry that boundary.
- Literature databases, plotting libraries, reproduction runtimes, and software scaffolds do not yet have tested adapters.
- Scientific writing and claim-to-evidence tracing are represented only by upstream references, not a local Skill.
- Cost, token, latency, and quality savings are design goals, not measured claims; a small repeated-task benchmark and routing receipts are still needed.

These are candidates for evidence-driven additions. They should not become folders until repeated use shows a stable method that is not already owned by a project or external tool.

## What BoundedFreedom adds

The projects above are often strongest at one part of the lifecycle. BoundedFreedom adds a small coordination layer across them:

1. **Separate four decisions.** Task method chooses the process; execution contract sets ownership and permissions; model and effort supply capability; S0-S4 sets evidence, independent review, and human acceptance.
2. **Keep Chief accountable.** A specialist Skill or worker may return evidence, but the primary session keeps intent, integration, verification, and the final decision.
3. **Load methods only when needed.** Five focused research Skills replace a giant standing prompt or a permanent team of agents.
4. **Name the evidence state honestly.** Search coverage is bounded; code running is not method implementation; method implementation is not claim reproduction; visual polish is not scientific validity.
5. **Let engineering grow with the work.** A one-off analysis, an internal package, public research software, and an HPC pipeline should not receive the same amount of machinery.

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

Snapshot reviewed: 2026-09-02. Links and project status may change.
