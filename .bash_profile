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

alias vscode='"/c/Program Files/Microsoft VS Code/Code.exe"'
alias code=vscode
alias www='cd /c/www'
alias templates='cd /c/www/templates'
alias hosts='vscode "/c/Windows/System32/drivers/etc/hosts"'

alias run='/c/www/run.sh 80 443'
alias dev='gulp dev'
alias prod='gulp prod'
alias open='gulp open'
alias help='gulp help'

fhelp() {
  if [ "$1" ]; then
    help | grep "$1" --color=auto
  else
    echo "It needs one argument."
  fi
}

isRemoteGit() {
  if [ -d ".git" ]; then
    cd ".git"
    if [ -f "config" ] && grep -q remote "config"; then
      cd ..
      pull
    else
      echo "Remote does not exists"
      cd ..
    fi
  else
    echo "Repo does not exists"
  fi
}

update() {
  if [ -d "templates" ]; then
    templates
    enterTemplates="yes"
  else
    enterTemplates="no"
  fi

  OLDIFS=""
  IFS=$'\n'

  folders=($(ls -d */ | cut -f1 -d'/'))

  IFS=$OLDIFS

  # WINDOWS
  # for dirName in ${!folders[@]}; do
  # ${folders[$dirName]}

  # MAC
  for dirName in $folders; do
    echo ""

    cd $dirName
    echo "Opening $dirName"

    isRemoteGit

    cd ..
    echo "Closing"
    echo ""
  done

  if [ $enterTemplates = "yes" ]; then
    www
  fi
}

logs() {
  if [ -d ".git" ]; then
    if [ "$1" ] && [ "$2" ]; then
      git log --pretty=format:"%C(yellow)%h %Cblue%>(12)%ad %Cgreen%<(7)%aN%Cred%d %Creset%s" --date-order -n "$1" --date=short --author="$2"
    elif [ "$1" ]; then
      git log --pretty=format:"%C(yellow)%h %Cblue%>(12)%ad %Cgreen%<(7)%aN%Cred%d %Creset%s" --date-order -n "$1" --date=short
    else
      git log --pretty=format:"%C(yellow)%h %Cblue%>(12)%ad %Cgreen%<(7)%aN%Cred%d %Creset%s" --date=short
    fi
  else
    echo "No such repository."
  fi
}

changes() {
  if [ -z "$(git status --porcelain)" ]; then
    changed=true
  else
    changed=false
  fi
  echo "$changed"
}

# Git verify if there are something to versioned
gcommit() {
  getChange="$(changes)"

  if [ $getChange = "false" ]; then

    echo ""
    echo "You have some modified files to commit."
    echo "Would you like to commit it? [1] Yes [2] No"
    echo ""
    read SEND

    if [ $SEND = "1" ]; then
      isRemoteGit
      git add .
      git commit -m "$1"
    else
      echo ""
      echo "Please, commit your modified files before bump version."
      git status -s
    fi
  else
    echo "Nothing to commit."
  fi
}

# Git update package version
# Usage: bump <version>
# where <version> is one of:
#     major, minor, patch
bump() {
  if [ "$1" != "" ] && [ "$1" ]; then
    local getChange="$(changes)"

    if [ $getChange = "true" ]; then
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
  PACKAGE_VERSION=$(cat package.json \
    | grep version \
    | head -1 \
    | awk -F: '{ print $2 }' \
    | sed 's/[",]//g' \
    | tr -d '[[:space:]]')

  echo $PACKAGE_VERSION
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
