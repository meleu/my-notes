#!/usr/bin/env bash
# pre-commit
############
# This is the script is supposed to work as a git hook.
#
# I use it to update the README.md file of this repo
# everytime I make a commit.
#
# It must be named as '.git/hooks/pre-commit'
#
# For more info about Git Hooks: https://githooks.com/
#
# meleu: october/2020

readonly REPO_DIR="$(git rev-parse --git-dir)/.."
readonly INVALID_CHARS="'[]/?!:\`.,()*\";{}+=<>~$|#@&â€“â€”"

# Generates a Table of Contents getting a markdown file as input.
#
# Inspiration for this script:
# https://medium.com/@acrodriguez/one-liner-to-generate-a-markdown-toc-f5292112fd14
#
# The list of invalid chars is probably incomplete, but is good enough for my
# needs.
# Got the list from:
# https://github.com/thlorenz/anchor-markdown-header/blob/56f77a232ab1915106ad1746b99333bf83ee32a2/anchor-markdown-header.js#L25
#
# The list of valid markdown extensions were obtained here:
# https://superuser.com/a/285878
toc() {
  local inputFile="$1"
  local codeBlock='false'
  local line
  local level
  local title
  local anchor

  while IFS='' read -r line || [[ -n "$line" ]]; do
    if [[ "$line" = '```'* ]]; then
      [[ "$codeBlock" = 'false' ]] && codeBlock='true' || codeBlock='false'
      continue
    fi

    [[ "$codeBlock" = 'true' ]] && continue

    title="$(sed -E 's/^#+ //' <<< "$line")"

    if [[ "$line" = '# '* ]]; then
      echo "- [${title}](${inputFile})"
      continue
    fi

    level="$(sed -E 's/^#(#+).*/\1/; s/#/    /g' <<< "$line")"
    anchor="$(tr '[:upper:] ' '[:lower:]-' <<< "$title" | tr -d "$INVALID_CHARS")"

    echo "${level}- [${title}](${inputFile}#${anchor})"
  done <<< "$(grep -E '^(#{1,10} |```)' "$inputFile" | tr -d '\r')"
}


updateReadme() {
  local readme="${REPO_DIR}/README.md"
  local file
  local level
  local currentLevel

  if [[ ! -f "${readme}" ]]; then
    echo "${readme}: file not found. Aborting..." >&2
    exit 1
  fi

  sed -i '1,/^## Table of Contents/!d' "${readme}"
  echo >> "${readme}"
  for file in */*.md; do

    # create a subheading for the directory
    currentLevel="${file%/*}"
    if [[ "${currentLevel}" != "${level}" ]]; then
      level="${currentLevel}"
      echo -e "\n### ${level}" >> "${readme}"
    fi

    # create a dropdown list (viewable only on the GitHub repo view)
    echo -e "<details><summary>${file##*/}</summary><br>\n" >> "${readme}"

    toc "${file}" >> "${readme}"

    echo -e "\n</details>\n\n" >> "${readme}"
  done
  git add "${readme}"
}


updateReadme "$@"

