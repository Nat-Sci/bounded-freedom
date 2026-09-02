# Figure contract and routes

Use only the sections relevant to the current figure.

## Figure contract

```text
figure_id_and_purpose
one_sentence_visual_claim
source_claim_study_run_analysis_or_finding_ids
audience_and_venue
panel_list_and_reading_order
panel_to_lineage_id_map
source_data_or_reference
analysis_or_transformation
visual_encoding
required_labels_units_legends
color_and_accessibility_constraints
anatomy_coordinate_or_model_constraints
prohibited_implications
editable_source_format
rendered_formats_and_size
caption_inputs
verification_and_human_freeze
```

If the one-sentence visual claim cannot be written, the figure is not ready to draw.

When lineage is in scope, record the rendered figure as an artifact that `visualizes` the retained IDs. A caption may state only claims supported within those records and their boundaries. See the shared [research-lineage contract](../../cost-efficient-orchestration/research-lineage.md).

## Data and statistical figures

- Generate plotted values from a retained data or summary table.
- Bind the analysis script, exclusions, aggregation, uncertainty, and random seed where relevant.
- Show distributions, observations, uncertainty, and model diagnostics when they affect interpretation.
- Verify axis limits, transformations, units, missingness, multiplicity marks, and legend-to-data correspondence.

## AI and CV architecture

Map every visual block to an implemented or explicitly proposed component. Use arrows with defined direction and semantics. Separate training-only and inference paths. Show tensor shapes only when verified.

Useful editable routes include [PlotNeuralNet](https://github.com/HarisIqbal88/PlotNeuralNet), [NN-SVG](https://github.com/alexlenail/NN-SVG), SVG, LaTeX, Draw.io, and PowerPoint.

## Method schematics

[PaperVizAgent](https://github.com/google-research/papervizagent) can support reference-driven drafts. [AutoFigure-Edit](https://github.com/ResearAI/AutoFigure-Edit) and [LiveFigure](https://github.com/tsinghua-fib-lab/LiveFigure) emphasize editable reconstruction. Treat all generated topology, arrows, labels, and citations as unverified until inspected against the method.

[Bioicons](https://bioicons.com/) can supply biology and neuroscience assets, but preserve the license and attribution of each selected item.

## Neuroimaging and neuroscience routes

| Need | Preferred execution routes | Mandatory checks |
| --- | --- | --- |
| MRI/fMRI volume or surface | [Nilearn](https://github.com/nilearn/nilearn), [surfplot](https://github.com/danjgale/surfplot), [pycortex](https://github.com/gallantlab/pycortex) | image space, orientation, hemisphere, atlas, threshold, interpolation, color scale |
| Gradients and map comparison | [BrainSpace](https://github.com/MICA-MNI/BrainSpace), [neuromaps](https://github.com/netneurolab/neuromaps) | surface density, correspondence, null model, spatial autocorrelation |
| Network neuroscience | [netplotbrain](https://github.com/wiheto/netplotbrain) | node identity, coordinate system, edge threshold and sign |
| EEG/MEG/iEEG/ECoG | [MNE-Python](https://github.com/mne-tools/mne-python) | sensor or source space, reference, time/frequency window, baseline, units |
| Region-level R figures | [ggseg](https://github.com/ggsegverse/ggseg) | atlas version, hemisphere, region matching, missing regions |

Use [BIDS](https://github.com/bids-standard/bids-specification) identities and relevant [COBIDAS](https://github.com/ohbm/cobidas-mri) fields when they govern the input or report.

## Psychology and behavioral routes

[ggdist](https://github.com/mjskay/ggdist), [raincloudplots](https://github.com/jorvlan/raincloudplots), and [see](https://github.com/easystats/see) support distributions, uncertainty, and model diagnostics. Preserve participant-level structure, repeated-measure relationships, scale direction, missingness, and uncertainty.

## Visual QA

Inspect both the editable source and final render for:

- clipped or overlapping text;
- misleading aspect ratios, scales, or area encodings;
- unreadable labels at final size;
- color-vision and grayscale failure;
- rasterization or transparency artifacts;
- disagreement between panels, caption, and analysis output.
