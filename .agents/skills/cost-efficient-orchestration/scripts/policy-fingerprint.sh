# Read-only portable policy fingerprint. Source this file; pass the repository root.
# Dependency names, ordering, cksum stream and final hash match the original callers.
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
