dev() {
  local subcommand

  subcommand="${1:-}"
  if [[ -n "${subcommand}" ]]; then
    shift
  fi

  case "${subcommand}" in
    clone)
      _dev_clone "$@"
      ;;
    cd)
      _dev_cd "$@"
      ;;
    new)
      _dev_new "$@"
      ;;
    init)
      _dev_init "$@"
      ;;
    ""|-h|--help|help)
      cat <<'EOF'
usage:
  dev clone [org] repo
  dev cd [org] repo
  dev new [repo] | [org repo]
  dev init [shell]
EOF
      ;;
    *)
      echo "unknown dev subcommand: ${subcommand}" >&2
      echo "run 'dev help' for usage" >&2
      return 1
      ;;
  esac
}
