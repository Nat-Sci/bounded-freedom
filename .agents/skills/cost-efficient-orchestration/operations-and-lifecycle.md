# Operations, lifecycle, and recovery

Use this protocol when a task may spawn workers, retry operations, mutate external state, or outlive one context window. It supplements the Chief decision; it does not create a second task record.

## 1. Freeze the phase and context budget

Before a substantial phase, state its objective, accepted inputs, active Skill and project rules, files or evidence in scope, expected verification, and next safe action. Include only the smallest context slice that can support the work. Prefer deterministic inventory or aggregation over placing raw logs, whole corpora, or repository-wide content into a model prompt.

Create a compact checkpoint and retire the completed context when:

- the active method or capability lane changes;
- a design, interface, evidence boundary, or other material decision is frozen;
- a worker return has been accepted or rejected;
- a large evidence slice or diagnostic log is no longer needed;
- the task is likely to compact or move to another session.

The next phase starts from the checkpoint plus observable repository or external state. Do not replay the full conversation merely for continuity. When frontier capability was used, record its exit decision and reconsider a balanced or fast lane before continuing.

## 2. Freeze a total worker budget

Record three numbers before the first spawn:

- **planned distinct workers:** normally `0` or `1`, never more than `2` without a revised Chief decision;
- **initial spawn attempts:** normally equal to planned workers and capped at `2`;
- **retry allowance:** normally `0`; add `1` only when a known transient failure mode and safe retry check exist.

A host concurrency limit answers “how many at once?” The worker budget answers “how many across the whole task?” Sequential spawning still consumes the total budget. Reusing an existing worker for a related bounded follow-up does not consume a new distinct-worker slot, but it must stay inside the original ownership and evidence boundary.

Use a second worker only for independent review or clearly non-overlapping evidence. Permit one writing owner and prohibit nested delegation. When the budget no longer fits, stop, update the Chief decision with the new evidence and scope, and justify the smallest increase before spawning again.

## 3. Track the lifecycle

Each worker moves through:

```text
planned -> running -> done | attention -> closed
```

Chief records the worker's bounded purpose and terminal state. `done` means the return was received; it does not mean accepted. `attention` means the worker needs input or stopped without an acceptable result. `closed` means Chief has consumed or rejected the return and, where the host exposes a close control, closed the completed worker thread.

At task completion:

1. inspect the current runtime's agent or thread status;
2. consume each completed return and verify it proportionately;
3. close only workers confirmed complete through supported host controls;
4. leave running or ambiguous work untouched and report it;
5. never edit a host database, archive an unrelated task, or infer a live process from a stored `open` edge.

## 4. Handle timeouts without duplicating effects

A timeout means the caller lacks a result. It does not prove failure.

1. Classify the operation as read-only, idempotent mutation, or non-idempotent/ambiguous mutation.
2. Check observable state through a read-only status call, repository state, or the operation's returned identifier.
3. If the effect is visible, continue without retrying.
4. If no effect is visible, retry a read-only or proven-idempotent operation once when the declared allowance permits it. Reuse the same idempotency key.
5. Do not retry an ambiguous mutation. Record the uncertainty and stop before creating a duplicate effect.
6. When waiting on a worker times out, poll the same worker with its current cursor or status. Do not spawn a replacement.

Record operation class, state check, retry count, and final disposition in the task record. Redact machine-local identifiers from retained output.

## 5. Checkpoint long tasks

Update the existing task record after scope freeze and after each meaningful phase. A recoverable checkpoint includes:

- governing intent, non-goals, assurance, and permitted actions;
- selected method and current execution/model lane;
- current phase, active context slice, and retired context boundary;
- planned and actual workers, attempts, retries, and lifecycle states;
- accepted input versions, source identifiers, or bounded evidence slice;
- changed artifacts and current repository or artifact identity;
- completed checks with pass/fail/unknown status;
- route outcome and the evidence for any escalation or return to a lower lane;
- unresolved uncertainty and the next safe action.

Do not paste raw logs or private local paths into the checkpoint. Preserve only the smallest evidence needed to resume and verify.

After compaction or interruption:

1. re-read the applicable repository instructions, Skill contract, and task checkpoint;
2. inspect actual repository status, diffs, artifacts, and external operation status;
3. reconcile worker lifecycle and retry counters;
4. compare the recorded checkpoint with observable state;
5. resume only the next safe action, correcting the record when reality differs.

When commits are authorized, a coherent verified milestone can be a recovery anchor. A commit is not a substitute for tests, scientific evidence, or a current task record.
