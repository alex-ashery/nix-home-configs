devinit() {
  local target_dir remote_url default_owner

  case "$#" in
    0)
      target_dir="$PWD"
      ;;
    1)
      default_owner="${GITHUB_DEFAULT_REPO:-${GITHUB_DEFAULT_ORG:?GITHUB_DEFAULT_ORG is not set}}"
      target_dir="$HOME/Development/$default_owner/$1"
      remote_url="git@github.com:${default_owner}/$1.git"
      ;;
    2)
      target_dir="$HOME/Development/$1/$2"
      remote_url="git@github.com:$1/$2.git"
      ;;
    *)
      echo "usage: devinit [repo] | [org repo]" >&2
      return 1
      ;;
  esac

  mkdir -p "$target_dir" || return 1
  cd "$target_dir" || return 1

  git init || return 1

  if [ -n "${remote_url:-}" ]; then
    git remote add -t main -m main origin "$remote_url" || return 1
  fi

  nix flake init -t github:alex-ashery/nix-templates#base || return 1
  direnv allow
}
