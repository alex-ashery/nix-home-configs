_dev_repo_parts() {
  case "$#" in
    1)
      REPLY="${GITHUB_DEFAULT_ORG:?GITHUB_DEFAULT_ORG is not set}:$1"
      ;;
    2)
      REPLY="$1:$2"
      ;;
    *)
      echo "usage: ${0} [org] repo" >&2
      return 1
      ;;
  esac
}
