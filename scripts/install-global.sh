#!/bin/sh
# Install BoundedFreedom links and thin host adapters without overwriting user files.
set -eu

usage() {
  cat <<'EOF'
Usage: scripts/install-global.sh [--dry-run|--install|--update|--status]
                                 [--host codex|claude|portable|all]
                                 [--target-root DIRECTORY]

  --dry-run              Show the changes that --install would make (default).
  --install, --update    Create or refresh managed links and marked global blocks.
  --status               Report installation state without changing files.
  --host HOST            Install the Codex adapter (default), Claude adapter,
                         portable Skills only, or both host adapters.
  --target-root DIR      Install below DIR instead of the current user's home directory.
                         Intended for testing or an isolated host profile.
EOF
}

mode="dry-run"
host="codex"
target_root=""

while [ "$#" -gt 0 ]; do
  case "$1" in
    --dry-run|--install|--update|--status)
      mode=${1#--}
      ;;
    --host)
      shift
      if [ "$#" -eq 0 ]; then
        echo "--host requires codex, claude, portable, or all" >&2
        exit 2
      fi
      host=$1
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

use_codex=0
use_claude=0
case "$host" in
  codex)
    use_codex=1
    ;;
  claude)
    use_claude=1
    ;;
  portable)
    ;;
  all)
    use_codex=1
    use_claude=1
    ;;
  *)
    echo "Unsupported host: $host" >&2
    usage >&2
    exit 2
    ;;
esac

repo_root=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd -P)
if [ -z "$target_root" ]; then
  target_root=$HOME
fi

portable_skills_dir="$target_root/.agents/skills"
skills_source_dir="$repo_root/.agents/skills"

codex_dir="$target_root/.codex"
codex_agents_dir="$codex_dir/agents"
codex_global_agents="$codex_dir/AGENTS.md"
codex_global_config="$codex_dir/config.toml"

claude_dir="$target_root/.claude"
claude_skills_dir="$claude_dir/skills"
claude_global_instructions="$claude_dir/CLAUDE.md"

global_instructions_source="$repo_root/install/global-agents.md"
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

if [ ! -d "$skills_source_dir" ]; then
  echo "Missing installer source: .agents/skills" >&2
  exit 1
fi
skill_count=0
for skill_source in "$skills_source_dir"/*; do
  if [ ! -d "$skill_source" ]; then
    continue
  fi
  if [ ! -f "$skill_source/SKILL.md" ]; then
    echo "Invalid installer source: .agents/skills/${skill_source##*/} has no SKILL.md" >&2
    exit 1
  fi
  skill_count=$((skill_count + 1))
done
if [ "$skill_count" -eq 0 ]; then
  echo "Missing installer source: no Skills found under .agents/skills" >&2
  exit 1
fi
if [ ! -f "$global_instructions_source" ]; then
  echo "Missing installer source: install/global-agents.md" >&2
  exit 1
fi
if [ "$use_codex" -eq 1 ] && [ ! -f "$agents_config_source" ]; then
  echo "Missing installer source: install/agents-config.toml" >&2
  exit 1
fi
if [ "$use_codex" -eq 1 ]; then
  for role in scout coder builder reviewer; do
    if [ ! -f "$repo_root/.codex/agents/$role.toml" ]; then
      echo "Missing installer source: .codex/agents/$role.toml" >&2
      exit 1
    fi
  done
fi

check_directory_path() {
  directory=$1
  label=$2
  if { [ -e "$directory" ] || [ -L "$directory" ]; } && [ ! -d "$directory" ]; then
    echo "conflict: $label path is not a directory; leaving it unchanged" >&2
    return 1
  fi
}

check_link_destination() {
  source=$1
  destination=$2
  label=$3
  if [ ! -e "$source" ]; then
    echo "missing source: $label" >&2
    return 1
  fi
  if [ -L "$destination" ]; then
    current_target=$(readlink "$destination")
    if [ "$current_target" != "$source" ]; then
      echo "conflict: $label links elsewhere; leaving it unchanged" >&2
      return 1
    fi
    return
  fi
  if [ -e "$destination" ]; then
    echo "conflict: $label exists and is not a BoundedFreedom link; leaving it unchanged" >&2
    return 1
  fi
}

has_valid_managed_markers() {
  destination=$1
  awk -v begin="$begin_marker" -v end="$end_marker" '
    $0 == begin {
      begin_count++
      if (inside || begin_count > 1) invalid = 1
      inside = 1
      next
    }
    $0 == end {
      end_count++
      if (!inside || end_count > 1) invalid = 1
      inside = 0
      next
    }
    END {
      if (invalid || inside || begin_count != end_count || begin_count > 1) exit 1
    }
  ' "$destination"
}

check_managed_destination() {
  destination=$1
  label=$2
  if [ -L "$destination" ]; then
    echo "conflict: $label is a symbolic link; leaving it unchanged" >&2
    return 1
  fi
  if [ -e "$destination" ] && [ ! -f "$destination" ]; then
    echo "conflict: $label is not a regular file; leaving it unchanged" >&2
    return 1
  fi
  if [ -f "$destination" ] && ! has_valid_managed_markers "$destination"; then
    echo "conflict: $label has incomplete or duplicate managed markers; leaving it unchanged" >&2
    return 1
  fi
}

preflight_installation() {
  check_directory_path "$target_root" "target root"
  check_directory_path "$target_root/.agents" "portable configuration"
  check_directory_path "$portable_skills_dir" "portable Skills"
  for skill_source in "$skills_source_dir"/*; do
    if [ ! -d "$skill_source" ]; then
      continue
    fi
    skill_name=${skill_source##*/}
    check_link_destination "$skill_source" "$portable_skills_dir/$skill_name" "portable Skill $skill_name"
  done

  if [ "$use_codex" -eq 1 ]; then
    check_directory_path "$codex_dir" "Codex configuration"
    check_directory_path "$codex_agents_dir" "Codex agents"
    for role in scout coder builder reviewer; do
      check_link_destination "$repo_root/.codex/agents/$role.toml" "$codex_agents_dir/$role.toml" "Codex agent $role"
    done
    check_managed_destination "$codex_global_agents" "Codex AGENTS.md"
    check_managed_destination "$codex_global_config" "Codex config.toml"
  fi

  if [ "$use_claude" -eq 1 ]; then
    check_directory_path "$claude_dir" "Claude configuration"
    check_directory_path "$claude_skills_dir" "Claude Skills"
    for skill_source in "$skills_source_dir"/*; do
      if [ ! -d "$skill_source" ]; then
        continue
      fi
      skill_name=${skill_source##*/}
      check_link_destination "$skill_source" "$claude_skills_dir/$skill_name" "Claude Skill $skill_name"
    done
    check_managed_destination "$claude_global_instructions" "Claude CLAUDE.md"
  fi
}

ensure_dir() {
  directory=$1
  label=$2
  if [ -d "$directory" ]; then
    return
  fi
  if [ "$apply" -eq 1 ]; then
    echo "create directory: $label"
    mkdir -p "$directory"
  else
    echo "would create directory: $label"
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
    ln -s "$source" "$destination"
  else
    echo "would link: $label"
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
    printf '%s\n' "$begin_marker"
    printf '\n'
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

show_block_status() {
  destination=$1
  label=$2
  if [ -L "$destination" ]; then
    echo "$label: conflict (symbolic link)"
  elif [ -e "$destination" ] && [ ! -f "$destination" ]; then
    echo "$label: conflict (not a regular file)"
  elif [ -f "$destination" ] && ! has_valid_managed_markers "$destination"; then
    echo "$label: invalid managed markers"
  elif [ -f "$destination" ] && grep -Fq "$begin_marker" "$destination"; then
    echo "$label: managed block present"
  else
    echo "$label: managed block absent"
  fi
}

show_status() {
  for skill_source in "$skills_source_dir"/*; do
    if [ ! -d "$skill_source" ]; then
      continue
    fi
    skill_name=${skill_source##*/}
    show_link_status "$skill_source" "$portable_skills_dir/$skill_name" "portable Skill $skill_name"
  done
  if [ "$use_codex" -eq 1 ]; then
    for role in scout coder builder reviewer; do
      show_link_status "$repo_root/.codex/agents/$role.toml" "$codex_agents_dir/$role.toml" "Codex agent $role"
    done
    show_block_status "$codex_global_agents" "Codex AGENTS.md"
    show_block_status "$codex_global_config" "Codex config.toml"
  fi
  if [ "$use_claude" -eq 1 ]; then
    for skill_source in "$skills_source_dir"/*; do
      if [ ! -d "$skill_source" ]; then
        continue
      fi
      skill_name=${skill_source##*/}
      show_link_status "$skill_source" "$claude_skills_dir/$skill_name" "Claude Skill $skill_name"
    done
    show_block_status "$claude_global_instructions" "Claude CLAUDE.md"
  fi
}

if [ "$mode" = "status" ]; then
  show_status
  exit 0
fi

preflight_installation

if [ "$use_codex" -eq 1 ] && has_unmanaged_agents_table "$codex_global_config"; then
  echo "config manual merge required: the global Codex config already contains a user-owned [agents] table" >&2
  echo "source to merge: install/agents-config.toml" >&2
  exit 3
fi

ensure_dir "$portable_skills_dir" "portable Skills"
for skill_source in "$skills_source_dir"/*; do
  if [ ! -d "$skill_source" ]; then
    continue
  fi
  skill_name=${skill_source##*/}
  link_file "$skill_source" "$portable_skills_dir/$skill_name" "portable Skill $skill_name"
done

if [ "$use_codex" -eq 1 ]; then
  ensure_dir "$codex_agents_dir" "Codex agents"
  link_file "$repo_root/.codex/agents/scout.toml" "$codex_agents_dir/scout.toml" "Codex agent scout"
  link_file "$repo_root/.codex/agents/coder.toml" "$codex_agents_dir/coder.toml" "Codex agent coder"
  link_file "$repo_root/.codex/agents/builder.toml" "$codex_agents_dir/builder.toml" "Codex agent builder"
  link_file "$repo_root/.codex/agents/reviewer.toml" "$codex_agents_dir/reviewer.toml" "Codex agent reviewer"
  refresh_managed_block "$codex_global_agents" "$global_instructions_source" "Codex AGENTS.md"
  refresh_managed_block "$codex_global_config" "$agents_config_source" "Codex config.toml"
fi

if [ "$use_claude" -eq 1 ]; then
  ensure_dir "$claude_skills_dir" "Claude Skills"
  for skill_source in "$skills_source_dir"/*; do
    if [ ! -d "$skill_source" ]; then
      continue
    fi
    skill_name=${skill_source##*/}
    link_file "$skill_source" "$claude_skills_dir/$skill_name" "Claude Skill $skill_name"
  done
  refresh_managed_block "$claude_global_instructions" "$global_instructions_source" "Claude CLAUDE.md"
fi

if [ "$apply" -eq 0 ]; then
  echo "dry-run complete; no files were changed"
else
  echo "installation complete; start a new host session before using the updated adapter"
fi
