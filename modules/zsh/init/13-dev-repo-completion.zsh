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

_dev_shell_completion() {
  local -a shells

  shells=(${(f)"$(_nix_home_configs_devshells 2>/dev/null)"})
  (( $#shells )) && compadd -Q -S "" -a shells
}

_dev_completion() {
  local -a subcommands

  subcommands=(
    'clone:clone a repository into ~/Development'
    'cd:change directory to a repository in ~/Development'
    'new:create a new repository with your standard flake setup'
    'init:configure direnv for an existing repository'
    'help:show dev command usage'
  )

  case $CURRENT in
    2)
      _describe -t dev-subcommands 'dev subcommands' subcommands
      ;;
    3|4)
      case "${words[2]}" in
        clone|cd|new)
          local saved_current saved_words
          saved_current=$CURRENT
          saved_words=("${words[@]}")
          words=("dev" "${words[@]:2}")
          CURRENT=$(( saved_current - 1 ))
          _dev_repo_completion
          words=("${saved_words[@]}")
          CURRENT=$saved_current
          ;;
        init)
          if (( CURRENT == 3 )); then
            _dev_shell_completion
          fi
          ;;
      esac
      ;;
  esac
}
