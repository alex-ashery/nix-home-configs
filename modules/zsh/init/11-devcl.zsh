devcl() {
  local parts org repo dev_dir
  _dev_repo_parts "$@" || return 1
  parts="$REPLY"
  org="${parts%%:*}"
  repo="${parts#*:}"

  dev_dir="$HOME/Development/$org"
  mkdir -p "$dev_dir" || return 1
  git -C "$dev_dir" clone "git@github.com:${org}/${repo}.git"
}
