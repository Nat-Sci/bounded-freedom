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

make_commit "2026-08-20T08:00:00Z" "first day one"
make_commit "2026-08-20T12:00:00Z" "first day two"
make_commit "2026-08-24T12:00:00Z" "middle day"
make_commit "2026-09-01T12:00:00Z" "recent day"
make_commit "2026-09-02T09:00:00Z" "yesterday"
make_commit "2026-09-03T08:00:00Z" "today one"
make_commit "2026-09-03T10:00:00Z" "today two"

first="$test_root/first.svg"
second="$test_root/second.svg"
node "$renderer" \
    --git-dir "$history_repo" \
    --now "2026-09-03T12:00:00Z" \
    --repo "Nat-Sci/bounded-freedom" \
    --output "$first"
node "$renderer" \
    --git-dir "$history_repo" \
    --now "2026-09-03T12:00:00Z" \
    --repo "Nat-Sci/bounded-freedom" \
    --output "$second"

cmp -s "$first" "$second"
checks=$((checks + 1))
check_contains "7 main updates · 5 active days" "$first"
check_contains "Aug 20 → Sep 3, 2026 · UTC" "$first"
check_contains "2026-08-20: 2 main updates" "$first"
check_contains "2026-09-03: 2 main updates" "$first"
check_contains "FIRST COMMIT · AUG 20" "$first"
check_contains "AS OF · SEP 3" "$first"
check_contains "DAY INTERVALS" "$first"
check_contains "activity is not a measure of research quality" "$first"

compressed_svg="$test_root/compressed.svg"
node "$renderer" \
    --git-dir "$history_repo" \
    --now "2026-09-03T12:00:00Z" \
    --repo "Nat-Sci/bounded-freedom" \
    --max-bars 8 \
    --output "$compressed_svg"
check_contains "7 main updates · 3 active weeks" "$compressed_svg"
check_contains "WEEK INTERVALS" "$compressed_svg"

empty_repo="$test_root/empty"
mkdir -p "$empty_repo"
git -C "$empty_repo" init -q -b main
empty_svg="$test_root/empty.svg"
node "$renderer" \
    --git-dir "$empty_repo" \
    --now "2026-09-03T12:00:00Z" \
    --repo "empty" \
    --output "$empty_svg"
check_contains "No main updates yet" "$empty_svg"
check_contains "As of Sep 3, 2026 · UTC" "$empty_svg"
check_contains "NO COMMITS YET" "$empty_svg"

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

if node "$renderer" --git-dir "$history_repo" --max-bars 7 --output "$test_root/invalid-bars.svg" >/dev/null 2>&1; then
    printf 'renderer accepted too few bars\n' >&2
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
