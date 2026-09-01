# Reproduction contract

Read before executing code or making a reproduction claim.

## Claim map

For each target, preserve:

```text
claim_id
paper_location
claim_text_or_paraphrase
equation_or_method_component
expected_metric_table_or_figure
repository_commit
file_class_function
config_and_default
data_and_preprocessing_path
checkpoint_or_initialization
evaluation_path
direct_evidence
inference_or_gap
```

Paper text, code behavior, and reviewer inference must remain distinguishable.

## Mode requirements

| Mode | Minimum evidence | Completion boundary |
| --- | --- | --- |
| Understanding map | Paper and repository identities, traced runtime path, gaps | Shows correspondence, not execution |
| Smoke reproduction | Frozen environment, minimal permitted data/config, successful representative run, output sanity checks | Shows that a bounded path runs |
| Claim-level reproduction | Protocol, data, seeds, preprocessing, metric, baseline, tolerance, repeated runs when needed, fresh comparison | Shows agreement or disagreement only for the named claim |

## Identity receipt

Bind these before interpreting output:

- paper version and supplementary material;
- source repository, commit, dirty state, and local changes;
- runtime, dependencies, containers, drivers, and hardware;
- data release, inclusion, preprocessing, order, and split;
- model architecture, initialization, checkpoint, and training state;
- config precedence and effective parameters;
- metric implementation, aggregation, uncertainty, and tolerance.

## Comparison states

- **Matched:** the frozen observable falls within the declared tolerance under a sufficiently matched protocol.
- **Mismatched:** a valid matched comparison falls outside tolerance.
- **Blocked:** an identified dependency, permission, data, compute, or documentation gap prevents comparison.
- **Indeterminate:** execution happened, but protocol identity or evidence is too weak to decide.

Do not select tolerances after seeing the result without labeling the analysis exploratory.

## Cost ladder

1. Static claim map and config resolution.
2. Import, compile, unit, or dry-run checks.
3. Tiny synthetic or documented example.
4. Small real-data or checkpoint evaluation.
5. Full baseline or ablation.
6. Claim-level repeated run.

Climb only when the lower step cannot answer the frozen question.

## Sources and optional systems

- [research-paper-code-study](https://github.com/baizhanxu/research-paper-code-study-codex-skill) for concept-to-runtime mapping.
- [xKG](https://github.com/zjunlp/xKG) as an experimental paper-code knowledge layer.
- [Paper2Code](https://github.com/going-doer/Paper2Code) and [DeepCode](https://github.com/HKUDS/DeepCode) as builder references, not reproduction proof.
- [paperReproductAgent](https://github.com/Winter-And-You-Gone/paperReproductAgent) as a staged first-pass execution reference, not full claim reproduction.
- [PaperBench](https://github.com/openai/frontier-evals/tree/main/project/paperbench), [ScienceAgentBench](https://github.com/OSU-NLP-Group/ScienceAgentBench), and [SciReplicate-Bench](https://github.com/xyzCS/SciReplicate-Bench) as evaluation references at different scopes.
