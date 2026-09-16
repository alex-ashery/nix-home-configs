_kitty_repo_title() {
  local repo_root repo_parent repo_name worktree_parent worktree_repo

  repo_root="$1"
  repo_name="${repo_root:t}"
  repo_parent="${repo_root:h}"

  if [[ "${repo_parent:t}" == ".worktrees" ]]; then
    REPLY="$repo_name"
    return
  fi

  worktree_parent="${repo_parent:h}"
  if [[ "${worktree_parent:t}" == ".worktrees" ]]; then
    worktree_repo="${repo_parent:t}"
    REPLY="${worktree_repo}@${repo_name}"
  else
    REPLY="$repo_name"
  fi
}

_kitty_apply_tab_title_override() {
  local desired_title repo_root
  local current_title="${_KITTY_APPLIED_TAB_TITLE_OVERRIDE:-}"

  if command -v git >/dev/null 2>&1; then
    repo_root="$(git rev-parse --show-toplevel 2>/dev/null || true)"
  else
    repo_root=""
  fi

  if [ -n "$repo_root" ]; then
    _kitty_repo_title "$repo_root"
    desired_title="$REPLY"
  else
    desired_title="${PWD/#$HOME/~}"
  fi

  [ "$desired_title" = "$current_title" ] && return 0

  if typeset -f title >/dev/null 2>&1; then
    title "$desired_title" "$desired_title"
  fi

  export _KITTY_APPLIED_TAB_TITLE_OVERRIDE="$desired_title"
}
