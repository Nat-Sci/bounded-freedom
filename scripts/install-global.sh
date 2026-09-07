#!/bin/sh
# Install BoundedFreedom links and thin host adapters without overwriting user files.
set -eu

usage() {
  cat <<'EOF'
Usage: scripts/install-global.sh [--dry-run|--install|--update|--status]
                                 [--host codex|claude|portable|all]
                                 [--codex-proxy unchanged|system|remove]
                                 [--target-root DIRECTORY]

  --dry-run              Show the changes that --install would make (default).
  --install, --update    Create or refresh managed links and marked global blocks.
  --status               Report installation state without changing files.
  --host HOST            Install the Codex adapter (default), Claude adapter,
                         portable Skills only, or both host adapters.
  --codex-proxy MODE     Leave Codex network settings unchanged (default), import
                         the active macOS HTTP(S) system proxy into a managed .env
                         block, or remove only that managed block.
  --target-root DIR      Install below DIR instead of the current user's home directory.
                         Intended for testing or an isolated host profile.
EOF
}

mode="dry-run"
host="codex"
codex_proxy="unchanged"
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
    --codex-proxy)
      shift
      if [ "$#" -eq 0 ]; then
        echo "--codex-proxy requires unchanged, system, or remove" >&2
        exit 2
      fi
      codex_proxy=$1
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

case "$codex_proxy" in
  unchanged|system|remove)
    ;;
  *)
    echo "Unsupported Codex proxy mode: $codex_proxy" >&2
    usage >&2
    exit 2
    ;;
esac

if [ "$codex_proxy" != "unchanged" ] && [ "$use_codex" -ne 1 ]; then
  echo "--codex-proxy requires --host codex or --host all" >&2
  exit 2
fi

repo_root=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd -P)
if [ -z "$target_root" ]; then
  target_root=$HOME
fi

version_source="$repo_root/VERSION"
edition_name="Astra Edition"
if [ ! -f "$version_source" ]; then
  echo "Missing installer source: VERSION" >&2
  exit 1
fi
package_version=$(sed -n '1p' "$version_source")
if ! printf '%s\n' "$package_version" | grep -Eq '^[0-9]+\.[0-9]+\.[0-9]+$'; then
  echo "Invalid installer source: VERSION must contain one semantic version" >&2
  exit 1
fi
echo "BoundedFreedom package: v$package_version ($edition_name)"

portable_skills_dir="$target_root/.agents/skills"
skills_source_dir="$repo_root/.agents/skills"
legacy_math_skills="mathematical-problem-mapping statistical-model-analysis neural-network-mathematical-analysis loss-objective-optimization"
retired_codex_role_files="scout-routed.toml coder-routed.toml builder-routed.toml reviewer-routed.toml"
retired_role_manifest_source="$repo_root/install/codex-retired-role-files.txt"
role_managed_marker="# BoundedFreedom managed role file"
role_checksum_prefix="# payload cksum: "
role_manifest_source="$repo_root/install/codex-role-files.txt"
codex_role_files=""

codex_dir="$target_root/.codex"
codex_agents_dir="$codex_dir/agents"
codex_global_agents="$codex_dir/AGENTS.md"
codex_global_config="$codex_dir/config.toml"
codex_proxy_env="$codex_dir/.env"

claude_dir="$target_root/.claude"
claude_skills_dir="$claude_dir/skills"
claude_global_instructions="$claude_dir/CLAUDE.md"

global_instructions_source="$repo_root/install/global-agents.md"
agents_config_source="$repo_root/install/agents-config.toml"
begin_marker="# >>> BoundedFreedom managed block >>>"
end_marker="# <<< BoundedFreedom managed block <<<"
proxy_http_url=""
proxy_https_url=""
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
load_codex_roles() {
  if [ ! -f "$role_manifest_source" ]; then
    echo "Missing installer source: install/codex-role-files.txt" >&2
    exit 1
  fi
  while IFS= read -r role_entry || [ -n "$role_entry" ]; do
    role_entry=$(printf '%s\n' "$role_entry" | sed 's/[[:space:]]*#.*$//; s/^[[:space:]]*//; s/[[:space:]]*$//; s/\r$//')
    [ -z "$role_entry" ] && continue
    if ! printf '%s\n' "$role_entry" | grep -Eq '^[A-Za-z0-9_-]+\.toml$'; then
      echo "Invalid installer source: install/codex-role-files.txt contains an invalid role entry" >&2
      exit 1
    fi
    if [ -n "$codex_role_files" ] && printf '%s\n' "$codex_role_files" | grep -Fxq -- "$role_entry"; then
      echo "Invalid installer source: install/codex-role-files.txt contains duplicate role entries" >&2
      exit 1
    fi
    role_source="$repo_root/.codex/agents/$role_entry"
    if [ ! -f "$role_source" ] || [ -L "$role_source" ]; then
      echo "Invalid installer source: a Codex role source is not a regular file" >&2
      exit 1
    fi
    codex_role_files="${codex_role_files}${codex_role_files:+
}$role_entry"
  done < "$role_manifest_source"
  if [ -z "$codex_role_files" ]; then
    echo "Missing installer source: install/codex-role-files.txt is empty" >&2
    exit 1
  fi
  if [ ! -f "$retired_role_manifest_source" ]; then
    echo "Missing installer source: install/codex-retired-role-files.txt" >&2
    exit 1
  fi
  for retired_role_file in $retired_codex_role_files; do
    if ! awk -v name="$retired_role_file" '$1 == name && $2 ~ /^[0-9]+$/ && $3 ~ /^[0-9]+$/ { count++ } END { exit(count == 1 ? 0 : 1) }' "$retired_role_manifest_source"; then
      echo "Invalid installer source: install/codex-retired-role-files.txt is incomplete" >&2
      exit 1
    fi
  done
}

if [ "$use_codex" -eq 1 ]; then
  load_codex_roles
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

role_payload_checksum() {
  cksum < "$1" | awk '{ print $1 " " $2 }'
}

managed_role_checksum() {
  sed '1,2d' "$1" | cksum | awk '{ print $1 " " $2 }'
}

role_file_is_managed() {
  destination=$1
  [ "$(sed -n '1p' "$destination")" = "$role_managed_marker" ] || return 1
  recorded_checksum=$(sed -n '2p' "$destination")
  case "$recorded_checksum" in
    "$role_checksum_prefix"*)
      recorded_checksum=${recorded_checksum#"$role_checksum_prefix"}
      ;;
    *)
      return 1
      ;;
  esac
  [ "$recorded_checksum" = "$(managed_role_checksum "$destination")" ]
}

check_role_destination() {
  source=$1
  destination=$2
  label=$3
  if [ -L "$destination" ]; then
    current_target=$(readlink "$destination")
    if [ "$current_target" != "$source" ]; then
      echo "conflict: $label links elsewhere; leaving it unchanged" >&2
      return 1
    fi
    return
  fi
  if [ -e "$destination" ] && [ ! -f "$destination" ]; then
    echo "conflict: $label is not a regular file; leaving it unchanged" >&2
    return 1
  fi
  if [ -f "$destination" ] && ! role_file_is_managed "$destination"; then
    echo "conflict: $label is not an unmodified managed role file; leaving it unchanged" >&2
    return 1
  fi
}

retired_role_is_repository_link() {
  destination=$1
  retired_name=$2
  [ -L "$destination" ] && [ "$(readlink "$destination")" = "$repo_root/.codex/agents/$retired_name" ]
}

retired_role_is_managed_copy() {
  destination=$1
  retired_name=$2
  expected_checksum=$(awk -v name="$retired_name" '$1 == name { print $2 " " $3; exit }' "$retired_role_manifest_source")
  [ -n "$expected_checksum" ] && [ ! -L "$destination" ] && [ -f "$destination" ] && role_file_is_managed "$destination" && [ "$(managed_role_checksum "$destination")" = "$expected_checksum" ]
}

check_retired_role_destination() {
  destination=$1
  retired_name=$2
  label=$3
  if [ ! -e "$destination" ] && [ ! -L "$destination" ]; then
    return
  fi
  if retired_role_is_repository_link "$destination" "$retired_name"; then
    return
  fi
  if retired_role_is_managed_copy "$destination" "$retired_name"; then
    return
  fi
  echo "conflict: $label is not an unmodified managed retired role file; leaving it unchanged" >&2
  return 1
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
    for role_file in $codex_role_files; do
      role_label=${role_file%.toml}
      check_role_destination "$repo_root/.codex/agents/$role_file" "$codex_agents_dir/$role_file" "Codex agent $role_label"
    done
    for retired_role_file in $retired_codex_role_files; do
      retired_role_label=${retired_role_file%.toml}
      check_retired_role_destination "$codex_agents_dir/$retired_role_file" "$retired_role_file" "retired Codex agent $retired_role_label"
    done
    check_managed_destination "$codex_global_agents" "Codex AGENTS.md"
    check_managed_destination "$codex_global_config" "Codex config.toml"
    if [ "$codex_proxy" != "unchanged" ]; then
      check_managed_destination "$codex_proxy_env" "Codex proxy .env"
    fi
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

install_role_file() {
  source=$1
  destination=$2
  label=$3
  source_checksum=$(role_payload_checksum "$source")
  if [ -f "$destination" ] && role_file_is_managed "$destination"; then
    destination_checksum=$(managed_role_checksum "$destination")
    if [ "$destination_checksum" = "$source_checksum" ]; then
      echo "role file ok: $label"
      return
    fi
  fi
  if [ "$apply" -ne 1 ]; then
    echo "would install managed role file: $label"
    return
  fi
  parent_dir=$(dirname "$destination")
  temporary=$(mktemp "$parent_dir/.bounded-freedom-role.XXXXXX")
  {
    printf '%s\n' "$role_managed_marker"
    printf '%s%s\n' "$role_checksum_prefix" "$source_checksum"
    cat "$source"
  } > "$temporary"
  mv "$temporary" "$destination"
  echo "install managed role file: $label"
}

retire_role_file() {
  destination=$1
  retired_name=$2
  label=$3
  if [ ! -e "$destination" ] && [ ! -L "$destination" ]; then
    return
  fi
  if ! retired_role_is_repository_link "$destination" "$retired_name" && ! retired_role_is_managed_copy "$destination" "$retired_name"; then
    echo "conflict: $label is not an unmodified managed retired role file; leaving it unchanged" >&2
    return 1
  fi
  if [ "$apply" -eq 1 ]; then
    rm "$destination"
    echo "retire managed role file: $label"
  else
    echo "would retire managed role file: $label"
  fi
}

remove_legacy_managed_links() {
  destination_dir=$1
  label_prefix=$2
  for legacy_name in $legacy_math_skills; do
    destination="$destination_dir/$legacy_name"
    expected_source="$repo_root/.agents/skills/$legacy_name"
    if [ ! -L "$destination" ]; then
      continue
    fi
    current_target=$(readlink "$destination")
    if [ "$current_target" != "$expected_source" ]; then
      continue
    fi
    if [ "$apply" -eq 1 ]; then
      echo "remove legacy managed $label_prefix $legacy_name"
      rm "$destination"
    else
      echo "would remove legacy managed $label_prefix $legacy_name"
    fi
  done
}

show_legacy_link_status() {
  destination_dir=$1
  label_prefix=$2
  for legacy_name in $legacy_math_skills; do
    destination="$destination_dir/$legacy_name"
    expected_source="$repo_root/.agents/skills/$legacy_name"
    if [ -L "$destination" ] && [ "$(readlink "$destination")" = "$expected_source" ]; then
      echo "legacy managed $label_prefix $legacy_name: stale"
    elif [ -L "$destination" ] || [ -e "$destination" ]; then
      echo "legacy $label_prefix $legacy_name: preserved user-owned path"
    fi
  done
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

has_unmanaged_proxy_setting() {
  destination=$1
  if [ ! -f "$destination" ]; then
    return 1
  fi
  awk -v begin="$begin_marker" -v end="$end_marker" '
    $0 == begin { inside = 1; next }
    $0 == end { inside = 0; next }
    !inside && $0 ~ /^[[:space:]]*(export[[:space:]]+)?(HTTP_PROXY|HTTPS_PROXY|NO_PROXY|ALL_PROXY|http_proxy|https_proxy|no_proxy|all_proxy)[[:space:]]*=/ { found = 1 }
    END { exit(found ? 0 : 1) }
  ' "$destination"
}

system_proxy_field() {
  field=$1
  printf '%s\n' "$system_proxy_snapshot" | awk -v key="$field" '
    $1 == key && $2 == ":" { print $3; exit }
  '
}

valid_proxy_host() {
  case "$1" in
    ""|*[!A-Za-z0-9._-]*)
      return 1
      ;;
    *)
      return 0
      ;;
  esac
}

valid_proxy_port() {
  case "$1" in
    ""|*[!0-9]*)
      return 1
      ;;
  esac
  [ "$1" -ge 1 ] && [ "$1" -le 65535 ]
}

load_macos_system_proxy() {
  if [ "$(uname -s)" != "Darwin" ]; then
    echo "system proxy import is currently supported only on macOS" >&2
    return 1
  fi
  if ! command -v scutil >/dev/null 2>&1; then
    echo "system proxy import requires the macOS scutil command" >&2
    return 1
  fi
  if ! system_proxy_snapshot=$(scutil --proxy); then
    echo "unable to read the active macOS proxy configuration" >&2
    return 1
  fi

  http_enabled=$(system_proxy_field HTTPEnable)
  https_enabled=$(system_proxy_field HTTPSEnable)
  http_host=$(system_proxy_field HTTPProxy)
  https_host=$(system_proxy_field HTTPSProxy)
  http_port=$(system_proxy_field HTTPPort)
  https_port=$(system_proxy_field HTTPSPort)

  if [ "$http_enabled" != "1" ] || [ "$https_enabled" != "1" ]; then
    echo "system proxy import requires active macOS HTTP and HTTPS proxies" >&2
    return 1
  fi
  if ! valid_proxy_host "$http_host" || ! valid_proxy_host "$https_host"; then
    echo "system proxy import found an unsupported proxy host format" >&2
    return 1
  fi
  if ! valid_proxy_port "$http_port" || ! valid_proxy_port "$https_port"; then
    echo "system proxy import found an invalid proxy port" >&2
    return 1
  fi

  proxy_http_url="http://$http_host:$http_port"
  proxy_https_url="http://$https_host:$https_port"
  echo "active macOS HTTP(S) proxy detected"
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

refresh_proxy_block() {
  destination=$1
  parent_dir=$(dirname "$destination")
  if [ "$apply" -eq 1 ]; then
    echo "refresh managed Codex proxy .env block"
  else
    echo "would refresh managed Codex proxy .env block"
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
    printf 'HTTP_PROXY="%s"\n' "$proxy_http_url"
    printf 'HTTPS_PROXY="%s"\n' "$proxy_https_url"
    printf 'NO_PROXY="localhost,127.0.0.1,::1"\n'
    printf '%s\n' "$end_marker"
  } > "$temporary.next"
  chmod 600 "$temporary.next"
  mv "$temporary.next" "$destination"
  rm -f "$temporary"
}

remove_proxy_block() {
  destination=$1
  if [ ! -f "$destination" ] || ! grep -Fq "$begin_marker" "$destination"; then
    echo "Codex proxy .env managed block already absent"
    return
  fi
  if [ "$apply" -ne 1 ]; then
    echo "would remove managed Codex proxy .env block"
    return
  fi
  parent_dir=$(dirname "$destination")
  temporary=$(mktemp "$parent_dir/.bounded-freedom.XXXXXX")
  without_managed_block "$destination" "$temporary"
  mv "$temporary" "$destination"
  echo "removed managed Codex proxy .env block"
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

show_role_status() {
  source=$1
  destination=$2
  label=$3
  if [ -L "$destination" ]; then
    current_target=$(readlink "$destination")
    if [ "$current_target" = "$source" ]; then
      echo "$label: legacy repository link (migration required)"
    else
      echo "$label: conflict (linked elsewhere)"
    fi
  elif [ -e "$destination" ] && [ ! -f "$destination" ]; then
    echo "$label: conflict (not a regular file)"
  elif [ -f "$destination" ] && ! role_file_is_managed "$destination"; then
    echo "$label: conflict (not an unmodified managed role file)"
  elif [ -f "$destination" ]; then
    if [ "$(managed_role_checksum "$destination")" = "$(role_payload_checksum "$source")" ]; then
      echo "$label: managed regular file (current)"
    else
      echo "$label: managed regular file (source update available)"
    fi
  else
    echo "$label: not installed"
  fi
}

show_retired_role_status() {
  destination=$1
  retired_name=$2
  label=$3
  if [ ! -e "$destination" ] && [ ! -L "$destination" ]; then
    echo "$label: retired"
  elif retired_role_is_repository_link "$destination" "$retired_name"; then
    echo "$label: retirement required (repository link)"
  elif retired_role_is_managed_copy "$destination" "$retired_name"; then
    echo "$label: retirement required (managed regular file)"
  else
    echo "$label: conflict (preserved)"
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
  show_legacy_link_status "$portable_skills_dir" "portable Skill"
  if [ "$use_codex" -eq 1 ]; then
    for role_file in $codex_role_files; do
      role_label=${role_file%.toml}
      show_role_status "$repo_root/.codex/agents/$role_file" "$codex_agents_dir/$role_file" "Codex agent $role_label"
    done
    for retired_role_file in $retired_codex_role_files; do
      retired_role_label=${retired_role_file%.toml}
      show_retired_role_status "$codex_agents_dir/$retired_role_file" "$retired_role_file" "Retired Codex agent $retired_role_label"
    done
    show_block_status "$codex_global_agents" "Codex AGENTS.md"
    show_block_status "$codex_global_config" "Codex config.toml"
    show_block_status "$codex_proxy_env" "Codex proxy .env"
  fi
  if [ "$use_claude" -eq 1 ]; then
    for skill_source in "$skills_source_dir"/*; do
      if [ ! -d "$skill_source" ]; then
        continue
      fi
      skill_name=${skill_source##*/}
      show_link_status "$skill_source" "$claude_skills_dir/$skill_name" "Claude Skill $skill_name"
    done
    show_legacy_link_status "$claude_skills_dir" "Claude Skill"
    show_block_status "$claude_global_instructions" "Claude CLAUDE.md"
  fi
  if [ "$use_codex" -eq 1 ]; then
    echo "Codex role file status is file-level only; it does not verify live role launch or model selection"
  fi
}

if [ "$mode" = "status" ]; then
  show_status
  exit 0
fi

if [ "$codex_proxy" = "system" ]; then
  load_macos_system_proxy
fi

preflight_installation

if [ "$use_codex" -eq 1 ] && has_unmanaged_agents_table "$codex_global_config"; then
  echo "config manual merge required: the global Codex config already contains a user-owned [agents] table" >&2
  echo "source to merge: install/agents-config.toml" >&2
  exit 3
fi

if [ "$codex_proxy" = "system" ] && has_unmanaged_proxy_setting "$codex_proxy_env"; then
  echo "proxy manual merge required: Codex .env already contains user-owned proxy variables" >&2
  exit 4
fi

ensure_dir "$portable_skills_dir" "portable Skills"
remove_legacy_managed_links "$portable_skills_dir" "portable Skill"
for skill_source in "$skills_source_dir"/*; do
  if [ ! -d "$skill_source" ]; then
    continue
  fi
  skill_name=${skill_source##*/}
  link_file "$skill_source" "$portable_skills_dir/$skill_name" "portable Skill $skill_name"
done

if [ "$use_codex" -eq 1 ]; then
  ensure_dir "$codex_agents_dir" "Codex agents"
  for retired_role_file in $retired_codex_role_files; do
    retired_role_label=${retired_role_file%.toml}
    retire_role_file "$codex_agents_dir/$retired_role_file" "$retired_role_file" "Retired Codex agent $retired_role_label"
  done
  for role_file in $codex_role_files; do
    role_label=${role_file%.toml}
    install_role_file "$repo_root/.codex/agents/$role_file" "$codex_agents_dir/$role_file" "Codex agent $role_label"
  done
  refresh_managed_block "$codex_global_agents" "$global_instructions_source" "Codex AGENTS.md"
  refresh_managed_block "$codex_global_config" "$agents_config_source" "Codex config.toml"
  case "$codex_proxy" in
    system)
      refresh_proxy_block "$codex_proxy_env"
      ;;
    remove)
      remove_proxy_block "$codex_proxy_env"
      ;;
    unchanged)
      ;;
  esac
fi

if [ "$use_claude" -eq 1 ]; then
  ensure_dir "$claude_skills_dir" "Claude Skills"
  remove_legacy_managed_links "$claude_skills_dir" "Claude Skill"
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
  echo "role file installation does not verify live role launch or model selection"
fi
