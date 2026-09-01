# Task record: neuro research cover

## Intent

- Objective: Create a clear research-facing cover for BoundedFreedom that speaks to neuroimaging, clinical, neuroscience, and psychology users.
- Non-goals: Present experimental results, diagnostic claims, patient data, or a detailed workflow diagram.
- Audience: Researchers and clinicians encountering the repository through its README.

## Chief decision

- Task route: `imagegen`.
- Risk: S1. This changes public presentation but not scientific behavior or claims.
- Execution: Direct, with no worker.
- Scope: One raster cover under `docs/assets/` and one README reference.
- Verification: Inspect anatomy, disciplinary cues, exact title text, absence of fake data, dimensions, link validity, and privacy.

## Execution and evidence

- Generated with the built-in image tool as a wide scientific cover.
- The composition combines structural MRI, cortical connectivity, observation, verification, a behavioral trajectory, and a human decision point inside an open geometric boundary.
- The image contains only the project name and its existing tagline. It contains no numerical result, diagnosis, patient identity, third-party logo, or watermark.
- Saved artifact: `docs/assets/bounded-freedom-neuro-research-cover.png`.

## Verification and decision

- Visual inspection: Passed for hierarchy, title spelling, scientific tone, and the intended four audiences.
- File inspection: PNG, 1672 by 941 pixels, approximately 16:9.
- Repository inspection: README uses a relative link and descriptive alternative text.
- Outcome: Accepted as the initial research cover.
- Remaining uncertainty: Audience response and small-screen readability should be assessed from actual repository use; revise one visual issue at a time if feedback identifies a problem.
