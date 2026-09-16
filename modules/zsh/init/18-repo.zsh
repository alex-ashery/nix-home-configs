_repo_worktree_usage() {
  cat <<'EOF'
usage:
  repo wt list
  repo wt cd [name]
  repo wt rm name
  repo wt prune
EOF
}

_repo_usage() {
  cat <<'EOF'
usage:
  repo root [-p|--print]
  repo wt command
EOF
}

_repo_current_parts() {
  local repo_root origin_url remote_path

  repo_root="$(git rev-parse --show-toplevel 2>/dev/null)" || {
    echo "repo must be run inside a git repository" >&2
    return 1
  }

  origin_url="$(git -C "$repo_root" config --get remote.origin.url 2>/dev/null || true)"
  case "$origin_url" in
    git@github.com:*)
      remote_path="${origin_url#git@github.com:}"
      ;;
    https://github.com/*)
      remote_path="${origin_url#https://github.com/}"
      ;;
    ssh://git@github.com/*)
      remote_path="${origin_url#ssh://git@github.com/}"
      ;;
    *)
      remote_path=""
      ;;
  esac

  if [[ -n "$remote_path" && "$remote_path" == */* ]]; then
    remote_path="${remote_path%.git}"
    REPLY="${remote_path%%/*}:${remote_path#*/}:$repo_root"
  else
    REPLY="${repo_root:h:t}:${repo_root:t}:$repo_root"
  fi
}

_repo_worktree_branch_exists() {
  git -C "$1" show-ref --verify --quiet "refs/heads/$2"
}

_repo_worktree_default_base() {
  local repo_root="$1"

  if git -C "$repo_root" rev-parse --verify --quiet origin/HEAD >/dev/null; then
    REPLY="origin/HEAD"
  elif git -C "$repo_root" rev-parse --verify --quiet main >/dev/null; then
    REPLY="main"
  elif git -C "$repo_root" rev-parse --verify --quiet master >/dev/null; then
    REPLY="master"
  else
    REPLY="HEAD"
  fi
}

_repo_worktree_name_to_path_part() {
  local name="$1"

  name="${name//\//-}"
  name="${name// /-}"
  REPLY="$name"
}

_repo_worktree_path() {
  local org="$1"
  local repo="$2"
  local name="$3"
  local path_part

  _repo_worktree_name_to_path_part "$name"
  path_part="$REPLY"
  REPLY="$HOME/Development/$org/.worktrees/$repo/$path_part"
}

_repo_resolved_dir() {
  REPLY="$(cd "$1" 2>/dev/null && pwd -P)" || return 1
}

_repo_current_worktree_path() {
  local parts org repo path_part

  _repo_current_parts || return 1
  parts="$REPLY"
  org="${parts%%:*}"
  parts="${parts#*:}"
  repo="${parts%%:*}"

  _repo_worktree_path "$org" "$repo" "$1"
}

_repo_primary_path() {
  local parts org repo

  _repo_current_parts || return 1
  parts="$REPLY"
  org="${parts%%:*}"
  parts="${parts#*:}"
  repo="${parts%%:*}"
  REPLY="$HOME/Development/$org/$repo"
}

_repo_root() {
  local repo_root

  case "${1:-}" in
    "")
      if (( $# != 0 )); then
        _repo_usage >&2
        return 1
      fi
      repo_root="$(git rev-parse --show-toplevel 2>/dev/null)" || {
        echo "repo root must be run inside a git repository" >&2
        return 1
      }
      cd "$repo_root"
      ;;
    -p|--print)
      if (( $# != 1 )); then
        _repo_usage >&2
        return 1
      fi
      git rev-parse --show-toplevel 2>/dev/null || {
        echo "repo root must be run inside a git repository" >&2
        return 1
      }
      ;;
    *)
      _repo_usage >&2
      return 1
      ;;
  esac
}

_repo_primary() {
  local primary_path

  if (( $# != 0 )); then
    _repo_worktree_usage >&2
    return 1
  fi

  _repo_primary_path || return 1
  primary_path="$REPLY"
  if [[ ! -d "$primary_path" ]]; then
    echo "primary checkout not found: $primary_path" >&2
    return 1
  fi

  cd "$primary_path"
}

_repo_worktree_cd() {
  local name base parts org repo repo_root target_dir path_part

  if (( $# == 0 )); then
    _repo_primary
    return
  elif (( $# != 1 )); then
    _repo_worktree_usage >&2
    return 1
  fi

  name="$1"
  base=""

  git check-ref-format --branch "$name" >/dev/null || return 1

  _repo_current_parts || return 1
  parts="$REPLY"
  org="${parts%%:*}"
  parts="${parts#*:}"
  repo="${parts%%:*}"
  repo_root="${parts#*:}"

  _repo_worktree_name_to_path_part "$name"
  path_part="$REPLY"
  target_dir="$HOME/Development/$org/.worktrees/$repo/$path_part"

  if [[ -e "$target_dir" ]]; then
    cd "$target_dir"
    return
  fi

  if [[ -z "$base" ]]; then
    _repo_worktree_default_base "$repo_root"
    base="$REPLY"
  fi

  mkdir -p "${target_dir:h}" || return 1

  if _repo_worktree_branch_exists "$repo_root" "$name"; then
    git -C "$repo_root" worktree add "$target_dir" "$name" || return 1
  else
    git -C "$repo_root" worktree add -b "$name" "$target_dir" "$base" || return 1
  fi

  cd "$target_dir"
}

_repo_worktree_list() {
  local parts repo_root

  if (( $# != 0 )); then
    _repo_worktree_usage >&2
    return 1
  fi

  _repo_current_parts || return 1
  parts="$REPLY"
  repo_root="${parts##*:}"
  git -C "$repo_root" worktree list
}

_repo_worktree_remove() {
  local current_root current_root_resolved target_dir target_dir_resolved

  if (( $# != 1 )); then
    _repo_worktree_usage >&2
    return 1
  fi

  current_root="$(git rev-parse --show-toplevel 2>/dev/null)" || return 1
  _repo_current_worktree_path "$1" || return 1
  target_dir="$REPLY"
  _repo_resolved_dir "$current_root" || return 1
  current_root_resolved="$REPLY"
  _repo_resolved_dir "$target_dir" || return 1
  target_dir_resolved="$REPLY"

  if [[ "$current_root_resolved" == "$target_dir_resolved" ]]; then
    echo "cannot remove the current worktree; cd to another checkout first" >&2
    return 1
  fi

  git -C "$current_root" worktree remove "$target_dir"
}

_repo_worktree_prune() {
  if (( $# != 0 )); then
    _repo_worktree_usage >&2
    return 1
  fi

  git worktree prune
}

_repo_worktree() {
  local subcommand="${1:-}"

  if [[ -n "$subcommand" ]]; then
    shift
  fi

  case "$subcommand" in
    ""|-h|--help|help)
      _repo_worktree_usage
      ;;
    list)
      _repo_worktree_list "$@"
      ;;
    cd)
      _repo_worktree_cd "$@"
      ;;
    rm|remove)
      _repo_worktree_remove "$@"
      ;;
    prune)
      _repo_worktree_prune "$@"
      ;;
    *)
      echo "unknown repo wt subcommand: $subcommand" >&2
      echo "run 'repo wt help' for usage" >&2
      return 1
      ;;
  esac
}

repo() {
  local subcommand="${1:-}"

  if [[ -n "$subcommand" ]]; then
    shift
  fi

  case "$subcommand" in
    root)
      _repo_root "$@"
      ;;
    wt)
      _repo_worktree "$@"
      ;;
    ""|-h|--help|help)
      _repo_usage
      ;;
    *)
      echo "unknown repo subcommand: $subcommand" >&2
      echo "run 'repo help' for usage" >&2
      return 1
      ;;
  esac
}
