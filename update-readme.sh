#!/usr/bin/env bash
# update-readme.sh
##########################################################################
# Update's the readme with links to the repository's content.
#
# Use it as a pre-commit git hook to make it run automagically everytime
# you commit and push a change to your repo.
#
##########################################################################
# How to use it in your own repository
##########################################################################
#
# STEP 1:
# Change the BASE_URL and EDIT_URL variables accordingly.
#
# STEP 2:
# Create a README.md with anything you want in the top of the file and
# then create a heading for your ToC like this: '## Notes'.
# If you want a different heading, change the REGEX_TOC_HEADING variable
# accordingly.
# NOTE: everything below that heading will be updated right before each
#       commit you do, so don't put there the text you want to be in the 
#       readme file.
#
# STEP 3:
# Put the content of this script in '.git/hooks/pre-commit', like this:
#
# $ cat update-readme.sh > .git/hooks/pre-commit
#
# STEP 4:
# Now every '*.md' file you have in the root dir of your repo will be
# linked in the readme.
# See an example here: https://meleu.github.io/my-notes/
#
#
# meleu - https://meleu.dev/

##########################################################################
# IMPORTANT!: edit the variables below to point to your own repository
readonly BASE_URL='https://meleu.github.io/my-notes'
readonly EDIT_URL='https://github.com/meleu/my-notes/edit/master'
# change the regex below if you want a different ToC heading
readonly REGEX_TOC_HEADING='^## .* Notes'
##########################################################################
# no need to edit anything from below this line

readonly REPO_DIR="${GIT_DIR}/.."

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

  # delete the current ToC (everything below '## Notes')
  sed -ni "1,/${REGEX_TOC_HEADING}/p" "${readme}"
  echo >> "${readme}"
  linksList >> "${readme}"
  git add "${readme}"
}

updateReadme "$@"

