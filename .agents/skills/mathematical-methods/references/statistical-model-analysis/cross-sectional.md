# Cross-sectional profile

Use this profile when the primary outcome and predictors are evaluated at one analysis time per independent unit, including grouped, paired, clustered, survey, case-control, and multi-site designs.

## Recover the design before the model

Record:

- target population, sampling frame, inclusion mechanism, and analysis weights;
- independence unit and any pairing, family, center, device, batch, or spatial cluster;
- outcome scale and prevalence or case-control sampling when relevant;
- exposure, predictor, adjustment, mediator, collider, and effect-modifier roles as declared by project authority;
- timing or provenance sufficient to prevent future or outcome information from entering predictors;
- measurement error, detection limits, missingness, and structural zeros.

The presence of one row per participant does not prove independence. Site, family, acquisition batch, matched sets, repeated derived regions, and shared preprocessing can create dependence.

## Candidate families

Choose by target and structure rather than by habit:

- generalized linear models for conditional mean, probability, rate, or count targets with an appropriate link and distribution;
- robust or quantile models when a mean model is scientifically insufficient and assumptions support the alternative target;
- mixed or marginal models for clusters, sites, matched groups, or repeated regions;
- multivariate or hierarchical models when outcomes or regions share structure and multiplicity matters;
- flexible nonlinear terms when the relationship is plausibly nonlinear and sample support is adequate;
- measurement models when observed scores imperfectly represent a latent construct.

Machine-learning prediction remains a prediction problem: preserve the estimand or prediction target, tuning boundary, calibration, and external evaluation rather than treating the algorithm name as the statistical specification.

## Checks that often change the answer

- distinguish conditional from marginal effects and adjusted from unadjusted targets;
- verify reference levels, contrasts, link-scale versus response-scale reporting, and interaction interpretation;
- inspect overlap, sparse cells, separation, influential clusters, and effective sample size;
- preserve matched or weighted designs in estimation and uncertainty;
- control or model multiple outcomes, regions, contrasts, and exploratory searches transparently;
- report effect magnitude and uncertainty, not significance alone;
- keep post hoc thresholds and subgroups exploratory.

Return to `scientific-data-quality` when the problem is an unresolved schema, exclusion, leakage, or split violation. Return to project authority when variable roles or the target population are not defined.
