_nix_home_configs_system() {
  local arch os

  arch="$(uname -m)" || return 1
  os="$(uname -s)" || return 1

  case "${arch}:${os}" in
    arm64:Darwin)
      REPLY="aarch64-darwin"
      ;;
    aarch64:Darwin)
      REPLY="aarch64-darwin"
      ;;
    x86_64:Linux)
      REPLY="x86_64-linux"
      ;;
    *)
      echo "unsupported system: ${arch} ${os}" >&2
      return 1
      ;;
  esac
}

_nix_home_configs_devshells() {
  local flake_path system nix_bin

  flake_path="${NIX_HOME_CONFIGS_FLAKE:?NIX_HOME_CONFIGS_FLAKE is not set}"
  nix_bin="$(command -v nix)" || {
    echo "nix is not available in PATH" >&2
    return 1
  }

  _nix_home_configs_system || return 1
  system="$REPLY"

  "$nix_bin" eval --impure --raw --expr "
    builtins.concatStringsSep \"\n\" (
      builtins.attrNames (builtins.getFlake \"${flake_path}\").devShells.${system}
    )
  "
}

_dev_init() {
  local shell_name flake_path git_dir envrc_line available_shells

  shell_name="${1:-go}"
  flake_path="${NIX_HOME_CONFIGS_FLAKE:?NIX_HOME_CONFIGS_FLAKE is not set}"

  git_dir="$(git rev-parse --git-dir 2>/dev/null)" || {
    echo "dev init must be run inside a git repository" >&2
    return 1
  }

  available_shells="$(_nix_home_configs_devshells)" || return 1
  if [[ -z "${available_shells}" || $'\n'"${available_shells}"$'\n' != *$'\n'"${shell_name}"$'\n'* ]]; then
    echo "unknown dev shell: ${shell_name}" >&2
    echo "available dev shells:" >&2
    printf '%s\n' "${available_shells}" >&2
    return 1
  fi

  envrc_line="use flake ${flake_path}#${shell_name}"
  printf '%s\n' "$envrc_line" > .envrc || return 1

  touch "${git_dir}/info/exclude" || return 1
  if ! grep -Fxq '.envrc' "${git_dir}/info/exclude"; then
    printf '.envrc\n' >> "${git_dir}/info/exclude" || return 1
  fi
  if ! grep -Fxq '.direnv/' "${git_dir}/info/exclude"; then
    printf '.direnv/\n' >> "${git_dir}/info/exclude" || return 1
  fi

  direnv allow || return 1
}
