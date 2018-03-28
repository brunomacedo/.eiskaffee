alias s='git status'
alias status='git status'
alias add='git add .'
alias commit='git commit -m'
alias push='git push'
alias pull='git pull'
alias discart='git checkout -f'
alias clone='git clone'
alias hosts='code "/c/drivers/etc/hosts"'

checkGit() {
  if [ -d .git ]; then
    cd .git
    if [ -f FETCH_HEAD ]; then
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
  folders=($(ls))
  for dirName in ${!folders[@]}; do
    echo ""
    
    cd ${folders[$dirName]}
    echo "Opening ${folders[$dirName]}"

    checkGit

    cd ..
    echo "Closing"
    echo ""
	done
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
