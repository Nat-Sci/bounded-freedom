#!/bin/sh
# Read effective Codex thread metadata without exposing local paths or thread IDs.
set -eu

scope=chief
if [ "${1:-}" = "--children" ]; then
  scope=children
elif [ "$#" -ne 0 ]; then
  echo "usage: codex-runtime-metadata.sh [--children]" >&2
  exit 2
fi

unknown() {
  printf '{"status":"unknown","scope":"%s","metadata_source":"runtime","policy_freshness":"unknown","policy_version":"unknown","policy_evidence":"unknown","reason":"%s"}\n' "$scope" "$1"
  exit 0
}

script_directory=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd -P)
[ -r "$script_directory/policy-fingerprint.sh" ] || unknown "policy-helper-unavailable"
. "$script_directory/policy-fingerprint.sh"

thread_id=${CODEX_THREAD_ID:-${CODEX_SESSION_ID:-}}
case "$thread_id" in
  ''|*[!0-9A-Fa-f-]*) unknown "thread-id-unavailable" ;;
esac

if ! command -v sqlite3 >/dev/null 2>&1; then
  unknown "sqlite3-unavailable"
fi

if [ -n "${CODEX_HOME:-}" ]; then
  codex_state_root=$CODEX_HOME
elif [ -n "${HOME:-}" ]; then
  codex_state_root=$HOME/.codex
else
  unknown "codex-state-root-unavailable"
fi

# Pick exactly one highest numeric generation. Never fall back after a failed query.
state_selection=$(
  for candidate in "$codex_state_root"/state_*.sqlite; do
    [ -f "$candidate" ] || continue
    generation=${candidate##*/state_}
    generation=${generation%.sqlite}
    case "$generation" in (''|*[!0-9]*) continue ;; esac
    printf '%s|%s\n' "$generation" "$candidate"
  done | LC_ALL=C sort -t '|' -k1,1n | tail -n 1
)
[ -n "$state_selection" ] || unknown "thread-metadata-unavailable"
state_db=${state_selection#*|}
if [ "$scope" = "chief" ]; then
  rows=$(sqlite3 -readonly -separator '|' "$state_db" \
    "SELECT model, reasoning_effort, created_at FROM threads WHERE id = '$thread_id' LIMIT 1;" \
    2>/dev/null) || rows=
else
  parent_rows=$(sqlite3 -readonly -separator '|' "$state_db" \
    "SELECT model, reasoning_effort, created_at FROM threads WHERE id = '$thread_id' LIMIT 1;" \
    2>/dev/null) || parent_rows=
  [ -n "$parent_rows" ] || unknown "thread-metadata-unavailable"
  rows=$(sqlite3 -readonly -separator '|' "$state_db" \
    "SELECT t.agent_role, t.model, t.reasoning_effort, e.status FROM thread_spawn_edges e JOIN threads t ON t.id = e.child_thread_id WHERE e.parent_thread_id = '$thread_id' ORDER BY t.created_at ASC;" \
    2>/dev/null) || rows=
fi
[ -n "$rows" ] || unknown "thread-metadata-unavailable"

if [ "$scope" = "chief" ]; then
  model=${rows%%|*}
  remainder=${rows#*|}
  effort=${remainder%%|*}
  thread_created_at=${remainder#*|}
  case "$model" in ''|*[!A-Za-z0-9._-]*) unknown "invalid-model-metadata" ;; esac
  case "$effort" in none|minimal|low|medium|high|xhigh|max|ultra) ;; *) unknown "invalid-effort-metadata" ;; esac
  case "$thread_created_at" in ''|*[!0-9]*) unknown "invalid-task-start-metadata" ;; esac

  policy_freshness=unknown
  policy_version=unknown
  policy_evidence=unknown
  policy_state="$codex_state_root/bounded-freedom-policy.state"
  if [ -f "$policy_state" ] && [ ! -L "$policy_state" ] \
    && [ "$(sed -n '1p' "$policy_state")" = "# BoundedFreedom managed policy state" ] \
    && [ "$(grep -c '^schema_version=1$' "$policy_state")" -eq 1 ] \
    && [ "$(grep -Ec '^package_version=[0-9]+\.[0-9]+\.[0-9]+$' "$policy_state")" -eq 1 ] \
    && [ "$(grep -Ec '^policy_fingerprint=[0-9]+-[0-9]+$' "$policy_state")" -eq 1 ] \
    && [ "$(grep -Ec '^installed_at_epoch=[0-9]+$' "$policy_state")" -eq 1 ]; then
    policy_version=$(sed -n 's/^package_version=//p' "$policy_state")
    installed_fingerprint=$(sed -n 's/^policy_fingerprint=//p' "$policy_state")
    policy_installed_at=$(sed -n 's/^installed_at_epoch=//p' "$policy_state")
    script_repo_root=$(CDPATH= cd -- "$(dirname -- "$0")/../../../.." 2>/dev/null && pwd -P) || script_repo_root=
    source_version=
    if [ -n "$script_repo_root" ] && [ -f "$script_repo_root/VERSION" ]; then
      source_version=$(sed -n '1p' "$script_repo_root/VERSION")
    fi
    source_fingerprint=
    if [ -n "$script_repo_root" ]; then
      source_fingerprint=$(compute_policy_fingerprint "$script_repo_root" 2>/dev/null) || source_fingerprint=
    fi
    policy_evidence=managed-install-marker+task-start
    if [ -z "$source_version" ] || [ -z "$source_fingerprint" ] \
      || [ "$policy_version" != "$source_version" ] \
      || [ "$installed_fingerprint" != "$source_fingerprint" ]; then
      policy_freshness=stale
      policy_evidence=managed-install-marker+source-mismatch
    elif [ "$thread_created_at" -ge "$policy_installed_at" ]; then
      policy_freshness=current
    else
      policy_freshness=stale
    fi
  fi

  printf '{"status":"observed","scope":"chief","model":"%s","reasoning_effort":"%s","metadata_source":"runtime","policy_freshness":"%s","policy_version":"%s","policy_evidence":"%s"}\n' "$model" "$effort" "$policy_freshness" "$policy_version" "$policy_evidence"
  exit 0
fi

printf '%s\n' "$rows" | while IFS='|' read -r role model effort lifecycle; do
  case "$role$model$lifecycle" in ''|*[!A-Za-z0-9._-]*) continue ;; esac
  case "$effort" in none|minimal|low|medium|high|xhigh|max|ultra) ;; *) continue ;; esac
  printf '{"status":"observed","scope":"child","role":"%s","model":"%s","reasoning_effort":"%s","lifecycle":"%s","metadata_source":"runtime"}\n' "$role" "$model" "$effort" "$lifecycle"
done
