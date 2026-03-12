_kitty_apply_tab_title_override() {
  local desired_title repo_root
  local current_title="${_KITTY_APPLIED_TAB_TITLE_OVERRIDE:-}"

  if command -v git >/dev/null 2>&1; then
    repo_root="$(git rev-parse --show-toplevel 2>/dev/null || true)"
  else
    repo_root=""
  fi

  if [ -n "$repo_root" ]; then
    desired_title="${repo_root:t}"
  else
    desired_title="${PWD/#$HOME/~}"
  fi

  [ "$desired_title" = "$current_title" ] && return 0

  if typeset -f title >/dev/null 2>&1; then
    title "$desired_title" "$desired_title"
  fi

  export _KITTY_APPLIED_TAB_TITLE_OVERRIDE="$desired_title"
}
