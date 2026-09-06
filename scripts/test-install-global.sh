#!/bin/sh
# Regression checks for the user-scope installer. All writes stay in one temporary root.
set -eu

repo_root=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd -P)
installer="$repo_root/scripts/install-global.sh"
begin_marker="# >>> BoundedFreedom managed block >>>"
temporary_parent=${TMPDIR:-/tmp}
temporary_parent=${temporary_parent%/}
test_root=$(mktemp -d "$temporary_parent/bounded-freedom-install-test.XXXXXX")
test_count=0

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

sh -n "$installer"
pass "installer has valid POSIX shell syntax"

dry_root="$test_root/dry-run"
"$installer" --host all --target-root "$dry_root" --dry-run > "$test_root/dry-run.out"
assert_path_absent "$dry_root" "dry-run makes no changes"
assert_contains "BoundedFreedom package: v0.3.0 (Astra Edition)" "$test_root/dry-run.out" "dry-run reports the package version and edition"
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
for role in scout coder builder reviewer; do
  role_source="$repo_root/.codex/agents/$role.toml"
  role_link="$all_root/.codex/agents/$role.toml"
  if [ ! -L "$role_link" ] || [ "$(readlink "$role_link")" != "$role_source" ]; then
    fail "Codex agent $role was not linked to its repository source"
  fi
done
pass "all Codex agent profiles link to repository sources"
"$installer" --host all --target-root "$all_root" --status > "$test_root/all-status.out"
assert_contains "portable Skill evidence-review: linked" "$test_root/all-status.out" "status reports portable Skills"
assert_contains "BoundedFreedom package: v0.3.0 (Astra Edition)" "$test_root/all-status.out" "status reports the package version and edition"
assert_contains "Codex config.toml: managed block present" "$test_root/all-status.out" "status reports the Codex managed block"
assert_contains "Codex proxy .env: managed block absent" "$test_root/all-status.out" "ordinary installation leaves Codex proxy settings unchanged"
assert_contains "Claude CLAUDE.md: managed block present" "$test_root/all-status.out" "status reports the Claude managed block"

if ! cmp -s "$repo_root/.codex/config.toml" "$repo_root/install/agents-config.toml"; then
  fail "project and install Codex agent defaults diverged"
fi
pass "project and install Codex agent defaults match"
assert_contains 'model = "gpt-5.3-codex-spark"' "$repo_root/.codex/agents/coder.toml" "Coder uses the specialized Spark route"
assert_contains 'model = "gpt-5.6-terra"' "$repo_root/.codex/agents/builder.toml" "Builder keeps the balanced Terra route"
assert_contains 'model = "gpt-5.6-sol"' "$repo_root/.codex/agents/reviewer.toml" "Reviewer keeps the strong Sol route"
assert_contains 'default_subagent_model = "gpt-5.6-luna"' "$repo_root/.codex/config.toml" "untyped bounded work keeps the economical Luna fallback"
assert_contains 'max_concurrent_threads_per_session = 2' "$repo_root/.codex/config.toml" "Codex keeps the two-worker concurrency ceiling"

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
