#!/bin/sh

set -eu

script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
renderer="$script_dir/render-repository-activity.mjs"
test_root=$(mktemp -d "${TMPDIR:-/tmp}/bounded-freedom-activity.XXXXXX")
trap 'rm -rf "$test_root"' EXIT HUP INT TERM

checks=0

check_contains() {
    needle=$1
    file=$2
    if ! grep -Fq -- "$needle" "$file"; then
        printf 'missing expected text: %s\n' "$needle" >&2
        exit 1
    fi
    checks=$((checks + 1))
}

history_repo="$test_root/history"
mkdir -p "$history_repo"
git -C "$history_repo" init -q -b main
git -C "$history_repo" config user.name "Activity Test"
git -C "$history_repo" config user.email "activity-test@example.invalid"

make_commit() {
    committed_at=$1
    label=$2
    printf '%s\n' "$label" >> "$history_repo/history.txt"
    git -C "$history_repo" add history.txt
    GIT_AUTHOR_DATE="$committed_at" GIT_COMMITTER_DATE="$committed_at" \
        git -C "$history_repo" commit -q -m "$label"
}

make_commit "2026-06-10T12:00:00Z" "outside window"
make_commit "2026-06-15T12:00:00Z" "window start one"
make_commit "2026-06-17T12:00:00Z" "window start two"
make_commit "2026-08-25T12:00:00Z" "recent week"
make_commit "2026-09-02T09:00:00Z" "current week one"
make_commit "2026-09-03T10:00:00Z" "current week two"

first="$test_root/first.svg"
second="$test_root/second.svg"
node "$renderer" \
    --git-dir "$history_repo" \
    --now "2026-09-03T12:00:00Z" \
    --repo "Nat-Sci/bounded-freedom" \
    --weeks 12 \
    --output "$first"
node "$renderer" \
    --git-dir "$history_repo" \
    --now "2026-09-03T12:00:00Z" \
    --repo "Nat-Sci/bounded-freedom" \
    --weeks 12 \
    --output "$second"

cmp -s "$first" "$second"
checks=$((checks + 1))
check_contains "5 updates · 3 of 12 active weeks" "$first"
check_contains "Last update 2026-09-03 UTC" "$first"
check_contains "Week of 2026-06-15: 2 updates" "$first"
check_contains "activity shows maintenance, not scientific validity" "$first"

empty_repo="$test_root/empty"
mkdir -p "$empty_repo"
git -C "$empty_repo" init -q -b main
empty_svg="$test_root/empty.svg"
node "$renderer" \
    --git-dir "$empty_repo" \
    --now "2026-09-03T12:00:00Z" \
    --repo "empty" \
    --output "$empty_svg"
check_contains "0 updates · 0 of 12 active weeks" "$empty_svg"
check_contains "No commits yet" "$empty_svg"

escaped_svg="$test_root/escaped.svg"
node "$renderer" \
    --git-dir "$empty_repo" \
    --now "2026-09-03T12:00:00Z" \
    --repo "A&B/project" \
    --output "$escaped_svg"
check_contains "A&amp;B / project" "$escaped_svg"

not_repo="$test_root/not-a-repository"
mkdir -p "$not_repo"
if node "$renderer" --git-dir "$not_repo" --output "$test_root/invalid.svg" >/dev/null 2>&1; then
    printf 'renderer accepted a non-Git directory\n' >&2
    exit 1
fi
checks=$((checks + 1))

if command -v xmllint >/dev/null 2>&1; then
    xmllint --noout "$first" "$empty_svg" "$escaped_svg"
    checks=$((checks + 1))
fi

remote_repo="$test_root/remote.git"
runner_repo="$test_root/runner"
second_runner="$test_root/second-runner"
git clone -q --bare "$history_repo" "$remote_repo"
git clone -q "$remote_repo" "$runner_repo"
published_svg="$test_root/published.svg"
node "$renderer" \
    --git-dir "$runner_repo" \
    --now "2026-09-03T12:00:00Z" \
    --repo "Nat-Sci/bounded-freedom" \
    --output "$published_svg"
git -C "$runner_repo" switch -q --orphan repository-activity
cp "$published_svg" "$runner_repo/repository-activity.svg"
touch "$runner_repo/.nojekyll"
git -C "$runner_repo" add repository-activity.svg .nojekyll
git -C "$runner_repo" config user.name "Activity Test"
git -C "$runner_repo" config user.email "activity-test@example.invalid"
git -C "$runner_repo" commit -q -m "publish activity"
git -C "$runner_repo" push -q origin HEAD:repository-activity

git clone -q "$remote_repo" "$second_runner"
git -C "$second_runner" fetch -q --depth=1 origin repository-activity
git -C "$second_runner" switch -q --detach FETCH_HEAD
cp "$published_svg" "$second_runner/repository-activity.svg"
touch "$second_runner/.nojekyll"
git -C "$second_runner" add repository-activity.svg .nojekyll
git -C "$second_runner" diff --cached --quiet
checks=$((checks + 1))

published_files=$(git -C "$runner_repo" ls-tree --name-only HEAD | sort | tr '\n' ' ')
if [ "$published_files" != ".nojekyll repository-activity.svg " ]; then
    printf 'unexpected activity branch files: %s\n' "$published_files" >&2
    exit 1
fi
checks=$((checks + 1))

printf 'repository activity tests: %s checks passed\n' "$checks"
