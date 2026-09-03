# Suite manifest and QA

Use a project-local structured manifest when a figure has several panels, when a source has been manually refined, or when Figure 1-N must remain consistent. The project chooses the path and format; YAML is convenient for machine checks, while equivalent structured Markdown is acceptable when automation is not needed.

## Minimum manifest

```yaml
schema_version: "0.1"
suite_id: paper-main
semantic_contract:
  story_order: []
  terms: {}
  visual_roles: {}
  shared_units: {}
  shared_scales: {}
  domain_conventions: {}
  declared_exceptions: []
figures:
  - figure_id: fig-01
    visual_claim: ""
    lineage_ids: []
    design_status: draft
    panels:
      - panel_id: fig-01a
        role: ""
        source_type: data | model | method | measured-image | external-asset
        source_ids: []
        data_code_authority: ""
        layout_authority: ""
        analysis_transformations: []
        display_transformations: []
        renderer: ""
        editable_source: ""
        rendered_output: ""
        change_scope: scientific | visual
        qa:
          machine: unverified
          visual: unverified
          scientific: unverified
    caption_source: ""
    overall_qa: unverified
```

Add hashes, versions, timestamps, commands, environment receipts, licenses, or reviewer IDs only when they improve reproducibility or acceptance. Do not turn the manifest into a duplicate evidence database.

## Figure 1-N semantic contract

Freeze shared meanings before styling the suite:

- figure order and the claim each figure is allowed to communicate;
- stable names, abbreviations, cohort and condition identities;
- semantic color, line, marker, and anatomy mappings;
- comparable units, axes, scales, uncertainty, and statistical notation;
- orientation, coordinate, atlas, hemisphere, and modality conventions;
- justified exceptions where a shared rule would be scientifically wrong.

Shared appearance is not the goal by itself. A shared mapping is required only when the underlying meanings are genuinely comparable.

## Change tracking

Each revision records the affected figure and panels, old and new authorities or hashes, reason, authoring source, requested scope, and invalidated checks.

- **Scientific change:** changes data, sample, exclusions, analysis, estimates, uncertainty, threshold, coordinate or anatomical mapping, visible comparison, visual encoding meaning, claim, or caption interpretation. Rerun the affected analysis and scientific, visual, and machine QA.
- **Visual change:** changes typography, spacing, alignment, panel placement, nonsemantic styling, or export settings without changing scientific content. Rerun affected machine and visual QA.

If one edit contains both, record two linked changes or classify the whole edit as scientific. If the classification is uncertain, treat it as scientific until resolved. A visual edit must never overwrite data-derived geometry or values.

## Rebuild contract

1. Resolve the data/code and layout authorities for every affected panel.
2. Regenerate scientific content from its data/code authority.
3. Reapply the retained layout source without editing generated values or geometry.
4. Compare authority versions, panel inventory, labels, and expected outputs with the manifest.
5. Run the required QA layers and update their states.

Reconstructing editable objects from only a PDF or raster image does not recover scientific authority. Keep such content `unverified` until it is rebound to data, code, method, or source evidence.

## Three-state QA

- **`pass`:** every required check for that layer ran and its evidence satisfies the frozen contract.
- **`fail`:** a required check found a conflict, missing requirement, or unacceptable result. Do not release the affected artifact as accepted.
- **`unverified`:** a check did not run, lacked evidence, could not inspect the needed representation, or still needs scientific or human judgment. It is not a soft pass.

Overall QA is `pass` only when all required layers pass. Any required failure makes it `fail`; otherwise any incomplete layer makes it `unverified`.

## QA layers

| Layer | Suitable checks | Boundary |
| --- | --- | --- |
| Machine | required fields, source existence, hashes or freshness, compile/export success, dimensions, physical size, DPI, panel IDs, labels, units, font embedding, editable text, vector/raster inventory, caption references, suite mapping drift | Detects declared structural and file failures, not scientific truth |
| Visual | clipping, overlap, reading order, final-size legibility, grayscale and color-vision robustness, connector endpoints, transparency, rasterization, cross-panel balance | Automation can flag candidates; inspect the final render |
| Scientific | values and geometry against analysis, denominator and sample identity, uncertainty, anatomy, coordinates, thresholds, comparison validity, caption and claim agreement, prohibited implications | Requires domain judgment; consequential claims may require an independent Reviewer or human acceptance |

Pixel similarity can detect rendering drift but cannot establish scientific equivalence. A successful compile or export proves only that a file was produced.
