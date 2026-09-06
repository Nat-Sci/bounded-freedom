# Task record: activity chart and commit consistency

## Intent and Chief decision

- Objective: explain and repair the mismatch between the README activity card and the commit list.
- Non-goals: rewrite Git history, create a live analytics service, add commits to main just to refresh an image, or change research methods.
- Task method: general repository engineering; orchestration manages scope and acceptance.
- Assurance: S1, repository presentation and accounting only.
- Chief planned capability lane: balanced.
- Chief planned model: UI-selected.
- Chief planned reasoning effort: UI-selected.
- Chief runtime model: unknown.
- Chief runtime reasoning effort: unknown.
- Chief metadata source: inherited; no authoritative runtime pair available.
- Plan: initially direct read-only diagnosis; one bounded Builder for renderer and regression tests while Chief updates the workflow/documentation and verifies hosted evidence.
- Worker configured pair: Terra / medium from the fixed Builder profile; runtime pair unknown.
- Budget: one distinct worker, one initial launch, one bounded review follow-up, and zero worker retries; no nested delegation and only one writing worker.
- Owned scope: renderer and initial tests belonged to Builder; Chief owns workflow, README, this task record, and final test integration after the worker handoff.
- Verification: reproducible date/count fixtures, selected-source identity, time-zone boundaries, full reachable history, valid SVG, publishing behavior, privacy, and the actual hosted result.

## Diagnosis

- Screenshot card: 25 commits, including three on September 6; this matches source commit `1c5731b`.
- Screenshot commit list: source `2bf1abc`, which has 27 commits. The two later commits are missing from that older image, not from Git history.
- Current source `941dcf5`: 28 reachable commits and 28 first-parent commits. The latest Actions run succeeded; the hosted SVG reports 28 total and six on September 6.
- Date mismatch is separate: `76d45f2` was committed at 00:02 on September 5 in UTC+08, which the old UTC chart places on September 4.
- README image is a stable raw-content URL with `Cache-Control: max-age=300`. An already open page is not a live image subscription. The screenshots establish an older displayed snapshot, but do not identify the exact client cache layer.
- Initial network reads were denied before sending by the sandbox; authorized read-only network access then succeeded. This was a permission transition, not an ambiguous external mutation or duplicate effect.

## Frozen repair

- Pin the source commit used for each render and expose its short SHA plus generation time on the card.
- Explicitly use `Asia/Shanghai` for this repository's daily grouping; keep the renderer's timezone configurable with UTC as the portable default.
- Count all commits reachable from the selected source so the scope matches a full commit history; do not include the separate image branch. Historical first-parent and full-history totals happen to be equal in this repository.
- Do not silently discard reachable commits because their timestamps are out of order or ahead of the render clock; derive the date range from the actual timestamps.
- Keep generated files on the separate activity branch and document static-image/cache freshness honestly. Use a new schema URL when deploying the revised card, without claiming cache-free or real-time updates.
- Stop after targeted checks and hosted verification; no unrelated Skills or installation changes.

## Checkpoint and outcome

- Implementation accepted locally. The renderer exposes its pinned SHA, generation timestamp, committer-date basis, and timezone; the workflow tests before rendering and skips a source already superseded on main before publication.
- Targeted regression suite: 38 checks passed. Coverage includes fixed-source rendering, empty history, escaping, invalid arguments, paths with spaces, midnight and DST boundaries, merged history, out-of-order/future timestamps, and actual workflow publication behavior.
- Chief review corrected a timestamp-fixture delimiter and strengthened stale/idempotent publication assertions to inspect remote branch state, not just exit status. A different stale payload now verifies that the freshness guard matters. One malformed local patch was rejected before writing and then corrected; no uncertain external effect was retried.
- Independent accounting against source `941dcf5`: all 28 commits and all eight active-day counts matched Git epoch timestamps converted independently to Asia/Shanghai. September 4/5/6 counts are 1/3/6; later source commits must be counted against their own SHA.
- Visual QA: the generated 1000 by 300 SVG was rasterized and inspected; title, date range, bars, and provenance footer are legible without overlap.
- Node syntax, SVG XML, workflow structure, whitespace, and changed-text privacy checks passed. No Skills, model configuration, Git history, or local installation was changed.
- Worker lifecycle: the bounded Builder returned its final result; no current-task worker remains running. The configured pair was Terra / medium; backend runtime metadata and cost remain unknown.
- Release handoff: commit and push this accepted tree, then confirm the successful hosted workflow and SVG source SHA against that containing commit. The final user receipt carries the release SHA and live verification, avoiding an extra main commit solely to update this record.
- Runtime cost unknown; no billing estimate.
