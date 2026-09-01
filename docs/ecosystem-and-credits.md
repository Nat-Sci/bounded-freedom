# Ecosystem, influences, and credits

BoundedFreedom did not begin from a blank page. Research methods, agent Skills, scientific tools, benchmarks, and coding harnesses already solve important parts of the problem. This page explains what those projects do, what BoundedFreedom learns from them, and where the boundary remains.

A link here means **influence or interoperability**, not bundled code, endorsement, or automatic trust. The current V0.1 Skills are an original synthesis. Third-party repositories are not vendored or installed by default.

## The related-work map

### Research methods and Skill collections

| Project | What it contributes | How BoundedFreedom uses the idea |
| --- | --- | --- |
| [scientific-research-skills](https://github.com/jxtse/scientific-research-skills) | Practical search and progressive paper-reading methods | Supports the distinction between a quick orientation and a deeper evidence review; adapters are not loaded by default |
| [systematic literature review Skill](https://github.com/yananlong/codex-skills/blob/main/research/research-systematic-literature-review/SKILL.md) | Review modes, corpus freeze, search records, evidence tables, and assurance checks | Informs `evidence-review`; BoundedFreedom keeps a lighter bounded evidence map as the normal mode |
| [research-paper-code-study](https://github.com/baizhanxu/research-paper-code-study-codex-skill) | Mapping a paper concept to files, classes, functions, and configuration | Informs the understanding mode of `paper-code-reproduction`; runnable code is still not treated as reproduced evidence |
| [scientific-agents](https://github.com/K-Dense-AI/scientific-agents) | Profession-specific context, including research software engineering | Used selectively at project or specialist scope; it does not replace Chief with a permanent persona |
| [Scientific Agent Skills](https://github.com/K-Dense-AI/scientific-agent-skills) | A broad catalog of research Skills and scientific data routes | A source to inspect selectively, not a catalog to install or load wholesale |

### Research systems, tools, and evaluation

| Project | Main role | Boundary in BoundedFreedom |
| --- | --- | --- |
| [codex-PaperFactory](https://github.com/happystander/codex-PaperFactory) | Persistent end-to-end research state and recovery | Advanced system reference; too much machinery for the default path |
| [PaperQA2](https://github.com/Future-House/paper-qa) | Cited question answering over an available paper corpus | Optional retrieval tool; cannot establish that the corpus is complete |
| [ASReview](https://github.com/asreview/asreview) | Active-learning support for large screening sets | Optional screening tool; human decisions and protocol evidence remain necessary |
| [Paper2Code](https://github.com/going-doer/Paper2Code) and [DeepCode](https://github.com/HKUDS/DeepCode) | Building code from papers and other technical sources | Builder references; generated code is not evidence that a scientific claim was reproduced |
| [PaperBench](https://github.com/openai/frontier-evals/tree/main/project/paperbench), [SciReplicate-Bench](https://github.com/xyzCS/SciReplicate-Bench), and [ScienceAgentBench](https://github.com/OSU-NLP-Group/ScienceAgentBench) | Evaluation of replication or scientific coding work | Support explicit evidence states and independent grading |
| [AI Scientist](https://github.com/SakanaAI/AI-Scientist) and [open-coscientist](https://github.com/jataware/open-coscientist) | End-to-end autonomous research systems | Architecture references, not the cost-efficient default execution model |

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

## What BoundedFreedom adds

The projects above are often strongest at one part of the lifecycle. BoundedFreedom adds a small coordination layer across them:

1. **Separate the task, the model, and the risk.** A literature review, a figure, and a code change choose different methods. Each bounded work unit chooses the least costly capable model. S0-S4 controls evidence and review rather than naming the task or model.
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

Snapshot reviewed: 2026-09-01. Links and project status may change.
