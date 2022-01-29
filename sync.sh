#!/usr/bin/env bash
# BUG: se por um acaso o script não concluir o push com sucesso, a próxima
# execução não fará o push (git status não vai pegar mudança alguma).

main() {
  gitStatus="$(git status --porcelain)"

  [[ -z "${gitStatus}" ]] && return 0

  git add --all \
  && git commit -m "Automated sync: ${gitStatus}" \
  && git pull --rebase \
  && git push
}

main "$@"
