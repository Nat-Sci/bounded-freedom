#!/bin/sh
# Regression checks for the user-scope installer. All writes stay in one temporary root.
set -eu

repo_root=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd -P)
installer="$repo_root/scripts/install-global.sh"
begin_marker="# >>> BoundedFreedom managed block >>>"
end_marker="# <<< BoundedFreedom managed block <<<"
package_version=$(sed -n '1p' "$repo_root/VERSION")
temporary_parent=${TMPDIR:-/tmp}
temporary_parent=${temporary_parent%/}
test_root=$(mktemp -d "$temporary_parent/bounded-freedom-install-test.XXXXXX")
test_count=0
skip_count=0

cleanup() {
  case "$test_root" in
    "$temporary_parent"/bounded-freedom-install-test.*)
      rm -rf "$test_root"
      ;;
    *)
      echo "refusing to clean an unexpected test path" >&2
      ;;
  esac
}
trap cleanup EXIT
trap 'exit 1' HUP INT TERM

pass() {
  test_count=$((test_count + 1))
  echo "ok $test_count - $1"
}

fail() {
  echo "not ok - $1" >&2
  exit 1
}

skip() {
  skip_count=$((skip_count + 1))
  echo "skip $skip_count - $1"
}

assert_path_absent() {
  if [ -e "$1" ] || [ -L "$1" ]; then
    fail "$2"
  fi
  pass "$2"
}

assert_file_unchanged() {
  if ! cmp -s "$1" "$2"; then
    fail "$3"
  fi
  pass "$3"
}

assert_managed_role_payload() {
  installed=$1
  source=$2
  label=$3
  if [ -L "$installed" ] || [ ! -f "$installed" ]; then
    fail "$label"
  fi
  if [ "$(sed -n '1p' "$installed")" != "# BoundedFreedom managed role file" ]; then
    fail "$label"
  fi
  if ! sed -n '2p' "$installed" | grep -Eq '^# payload cksum: [0-9]+ [0-9]+$'; then
    fail "$label"
  fi
  sed '1,2d' "$installed" > "$test_root/role-payload"
  if ! cmp -s "$source" "$test_root/role-payload"; then
    fail "$label"
  fi
  pass "$label"
}

assert_managed_source() {
  awk -v begin="$begin_marker" -v end="$end_marker" '
    $0 == begin { inside = 1; separator = 1; next }
    $0 == end { exit }
    inside && separator { separator = 0; if ($0 == "") next }
    inside { print }
  ' "$1" > "$test_root/deployed-block"
  assert_file_unchanged "$2" "$test_root/deployed-block" "$3"
}

assert_contains() {
  if ! grep -Fq "$1" "$2"; then
    fail "$3"
  fi
  pass "$3"
}

assert_not_contains() {
  if grep -Fq "$1" "$2"; then
    fail "$3"
  fi
  pass "$3"
}

file_mode() {
  if stat -f '%Lp' "$1" >/dev/null 2>&1; then
    stat -f '%Lp' "$1"
  else
    stat -c '%a' "$1"
  fi
}

expect_exit() {
  expected_status=$1
  output_file=$2
  shift 2
  set +e
  "$@" > "$output_file" 2>&1
  actual_status=$?
  set -e
  if [ "$actual_status" -ne "$expected_status" ]; then
    fail "expected exit $expected_status but received $actual_status"
  fi
}

codex_role_manifest="$repo_root/install/codex-role-files.txt"
codex_role_files=""
load_codex_roles() {
  while IFS= read -r role_entry || [ -n "$role_entry" ]; do
    role_entry=$(printf '%s\n' "$role_entry" | sed 's/[[:space:]]*#.*$//; s/^[[:space:]]*//; s/[[:space:]]*$//; s/\r$//')
    [ -z "$role_entry" ] && continue
    codex_role_files="${codex_role_files}${codex_role_files:+
}$role_entry"
  done < "$codex_role_manifest"
}

load_codex_roles
tomllib_available=0
if command -v python3 >/dev/null 2>&1 && python3 -c 'import tomllib' >/dev/null 2>&1
then
  tomllib_available=1
fi

toml_scalar_assert() {
  file=$1
  key=$2
  expected=$3
  label=$4
  if python3 - "$file" "$key" "$expected" <<'PY'
import sys
import tomllib

with open(sys.argv[1], "rb") as handle:
  data = tomllib.load(handle)
if data.get(sys.argv[2]) != sys.argv[3]:
  raise SystemExit(1)
PY
  then
    pass "$label"
  else
    fail "$label"
  fi
}

toml_key_absent() {
  file=$1
  key=$2
  label=$3
  if python3 - "$file" "$key" <<'PY'
import sys
import tomllib

with open(sys.argv[1], "rb") as handle:
  data = tomllib.load(handle)
if sys.argv[2] in data:
  raise SystemExit(1)
PY
  then
    pass "$label"
  else
    fail "$label"
  fi
}

expected_role_name() {
  case "$1" in
    scout) printf '%s\n' Scout ;;
    coder) printf '%s\n' Coder ;;
    builder) printf '%s\n' Builder ;;
    reviewer) printf '%s\n' Reviewer ;;
    *)
      return 1
      ;;
  esac
}

sh -n "$installer"
pass "installer has valid POSIX shell syntax"

dry_root="$test_root/dry-run"
"$installer" --host all --target-root "$dry_root" --dry-run > "$test_root/dry-run.out"
assert_path_absent "$dry_root" "dry-run makes no changes"
assert_contains "BoundedFreedom package: v$package_version (Astra Edition)" "$test_root/dry-run.out" "dry-run reports the package version and edition"
assert_contains "dry-run complete; no files were changed" "$test_root/dry-run.out" "dry-run reports completion"

all_root="$test_root/all-hosts"
"$installer" --host all --target-root "$all_root" --install > "$test_root/all-install.out"
for skill_source in "$repo_root/.agents/skills"/*; do
  skill_name=${skill_source##*/}
  portable_link="$all_root/.agents/skills/$skill_name"
  claude_link="$all_root/.claude/skills/$skill_name"
  if [ ! -L "$portable_link" ] || [ "$(readlink "$portable_link")" != "$skill_source" ]; then
    fail "portable Skill $skill_name was not linked to its repository source"
  fi
  if [ ! -L "$claude_link" ] || [ "$(readlink "$claude_link")" != "$skill_source" ]; then
    fail "Claude Skill $skill_name was not linked to its repository source"
  fi
done
pass "all portable and Claude Skills link to repository sources"
for role_file_name in $codex_role_files; do
  role_label=${role_file_name%.toml}
  role_source="$repo_root/.codex/agents/$role_file_name"
  role_file="$all_root/.codex/agents/$role_file_name"
  assert_managed_role_payload "$role_file" "$role_source" "Codex agent $role_label is a managed regular file with literal source metadata"
done
"$installer" --host all --target-root "$all_root" --status > "$test_root/all-status.out"
assert_contains "portable Skill evidence-review: linked" "$test_root/all-status.out" "status reports portable Skills"
assert_contains "portable Skill mathematical-methods: linked" "$test_root/all-status.out" "status reports the sole mathematical entry Skill"
assert_not_contains "portable Skill mathematical-problem-mapping: linked" "$test_root/all-status.out" "status omits the former problem-mapping Skill"
assert_not_contains "portable Skill statistical-model-analysis: linked" "$test_root/all-status.out" "status omits the former statistical Skill"
assert_not_contains "portable Skill neural-network-mathematical-analysis: linked" "$test_root/all-status.out" "status omits the former network Skill"
assert_not_contains "portable Skill loss-objective-optimization: linked" "$test_root/all-status.out" "status omits the former loss Skill"
assert_contains "BoundedFreedom package: v$package_version (Astra Edition)" "$test_root/all-status.out" "status reports the package version and edition"
assert_contains "Codex config.toml: managed block present" "$test_root/all-status.out" "status reports the Codex managed block"
for role_file_name in $codex_role_files; do
  role_label=${role_file_name%.toml}
  assert_contains "Codex agent $role_label: managed regular file (current)" "$test_root/all-status.out" "status reports current managed role $role_label"
done
assert_contains "Codex role file status is file-level only; it does not verify live role launch or model selection" "$test_root/all-status.out" "status states that role files are not live runtime verification"
assert_contains "Codex proxy .env: managed block absent" "$test_root/all-status.out" "ordinary installation leaves Codex proxy settings unchanged"
assert_contains "Claude CLAUDE.md: managed block present" "$test_root/all-status.out" "status reports the Claude managed block"

if ! cmp -s "$repo_root/.codex/config.toml" "$repo_root/install/agents-config.toml"; then
  fail "project and install Codex agent defaults diverged"
fi
pass "project and install Codex agent defaults match"

portable_no_codex_root="$test_root/portable-no-codex"
mkdir -p "$portable_no_codex_root/scripts" "$portable_no_codex_root/install"
portable_no_codex_root=$(CDPATH= cd -- "$portable_no_codex_root" && pwd -P)
cp "$repo_root/scripts/install-global.sh" "$portable_no_codex_root/scripts/"
cp -R "$repo_root/.agents" "$portable_no_codex_root/"
cp "$repo_root/install/global-agents.md" "$portable_no_codex_root/install/"
cp "$repo_root/VERSION" "$portable_no_codex_root/VERSION"
portable_no_codex_target="$portable_no_codex_root/target"
"$portable_no_codex_root/scripts/install-global.sh" --host portable --target-root "$portable_no_codex_target" --install > "$test_root/portable-no-codex.out"
assert_path_absent "$portable_no_codex_root/.codex" "portable mode ignores missing Codex adapter sources"
assert_path_absent "$portable_no_codex_root/install/codex-role-files.txt" "portable mode ignores a missing Codex role manifest"
for skill_source in "$portable_no_codex_root/.agents/skills"/*; do
  skill_name=${skill_source##*/}
  portable_link="$portable_no_codex_target/.agents/skills/$skill_name"
  if [ ! -L "$portable_link" ] || [ "$(readlink "$portable_link")" != "$skill_source" ]; then
    fail "portable mode links the Skill $skill_name without a source Codex install manifest"
  fi
done
pass "portable mode links Skills without Codex adapter source requirements"
claude_no_codex_target="$portable_no_codex_root/claude-target"
"$portable_no_codex_root/scripts/install-global.sh" --host claude --target-root "$claude_no_codex_target" --install > "$test_root/claude-no-codex.out"
assert_managed_source "$claude_no_codex_target/.claude/CLAUDE.md" "$repo_root/install/global-agents.md" "Claude mode installs instructions without Codex adapter sources"
assert_path_absent "$claude_no_codex_target/.codex" "Claude-only mode creates no Codex adapter files"
if [ "$tomllib_available" -eq 1 ]; then
  expected_role_count=$(printf '%s\n' "$codex_role_files" | wc -l | tr -d ' ')
  if [ "$expected_role_count" -ne 4 ]; then
    fail "installer role manifest does not list exactly four canonical role profiles"
  fi
  pass "installer role manifest lists exactly four canonical role profiles"
  role_names_seen=""
  for role_file_name in $codex_role_files; do
    role_base_name=${role_file_name%.toml}
    expected_name_text=$(expected_role_name "$role_base_name")
    if [ -z "$expected_name_text" ]; then
      fail "unknown installer role profile: $role_file_name"
    fi
    toml_scalar_assert "$repo_root/.codex/agents/$role_file_name" "name" "$expected_name_text" "role name is exact for $role_file_name"
    if printf '%s\n' "$role_names_seen" | grep -Fxq -- "$expected_name_text"; then
      fail "role names must be unique; $expected_name_text is duplicated"
    fi
    role_names_seen="$role_names_seen
$expected_name_text"
    case "$role_base_name" in
      scout)
        toml_scalar_assert "$repo_root/.codex/agents/$role_file_name" "sandbox_mode" "read-only" "Scout role profile keeps read-only sandbox policy"
        toml_key_absent "$repo_root/.codex/agents/$role_file_name" "model" "Scout role profile omits model"
        toml_key_absent "$repo_root/.codex/agents/$role_file_name" "model_reasoning_effort" "Scout role profile omits model_reasoning_effort"
        ;;
      coder)
        toml_scalar_assert "$repo_root/.codex/agents/$role_file_name" "sandbox_mode" "workspace-write" "Coder profile keeps workspace-write policy"
        toml_key_absent "$repo_root/.codex/agents/$role_file_name" "model" "Coder role profile omits model"
        toml_key_absent "$repo_root/.codex/agents/$role_file_name" "model_reasoning_effort" "Coder role profile omits model_reasoning_effort"
        ;;
      builder)
        toml_scalar_assert "$repo_root/.codex/agents/$role_file_name" "sandbox_mode" "workspace-write" "Builder profile keeps workspace-write policy"
        toml_key_absent "$repo_root/.codex/agents/$role_file_name" "model" "Builder role profile omits model"
        toml_key_absent "$repo_root/.codex/agents/$role_file_name" "model_reasoning_effort" "Builder role profile omits model_reasoning_effort"
        ;;
      reviewer)
        toml_scalar_assert "$repo_root/.codex/agents/$role_file_name" "sandbox_mode" "read-only" "Reviewer profile keeps read-only policy"
        toml_key_absent "$repo_root/.codex/agents/$role_file_name" "model" "Reviewer role profile omits model"
        toml_key_absent "$repo_root/.codex/agents/$role_file_name" "model_reasoning_effort" "Reviewer role profile omits model_reasoning_effort"
        ;;
      *)
        fail "unknown installer role profile: $role_file_name"
        ;;
    esac
  done
else
  skip "python3 with tomllib is unavailable for role TOML semantic checks"
fi
assert_contains 'default_subagent_model = "gpt-5.6-luna"' "$repo_root/.codex/config.toml" "untyped bounded work keeps the economical Luna fallback"
assert_contains 'max_concurrent_threads_per_session = 2' "$repo_root/.codex/config.toml" "Codex keeps the two-worker concurrency ceiling"
orchestration_skill="$repo_root/.agents/skills/cost-efficient-orchestration/SKILL.md"
host_routing="$repo_root/.agents/skills/cost-efficient-orchestration/host-model-routing.md"
route_evals="$repo_root/.agents/skills/cost-efficient-orchestration/routing-evals.md"
assert_contains 'run the host adapter' "$orchestration_skill" "orchestration requires the Spark candidate preflight"
assert_contains 'immediately before every prospective Spark worker launch' "$host_routing" "host routing refreshes quota before each Spark launch"
assert_contains '`available`:' "$host_routing" "Spark preflight defines available status"
assert_contains '`blocked`:' "$host_routing" "Spark preflight defines blocked status"
assert_contains '`unknown`:' "$host_routing" "Spark preflight defines unknown status"
assert_contains 'Reviewer policy has no universal Sol floor' "$host_routing" "Reviewer policy distinguishes role from model floor"
assert_contains 'do not rewrite the planned model/effort to fit it' "$host_routing" "runtime mismatch cannot rewrite the route ticket"
assert_contains 'not an `AstraReviewer` role' "$host_routing" "Astra review remains an evidence-gated Reviewer escalation"
assert_contains 'Reviewer is planned Sol/high, but authoritative runtime metadata reports Luna/high' "$route_evals" "routing evaluations cover Reviewer runtime mismatch"
runtime_probe="$repo_root/.agents/skills/cost-efficient-orchestration/scripts/codex-runtime-metadata.sh"
sh -n "$runtime_probe"
pass "Codex runtime metadata probe has valid POSIX shell syntax"
resource_snapshot_script="$repo_root/.agents/skills/cost-efficient-orchestration/scripts/codex-task-resource-snapshot.py"
assert_contains 'TASK RESOURCE SNAPSHOT' "$orchestration_skill" "orchestration requires a compact task resource snapshot"
assert_contains 'pre-final checkpoint' "$orchestration_skill" "orchestration labels Skill-time resource coverage honestly"
assert_contains 'TASK RESOURCE SNAPSHOT' "$repo_root/install/global-agents.md" "installed instructions request the resource snapshot"
if command -v python3 >/dev/null 2>&1; then
  python3 -m py_compile "$resource_snapshot_script"
  pass "Codex task resource snapshot script has valid Python syntax"
  python3 "$repo_root/scripts/test-codex-task-resource-snapshot.py" > "$test_root/task-resource-snapshot.out" 2>&1
  assert_contains "Ran 14 tests in" "$test_root/task-resource-snapshot.out" "focused task-resource snapshot tests pass"
else
  skip "python3 is unavailable for task-resource snapshot tests"
fi
CODEX_HOME="$test_root/runtime-missing" CODEX_THREAD_ID= CODEX_SESSION_ID= sh "$runtime_probe" > "$test_root/runtime-missing.out"
assert_contains '"status":"unknown"' "$test_root/runtime-missing.out" "runtime probe fails closed without a thread identifier"
if command -v sqlite3 >/dev/null 2>&1; then
  runtime_root="$test_root/runtime-metadata"
  mkdir -p "$runtime_root"
  sqlite3 "$runtime_root/state_5.sqlite" <<'SQL'
CREATE TABLE threads (id TEXT PRIMARY KEY, model TEXT, reasoning_effort TEXT, agent_role TEXT, created_at INTEGER);
CREATE TABLE thread_spawn_edges (parent_thread_id TEXT, child_thread_id TEXT, status TEXT);
INSERT INTO threads VALUES ('11111111-1111-1111-1111-111111111111', 'gpt-5.6-sol', 'high', NULL, 1);
INSERT INTO threads VALUES ('22222222-2222-2222-2222-222222222222', 'gpt-5.3-codex-spark', 'medium', 'Coder', 2);
INSERT INTO thread_spawn_edges VALUES ('11111111-1111-1111-1111-111111111111', '22222222-2222-2222-2222-222222222222', 'open');
SQL
  CODEX_HOME="$runtime_root" CODEX_THREAD_ID='11111111-1111-1111-1111-111111111111' sh "$runtime_probe" > "$test_root/runtime-chief.out"
  assert_contains '"scope":"chief","model":"gpt-5.6-sol","reasoning_effort":"high"' "$test_root/runtime-chief.out" "runtime probe reports the host-recorded Chief pair"
  CODEX_HOME="$runtime_root" CODEX_THREAD_ID='11111111-1111-1111-1111-111111111111' sh "$runtime_probe" --children > "$test_root/runtime-child.out"
  assert_contains '"scope":"child","role":"Coder","model":"gpt-5.3-codex-spark","reasoning_effort":"medium","lifecycle":"open"' "$test_root/runtime-child.out" "runtime probe reports the host-recorded child pair"
else
  skip "sqlite3 is unavailable for runtime metadata regression coverage"
fi
assert_managed_source "$all_root/.codex/AGENTS.md" "$repo_root/install/global-agents.md" "Codex receives the complete managed instructions"
assert_managed_source "$all_root/.codex/config.toml" "$repo_root/install/agents-config.toml" "Codex receives the complete managed configuration"
assert_managed_source "$all_root/.claude/CLAUDE.md" "$repo_root/install/global-agents.md" "Claude receives the complete managed instructions"

discoverable_skill_count=$(find "$repo_root/.agents/skills" -mindepth 2 -maxdepth 2 -name SKILL.md | wc -l | tr -d ' ')
if [ "$discoverable_skill_count" -ne 8 ]; then
  fail "the repository does not expose the expected eight Skills"
fi
pass "the repository exposes the expected eight Skills"
discoverable_math_count=$(find "$repo_root/.agents/skills" -mindepth 2 -maxdepth 2 -name SKILL.md -path '*/mathematical-*/*' | wc -l | tr -d ' ')
if [ "$discoverable_math_count" -ne 1 ]; then
  fail "the repository does not expose exactly one mathematical Skill"
fi
pass "the repository exposes exactly one mathematical Skill"
if find "$repo_root/.agents/skills/mathematical-methods/references" -name SKILL.md | grep -q .; then
  fail "an internal mathematical module is independently discoverable"
fi
pass "mathematical method modules are references rather than discoverable Skills"

legacy_root="$test_root/legacy-migration"
mkdir -p "$legacy_root/.agents/skills" "$legacy_root/.claude/skills"
for legacy_name in mathematical-problem-mapping statistical-model-analysis neural-network-mathematical-analysis loss-objective-optimization; do
  ln -s "$repo_root/.agents/skills/$legacy_name" "$legacy_root/.agents/skills/$legacy_name"
  ln -s "$repo_root/.agents/skills/$legacy_name" "$legacy_root/.claude/skills/$legacy_name"
done
"$installer" --host all --target-root "$legacy_root" --dry-run > "$test_root/legacy-dry-run.out"
assert_contains "would remove legacy managed portable Skill mathematical-problem-mapping" "$test_root/legacy-dry-run.out" "migration dry-run reports portable legacy cleanup"
assert_contains "would remove legacy managed Claude Skill mathematical-problem-mapping" "$test_root/legacy-dry-run.out" "migration dry-run reports Claude legacy cleanup"
if [ ! -L "$legacy_root/.agents/skills/mathematical-problem-mapping" ]; then
  fail "migration dry-run changed a portable legacy link"
fi
pass "migration dry-run preserves portable legacy links"
"$installer" --host all --target-root "$legacy_root" --update > "$test_root/legacy-update.out"
for legacy_name in mathematical-problem-mapping statistical-model-analysis neural-network-mathematical-analysis loss-objective-optimization; do
  assert_path_absent "$legacy_root/.agents/skills/$legacy_name" "migration removes exact managed portable legacy link $legacy_name"
  assert_path_absent "$legacy_root/.claude/skills/$legacy_name" "migration removes exact managed Claude legacy link $legacy_name"
done
if [ ! -L "$legacy_root/.agents/skills/mathematical-methods" ]; then
  fail "migration did not install the consolidated mathematical entry"
fi
pass "migration installs the consolidated mathematical entry"

legacy_preserve_root="$test_root/legacy-preserve"
mkdir -p "$legacy_preserve_root/.agents/skills"
printf 'user-owned\n' > "$legacy_preserve_root/user-owned-target"
ln -s "$legacy_preserve_root/user-owned-target" "$legacy_preserve_root/.agents/skills/statistical-model-analysis"
"$installer" --host portable --target-root "$legacy_preserve_root" --update > "$test_root/legacy-preserve.out"
if [ ! -L "$legacy_preserve_root/.agents/skills/statistical-model-analysis" ] || [ "$(readlink "$legacy_preserve_root/.agents/skills/statistical-model-analysis")" != "$legacy_preserve_root/user-owned-target" ]; then
  fail "migration changed a user-owned legacy-name path"
fi
pass "migration preserves a user-owned legacy-name path"

idempotent_root="$test_root/idempotent"
mkdir -p "$idempotent_root/.codex"
printf 'user instruction\n\n' > "$test_root/user-agents"
printf 'model = "user-choice"\n\n' > "$test_root/user-config"
cp "$test_root/user-agents" "$idempotent_root/.codex/AGENTS.md"
cp "$test_root/user-config" "$idempotent_root/.codex/config.toml"
"$installer" --host codex --target-root "$idempotent_root" --install > "$test_root/idempotent-install.out"
cp "$idempotent_root/.codex/AGENTS.md" "$test_root/agents-installed"
cp "$idempotent_root/.codex/config.toml" "$test_root/config-installed"
"$installer" --host codex --target-root "$idempotent_root" --update > "$test_root/idempotent-update.out"
assert_file_unchanged "$test_root/agents-installed" "$idempotent_root/.codex/AGENTS.md" "AGENTS.md update is byte-idempotent"
assert_file_unchanged "$test_root/config-installed" "$idempotent_root/.codex/config.toml" "config.toml update is byte-idempotent"
sed "/^$begin_marker\$/,\$d" "$idempotent_root/.codex/AGENTS.md" > "$test_root/agents-prefix"
sed "/^$begin_marker\$/,\$d" "$idempotent_root/.codex/config.toml" > "$test_root/config-prefix"
assert_file_unchanged "$test_root/user-agents" "$test_root/agents-prefix" "AGENTS.md preserves user-owned content"
assert_file_unchanged "$test_root/user-config" "$test_root/config-prefix" "config.toml preserves user-owned content"

role_idempotent_before="$test_root/role-idempotent-before"
cp "$idempotent_root/.codex/agents/builder.toml" "$role_idempotent_before"
"$installer" --host codex --target-root "$idempotent_root" --update > "$test_root/role-idempotent-update.out"
assert_file_unchanged "$role_idempotent_before" "$idempotent_root/.codex/agents/builder.toml" "managed role update is byte-idempotent"

role_legacy_root="$test_root/role-legacy-migration"
mkdir -p "$role_legacy_root/.codex/agents"
for role in scout coder builder reviewer; do
  ln -s "$repo_root/.codex/agents/$role.toml" "$role_legacy_root/.codex/agents/$role.toml"
done
"$installer" --host codex --target-root "$role_legacy_root" --dry-run > "$test_root/role-legacy-dry-run.out"
assert_contains "would install managed role file: Codex agent scout" "$test_root/role-legacy-dry-run.out" "dry-run reports legacy role migration"
if [ ! -L "$role_legacy_root/.codex/agents/scout.toml" ]; then
  fail "role migration dry-run changed a legacy role link"
fi
pass "role migration dry-run preserves legacy links"
"$installer" --host codex --target-root "$role_legacy_root" --update > "$test_root/role-legacy-update.out"
for role in scout coder builder reviewer; do
  assert_managed_role_payload "$role_legacy_root/.codex/agents/$role.toml" "$repo_root/.codex/agents/$role.toml" "legacy Codex agent $role migrates to a managed regular file"
done

role_foreign_root="$test_root/role-foreign-conflict"
mkdir -p "$role_foreign_root/.codex/agents"
printf 'user-owned\n' > "$role_foreign_root/foreign-role"
ln -s "$role_foreign_root/foreign-role" "$role_foreign_root/.codex/agents/scout.toml"
expect_exit 1 "$test_root/role-foreign-conflict.out" "$installer" --host codex --target-root "$role_foreign_root" --install
if [ ! -L "$role_foreign_root/.codex/agents/scout.toml" ]; then
  fail "foreign role link was replaced"
fi
pass "foreign role link is preserved"
assert_path_absent "$role_foreign_root/.agents" "foreign role conflict causes no portable installation"
assert_path_absent "$role_foreign_root/.codex/agents/coder.toml" "foreign role conflict causes no preceding role mutation for coder"
for role_file_name in $codex_role_files; do
  role_label=${role_file_name%.toml}
  if [ "$role_label" = "scout" ] || [ "$role_label" = "coder" ]; then
    continue
  fi
  assert_path_absent "$role_foreign_root/.codex/agents/$role_file_name" "foreign role conflict causes no preceding role mutation for $role_label"
done

role_unmanaged_root="$test_root/role-unmanaged-conflict"
mkdir -p "$role_unmanaged_root/.codex/agents"
printf 'model = "user-choice"\n' > "$role_unmanaged_root/.codex/agents/coder.toml"
cp "$role_unmanaged_root/.codex/agents/coder.toml" "$test_root/role-unmanaged-before"
expect_exit 1 "$test_root/role-unmanaged-conflict.out" "$installer" --host codex --target-root "$role_unmanaged_root" --install
assert_file_unchanged "$test_root/role-unmanaged-before" "$role_unmanaged_root/.codex/agents/coder.toml" "unmanaged role file is preserved"
assert_path_absent "$role_unmanaged_root/.agents" "unmanaged role conflict causes no portable installation"
assert_path_absent "$role_unmanaged_root/.codex/agents/scout.toml" "unmanaged role conflict causes no preceding role mutation for scout"
for role_file_name in $codex_role_files; do
  role_label=${role_file_name%.toml}
  if [ "$role_label" = "coder" ] || [ "$role_label" = "scout" ]; then
    continue
  fi
  assert_path_absent "$role_unmanaged_root/.codex/agents/$role_file_name" "unmanaged role conflict causes no preceding role mutation for $role_label"
done

retired_roles="scout-routed.toml coder-routed.toml builder-routed.toml reviewer-routed.toml"
retired_role_fixture_dir="$repo_root/scripts/fixtures/retired-codex-roles"
role_retirement_root="$test_root/role-retirement"
mkdir -p "$role_retirement_root/.codex/agents"
for retired_role in $retired_roles; do
  cp "$retired_role_fixture_dir/$retired_role" "$test_root/retired-role-payload"
  payload_checksum=$(cksum < "$test_root/retired-role-payload" | awk '{ print $1 " " $2 }')
  { printf '%s\n' '# BoundedFreedom managed role file'; printf '%s%s\n' '# payload cksum: ' "$payload_checksum"; cat "$test_root/retired-role-payload"; } > "$role_retirement_root/.codex/agents/$retired_role.next"
  mv "$role_retirement_root/.codex/agents/$retired_role.next" "$role_retirement_root/.codex/agents/$retired_role"
done
"$installer" --host codex --target-root "$role_retirement_root" --dry-run > "$test_root/role-retirement-dry-run.out"
assert_contains "would retire managed role file: Retired Codex agent scout-routed" "$test_root/role-retirement-dry-run.out" "dry-run reports managed retired-role cleanup"
"$installer" --host codex --target-root "$role_retirement_root" --status > "$test_root/role-retirement-status.out"
assert_contains "Retired Codex agent reviewer-routed: retirement required (managed regular file)" "$test_root/role-retirement-status.out" "status distinguishes retired managed role cleanup"
"$installer" --host codex --target-root "$role_retirement_root" --update > "$test_root/role-retirement-update.out"
for retired_role in $retired_roles; do
  assert_path_absent "$role_retirement_root/.codex/agents/$retired_role" "update retires managed $retired_role"
done
"$installer" --host codex --target-root "$role_retirement_root" --update > "$test_root/role-retirement-idempotent.out"
assert_not_contains "retire managed role file" "$test_root/role-retirement-idempotent.out" "retired-role cleanup is idempotent"

role_retired_foreign_root="$test_root/role-retired-foreign-conflict"
mkdir -p "$role_retired_foreign_root/.codex/agents"
printf 'user-owned\n' > "$role_retired_foreign_root/foreign-role"
ln -s "$role_retired_foreign_root/foreign-role" "$role_retired_foreign_root/.codex/agents/reviewer-routed.toml"
expect_exit 1 "$test_root/role-retired-foreign-conflict.out" "$installer" --host codex --target-root "$role_retired_foreign_root" --install
assert_contains "retired Codex agent reviewer-routed" "$test_root/role-retired-foreign-conflict.out" "preflight checks retired alias conflicts"
if [ ! -L "$role_retired_foreign_root/.codex/agents/reviewer-routed.toml" ]; then
  fail "foreign retired alias link was replaced"
fi
pass "foreign retired alias is preserved"
assert_path_absent "$role_retired_foreign_root/.agents" "foreign retired alias conflict causes no portable installation"
assert_path_absent "$role_retired_foreign_root/.codex/agents/scout.toml" "foreign retired alias conflict causes no canonical role mutation"

role_retired_matching_link_root="$test_root/role-retired-matching-link-conflict"
mkdir -p "$role_retired_matching_link_root/.codex/agents"
cp "$retired_role_fixture_dir/builder-routed.toml" "$role_retired_matching_link_root/foreign-managed-role"
payload_checksum=$(cksum < "$role_retired_matching_link_root/foreign-managed-role" | awk '{ print $1 " " $2 }')
{ printf '%s\n' '# BoundedFreedom managed role file'; printf '%s%s\n' '# payload cksum: ' "$payload_checksum"; cat "$role_retired_matching_link_root/foreign-managed-role"; } > "$role_retired_matching_link_root/foreign-managed-role.next"
mv "$role_retired_matching_link_root/foreign-managed-role.next" "$role_retired_matching_link_root/foreign-managed-role"
cp "$role_retired_matching_link_root/foreign-managed-role" "$test_root/role-retired-matching-link-target-before"
ln -s "$role_retired_matching_link_root/foreign-managed-role" "$role_retired_matching_link_root/.codex/agents/builder-routed.toml"
expect_exit 1 "$test_root/role-retired-matching-link-conflict.out" "$installer" --host codex --target-root "$role_retired_matching_link_root" --install
if [ ! -L "$role_retired_matching_link_root/.codex/agents/builder-routed.toml" ]; then
  fail "foreign checksum-matched retired alias link was replaced"
fi
pass "foreign checksum-matched retired alias link is preserved"
assert_file_unchanged "$test_root/role-retired-matching-link-target-before" "$role_retired_matching_link_root/foreign-managed-role" "foreign checksum-matched retired alias target is unchanged"
assert_path_absent "$role_retired_matching_link_root/.agents" "foreign checksum-matched retired alias conflict causes no portable installation"
assert_path_absent "$role_retired_matching_link_root/.codex/agents/scout.toml" "foreign checksum-matched retired alias conflict causes no canonical role mutation"

role_retired_modified_root="$test_root/role-retired-modified-conflict"
mkdir -p "$role_retired_modified_root/.codex/agents"
printf '%s\n%s\nlegacy role payload\n# local modification\n' '# BoundedFreedom managed role file' '# payload cksum: 0 0' > "$role_retired_modified_root/.codex/agents/builder-routed.toml"
cp "$role_retired_modified_root/.codex/agents/builder-routed.toml" "$test_root/role-retired-modified-before"
expect_exit 1 "$test_root/role-retired-modified-conflict.out" "$installer" --host codex --target-root "$role_retired_modified_root" --update
assert_file_unchanged "$test_root/role-retired-modified-before" "$role_retired_modified_root/.codex/agents/builder-routed.toml" "modified retired managed role payload is preserved"
assert_path_absent "$role_retired_modified_root/.agents" "modified retired alias conflict causes no partial portable installation"

role_modified_root="$test_root/role-modified-conflict"
mkdir -p "$role_modified_root/.codex/agents"
cp "$all_root/.codex/agents/reviewer.toml" "$role_modified_root/.codex/agents/reviewer.toml"
printf '# local modification\n' >> "$role_modified_root/.codex/agents/reviewer.toml"
cp "$role_modified_root/.codex/agents/reviewer.toml" "$test_root/role-modified-before"
expect_exit 1 "$test_root/role-modified-conflict.out" "$installer" --host codex --target-root "$role_modified_root" --update
assert_file_unchanged "$test_root/role-modified-before" "$role_modified_root/.codex/agents/reviewer.toml" "modified managed role payload is preserved"
assert_path_absent "$role_modified_root/.agents/skills/evidence-review" "modified role conflict causes no partial portable installation"
for role_file_name in $codex_role_files; do
  role_label=${role_file_name%.toml}
  if [ "$role_label" = "reviewer" ]; then
    continue
  fi
  assert_path_absent "$role_modified_root/.codex/agents/$role_file_name" "modified role conflict causes no partial role mutation for $role_label"
done

role_fixture_root="$test_root/role-source-fixture"
mkdir -p "$role_fixture_root"
cp -R "$repo_root/scripts" "$repo_root/.codex" "$repo_root/.agents" "$repo_root/install" "$role_fixture_root/"
cp "$repo_root/VERSION" "$role_fixture_root/VERSION"
fixture_installer="$role_fixture_root/scripts/install-global.sh"
role_refresh_root="$test_root/role-refresh"
"$fixture_installer" --host codex --target-root "$role_refresh_root" --install > "$test_root/role-refresh-install.out"
printf '\n# fixture source refresh\n' >> "$role_fixture_root/.codex/agents/builder.toml"
"$fixture_installer" --host codex --target-root "$role_refresh_root" --update > "$test_root/role-refresh-update.out"
assert_managed_role_payload "$role_refresh_root/.codex/agents/builder.toml" "$role_fixture_root/.codex/agents/builder.toml" "managed role refreshes when its isolated source changes"

role_fixed_payload_root="$test_root/role-fixed-payload-update"
cp "$role_fixture_root/.codex/agents/builder.toml" "$test_root/builder-unpinned-source"
awk '
  /^sandbox_mode/ {
    print "model = \"gpt-5.6-terra\""
    print "model_reasoning_effort = \"medium\""
  }
  { print }
' "$test_root/builder-unpinned-source" > "$role_fixture_root/.codex/agents/builder.toml"
"$fixture_installer" --host codex --target-root "$role_fixed_payload_root" --install > "$test_root/role-fixed-payload-install.out"
cp "$test_root/builder-unpinned-source" "$role_fixture_root/.codex/agents/builder.toml"
"$fixture_installer" --host codex --target-root "$role_fixed_payload_root" --update > "$test_root/role-fixed-payload-update.out"
assert_managed_role_payload "$role_fixed_payload_root/.codex/agents/builder.toml" "$role_fixture_root/.codex/agents/builder.toml" "old managed fixed canonical payload refreshes to the unpinned source"
if [ "$tomllib_available" -eq 1 ]; then
  toml_key_absent "$role_fixed_payload_root/.codex/agents/builder.toml" "model" "updated canonical Builder payload removes the former fixed model"
  toml_key_absent "$role_fixed_payload_root/.codex/agents/builder.toml" "model_reasoning_effort" "updated canonical Builder payload removes the former fixed effort"
fi

if command -v python3 >/dev/null 2>&1; then
  secure_open_root="$test_root/secure-open"
  mkdir -p "$secure_open_root"
  printf 'fixture payload\n' > "$secure_open_root/source.toml"
  ln -s "$secure_open_root/source.toml" "$secure_open_root/legacy.toml"
  if python3 - "$secure_open_root/legacy.toml" "$role_refresh_root/.codex/agents" "$codex_role_manifest" <<'PY'
import errno
import os
import sys
from pathlib import Path

legacy, installed_directory, manifest = sys.argv[1:]
with open(legacy, encoding="utf-8") as handle:
  assert handle.read() == "fixture payload\n"
if not hasattr(os, "O_NOFOLLOW"):
  raise SystemExit(77)
flags = os.O_RDONLY | os.O_NOFOLLOW | getattr(os, "O_NONBLOCK", 0)
try:
  descriptor = os.open(legacy, flags)
except OSError as error:
  if error.errno != errno.ELOOP:
    raise
else:
  os.close(descriptor)
  raise AssertionError("secure open unexpectedly accepted a symlink")
for entry in Path(manifest).read_text(encoding="utf-8").splitlines():
  name = entry.partition("#")[0].strip()
  if name:
    descriptor = os.open(Path(installed_directory) / name, flags)
    os.close(descriptor)
PY
  then
    pass "secure open rejects a role symlink and accepts all installer-produced regular role files when supported"
  else
    secure_open_status=$?
    if [ "$secure_open_status" -eq 77 ]; then
      skip "O_NOFOLLOW is unavailable for secure-open regression coverage"
    else
      fail "secure-open regression failed"
    fi
  fi
else
  skip "python3 is unavailable for O_NOFOLLOW regression coverage"
fi

manifest_error_root="$test_root/manifest-errors"
mkdir -p "$manifest_error_root"
manifest_error_fixture="$manifest_error_root/base"
mkdir -p "$manifest_error_fixture"
cp -R "$repo_root/scripts" "$repo_root/.codex" "$repo_root/.agents" "$repo_root/install" "$repo_root/VERSION" "$manifest_error_root/base/"
manifest_invalid_path_root="$manifest_error_root/invalid-path"
mkdir -p "$manifest_invalid_path_root"
cp -R "$manifest_error_fixture/." "$manifest_invalid_path_root/"
cat > "$manifest_invalid_path_root/install/codex-role-files.txt" <<'EOF_ROLES'
scout.toml
bad/name.toml
EOF_ROLES
expect_exit 1 "$test_root/manifest-invalid-path.out" "$manifest_invalid_path_root/scripts/install-global.sh" --host codex --target-root "$manifest_error_root/invalid-path-target" --install
assert_contains "contains an invalid role entry" "$test_root/manifest-invalid-path.out" "invalid manifest rejection reaches role-entry validation"
assert_not_contains "bad/name.toml" "$test_root/manifest-invalid-path.out" "manifest errors do not echo untrusted path entries"
assert_path_absent "$manifest_error_root/invalid-path-target" "invalid manifest entries are rejected before writes"

manifest_duplicate_root="$manifest_error_root/duplicate-entry"
mkdir -p "$manifest_duplicate_root"
cp -R "$manifest_error_fixture/." "$manifest_duplicate_root/"
cat > "$manifest_duplicate_root/install/codex-role-files.txt" <<'EOF_ROLES'
scout.toml
scout.toml
coder.toml
builder.toml
reviewer.toml
EOF_ROLES
expect_exit 1 "$test_root/manifest-duplicate.out" "$manifest_duplicate_root/scripts/install-global.sh" --host codex --target-root "$manifest_error_root/duplicate-target" --install
assert_contains "contains duplicate role entries" "$test_root/manifest-duplicate.out" "duplicate manifest rejection reaches duplicate validation"
assert_path_absent "$manifest_error_root/duplicate-target" "duplicate manifest entries are rejected before writes"

manifest_missing_root="$manifest_error_root/missing-source"
mkdir -p "$manifest_missing_root"
cp -R "$manifest_error_fixture/." "$manifest_missing_root/"
cat > "$manifest_missing_root/install/codex-role-files.txt" <<'EOF_ROLES'
scout.toml
coder.toml
builder.toml
reviewer.toml
missing-profile.toml
EOF_ROLES
expect_exit 1 "$test_root/manifest-missing-source.out" "$manifest_missing_root/scripts/install-global.sh" --host codex --target-root "$manifest_error_root/missing-source-target" --install
assert_contains "a Codex role source is not a regular file" "$test_root/manifest-missing-source.out" "missing source rejection reaches role-file validation"
assert_path_absent "$manifest_error_root/missing-source-target" "missing manifest sources are rejected before writes"

manifest_empty_root="$manifest_error_root/empty"
mkdir -p "$manifest_empty_root"
cp -R "$manifest_error_fixture/." "$manifest_empty_root/"
printf '# no roles\n\n' > "$manifest_empty_root/install/codex-role-files.txt"
expect_exit 1 "$test_root/manifest-empty.out" "$manifest_empty_root/scripts/install-global.sh" --host codex --target-root "$manifest_error_root/empty-target" --install
assert_contains "install/codex-role-files.txt is empty" "$test_root/manifest-empty.out" "empty manifest rejection reaches role-list validation"
assert_path_absent "$manifest_error_root/empty-target" "an empty manifest is rejected before writes"

proxy_bin="$test_root/proxy-bin"
mkdir -p "$proxy_bin"
cat > "$proxy_bin/scutil" <<'EOF'
#!/bin/sh
if [ "${1:-}" != "--proxy" ]; then
  exit 2
fi
cat <<'PROXY'
<dictionary> {
  HTTPEnable : 1
  HTTPPort : 18080
  HTTPProxy : 127.0.0.1
  HTTPSEnable : 1
  HTTPSPort : 18080
  HTTPSProxy : 127.0.0.1
}
PROXY
EOF
chmod +x "$proxy_bin/scutil"
cat > "$proxy_bin/uname" <<'EOF'
#!/bin/sh
printf 'Darwin\n'
EOF
chmod +x "$proxy_bin/uname"

proxy_dry_root="$test_root/proxy-dry-run"
PATH="$proxy_bin:$PATH" "$installer" --host codex --target-root "$proxy_dry_root" --codex-proxy system --dry-run > "$test_root/proxy-dry-run.out"
assert_path_absent "$proxy_dry_root" "proxy dry-run makes no target-root changes"
assert_contains "would refresh managed Codex proxy .env block" "$test_root/proxy-dry-run.out" "proxy dry-run reports the managed .env action"

proxy_root="$test_root/proxy-install"
mkdir -p "$proxy_root/.codex"
printf 'USER_SETTING="preserved"\n\n' > "$proxy_root/.codex/.env"
PATH="$proxy_bin:$PATH" "$installer" --host codex --target-root "$proxy_root" --codex-proxy system --install > "$test_root/proxy-install.out"
assert_contains 'USER_SETTING="preserved"' "$proxy_root/.codex/.env" "proxy import preserves unrelated user .env content"
assert_contains 'HTTP_PROXY="http://127.0.0.1:18080"' "$proxy_root/.codex/.env" "proxy import records the detected HTTP proxy"
assert_contains 'HTTPS_PROXY="http://127.0.0.1:18080"' "$proxy_root/.codex/.env" "proxy import records the detected HTTPS proxy"
assert_contains 'NO_PROXY="localhost,127.0.0.1,::1"' "$proxy_root/.codex/.env" "proxy import keeps local services outside the proxy"
if [ "$(file_mode "$proxy_root/.codex/.env")" != "600" ]; then
  fail "managed proxy .env is not private to its owner"
fi
pass "managed proxy .env is private to its owner"
"$installer" --host codex --target-root "$proxy_root" --status > "$test_root/proxy-status.out"
assert_contains "Codex proxy .env: managed block present" "$test_root/proxy-status.out" "status reports the managed proxy block"
cp "$proxy_root/.codex/.env" "$test_root/proxy-installed"
PATH="$proxy_bin:$PATH" "$installer" --host codex --target-root "$proxy_root" --codex-proxy system --update > "$test_root/proxy-update.out"
assert_file_unchanged "$test_root/proxy-installed" "$proxy_root/.codex/.env" "proxy update is byte-idempotent"
"$installer" --host codex --target-root "$proxy_root" --codex-proxy remove --update > "$test_root/proxy-remove.out"
assert_contains 'USER_SETTING="preserved"' "$proxy_root/.codex/.env" "proxy removal preserves unrelated user .env content"
assert_not_contains "$begin_marker" "$proxy_root/.codex/.env" "proxy removal removes only the managed block"
assert_not_contains 'HTTP_PROXY=' "$proxy_root/.codex/.env" "proxy removal removes managed proxy values"

proxy_conflict_root="$test_root/proxy-conflict"
mkdir -p "$proxy_conflict_root/.codex"
printf 'HTTPS_PROXY="http://user-owned.invalid:18080"\n' > "$proxy_conflict_root/.codex/.env"
cp "$proxy_conflict_root/.codex/.env" "$test_root/proxy-conflict-before"
expect_exit 4 "$test_root/proxy-conflict.out" env PATH="$proxy_bin:$PATH" "$installer" --host codex --target-root "$proxy_conflict_root" --codex-proxy system --install
assert_file_unchanged "$test_root/proxy-conflict-before" "$proxy_conflict_root/.codex/.env" "proxy import preserves user-owned proxy variables"
assert_path_absent "$proxy_conflict_root/.agents" "proxy conflict creates no portable configuration"
assert_path_absent "$proxy_conflict_root/.codex/agents" "proxy conflict creates no Codex agent links"

expect_exit 2 "$test_root/proxy-host.out" "$installer" --host portable --target-root "$test_root/proxy-host" --codex-proxy system --install
assert_path_absent "$test_root/proxy-host" "non-Codex proxy request makes no changes"

link_conflict_root="$test_root/link-conflict"
mkdir -p "$link_conflict_root/.claude/skills/evidence-review"
expect_exit 1 "$test_root/link-conflict.out" "$installer" --host all --target-root "$link_conflict_root" --install
link_count=$(find "$link_conflict_root" -type l | wc -l | tr -d ' ')
if [ "$link_count" -ne 0 ]; then
  fail "a late link conflict caused a partial installation"
fi
pass "a late link conflict creates no partial links"
assert_path_absent "$link_conflict_root/.agents" "a late link conflict creates no portable configuration"
assert_path_absent "$link_conflict_root/.codex" "a late link conflict creates no Codex configuration"
if [ ! -d "$link_conflict_root/.claude/skills/evidence-review" ]; then
  fail "the conflicting user-owned path was not preserved"
fi
pass "a conflicting user-owned path is preserved"

config_conflict_root="$test_root/config-conflict"
mkdir -p "$config_conflict_root/.codex"
printf '[agents]\nmax_threads = 2\n' > "$config_conflict_root/.codex/config.toml"
cp "$config_conflict_root/.codex/config.toml" "$test_root/config-conflict-before"
expect_exit 3 "$test_root/config-conflict.out" "$installer" --host codex --target-root "$config_conflict_root" --install
assert_file_unchanged "$test_root/config-conflict-before" "$config_conflict_root/.codex/config.toml" "user-owned agents table is preserved"
assert_path_absent "$config_conflict_root/.agents" "agents-table conflict creates no portable configuration"
assert_path_absent "$config_conflict_root/.codex/agents" "agents-table conflict creates no Codex agent links"

symlink_root="$test_root/managed-symlink"
mkdir -p "$symlink_root/.codex"
printf 'user instruction\n' > "$symlink_root/user-agents"
cp "$symlink_root/user-agents" "$test_root/symlink-target-before"
ln -s "$symlink_root/user-agents" "$symlink_root/.codex/AGENTS.md"
expect_exit 1 "$test_root/managed-symlink.out" "$installer" --host codex --target-root "$symlink_root" --install
if [ ! -L "$symlink_root/.codex/AGENTS.md" ]; then
  fail "a managed-file symlink was replaced"
fi
pass "a managed-file symlink is not replaced"
assert_file_unchanged "$test_root/symlink-target-before" "$symlink_root/user-agents" "a managed-file symlink target is unchanged"
assert_path_absent "$symlink_root/.agents" "managed-file conflict creates no portable configuration"
"$installer" --host codex --target-root "$symlink_root" --status > "$test_root/managed-symlink-status.out"
assert_contains "Codex AGENTS.md: conflict (symbolic link)" "$test_root/managed-symlink-status.out" "status identifies a managed-file symlink conflict"

marker_root="$test_root/malformed-markers"
mkdir -p "$marker_root/.codex"
printf 'user instruction\n%s\nunclosed managed text\n' "$begin_marker" > "$marker_root/.codex/AGENTS.md"
cp "$marker_root/.codex/AGENTS.md" "$test_root/malformed-before"
expect_exit 1 "$test_root/malformed-markers.out" "$installer" --host codex --target-root "$marker_root" --install
assert_file_unchanged "$test_root/malformed-before" "$marker_root/.codex/AGENTS.md" "malformed managed markers are preserved for manual repair"
assert_path_absent "$marker_root/.agents" "malformed markers create no portable configuration"
"$installer" --host codex --target-root "$marker_root" --status > "$test_root/malformed-status.out"
assert_contains "Codex AGENTS.md: invalid managed markers" "$test_root/malformed-status.out" "status identifies malformed managed markers"

echo "installer regression tests passed: $test_count"
echo "installer regression checks skipped: $skip_count"
