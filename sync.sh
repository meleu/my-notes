#!/usr/bin/env bash
# BUG: if the script doesn't finish successfully, the next run will not
# push the changes ('git status' won't get the new changes)

readonly SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" && pwd )"

main() {
  cd "${SCRIPT_DIR}"

  gitStatus="$(git status --porcelain)"

  [[ -z "${gitStatus}" ]] && return 0

  git add --all \
  && git commit -m "Automated sync: ${gitStatus}" \
  && git pull --rebase \
  && git push
}

main "$@"
