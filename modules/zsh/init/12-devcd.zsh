_dev_cd() {
  local parts org repo worktree target_dir
  local -a args

  worktree=""
  args=()
  while (( $# > 0 )); do
    case "$1" in
      -w|--worktree)
        if (( $# < 2 )); then
          echo "usage: dev cd [org] repo [-w worktree]" >&2
          return 1
        fi
        worktree="$2"
        shift 2
        ;;
      --worktree=*)
        worktree="${1#--worktree=}"
        shift
        ;;
      --)
        shift
        args+=("$@")
        break
        ;;
      -*)
        echo "unknown dev cd option: $1" >&2
        echo "usage: dev cd [org] repo [-w worktree]" >&2
        return 1
        ;;
      *)
        args+=("$1")
        shift
        ;;
    esac
  done

  if (( ${#args[@]} > 0 )) && [[ "${args[-1]}" == *@* ]]; then
    if [[ -n "$worktree" ]]; then
      echo "dev cd accepts only one worktree" >&2
      return 1
    fi
    worktree="${args[-1]#*@}"
    args[-1]="${args[-1]%%@*}"
    if [[ -z "$worktree" || -z "${args[-1]}" ]]; then
      echo "usage: dev cd [org] repo@worktree" >&2
      return 1
    fi
  fi

  _dev_repo_parts "${args[@]}" || return 1
  parts="$REPLY"
  org="${parts%%:*}"
  repo="${parts#*:}"

  if [[ -n "$worktree" ]]; then
    _repo_worktree_path "$org" "$repo" "$worktree"
    target_dir="$REPLY"
    if [[ ! -d "$target_dir" ]]; then
      echo "worktree not found: $worktree" >&2
      echo "from $HOME/Development/$org/$repo, run: repo wt $worktree" >&2
      return 1
    fi
    cd "$target_dir"
  else
    mkdir -p "$HOME/Development/$org" || return 1
    cd "$HOME/Development/$org/$repo"
  fi
}
