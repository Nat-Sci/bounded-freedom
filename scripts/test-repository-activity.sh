#!/bin/sh

set -eu

script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
repo_root=$(CDPATH= cd -- "$script_dir/.." && pwd)
renderer="$script_dir/render-repository-activity.mjs"
workflow="$repo_root/.github/workflows/update-repository-activity.yml"
test_root=$(mktemp -d "${TMPDIR:-/tmp}/bounded-freedom-activity.XXXXXX")
trap 'rm -rf "$test_root"' EXIT HUP INT TERM
checks=0

has() {
    if ! grep -Fq -- "$1" "$2"; then
        printf 'missing expected text: %s\n' "$1" >&2
        exit 1
    fi
    checks=$((checks + 1))
}

equal() {
    if [ "$1" != "$2" ]; then
        printf 'assertion failed: %s\n' "$3" >&2
        exit 1
    fi
    checks=$((checks + 1))
}

rejects() {
    if node "$renderer" --output "$test_root/invalid.svg" "$@" >/dev/null 2>&1; then
        printf 'renderer accepted invalid input\n' >&2
        exit 1
    fi
    checks=$((checks + 1))
}

render() {
    g=$1; n=$2; o=$3
    shift 3
    node "$renderer" --git-dir "$g" --now "$n" \
        --repo Nat-Sci/bounded-freedom --output "$o" "$@"
}

init_repo() {
    mkdir -p "$1"
    git -C "$1" init -q -b main
    git -C "$1" config user.name "Activity Test"
    git -C "$1" config user.email activity-test@example.invalid
}

commit_at() {
    r=$1; d=$2; m=$3
    printf '%s\n' "$m" >> "$r/history"
    git -C "$r" add history
    GIT_AUTHOR_DATE="$d" GIT_COMMITTER_DATE="$d" git -C "$r" commit -q -m "$m"
}

history="$test_root/history with spaces"
init_repo "$history"
commit_at "$history" 2026-08-20T08:00:00Z a
commit_at "$history" 2026-08-20T12:00:00Z b
commit_at "$history" 2026-08-24T12:00:00Z c
commit_at "$history" 2026-09-01T12:00:00Z d
commit_at "$history" 2026-09-02T09:00:00Z e
commit_at "$history" 2026-09-03T08:00:00Z f
commit_at "$history" 2026-09-03T10:00:00Z g

first="$test_root/first.svg"
render "$history" 2026-09-03T12:00:00Z "$first"
touch "$test_root/marker"
render "$history" 2026-09-03T12:00:00Z "$first"
test ! "$first" -nt "$test_root/marker"
checks=$((checks + 1))
has '7 commits · 5 active days' "$first"
has 'DAY INTERVALS' "$first"
has 'Aug 20 → Sep 3, 2026 · UTC' "$first"
has '2026-08-20 through 2026-08-20: 2 commits' "$first"
has '2026-09-03 through 2026-09-03: 2 commits' "$first"
has 'Generated · 2026-09-03T12:00:00Z (UTC)' "$first"
has 'Source · ' "$first"

compressed="$test_root/compressed.svg"
render "$history" 2026-09-03T12:00:00Z "$compressed" --max-bars 8
has '7 commits · 3 active weeks' "$compressed"
has 'WEEK INTERVALS' "$compressed"
has '2026-08-17 through 2026-08-23: 2 commits' "$compressed"
has '2026-08-31 through 2026-09-03: 4 commits' "$compressed"

empty="$test_root/empty"
init_repo "$empty"
empty_svg="$test_root/empty.svg"
render "$empty" 2026-09-03T12:00:00Z "$empty_svg"
has 'No commits yet' "$empty_svg"
has 'Source · none' "$empty_svg"
escaped="$test_root/escaped.svg"
render "$empty" 2026-09-03T12:00:00Z "$escaped" --repo 'A&B/project'
has 'A&amp;B / project' "$escaped"
rejects --git-dir "$test_root/no-repo"
rejects --git-dir "$history" --max-bars 7
rejects --git-dir "$history" --time-zone Not/AZone
rejects --git-dir "$history" --ref no-such-ref

# The same UTC date crosses midnight in Shanghai; DST uses civil days as well.
cross="$test_root/cross"
init_repo "$cross"
commit_at "$cross" 2026-08-20T15:30:00Z one
commit_at "$cross" 2026-08-20T16:30:00Z two
utc="$test_root/utc.svg"
shanghai="$test_root/shanghai.svg"
render "$cross" 2026-08-21T12:00:00Z "$utc"
render "$cross" 2026-08-21T12:00:00Z "$shanghai" --time-zone Asia/Shanghai
has '2 commits · 1 active day' "$utc"
has 'DAY INTERVALS' "$utc"
has '2 commits · 2 active days' "$shanghai"
has 'DAY INTERVALS' "$shanghai"
has '2026-08-20 through 2026-08-20: 1 commit' "$shanghai"
has '2026-08-21 through 2026-08-21: 1 commit' "$shanghai"

week="$test_root/week"
init_repo "$week"
commit_at "$week" 2026-03-03T12:00:00Z w1
commit_at "$week" 2026-03-08T12:00:00Z w2
commit_at "$week" 2026-03-10T12:00:00Z w3
commit_at "$week" 2026-03-20T12:00:00Z w4
week_svg="$test_root/week.svg"
render "$week" 2026-03-20T12:00:00Z "$week_svg" --max-bars 8
has '4 commits · 3 active weeks' "$week_svg"
has 'WEEK INTERVALS' "$week_svg"
has '2026-03-02 through 2026-03-08: 2 commits' "$week_svg"
has '2026-03-09 through 2026-03-15: 1 commit' "$week_svg"
has '2026-03-16 through 2026-03-20: 1 commit' "$week_svg"

two_week="$test_root/two-week"
init_repo "$two_week"
commit_at "$two_week" 2026-01-01T12:00:00Z t1
commit_at "$two_week" 2026-01-10T12:00:00Z t2
commit_at "$two_week" 2026-02-05T12:00:00Z t3
commit_at "$two_week" 2026-03-10T12:00:00Z t4
two_week_svg="$test_root/two-week.svg"
render "$two_week" 2026-03-18T12:00:00Z "$two_week_svg" --max-bars 8
has '4 commits · 4 active 2-week periods' "$two_week_svg"
has '2-WEEK INTERVALS' "$two_week_svg"
has '2025-12-22 through 2026-01-04: 1 commit' "$two_week_svg"
has '2026-03-02 through 2026-03-15: 1 commit' "$two_week_svg"

month="$test_root/month"
init_repo "$month"
commit_at "$month" 2024-02-29T12:00:00Z m1
commit_at "$month" 2024-03-31T12:00:00Z m2
commit_at "$month" 2024-06-15T12:00:00Z m3
commit_at "$month" 2024-09-01T12:00:00Z m4
month_svg="$test_root/month.svg"
render "$month" 2024-09-01T12:00:00Z "$month_svg" --max-bars 8
has '4 commits · 4 active months' "$month_svg"
has 'MONTH INTERVALS' "$month_svg"
has '2024-02-01 through 2024-02-29: 1 commit' "$month_svg"
has '2024-03-01 through 2024-03-31: 1 commit' "$month_svg"
has '2024-06-01 through 2024-06-30: 1 commit' "$month_svg"
has '2024-09-01 through 2024-09-01: 1 commit' "$month_svg"

dst="$test_root/dst"
init_repo "$dst"
commit_at "$dst" 2026-03-08T04:30:00Z before
commit_at "$dst" 2026-03-09T03:30:00Z after
dst_svg="$test_root/dst.svg"
render "$dst" 2026-03-10T12:00:00Z "$dst_svg" --time-zone America/New_York
has '2 commits · 2 active days' "$dst_svg"
has 'DAY INTERVALS' "$dst_svg"
has 'Mar 7 → Mar 10, 2026 · America/New_York' "$dst_svg"

quarter="$test_root/quarter"
init_repo "$quarter"
commit_at "$quarter" 2025-01-15T12:00:00Z q1
commit_at "$quarter" 2025-04-01T12:00:00Z q2
commit_at "$quarter" 2025-08-01T12:00:00Z q3
commit_at "$quarter" 2026-01-15T12:00:00Z q4
quarter_svg="$test_root/quarter.svg"
render "$quarter" 2026-01-31T12:00:00Z "$quarter_svg" --max-bars 8
has '4 commits · 4 active quarters' "$quarter_svg"
has 'QUARTER INTERVALS' "$quarter_svg"
has '2025-01-01 through 2025-03-31: 1 commit' "$quarter_svg"
has '2025-04-01 through 2025-06-30: 1 commit' "$quarter_svg"
has '2026-01-01 through 2026-01-31: 1 commit' "$quarter_svg"

half_year="$test_root/half-year"
init_repo "$half_year"
commit_at "$half_year" 2022-02-01T12:00:00Z h1
commit_at "$half_year" 2022-08-01T12:00:00Z h2
commit_at "$half_year" 2023-04-01T12:00:00Z h3
commit_at "$half_year" 2024-07-15T12:00:00Z h4
commit_at "$half_year" 2025-11-10T12:00:00Z h5
half_svg="$test_root/half-year.svg"
render "$half_year" 2025-12-31T12:00:00Z "$half_svg" --max-bars 8
has '5 commits · 5 active half-years' "$half_svg"
has 'HALF-YEAR INTERVALS' "$half_svg"
has '2022-01-01 through 2022-06-30: 1 commit' "$half_svg"
has '2022-07-01 through 2022-12-31: 1 commit' "$half_svg"
has '2025-07-01 through 2025-12-31: 1 commit' "$half_svg"

year="$test_root/year"
init_repo "$year"
commit_at "$year" 2016-06-01T12:00:00Z y1
commit_at "$year" 2018-06-01T12:00:00Z y2
commit_at "$year" 2020-06-01T12:00:00Z y3
commit_at "$year" 2022-06-01T12:00:00Z y4
commit_at "$year" 2024-06-01T12:00:00Z y5
commit_at "$year" 2026-06-01T12:00:00Z y6
year_svg="$test_root/year.svg"
render "$year" 2026-12-31T12:00:00Z "$year_svg" --max-bars 12
has '6 commits · 6 active years' "$year_svg"
has 'YEAR INTERVALS' "$year_svg"
has '2016-01-01 through 2016-12-31: 1 commit' "$year_svg"
has '2026-01-01 through 2026-12-31: 1 commit' "$year_svg"

older=$(git -C "$history" rev-parse HEAD~1)
pinned="$test_root/pinned.svg"
render "$history" 2026-09-03T12:00:00Z "$pinned" --ref "$older"
has '6 commits' "$pinned"
has "Source · $(printf %.12s "$older")" "$pinned"

# Full reachable history includes a merged side branch, not just first-parent.
merge="$test_root/merge"
init_repo "$merge"
commit_at "$merge" 2026-01-01T12:00:00Z base
git -C "$merge" switch -q -c feature
GIT_AUTHOR_DATE=2026-01-02T12:00:00Z GIT_COMMITTER_DATE=2026-01-02T12:00:00Z \
    git -C "$merge" commit --allow-empty -q -m side
git -C "$merge" switch -q main
GIT_AUTHOR_DATE=2026-01-03T12:00:00Z GIT_COMMITTER_DATE=2026-01-03T12:00:00Z \
    git -C "$merge" commit --allow-empty -q -m main
GIT_AUTHOR_DATE=2026-01-04T12:00:00Z GIT_COMMITTER_DATE=2026-01-04T12:00:00Z \
    git -C "$merge" merge -q --no-ff feature -m merge
merge_svg="$test_root/merge.svg"
render "$merge" 2026-01-05T12:00:00Z "$merge_svg"
has '4 commits' "$merge_svg"

# Parent ordering and the render clock must not silently drop reachable commits.
inversion="$test_root/inversion"
init_repo "$inversion"
commit_at "$inversion" 2026-06-10T12:00:00Z parent
commit_at "$inversion" 2026-06-01T12:00:00Z child
inversion_svg="$test_root/inversion.svg"
render "$inversion" 2026-06-11T12:00:00Z "$inversion_svg"
has 'Jun 1 → Jun 11, 2026 · UTC' "$inversion_svg"
has '2 commits · 2 active days' "$inversion_svg"
has 'DAY INTERVALS' "$inversion_svg"
future="$test_root/future"
init_repo "$future"
commit_at "$future" 2030-01-02T12:00:00Z future
future_svg="$test_root/future.svg"
render "$future" 2026-01-01T12:00:00Z "$future_svg"
has 'Jan 2, 2030 · UTC' "$future_svg"
has '1 commit · 1 active day' "$future_svg"
has 'DAY INTERVALS' "$future_svg"
has '2030-01-02 through 2030-01-02: 1 commit' "$future_svg"

multi_year="$test_root/multi-year"
init_repo "$multi_year"
commit_at "$multi_year" 2009-02-01T12:00:00Z m1
commit_at "$multi_year" 2011-05-01T12:00:00Z m2
commit_at "$multi_year" 2013-07-01T12:00:00Z m3
commit_at "$multi_year" 2016-08-01T12:00:00Z m4
commit_at "$multi_year" 2019-09-01T12:00:00Z m5
commit_at "$multi_year" 2022-10-01T12:00:00Z m6
commit_at "$multi_year" 2024-11-01T12:00:00Z m7
multi_year_svg="$test_root/multi-year.svg"
render "$multi_year" 2026-06-01T12:00:00Z "$multi_year_svg" --max-bars 8
has '7 commits · 6 active 3-year periods' "$multi_year_svg"
has '3-YEAR INTERVALS' "$multi_year_svg"
has '2007-01-01 through 2009-12-31: 1 commit' "$multi_year_svg"
has '2022-01-01 through 2024-12-31: 2 commits' "$multi_year_svg"

if command -v xmllint >/dev/null 2>&1; then
    xmllint --noout "$first" "$empty_svg" "$escaped" "$shanghai"
    checks=$((checks + 1))
fi

# Exercise the actual publication body, so a regression in the workflow fails here.
publish="$test_root/publish.sh"
awk '
    /      - name: Publish generated asset without changing main/ {found=1; next}
    found && /^        run: \|/ {body=1; next}
    body && /^      - name: / {exit}
    body {sub(/^          /, ""); print}
' "$workflow" > "$publish"
test -s "$publish"
remote="$test_root/remote.git"
git clone -q --bare "$history" "$remote"
runner="$test_root/runner"
git clone -q "$remote" "$runner"
runner_temp="$test_root/runner-temp"
mkdir -p "$runner_temp"
cp "$first" "$runner_temp/repository-activity.svg"
source_sha=$(git -C "$runner" rev-parse HEAD)

run_publish() {
    (cd "$1" && RUNNER_TEMP="$runner_temp" SOURCE_SHA="$source_sha" \
        ACTIVITY_BRANCH=repository-activity ACTIVITY_PATH=repository-activity.svg \
        bash "$publish") >/dev/null 2>&1
}

asset_head() {
    git --git-dir="$remote" rev-parse refs/heads/repository-activity
}

run_publish "$runner"
published_sha=$(asset_head)
git --git-dir="$remote" show repository-activity:repository-activity.svg > "$test_root/published.svg"
cmp -s "$first" "$test_root/published.svg"
checks=$((checks + 1))
equal "$(git --git-dir="$remote" rev-parse main)" "$source_sha" 'initial publish preserves main'

repeat="$test_root/repeat"
git clone -q "$remote" "$repeat"
run_publish "$repeat"
equal "$(asset_head)" "$published_sha" 'identical publication creates no commit'

commit_at "$history" 2026-09-04T12:00:00Z advance
git -C "$history" push -q "$remote" main
new_source=$(git -C "$history" rev-parse HEAD)
stale="$test_root/stale"
git clone -q "$remote" "$stale"
# Use a different payload: a no-op payload would not detect a missing stale guard.
cp "$empty_svg" "$runner_temp/repository-activity.svg"
run_publish "$stale"
equal "$(asset_head)" "$published_sha" 'superseded snapshot is not published'
equal "$(git --git-dir="$remote" rev-parse main)" "$new_source" 'stale publication preserves new main'

source_sha=$new_source
render "$stale" 2026-09-04T12:00:00Z "$runner_temp/repository-activity.svg" --ref "$source_sha"
run_publish "$stale"
git --git-dir="$remote" show repository-activity:repository-activity.svg > "$test_root/updated.svg"
has "Source · $(printf %.12s "$source_sha")" "$test_root/updated.svg"
has '8 commits' "$test_root/updated.svg"
equal "$(git --git-dir="$remote" rev-parse main)" "$new_source" 'updated publication preserves main'
files=$(git --git-dir="$remote" ls-tree --name-only repository-activity | sort | tr '\n' ' ')
equal "$files" '.nojekyll repository-activity.svg ' 'activity branch contains only generated assets'

printf 'repository activity tests: %s checks passed\n' "$checks"
