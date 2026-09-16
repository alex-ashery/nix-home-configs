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

_worktree_name_completion_for_repo() {
  local org="$1"
  local repo="$2"
  local base_dir
  local -a worktrees

  base_dir="$HOME/Development/$org/.worktrees/$repo"

  worktrees=("$base_dir"/*(/N:t))
  (( $#worktrees )) && compadd -Q -S "" -a worktrees
}

_repo_worktree_name_completion() {
  local parts org repo

  _repo_current_parts >/dev/null 2>&1 || return
  parts="$REPLY"
  org="${parts%%:*}"
  parts="${parts#*:}"
  repo="${parts%%:*}"

  _worktree_name_completion_for_repo "$org" "$repo"
}

_repo_branch_completion() {
  local branch current_branch
  local -a branches

  current_branch="$(git branch --show-current 2>/dev/null || true)"
  branches=()
  while IFS= read -r branch; do
    [[ -z "$branch" || "$branch" == "$current_branch" ]] && continue
    branches+=("$branch")
  done < <(git for-each-ref --format='%(refname:short)' refs/heads 2>/dev/null)

  (( $#branches )) && compadd -Q -S "" -a branches
}

_dev_cd_worktree_completion() {
  local parts org repo token
  local -a args
  integer i

  args=()
  i=3
  while (( i < CURRENT )); do
    token="${words[i]}"
    case "$token" in
      -w|--worktree)
        (( i++ ))
        ;;
      --worktree=*)
        ;;
      -*)
        ;;
      *)
        args+=("$token")
        ;;
    esac
    (( i++ ))
  done

  if (( ${#args[@]} > 0 )) && [[ "${args[-1]}" == *@* ]]; then
    args[-1]="${args[-1]%%@*}"
  fi

  _dev_repo_parts "${args[@]}" >/dev/null 2>&1 || return
  parts="$REPLY"
  org="${parts%%:*}"
  repo="${parts#*:}"

  _worktree_name_completion_for_repo "$org" "$repo"
}

_repo_completion() {
  local -a subcommands root_options wt_subcommands

  subcommands=(
    'root:change directory to the current repository root'
    'wt:create, enter, list, or remove worktrees for the current repository'
    'help:show repo command usage'
  )

  root_options=(
    '-p:print the current repository root'
    '--print:print the current repository root'
  )

  wt_subcommands=(
    'list:list worktrees for the current repository'
    'cd:change directory to the primary checkout or a named worktree'
    'rm:remove an existing worktree'
    'prune:prune stale git worktree metadata'
    'help:show worktree usage'
  )

  case $CURRENT in
    2)
      _describe -t repo-subcommands 'repo subcommands' subcommands
      ;;
    3)
      case "${words[2]}" in
        root)
          _describe -t repo-root-options 'repo root options' root_options
          ;;
        wt)
          _describe -t repo-worktree-subcommands 'repo wt subcommands' wt_subcommands
          ;;
      esac
      ;;
    4)
      case "${words[2]}" in
        wt)
          if [[ "${words[3]}" == "cd" ]]; then
            _repo_branch_completion
          elif [[ "${words[3]}" == "rm" || "${words[3]}" == "remove" ]]; then
            _repo_worktree_name_completion
          fi
          ;;
      esac
      ;;
  esac
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
    3|4|5|6)
      case "${words[2]}" in
        clone)
          local saved_current saved_words
          saved_current=$CURRENT
          saved_words=("${words[@]}")
          words=("dev" "${words[@]:2}")
          CURRENT=$(( saved_current - 1 ))
          _dev_repo_completion
          words=("${saved_words[@]}")
          CURRENT=$saved_current
          ;;
        cd)
          if [[ "${words[CURRENT - 1]}" == "-w" || "${words[CURRENT - 1]}" == "--worktree" ]]; then
            _dev_cd_worktree_completion
          else
            local saved_current saved_words
            saved_current=$CURRENT
            saved_words=("${words[@]}")
            words=("dev" "${words[@]:2}")
            CURRENT=$(( saved_current - 1 ))
            _dev_repo_completion
            words=("${saved_words[@]}")
            CURRENT=$saved_current
          fi
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
