---
name: scientific-figure
description: Design, create, revise, rebuild, or audit scientific figures and figure suites when scientific meaning, provenance, editability, captioning, or visual verification matters; not for general promotional artwork.
---

# Scientific figure

A scientific figure is a visual argument. Freeze what the figure must communicate before choosing how to draw it.

## Select the entry

Choose one operation before changing an artifact:

- **Create:** design and build a new figure.
- **Revise:** change an existing figure within a declared scientific or visual scope.
- **Rebuild:** regenerate from the retained data/code and layout authorities rather than patching a rendered output.
- **Audit:** inspect one figure without changing it unless the user separately authorizes repair.
- **Suite audit:** inspect Figure 1-N as one semantic and visual system.

## Work in two stages

### 1. Design

Freeze the visual claim, evidence and lineage, panel roles, reading order, analysis and display transformations, shared semantics, layout grid, safe area, object anchors, allowed overlaps, prohibited implications, and acceptance checks. Use a manifest for a multi-panel figure or figure suite. A design remains `draft` until these decisions are explicit; only `frozen` designs proceed to a consequential build.

Read [figure contract and build routes](references/figure-contract-and-routes.md) before designing a multi-panel, architecture, neuroimaging, electrophysiology, or publication-ready figure.

### 2. Build and verify

Route each panel from its scientific source and representation need. Prefer TikZ or PGFPlots for structured geometry, formulas, precise annotations, or suitable LaTeX-native plots. Use code-first SVG/PDF for quantitative plots, established domain tools for measured images and maps, and SVG/Draw.io or PPTX when irregular or collaborative vector editing is the limiting factor. PDF is a delivery container, not an editable authority, and neither PDF nor PPTX guarantees that every object is vector.

Preserve two authorities when they differ: data and analysis code own values and data geometry; the editable layout source owns panel placement, typography, annotations, and assembly. A layout tool must not silently alter code-derived content.

Read [suite manifest and QA](references/suite-manifest-and-qa.md) when tracking panels, revisions, rebuilds, shared Figure 1-N semantics, or machine checks.

Read the shared [research-lineage contract](../cost-efficient-orchestration/research-lineage.md) when a figure communicates a retained claim or finding. Pass only the IDs and records the figure actually uses.

## Required controls

1. Route and record each panel independently; do not force a whole figure through one renderer.
2. Keep analysis transformations separate from display-only transformations.
3. Record the data/code authority and editable layout authority.
4. Track scientific and visual changes separately; uncertainty is treated as scientific until resolved.
5. Give Figure 1-N a shared semantic contract for terms, colors, groups, units, scales, anatomy, and stated exceptions.
6. End each required QA layer with `pass`, `fail`, or `unverified`. Visual QA must inspect the final render at full and smallest intended viewing size; missing evidence is never a pass.
7. Bind every non-decorative label, icon, legend key, and connector to a stable semantic object ID. One label has one target by default; shared labels, multi-target connectors, and intentionally unlabeled objects require an explicit exception. Proximity, numbering, or visual similarity alone is not a binding.

## Work-unit model guidance

| Work unit | Execution contract | Capability lane |
| --- | --- | --- |
| Locate data, plotting code, labels, assets, and provenance | Scout | Fast and economical |
| Make a narrow edit after design and ownership are frozen | Coder | Fast and economical |
| Build or rebuild a coordinated multi-panel figure and its editable sources | Builder | Balanced |
| Resolve ambiguous scientific meaning, misleading encoding, anatomy, or statistical conflict | Chief, direct; Reviewer when independence is required | Strong reasoning |

Deterministic manifest, file, format, and render checks should run as tools rather than consume strong-model judgment. An image model is a drawing tool, not a reasoning lane. Use the general orchestration route for work not listed here.

## Required return

- selected entry and frozen or unresolved design contract;
- panel manifest, selected route, editable source, and rendered artifact;
- semantic object and label/icon/connector bindings when the figure contains diagrams, legends, callouts, or routed elements;
- data/code and layout authorities, transformations, external assets, and lineage links;
- scientific and visual change records when revising or rebuilding;
- machine, visual, and scientific QA results as `pass`, `fail`, or `unverified`;
- caption inputs, known limitations, and required human or independent review.

## Boundaries

- Attractive output is not evidence that the visual encoding or interpretation is correct.
- Do not manually place values that should be generated from data.
- Do not silently change cohorts, exclusions, aggregation, thresholds, coordinate space, hemispheres, atlases, interpolation, labels, or uncertainty to improve appearance.
- A display transformation that changes the visible scientific comparison is a scientific change.
- Preserve the license and attribution of external icons, templates, fonts, and anatomical assets.
- Treat image-model-generated labels, icons, arrows, and topology as `unverified` until their declared bindings and meanings are checked against the frozen design.
- A figure visualizes evidence or a finding; it is not additional independent evidence.
- Chief retains final model, delegation, S0-S4, and acceptance decisions.

## Upstream adoption

- **Selected:** claim-first design, two-stage design/build separation, five operation entries, panel manifests, stable semantic object and label/icon/connector bindings, dual authorities, reproducible rebuilds, editable vector sources, Figure 1-N semantic contracts, separated change scopes, three-state QA, and domain checks.
- **Not selected now:** a standing figure-agent crew, one mandatory authoring format, PDF as the only source, bundled plotting runtimes or templates, pixel similarity as scientific validity, or image models inventing values, anatomy, labels, and topology.

The source-by-source decision is in the [adoption ledger](../../../docs/ecosystem-and-credits.md#adoption-ledger-by-local-skill).

## Influences and credits

This Skill is an original synthesis informed by [Scientific Figure Design](https://github.com/qhy991/Scientific-Figure-Design), [SciPlot](https://github.com/SciToolsmith/sci-plot), [scientific-figure-skills](https://github.com/adjurtime/scientific-figure-skills), [FigRecipe](https://github.com/scitex-ai/figrecipe), [PaperVizAgent](https://github.com/google-research/papervizagent), [AutoFigure-Edit](https://github.com/ResearAI/AutoFigure-Edit), and established domain libraries. These remain references or optional routes, not bundled dependencies. See [ecosystem, influences, and credits](../../../docs/ecosystem-and-credits.md).
