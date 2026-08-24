#!/bin/sh
# Install BoundedFreedom as a user-level Codex layer without overwriting user files.
set -eu

usage() {
  cat <<'EOF'
Usage: scripts/install-global.sh [--dry-run|--install|--update|--status] [--target-root DIRECTORY]

  --dry-run              Show the changes that --install would make (default).
  --install, --update    Create or refresh managed links and marked global blocks.
  --status               Report installation state without changing files.
  --target-root DIR      Install below DIR instead of the current user's home directory.
                         Intended for testing or an isolated Codex profile.
EOF
}

mode="dry-run"
target_root=""

while [ "$#" -gt 0 ]; do
  case "$1" in
    --dry-run|--install|--update|--status)
      mode=${1#--}
      ;;
    --target-root)
      shift
      if [ "$#" -eq 0 ]; then
        echo "--target-root requires a directory" >&2
        exit 2
      fi
      target_root=$1
      ;;
    --help|-h)
      usage
      exit 0
      ;;
    *)
      echo "Unknown option: $1" >&2
      usage >&2
      exit 2
      ;;
  esac
  shift
done

repo_root=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd -P)
if [ -z "$target_root" ]; then
  target_root=$HOME
fi

codex_dir="$target_root/.codex"
agents_dir="$codex_dir/agents"
skills_dir="$target_root/.agents/skills"
global_agents="$codex_dir/AGENTS.md"
global_config="$codex_dir/config.toml"
global_agents_source="$repo_root/install/global-agents.md"
agents_config_source="$repo_root/install/agents-config.toml"
begin_marker="# >>> BoundedFreedom managed block >>>"
end_marker="# <<< BoundedFreedom managed block <<<"
apply=0

case "$mode" in
  install|update)
    apply=1
    ;;
  dry-run|status)
    ;;
  *)
    echo "Unsupported mode: $mode" >&2
    exit 2
    ;;
esac

if [ ! -f "$global_agents_source" ]; then
  echo "Missing installer source: install/global-agents.md" >&2
  exit 1
fi
if [ ! -f "$agents_config_source" ]; then
  echo "Missing installer source: install/agents-config.toml" >&2
  exit 1
fi

ensure_dir() {
  directory=$1
  label=$2
  if [ -d "$directory" ]; then
    return
  fi
  if [ "$apply" -eq 1 ]; then
    echo "create directory: $label"
  else
    echo "would create directory: $label"
  fi
  if [ "$apply" -eq 1 ]; then
    mkdir -p "$directory"
  fi
}

link_file() {
  source=$1
  destination=$2
  label=$3
  if [ -L "$destination" ]; then
    current_target=$(readlink "$destination")
    if [ "$current_target" = "$source" ]; then
      echo "link ok: $label"
      return
    fi
    echo "conflict: $label links elsewhere; leaving it unchanged" >&2
    return 1
  fi
  if [ -e "$destination" ]; then
    echo "conflict: $label exists and is not a BoundedFreedom link; leaving it unchanged" >&2
    return 1
  fi
  if [ "$apply" -eq 1 ]; then
    echo "link: $label"
  else
    echo "would link: $label"
  fi
  if [ "$apply" -eq 1 ]; then
    ln -s "$source" "$destination"
  fi
}

without_managed_block() {
  destination=$1
  output=$2
  if [ -f "$destination" ]; then
    awk -v begin="$begin_marker" -v end="$end_marker" '
      $0 == begin { inside = 1; next }
      $0 == end { inside = 0; next }
      !inside { print }
    ' "$destination" > "$output"
  else
    : > "$output"
  fi
}

has_unmanaged_agents_table() {
  destination=$1
  if [ ! -f "$destination" ]; then
    return 1
  fi
  awk -v begin="$begin_marker" -v end="$end_marker" '
    $0 == begin { inside = 1; next }
    $0 == end { inside = 0; next }
    !inside && $0 ~ /^[[:space:]]*\[agents\][[:space:]]*$/ { found = 1 }
    END { exit(found ? 0 : 1) }
  ' "$destination"
}

refresh_managed_block() {
  destination=$1
  source=$2
  label=$3
  parent_dir=$(dirname "$destination")
  if [ "$apply" -eq 1 ]; then
    echo "refresh managed $label block"
  else
    echo "would refresh managed $label block"
  fi
  if [ "$apply" -ne 1 ]; then
    return
  fi
  mkdir -p "$parent_dir"
  temporary=$(mktemp "$parent_dir/.bounded-freedom.XXXXXX")
  without_managed_block "$destination" "$temporary"
  {
    cat "$temporary"
    if [ -s "$temporary" ]; then
      printf '\n'
    fi
    printf '%s\n' "$begin_marker"
    cat "$source"
    printf '%s\n' "$end_marker"
  } > "$temporary.next"
  mv "$temporary.next" "$destination"
  rm -f "$temporary"
}

show_link_status() {
  source=$1
  destination=$2
  label=$3
  if [ -L "$destination" ]; then
    current_target=$(readlink "$destination")
    if [ "$current_target" != "$source" ]; then
      echo "$label: conflict (linked elsewhere)"
    elif [ -e "$destination" ]; then
      echo "$label: linked"
    else
      echo "$label: broken repository link"
    fi
  elif [ -e "$destination" ]; then
    echo "$label: conflict (not a repository link)"
  else
    echo "$label: not linked"
  fi
}

show_status() {
  for role in scout coder builder reviewer; do
    source="$repo_root/.codex/agents/$role.toml"
    destination="$agents_dir/$role.toml"
    show_link_status "$source" "$destination" "agent $role"
  done
  skill_source="$repo_root/.agents/skills/cost-efficient-orchestration"
  skill_destination="$skills_dir/cost-efficient-orchestration"
  show_link_status "$skill_source" "$skill_destination" "skill"
  if [ -f "$global_agents" ] && grep -Fq "$begin_marker" "$global_agents"; then
    echo "global AGENTS.md: managed block present"
  else
    echo "global AGENTS.md: managed block absent"
  fi
  if [ -f "$global_config" ] && grep -Fq "$begin_marker" "$global_config"; then
    echo "global config.toml: managed [agents] block present"
  else
    echo "global config.toml: managed [agents] block absent"
  fi
}

if [ "$mode" = "status" ]; then
  show_status
  exit 0
fi

if has_unmanaged_agents_table "$global_config"; then
  echo "config manual merge required: the global Codex config already contains a user-owned [agents] table" >&2
  echo "source to merge: install/agents-config.toml" >&2
  exit 3
fi

ensure_dir "$agents_dir" "Codex agents"
ensure_dir "$skills_dir" "personal skills"

link_file "$repo_root/.codex/agents/scout.toml" "$agents_dir/scout.toml" "agent scout"
link_file "$repo_root/.codex/agents/coder.toml" "$agents_dir/coder.toml" "agent coder"
link_file "$repo_root/.codex/agents/builder.toml" "$agents_dir/builder.toml" "agent builder"
link_file "$repo_root/.codex/agents/reviewer.toml" "$agents_dir/reviewer.toml" "agent reviewer"
link_file "$repo_root/.agents/skills/cost-efficient-orchestration" "$skills_dir/cost-efficient-orchestration" "orchestration skill"

refresh_managed_block "$global_agents" "$global_agents_source" "AGENTS.md"
refresh_managed_block "$global_config" "$agents_config_source" "config.toml"

if [ "$apply" -eq 0 ]; then
  echo "dry-run complete; no files were changed"
else
  echo "installation complete; restart Codex before starting a new task"
fi
