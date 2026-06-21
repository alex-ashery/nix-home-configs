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

_dev_template_completion() {
  local template_dir
  local -a templates

  template_dir="${NIX_DEV_FLAKE_TEMPLATE_DIR:-$HOME/Development/alex-ashery/nix-templates/templates}"
  if [[ -d "${template_dir}" ]]; then
    templates=("${template_dir}"/*(/N:t))
    (( $#templates )) && compadd -Q -S "" -a templates
  fi
}

_dev_completion() {
  local -a subcommands

  subcommands=(
    'clone:clone a repository into ~/Development'
    'cd:change directory to a repository in ~/Development'
    'new:create a new repository with a selected flake template'
    'init:add a selected flake template to an existing repository'
    'help:show dev command usage'
  )

  case $CURRENT in
    2)
      _describe -t dev-subcommands 'dev subcommands' subcommands
      ;;
    3|4)
      case "${words[2]}" in
        clone|cd)
          local saved_current saved_words
          saved_current=$CURRENT
          saved_words=("${words[@]}")
          words=("dev" "${words[@]:2}")
          CURRENT=$(( saved_current - 1 ))
          _dev_repo_completion
          words=("${saved_words[@]}")
          CURRENT=$saved_current
          ;;
        new)
          if [[ "${words[CURRENT - 1]}" == "-t" || "${words[CURRENT - 1]}" == "--template" ]]; then
            _dev_template_completion
          elif (( CURRENT == 3 )); then
            _arguments \
              '(-t --template)'{-t,--template}'[select flake template]:template:_dev_template_completion' \
              '*::repo:_dev_repo_completion'
          else
            _dev_repo_completion
          fi
          ;;
        init)
          if [[ "${words[CURRENT - 1]}" == "-t" || "${words[CURRENT - 1]}" == "--template" ]]; then
            _dev_template_completion
          elif (( CURRENT == 3 )); then
            _arguments \
              '(-t --template)'{-t,--template}'[select flake template]:template:_dev_template_completion' \
              '1:template:_dev_template_completion'
          fi
          ;;
      esac
      ;;
  esac
}
