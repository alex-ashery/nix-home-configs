_dev_repo_completion() {
  local base_dir="$HOME/Development"
  local default_org="${GITHUB_DEFAULT_ORG:-}"
  local default_org_dir="$base_dir/$default_org"
  local -a orgs repos entries

  case $CURRENT in
    2)
      orgs=($base_dir/*(/N:t))

      if [[ -n "$default_org" && -d "$default_org_dir" ]]; then
        repos=($default_org_dir/*(/N:t))
      else
        repos=()
      fi

      entries=($orgs $repos)
      (( $#entries )) && compadd -Q -S "" -a entries
      ;;
    3)
      if [[ -d "$base_dir/$words[2]" ]]; then
        repos=($base_dir/$words[2]/*(/N:t))
        (( $#repos )) && compadd -Q -S "" -a repos
      fi
      ;;
  esac
}
