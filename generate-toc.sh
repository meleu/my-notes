#!/usr/bin/env bash
# update-readme.sh
###################
# Update's the readme with links to the repository's content.

readonly REPO_DIR="${GIT_DIR}/.."
readonly BASE_URL='https://meleu.github.io/my-notes'
readonly EDIT_URL='https://github.com/meleu/my-notes/edit/master'

linksList() {
  local fileFull
  local fileBase
  local fileNoExtension

  for fileFull in "${REPO_DIR}"/*.md ; do
    fileBase="${fileFull##*/}"
    [[ $fileBase =~ .*README\.md ]] && continue

    fileNoExtension="${fileBase%.*}"

    echo -n "- [${fileNoExtension}](${BASE_URL}/${fileNoExtension})"
    echo " - [✏️](${EDIT_URL}/${fileBase})"
  done
}

updateReadme() {
  local readme="${GIT_DIR}/../README.md"

  if [[ ! -f "${readme}" ]]; then
    echo "${readme}: file not found. Aborting..." >&2
    exit 1
  fi

  sed -i '1,/^## .* Notes/!d' "${readme}"
  echo >> "${readme}"
  linksList >> "${readme}"
  git add "${readme}"
}

updateReadme "$@"

