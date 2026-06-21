_dev_template_ref() {
  local template_name template_source local_template_source

  template_name="${1:-}"
  local_template_source="${NIX_DEV_FLAKE_TEMPLATE_SOURCE:-$HOME/Development/alex-ashery/nix-templates}"
  if [[ -n "${NIX_DEV_FLAKE_TEMPLATE_SOURCE:-}" ]]; then
    template_source="${NIX_DEV_FLAKE_TEMPLATE_SOURCE}"
  elif [[ -f "${local_template_source}/flake.nix" ]]; then
    template_source="${local_template_source}"
  else
    template_source="github:alex-ashery/nix-templates"
  fi

  if [[ -z "${template_name}" ]]; then
    REPLY="${NIX_DEV_FLAKE_TEMPLATE:-${template_source}#base}"
  elif [[ "${template_name}" == *"#"* ]]; then
    REPLY="${template_name}"
  else
    REPLY="${template_source}#${template_name}"
  fi
}

_dev_bootstrap_flake() {
  local template_name template git_dir old_envrc_prefix envrc_content

  template_name="${1:-}"
  _dev_template_ref "${template_name}" || return 1
  template="${REPLY}"

  git_dir="$(git rev-parse --git-dir 2>/dev/null)" || {
    echo "dev flake bootstrap must be run inside a git repository" >&2
    return 1
  }

  if [[ ! -e flake.nix ]]; then
    old_envrc_prefix="use flake ${NIX_HOME_CONFIGS_FLAKE:-}#"
    if [[ -n "${NIX_HOME_CONFIGS_FLAKE:-}" && -f .envrc ]]; then
      envrc_content="$(< .envrc)" || return 1
      if [[ "${envrc_content}" == ${old_envrc_prefix}* ]]; then
        rm .envrc || return 1
      fi
    fi

    nix flake init -t "${template}" || return 1
  else
    echo "flake.nix already exists; leaving existing Nix config in place"
  fi

  touch "${git_dir}/info/exclude" || return 1
  if ! grep -Fxq '.direnv/' "${git_dir}/info/exclude"; then
    printf '.direnv/\n' >> "${git_dir}/info/exclude" || return 1
  fi

  direnv allow || return 1
}

_dev_init() {
  local template_name

  template_name=""
  while (( $# > 0 )); do
    case "$1" in
      -t|--template)
        if (( $# < 2 )); then
          echo "usage: dev init [-t template] [template]" >&2
          return 1
        fi
        if [[ -n "${template_name}" ]]; then
          echo "dev init accepts only one template" >&2
          return 1
        fi
        template_name="$2"
        shift 2
        ;;
      --template=*)
        if [[ -n "${template_name}" ]]; then
          echo "dev init accepts only one template" >&2
          return 1
        fi
        template_name="${1#--template=}"
        shift
        ;;
      -*)
        echo "unknown dev init option: $1" >&2
        echo "usage: dev init [-t template] [template]" >&2
        return 1
        ;;
      *)
        if [[ -n "${template_name}" ]]; then
          echo "dev init accepts only one template" >&2
          return 1
        fi
        template_name="$1"
        shift
        ;;
    esac
  done

  if [[ -z "${template_name}" ]]; then
    _dev_bootstrap_flake
  else
    _dev_bootstrap_flake "${template_name}"
  fi
}
