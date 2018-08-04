# Import colors functions
source ~/.colors

alias s='git status -s'
alias status='git status -s'
alias add='git add .'
alias commit='git commit -m'
alias push='git push'
alias pull='git pull'
alias discart='git checkout -f'
alias clone='git clone'
alias cherry='git cherry -v'

# alias vscode='"/c/Program Files/Microsoft VS Code/Code.exe"'
# alias code=vscode
# alias www='cd /c/www'
# alias templates='cd /c/www/templates'
# alias hosts='vscode "/c/Windows/System32/drivers/etc/hosts"'

# Git get the current branch
getCurrentBranch() {
  local ref
  ref=$(command git symbolic-ref --quiet HEAD 2> /dev/null)
  local ret=$?
  if [[ $ret != 0 ]]; then
    [[ $ret == 128 ]] && return  # no git repo.
    ref=$(command git rev-parse --short HEAD 2> /dev/null) || return
  fi
  echo ${ref#refs/heads/}
}

# Verify if local repository exists
isGitRepo() {
  local GET_REPO=true
  if [[ ! -d ".git" ]]; then
    echo "${redb}No such repository (.git).${end}"
    GET_REPO=false
    return false
  fi

  echo $GET_REPO
}

# Verify if there is a remote repository
isRemoteGitPull() {
  local CURRENT_BRANCH="$(getCurrentBranch)"
  if [[ -n "$(command git show-ref origin/${CURRENT_BRANCH} 2> /dev/null)" ]]; then
    pull
  else
    echo "${blueb}Remote does not exists.${end}"
  fi
}

# Git update [pull] multiple repositories
update() {
  OLDIFS=""
  IFS=$'\n'

  local folders=($(ls -d */ | cut -f1 -d'/'))

  IFS=$OLDIFS
  for (( i = 1; i <= ${#folders}; ++i )); do
    echo ""

    cd ${folders[i]}
    echo "Opening ${blueb}${folders[i]}${end}"

    isRemoteGitPull

    cd ..
    echo "Closing."
    echo ""
	done
}

# Git show logs
# Usage: logs <number> <user_name:optional>
# where <number> is one of:
#     1 ... ~
logs() {
  if [[ "$(isGitRepo)" = true ]]; then
    if [ "$1" ] && [ "$2" ]; then
      git log --pretty=format:"%C(yellow)%h %Cblue%>(12)%ad %Cgreen%<(7)%aN%Cred%d %Creset%s" --date-order -n "$1" --date=short --author="$2"
    elif [ "$1" ]; then
      git log --pretty=format:"%C(yellow)%h %Cblue%>(12)%ad %Cgreen%<(7)%aN%Cred%d %Creset%s" --date-order -n "$1" --date=short
    else
      git log --pretty=format:"%C(yellow)%h %Cblue%>(12)%ad %Cgreen%<(7)%aN%Cred%d %Creset%s" --date=short
    fi

    return
  fi

  isGitRepo
}

# Verify if there are files to versioned
changes() {
  local changed=false
  if [[ -n "$(command git status --porcelain)" ]]; then
    changed=true
  fi
  echo $changed
}

# Ask if you'd like to commit changes
gcommit() {
  if [[ "$(isGitRepo)" = true ]]; then
    local getChange="$(changes)"

    if [ $getChange = true ]; then
      echo ""
      echo "${lightblueb}You have some modified files to commit.${end}"
      echo "Would you like to commit it? ${yellowb}[1]${end} Yes ${yellowb}[2]${end} No"
      echo ""
      read SEND

      if [ $SEND = "1" ]; then
        git add .
        git commit -m "$1"
      else
        echo ""
        echo "${redb}Your have files not versioned.${end}"
        git status -s
      fi
    else
      echo "Nothing to commit."
    fi

    return
  fi

  isGitRepo
}

# Git update package version
# Usage: bump <version>
# where <version> is one of:
#     major, minor, patch
bump() {
  if [ "$1" != "" ] && [ "$1" ]; then
    local getChange="$(changes)"

    if [ $getChange = false ]; then
      npm version "$1" -m "Bumped to version %s"
      # git push --tags
    else
      gcommit "Before bump commit."
    fi
  else
    echo -e "\nUsage: bump ${yellowb}<version>${end}\n\nwhere <version> is one of:\n    ${purple}major, minor, patch${end}\n"
  fi
}

# Get your package.json version
version() {
  local PACKAGE_VERSION=$(cat package.json \
    | grep version \
    | head -1 \
    | awk -F: '{ print $2 }' \
    | sed 's/[",]//g' \
    | tr -d '[[:space:]]')

  echo "${greenb}v${PACKAGE_VERSION}${end}"
}

# Rename folders and files with special
# Usage: rename <command>
# where <command> is one of:
#     all, dirs, folders, files
rename() {
  OLDIFS=""
  IFS=$'\n'
  local files=()
  local ARGS=true
  local COUNTRENAME=0

  if [ "$1" = "files" ]; then
    files=(`ls -F | grep -v '[/@=|]$'`)

  elif [ "$1" = "dirs" ] || [ "$1" = "folders" ]; then
    files=(`ls -d */ | cut -f1 -d'/'`)

  elif [ "$1" = "all" ] || [ "$1" = "" ]; then
    files=(`ls -G | sed 's/[\/]//g'`)

  else
    ARGS=false
    echo -e "\nUsage: rename ${yellowb}<command>${end}\n\nwhere <command> is one of:\n    ${purple}all, dirs, folders, files${end}\n"

  fi

  IFS=$OLDIFS
  if $ARGS; then

    for (( i = 1; i <= ${#files}; ++i )); do
      byte="$str[i]"

      if [ ${files[i]} != `replaceCharacters ${files[i]}` ]; then
        echo -e "${yellowb}Renamed:${end}" `replaceCharacters "${files[i]}"`
        mv "${files[i]}" `replaceCharacters "${files[i]}"`
        COUNTRENAME=$((COUNTRENAME+1))
      fi
    done

    if (( $COUNTRENAME <= 0 )); then
      echo -e "${lightblueb}Everything is look good.${end}"
    fi
  fi
}

# Map of characters
replaceCharacters() {
  echo "$1" | tr '[:upper:]' '[:lower:]' | \
    sed "s/[áàâãä@]/a/g; \
        s/[éèêë&]/e/g; \
        s/[íìîï]/i/g; \
        s/[óòôõö]/o/g; \
        s/[úùûü]/u/g; \
        s/[ç]/c/g; \
        s/(//g; \
        s/)//g; \
        s/\]//g; \
        s/\[//g; \
        s/[#~^,*´%¨$]/ /g" | \
    tr -s '[:blank:]' '-'
}
