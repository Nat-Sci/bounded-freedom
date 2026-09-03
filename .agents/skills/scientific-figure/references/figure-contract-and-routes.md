# Figure contract and build routes

Use this reference to freeze a scientific figure design and then select a route for each panel.

## Five entries

| Entry | Starting point | Allowed result |
| --- | --- | --- |
| `create` | Claim, evidence, data, or method without a figure | Frozen design, editable source, render, and QA |
| `revise` | Existing source or render plus a requested change | Bounded scientific or visual change with before/after evidence |
| `rebuild` | Retained data/code authority and layout authority | Regenerated artifact; recovered content stays unverified until rebound to its sources |
| `audit` | One existing figure | Read-only findings and a prioritized repair plan |
| `suite-audit` | Figure 1-N and their captions or manuscript context | Read-only semantic, scientific, and visual consistency findings |

Do not turn an audit into an edit without explicit authorization.

## Stage 1: design

Record only fields that affect the task, but do not omit unresolved scientific meaning.

```text
operation
figure_or_suite_id
purpose_and_one_sentence_visual_claim
source_claim_study_run_analysis_or_finding_ids
audience_venue_final_size_and_smallest_review_size
panel_ids_roles_and_reading_order
panel_to_lineage_map
layout_grid_safe_area_object_anchors_and_allowed_overlaps
source_data_model_method_or_reference
analysis_transformations
display_transformations
visual_encoding_and_comparison_task
required_labels_units_legends_and_uncertainty
semantic_object_ids_and_label_icon_connector_bindings
shared_terms_colors_scales_and_domain_conventions
prohibited_implications_and_counter_readings
data_code_authority
editable_layout_authority
planned_rendered_formats
caption_inputs
required_machine_visual_scientific_and_human_checks
design_status: draft | frozen
```

If the visual claim, panel roles, authorities, or forbidden readings are unresolved, keep the design `draft`. Audit operations may examine draft or legacy figures, but a new consequential build requires `frozen`.

Every label, legend, connector, inset, and annotation must be anchored to a named panel, object, data mark, or layout region. Record intentional overlaps; an unplanned overlap is a defect even when every element remains technically visible. Inspect one full-size render and the smallest intended viewing size. If a crop or alternate aspect ratio is a deliverable, give it a separate layout contract rather than relying on automatic cropping.

### Semantic binding contract

Layout anchors answer where an element is placed; semantic bindings answer what it refers to. Freeze both before a diagram, legend, callout, or routed figure is built.

Assign stable IDs to every meaning-bearing object, including panels, icons, nodes, blocks, data series, regions, legend keys, and connector endpoints. Then record only the bindings the figure actually uses:

```yaml
semantic_objects:
  - object_id: card-05
    meaning: research-software route
semantic_bindings:
  - binding_id: route-05
    label_id: label-05
    label_text: 科研软件
    target_id: card-05
    relation: names-and-routes-to
    connector_id: connector-05
    expected_label_count: 1
    expected_connector_count: 1
    meaning_authority: frozen figure design
```

The default rule is one label to one target. A shared title, grouped legend, bidirectional edge, one-to-many callout, or intentionally unlabeled object is allowed only when its scope and cardinality are declared. A connector records its source, target, and direction separately; matching colors, nearby placement, or the same visible number do not prove correspondence.

An image model or icon library may supply appearance, but it does not own meaning. The frozen design, method, data/code authority, or cited external source owns the interpretation. Rebinding a label, icon, legend key, or connector to a different meaning is a scientific or semantic change; moving the same verified binding without changing its meaning may be visual.

### Analysis versus display

- **Analysis transformation:** changes the observations, selection, aggregation, estimates, uncertainty, statistical model, threshold, coordinate mapping, or derived values. It belongs in retained analysis code or an equivalent reproducible record.
- **Display transformation:** changes only the presentation of already frozen content, such as panel placement, typography, spacing, nonsemantic line width, or export size.
- Cropping, normalization, interpolation, color limits, ordering, or thresholding are not automatically display-only. If they can change the visible comparison or interpretation, classify them as analysis or scientific transformations.

## Stage 2: panel-level build routing

Route each panel separately, then choose the simplest assembly source that preserves the frozen design.

| Panel source or need | Preferred route | Authority and checks |
| --- | --- | --- |
| Structured architecture, workflow, formula, or precise annotation | TikZ first when a working LaTeX environment exists; otherwise SVG or Draw.io | Verify topology, arrow meaning, labels, component identity, and editability |
| Simple LaTeX-native quantitative plot | PGFPlots/TikZ when data binding remains reproducible | Values and geometry come from retained data/code, never manual placement |
| Complex data, statistical, or result plot | Python, R, MATLAB, or another analysis-native library to SVG/PDF | Bind exclusions, aggregation, uncertainty, seeds, units, and analysis output |
| Irregular method schematic | TikZ, SVG, or Draw.io; PPTX when human handoff is the main constraint | Generated topology, labels, and references remain unverified until checked |
| MRI, fMRI, diffusion MRI, brain surface, tractography, EEG/MEG, or other measured map | Established domain renderer; retain raster, mesh, or vector layers as scientifically appropriate | TikZ/SVG/PPTX may assemble and label the output but must not invent the measurement |
| Mixed multi-panel figure | Generate each panel by its correct route; assemble in TikZ, SVG/Draw.io, or PPTX | Record authority, transform, and QA per panel plus the final assembly |

PDF is normally a rendered delivery artifact. PPTX is editable for collaborators but is difficult to diff and may contain raster objects. SVG and Draw.io are useful general vector fallbacks. A filename extension alone does not prove that text or graphics remain vector and editable.

## Dual authority

The two authorities may be one codebase or separate sources:

- **Data/code authority:** owns numerical values, statistical results, data geometry, coordinate mappings, and generated scientific marks.
- **Layout authority:** owns panel placement, typography, legends, annotations, arrows, and final composition.

On rebuild, regenerate scientific content from the data/code authority and reapply the retained layout authority. If the layout source contains a conflicting numerical value, geometry, label, or scientific mapping, QA must fail until the conflict is resolved.

## Scientific routes and mandatory checks

### Data and statistics

- Generate plotted values from retained data or summary tables.
- Bind analysis code, exclusions, aggregation, uncertainty, multiplicity decisions, and random seeds where relevant.
- Show distributions, observations, uncertainty, or diagnostics when omission would change interpretation.
- Verify axis limits, transformations, units, missingness, sample sizes, and legend-to-data correspondence.

### AI and CV architecture

Map each visual block to an implemented or explicitly proposed component through a stable semantic object ID. Bind its visible label and every incoming or outgoing arrow to that object; define arrow direction and semantics, distinguish training and inference, and show tensor shapes only when verified. Useful routes include [PlotNeuralNet](https://github.com/HarisIqbal88/PlotNeuralNet), [NN-SVG](https://github.com/alexlenail/NN-SVG), TikZ, SVG, Draw.io, and PPTX.

### Method schematics

[PaperVizAgent](https://github.com/google-research/papervizagent), [AutoFigure-Edit](https://github.com/ResearAI/AutoFigure-Edit), and [LiveFigure](https://github.com/tsinghua-fib-lab/LiveFigure) may support drafts or editable reconstruction. Treat generated topology, arrows, labels, and citations as unverified until inspected against the method. Preserve licenses for assets such as [Bioicons](https://bioicons.com/).

### Neuroimaging and neuroscience

| Need | Example execution routes | Mandatory checks |
| --- | --- | --- |
| MRI/fMRI volume or surface | [Nilearn](https://github.com/nilearn/nilearn), [surfplot](https://github.com/danjgale/surfplot), [pycortex](https://github.com/gallantlab/pycortex) | image space, orientation, hemisphere, atlas, threshold, interpolation, color scale |
| Diffusion MRI and tractography | [DIPY](https://github.com/dipy/dipy), [MRtrix3](https://github.com/MRtrix3/mrtrix3), [FURY](https://github.com/fury-gl/fury) | gradient or model identity, tract or bundle selection, coordinate space, direction encoding, thresholds |
| Gradients and map comparison | [BrainSpace](https://github.com/MICA-MNI/BrainSpace), [neuromaps](https://github.com/netneurolab/neuromaps) | surface density, correspondence, null model, spatial autocorrelation |
| Network neuroscience | [netplotbrain](https://github.com/wiheto/netplotbrain) | node identity, coordinate system, edge threshold and sign |
| EEG/MEG/iEEG/ECoG | [MNE-Python](https://github.com/mne-tools/mne-python) | sensor or source space, reference, time/frequency window, baseline, units |
| Region-level R figures | [ggseg](https://github.com/ggsegverse/ggseg) | atlas version, hemisphere, region matching, missing regions |

Use [BIDS](https://github.com/bids-standard/bids-specification) identities and relevant [COBIDAS](https://github.com/ohbm/cobidas-mri) fields when they govern the input or report.

### Psychology and behavior

[ggdist](https://github.com/mjskay/ggdist), [raincloudplots](https://github.com/jorvlan/raincloudplots), and [see](https://github.com/easystats/see) can support distributions, uncertainty, and diagnostics. Preserve participant-level structure, repeated-measure relationships, scale direction, missingness, and uncertainty.
