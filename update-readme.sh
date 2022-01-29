#!/usr/bin/env bash
# update-readme.sh
##########################################################################
# Updates the readme with links to the repository's content.
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
readonly BASE_URL='https://meleu.github.io/my-notes'
readonly EDIT_URL='https://github.com/meleu/my-notes/edit/master'
#
# STEP 2:
# Create a README.md with anything you want in the top of the file and
# then create a heading for your ToC like this: '## Table of Contents'.
# If you want a different heading, change the REGEX_TOC_HEADING variable
# accordingly.
readonly REGEX_TOC_HEADING='^## .* Table of Contents'
#
# NOTE: everything below that heading will be updated right before each
#       commit you do, so don't put there the text you want to be in the 
#       readme file.
#
# STEP 3:
# Put the content of this script in '.git/hooks/pre-commit', like this:
#
# $ cat update-readme.sh > .git/hooks/pre-commit
# $ chmod a+x .git/hooks/pre-commit
#
# STEP 4:
# Now every '*.md' file you have in the root dir of your repo will be
# linked in the readme.
# See an example here: https://meleu.github.io/my-notes/
#
#
# meleu - https://meleu.dev/

readonly REPO_DIR="$(git rev-parse --git-dir)/.."


# FUNCTIONS
###############################################################################

# hasToCHeading():
# arg1: readme file
hasToCHeading() {
  local file="$1"
  grep -iq "${REGEX_TOC_HEADING}" "${file}"
}

# readmeList(): print only README files with the $REGEX_TOC_HEADING
# arg1: directory
# arg2: 'true' to check only one sublevel
readmeList() {
  local startingDir="${1:-$REPO_DIR}"
  local readmeFile
  local maxdepth="${2}"
  local maxdepthArg

  [[ ${maxdepth} == 'true' ]] && maxdepthArg='-mindepth 2 -maxdepth 2'

  for readmeFile in $(find "${startingDir}" ${maxdepthArg} -type f -name 'README.md' | sort); do
    hasToCHeading "${readmeFile}" && echo "${readmeFile}"
  done
}

# subDirList(): print only subdirectories with a valid README
# arg1: directory
subDirList() {
  local startingDir="${1:-$REPO_DIR}"
  local directory
  for directory in $(readmeList "${startingDir}" true); do
    dirname "${directory}"
  done
}

# createToCFolders(): create links for subdirectories
# arg1: readme file
createToCFolders() {
  local readmeFile="${1}"
  local directory
  local iteratorDir
  local directories=()

  [[ -f "${readmeFile}" ]] || return 1

  directory="$(dirname "${readmeFile}")"
  directories+=( $(subDirList "${directory}") )

  [[ -z "${directories[@]}" ]] && return 0

  echo -e '\n### 📂 Folders\n' >> "${readmeFile}"

  for iteratorDir in "${directories[@]}"; do
    directory="${iteratorDir/$REPO_DIR\//}"
    echo "- [${directory}/](${directory}/README.md)" >> "${readmeFile}"
  done
}

# createToCNotes(): create links for notes in the same dir as the readme file
# arg1: readme file
createToCNotes() {
  local readmeFile="${1}"
  local directory
  local iteratorFile
  local fileBase
  local fileNoExtension

  [[ -f "${readmeFile}" ]] || return 1

  directory="$(dirname "${readmeFile}")"
  directory="${directory/$REPO_DIR\//}"

  echo -e '\n### 📝 Notes\n' >> "${readmeFile}"

  for iteratorFile in "${directory}"/*.md ; do
    fileBase="${iteratorFile##*/}"
    [[ $fileBase =~ .*README\.md ]] && continue

    fileNoExtension="${fileBase%.*}"

    # echo -n "- [${fileNoExtension}](${BASE_URL}/${directory}/${fileNoExtension})" >> "${readmeFile}"
    echo -n "- [${fileNoExtension}](${fileBase})" >> "${readmeFile}"
    echo " - [✏️](${EDIT_URL}/${directory}/${fileBase})" >> "${readmeFile}"
  done
}

# updateReadme(): update all readme files in the repository
updateReadme() {
  local readmeFile

  for readmeFile in $(readmeList); do
    sed -ni "1,/${REGEX_TOC_HEADING}/p" "${readmeFile}"
    createToCFolders "${readmeFile}"
    createToCNotes "${readmeFile}"
    git add "${readmeFile}"
  done
}

updateReadme "$@"

