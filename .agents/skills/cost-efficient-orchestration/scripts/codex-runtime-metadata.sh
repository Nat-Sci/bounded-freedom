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

compute_policy_fingerprint() {
  policy_repo_root=$1
  (
    CDPATH= cd -- "$policy_repo_root"
    {
      for policy_source in VERSION install/global-agents.md install/agents-config.toml install/codex-role-files.txt; do
        [ -f "$policy_source" ] || exit 1
        policy_checksum=$(cksum < "$policy_source")
        printf '%s|%s\n' "$policy_source" "$policy_checksum"
      done
      find .agents/skills .codex/agents -type f \
        \( -name 'SKILL.md' -o -name '*.md' -o -name '*.sh' -o -name '*.py' -o -name '*.toml' \) \
        ! -path '*/__pycache__/*' ! -name '*.pyc' -print | LC_ALL=C sort | while IFS= read -r policy_source; do
          policy_checksum=$(cksum < "$policy_source")
          printf '%s|%s\n' "$policy_source" "$policy_checksum"
        done
    } | cksum | awk '{ print $1 "-" $2 }'
  )
}

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

rows=
for state_db in "$codex_state_root"/state_*.sqlite; do
  [ -f "$state_db" ] || continue
  if [ "$scope" = "chief" ]; then
    rows=$(sqlite3 -readonly -separator '|' "$state_db" \
      "SELECT model, reasoning_effort, created_at FROM threads WHERE id = '$thread_id' LIMIT 1;" \
      2>/dev/null) || rows=
  else
    rows=$(sqlite3 -readonly -separator '|' "$state_db" \
      "SELECT t.agent_role, t.model, t.reasoning_effort, e.status FROM thread_spawn_edges e JOIN threads t ON t.id = e.child_thread_id WHERE e.parent_thread_id = '$thread_id' ORDER BY t.created_at ASC;" \
      2>/dev/null) || rows=
  fi
  [ -n "$rows" ] && break
done

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
