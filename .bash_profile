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
alias code='"/c/Program Files/Microsoft VS Code/Code.exe"'
alias www='cd /c/www'
alias templates='cd /c/www/templates'
alias hosts='vscode "/c/Windows/System32/drivers/etc/hosts"'

alias run='/c/www/run.sh 80 443'
alias dev='gulp dev'
alias prod='gulp prod'
alias open='gulp open'
alias stop='gulp kill'
alias help='gulp help'

fhelp() {
  if [ "$1" ]; then
    help | grep "$1" --color=auto
  else
    echo "It needs one argument."
  fi
}

checkGit() {
  if [ -d ".git" ]; then
    cd ".git"
    if [ -f "FETCH_HEAD" ]; then
      cd ..
      pull
    else
      echo "Remote does not exists"
      cd ..
    fi
  else
    echo "Repository does not exists"
  fi
}

update() {
  if [ -d "templates" ]; then
    templates
    enterTemplates="yes"
  else
    enterTemplates="no"
  fi

  folders=($(ls -d */ | cut -f1 -d'/'))
  for dirName in ${!folders[@]}; do
    echo ""

    cd ${folders[$dirName]}
    echo "Opening ${folders[$dirName]}"

    checkGit

    cd ..
    echo "Closing"
    echo ""
	done

  if [ $enterTemplates = "yes" ]; then
    www
  fi
}

logs() {
  if [ "$1" ] && [ "$2" ]; then
    git log --pretty=format:"%C(yellow)%h %Cblue%>(12)%ad %Cgreen%<(7)%aN%Cred%d %Creset%s" --date-order -n "$1" --date=short --author="$2"
  elif [ "$1" ]; then
    git log --pretty=format:"%C(yellow)%h %Cblue%>(12)%ad %Cgreen%<(7)%aN%Cred%d %Creset%s" --date-order -n "$1" --date=short
  else
    git log --pretty=format:"%C(yellow)%h %Cblue%>(12)%ad %Cgreen%<(7)%aN%Cred%d %Creset%s" --date=short
  fi
}

changes() {
  if [ -z "$(git status --porcelain)" ]; then
    echo "Git clean"
  else
    echo "Has commits"
  fi
}
