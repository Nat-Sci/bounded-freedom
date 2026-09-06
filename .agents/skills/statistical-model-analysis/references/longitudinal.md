# Longitudinal profile

Use this profile for repeated measurements, developmental or disease trajectories, irregular follow-up, time-varying quantities, event histories, censoring, or dropout.

## Time and dependence contract

Record:

- time origin, unit, clock, ordering, visit windows, and analysis horizon;
- subject or entity identity, repeated outcomes, and nested site, family, device, or region levels;
- within-unit change separately from between-unit differences;
- baseline and time-varying exposures, confounders, treatments, and measurement schedules;
- missing visits, intermittent missingness, censoring, dropout, death, and competing events;
- whether observation timing or dropout depends on prior outcomes or latent state.

Do not treat visits from one participant as independent rows. Do not infer individual change from a cross-sectional age association without a declared assumption and appropriate design.

## Candidate families

- mixed-effects or generalized additive mixed models for subject-specific nonlinear trajectories and hierarchical variation;
- marginal models such as GEE for population-average targets with a defensible working dependence and sufficient clusters;
- latent growth or measurement models when repeated indicators represent an evolving latent construct;
- state-space, hidden-state, or Gaussian-process models for irregular dynamic processes and measurement error;
- survival, recurrent-event, or multi-state models for event timing and transitions;
- joint longitudinal-event models when dropout or an event process is scientifically coupled to the repeated outcome;
- longitudinal causal methods only after `hypothesis-study-design` or project authority freezes an intervention estimand and identification assumptions.

## Required checks

- test whether time should be linear, piecewise, smooth, transformed, event-aligned, or age-aligned;
- state random-effect and residual-correlation structures and whether data can support them;
- inspect individual trajectories as well as population summaries without exposing private identities;
- distinguish change-from-baseline, average trajectory, subject-specific slope, milestone time, and future-risk targets;
- assess informative observation and dropout mechanisms through named sensitivity analyses;
- separate interpolation from forecasting and extrapolation;
- use subject-, family-, site-, and time-aware validation boundaries;
- report uncertainty across the full trajectory or horizon, not only at selected time points.

When data from different cohorts or studies cover different age or time ranges, separate longitudinal change from cohort and site effects before combining them.
