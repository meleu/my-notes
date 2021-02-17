# bash
[✏️](https://github.com/meleu/my-notes/edit/master/bash.md)


## links

- <https://github.com/jlevy/the-art-of-command-line> - The Art of Command Line - good source of inspiration for articles
- <https://github.com/alexanderepstein/Bash-Snippets> - **THIS IS AN EXTREMELY VALUABLE RESOURCE**
- <https://github.com/dylanaraps/pure-bash-bible> - pure bash bible
- <https://github.com/alebcay/awesome-shell> - Awesome Shell resources
- <https://ebook.bobby.sh/> - inspiration for an interactive bash book/website.
- <https://cheat.sh> - the only cheat sheet you need :)
- <https://explainshell.com/> - write down a command-line to see the help text that matches each argument.

### references

- <http://mywiki.wooledge.org/> - awesome bash knowledge resource.
- <https://wiki.bash-hackers.org> - more bash hacking


## using bit.ly url shortener from terminal

See the article (in portuguese): <https://meleu.sh/url-shortener/>

```bash
#!/usr/bin/env bash
# urlshort.sh
#############
#
# An URL shortener using a free bit.ly account.
#
# Before running this script, you're gonna need a bitly access token.
#
# INSTRUCTIONS:
# 1. Create an account at https://bitly.com
# 2. Once you're logged in and in your dashboard:
#     - click on your account name on the top-right corner
#     - Profile Settings > Generic Access Token
#     - enter your password and you'll get your token
# 3. Copy your token and paste it in the BITLY_TOKEN declaration below
#
# meleu - February/2020

readonly BITLY_TOKEN=''
readonly BITLY_ENDPOINT='https://api-ssl.bitly.com/v4/shorten'

shortener() {
  local long_url="$1"
  while [[ -z "$long_url" ]]; do
    read -r -p "Digite a url: " long_url
  done
  curl -s \
    --header "Authorization: Bearer ${BITLY_TOKEN}" \
    --header "Content-Type: application/json" \
    --data "{\"long_url\":\"${long_url}\"}" \
    "${BITLY_ENDPOINT}" \
    | jq -r 'if .link == null then .description else .link end'
}

if [[ -z "$BITLY_TOKEN" ]]; then
  echo "ERROR: API access token not found" >&2
  echo "(have you filled the BITLY_TOKEN variable with your token?)" >&2
  exit 1
fi

shortener "$@"
```

## tool to build a bargraph on terminal: termgraph

See the article (in portuguese): <https://meleu.sh/coronavirus-ranking/>

Example of usage:
```bash
#!/usr/bin/env bash
# covid-ranking.sh
##################
#
# Show a bargraph with a ranking of countries with 
# the highest number of deaths caused by COVID-19.
#
# Dependencies: curl, jq, termgraph
#
# (install termgraph via `pip3 install termgraph`)

readonly URL='https://corona.lmao.ninja/countries?sort=deaths'

readonly DEPENDENCIES=(curl jq termgraph)

checkDependencies() {
  local errorFound=0

  for command in "${DEPENDENCIES[@]}"; do
    if ! which "$command" > /dev/null ; then
      echo "ERROR: command not found: '$command'" >&2
      errorFound=1
    fi
  done

  if [[ "$errorFound" != "0" ]]; then
    echo "---ABORTING---"
    echo "This scripts needs the commands listed above." >&2
    echo "Install them and/or check if they're in your \$PATH" >&2
    exit 1
  fi
}

main() {
  checkDependencies

  curl --silent "$URL" \
    | jq '.[:10][] | "\(.country);\(.deaths)"' \
    | tr -d \" \
    | termgraph --delim ';' --title 'Countries with the highest number of deaths caused by COVID-19' \
    | sed 's/\.00$//'
}

main "$@"
```


## urlencode

```bash
#!/usr/bin/env bash
# urlencode
###########
# my explanation about what happens here (portuguese only):
# https://meleu.sh/urlencode/

urlencode() {
    local LC_ALL=C
    local string="$*"
    local length="${#string}"
    local char

    for (( i = 0; i < length; i++ )); do
        char="${string:i:1}"
        if [[ "$char" == [a-zA-Z0-9.~_-] ]]; then
            printf "$char" 
        else
            printf '%%%02X' "'$char" 
        fi
    done
    printf '\n' # optional
}

urlencode "$@"
```

## urldecode

```bash
#!/usr/bin/env bash
# urldecode
###########
# my explanation about what happens here (portuguese only):
# https://meleu.sh/urlencode/

urldecode() {
    local encoded="${*//+/ }"
    printf '%b\n' "${encoded//%/\\x}"
    # the '\n' above is optional
}

urldecode "$@"
```
