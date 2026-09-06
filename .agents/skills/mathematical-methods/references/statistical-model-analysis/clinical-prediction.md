# Clinical prediction profile

Use this profile for diagnostic accuracy, screening, staging, prognosis, progression risk, or decision-support models. It supports research design and evaluation; it does not authorize an individual diagnosis, treatment, or deployment.

## Intended-use contract

Freeze before model comparison:

- target population, setting, point in the care pathway, intended user, and intended action;
- diagnostic, screening, staging, prognostic, monitoring, or treatment-selection purpose;
- outcome or target condition, prediction horizon, competing events, and reference-standard authority;
- candidate predictors and the exact time at which each is available;
- development, tuning, internal evaluation, and external evaluation identities;
- clinically meaningful thresholds, consequences of false decisions, and who has authority to choose them.

For Alzheimer disease research, keep clinical syndrome, biological disease, stage, and future progression as separate targets. The [2024 revised criteria](https://alz-journals.onlinelibrary.wiley.com/doi/10.1002/alz.13859) explicitly separate syndrome from biology and should not be reduced to an interchangeable binary label.

## Evaluation contract

- describe sample selection, prevalence or spectrum, missing tests, verification, censoring, and reference-standard uncertainty;
- evaluate overall fit, discrimination, calibration across the relevant range, and uncertainty;
- perform subject-, site-, and time-separated evaluation with frozen preprocessing and tuning boundaries;
- use an external population and setting relevant to intended use before making transportability claims;
- evaluate key subgroups and sites with adequate uncertainty rather than reporting isolated point estimates;
- assess clinical utility or net benefit only against predeclared plausible actions and thresholds;
- distinguish model evaluation from impact evaluation in a real workflow;
- document missing modalities, acquisition shifts, calibration drift, and update rules.

Use [TRIPOD+AI](https://www.bmj.com/content/385/bmj-2023-078378) for transparent reporting of diagnostic or prognostic prediction-model studies and [PROBAST+AI](https://www.bmj.com/content/388/bmj-2024-082505) for quality, risk-of-bias, and applicability assessment. Use [STARD-AI](https://www.nature.com/articles/s41591-025-03953-8) when the study evaluates AI-centered diagnostic accuracy. These instruments have different purposes; completing a reporting checklist is not evidence of low bias or clinical usefulness.

## Prohibited shortcuts

- Do not report AUC alone as adequate prediction evidence.
- Do not call tuning data external validation or let preprocessing learn from evaluation data.
- Do not choose a threshold from the evaluation set and report its performance as untouched evidence.
- Do not equate class weighting, balanced accuracy, or a differentiable surrogate with clinical utility.
- Do not infer causal or treatment benefit from diagnostic or prognostic prediction.
- Do not claim readiness for clinical use from retrospective performance alone.
