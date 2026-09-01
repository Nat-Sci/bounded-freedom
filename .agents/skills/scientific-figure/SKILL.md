---
name: scientific-figure
description: Plan, create, revise, or audit scientific figures for data and statistics, AI/CV architectures, method schematics, neuroimaging, neuroscience, or psychology. Use when scientific meaning, provenance, editability, captioning, or visual verification matters; not for general promotional artwork.
---

# Scientific figure

A scientific figure is a visual argument. Freeze the argument before choosing a drawing tool.

## Route the figure

- **Data, statistical, or result figure:** code-first from real source data. Never ask an image model to invent values, axes, uncertainty, significance, or anatomy.
- **AI/CV architecture:** prefer editable vector or code-native output such as SVG, LaTeX, Draw.io, Mermaid, or PowerPoint.
- **Method schematic:** write a figure contract, then create an editable draft. Generated raster imagery may support illustration but cannot decide topology or labels.
- **Domain visualization:** use established scientific libraries and verify domain-specific orientation, space, scales, thresholds, and uncertainty.

Read [references/figure-contract-and-routes.md](references/figure-contract-and-routes.md) before creating a multi-panel figure, neuroimaging or electrophysiology figure, architecture diagram, or publication-ready asset.

## Work-unit model guidance

| Work unit | Start with |
| --- | --- |
| Locate data, plotting code, labels, assets, and provenance | Fast / Scout |
| Make a narrow plotting edit after the figure contract is frozen | Fast / Coder |
| Build a coordinated multi-panel figure, data path, or editable schematic | Balanced / Builder |
| Resolve ambiguous scientific meaning, misleading encoding, anatomy, or statistical conflict | Strong / Chief |

An image model is a drawing tool, not a stronger reasoning lane. Data, labels, topology, and scientific checks remain code- or evidence-led. Use the general orchestration route for work not listed here.

## Workflow

1. Freeze the message, audience, target venue, panels, inputs, visual encodings, required labels, and prohibited implications.
2. Choose the route and the simplest editable source that preserves scientific meaning.
3. Bind data, analysis, coordinate systems, atlases, models, or references used by the figure.
4. Build content before decoration. Preserve code or editable source alongside the rendered artifact.
5. Inspect the rendered figure at full size and intended publication size.
6. Check labels, legends, units, color scale, contrast, accessibility, panel order, anatomy, and caption agreement.
7. Record provenance and unresolved visual or scientific uncertainty.

## Required return

- figure contract and selected route;
- editable source and rendered artifact;
- data, code, model, anatomy, and external-asset provenance;
- visual inspection result and scientific checks;
- caption or caption inputs;
- known limitations and any human review required.

## Boundaries

- Attractive output is not evidence that the visual encoding or scientific interpretation is correct.
- Do not manually place values that should be generated from data.
- Do not silently flip hemispheres, change coordinate space, interpolate labels, alter thresholds, or change exclusions to improve appearance.
- Preserve the license and attribution of external icons, templates, fonts, and anatomical assets.
- These rows are starting points. Chief retains the final model, delegation, S0–S4, and acceptance decisions.

## Influences and credits

This Skill is an original synthesis informed by figure-contract and editable-output ideas across [PaperVizAgent](https://github.com/google-research/papervizagent), [AutoFigure-Edit](https://github.com/ResearAI/AutoFigure-Edit), and related scientific figure projects, plus established domain libraries such as Nilearn and MNE-Python. Those tools are optional routes, not bundled dependencies. See [ecosystem, influences, and credits](../../../docs/ecosystem-and-credits.md).
