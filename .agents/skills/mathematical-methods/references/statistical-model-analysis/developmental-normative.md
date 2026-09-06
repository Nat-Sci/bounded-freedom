# Developmental and normative profile

Use this profile for infant or child development, age-conditioned reference curves, developmental milestones, and individual deviation from an expected population trajectory. Combine it with the longitudinal profile when repeated measures are available.

## Developmental contract

Freeze:

- chronological age, gestational age, corrected age, postmenstrual age, or another scientifically authorized developmental clock;
- time unit and precision, especially when change is rapid;
- target construct, instrument version, language, rater, acquisition system, and evidence that measurement remains comparable across age;
- within-child trajectory, population reference curve, centile, milestone time, or individual deviation as distinct targets;
- nesting by child, family, center, scanner or device, protocol, and acquisition batch;
- sex, birth context, prematurity, health state, and other reference-population conditions relevant to the declared use;
- sparse visits, motion or acquisition failure, informative dropout, and changing data quality with age.

## Modeling implications

- use nonlinear age functions when biology and diagnostics support them;
- model age-dependent variance, skewness, or tails when centiles or individual deviations are the target;
- separate a normative reference from a sample description and document transport to a new site or population;
- test longitudinal measurement invariance or another justified comparability argument before interpreting score change as construct change;
- preserve uncertainty in centiles and deviation scores, especially near age-range boundaries or under sparse support;
- distinguish population-average maturation from individual developmental change;
- treat multimodal alignment, missing modality, and modality-specific measurement error as part of the observation model.

The [WHO Child Growth Standards](https://www.who.int/tools/child-growth-standards/standards) illustrate how age-conditioned distributions and velocity can define reference curves. Neuroimaging [normative modeling](https://elifesciences.org/articles/85082) generalizes the reference-coordinate idea to more complex measures. Neither source makes a new developmental marker clinically valid without population, measurement, and external-validation evidence.

## Prohibited shortcuts

- Do not use calendar age and corrected age interchangeably.
- Do not interpret a cross-sectional age trend as an individual developmental trajectory.
- Do not label a statistical deviation as pathology without an authorized clinical construct and validation.
- Do not pool centers or devices without representing or testing their effect.
- Do not impute a missing developmental visit from future information across a held-out prediction boundary.
- Do not choose the reference population after inspecting which choice makes the target group appear most abnormal.
