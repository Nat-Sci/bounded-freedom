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
  printf '{"status":"unknown","scope":"%s","metadata_source":"runtime","reason":"%s"}\n' "$scope" "$1"
  exit 0
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
      "SELECT model, reasoning_effort FROM threads WHERE id = '$thread_id' LIMIT 1;" \
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
  effort=${rows#*|}
  case "$model" in ''|*[!A-Za-z0-9._-]*) unknown "invalid-model-metadata" ;; esac
  case "$effort" in none|minimal|low|medium|high|xhigh|max|ultra) ;; *) unknown "invalid-effort-metadata" ;; esac
  printf '{"status":"observed","scope":"chief","model":"%s","reasoning_effort":"%s","metadata_source":"runtime"}\n' "$model" "$effort"
  exit 0
fi

printf '%s\n' "$rows" | while IFS='|' read -r role model effort lifecycle; do
  case "$role$model$lifecycle" in ''|*[!A-Za-z0-9._-]*) continue ;; esac
  case "$effort" in none|minimal|low|medium|high|xhigh|max|ultra) ;; *) continue ;; esac
  printf '{"status":"observed","scope":"child","role":"%s","model":"%s","reasoning_effort":"%s","lifecycle":"%s","metadata_source":"runtime"}\n' "$role" "$model" "$effort" "$lifecycle"
done
