devcd() {
  local parts org repo
  _dev_repo_parts "$@" || return 1
  parts="$REPLY"
  org="${parts%%:*}"
  repo="${parts#*:}"

  mkdir -p "$HOME/Development/$org" || return 1
  cd "$HOME/Development/$org/$repo"
}
