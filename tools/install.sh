end=$'\033[0m'
red=$'\033[0;31m'
green=$'\033[0;32m'

REPOSITORY="https://github.com/brunomacedo/.eiskaffee.git"

command -v git >/dev/null 2>&1 || {
  echo "Error: git is not installed"
  exit 1
}

if [ ! -n "$FINDROOT" ]; then
  FINDROOT=~/.eiskaffee
fi

if [ ! -d $FINDROOT ]; then
  env git clone --depth=1 "$REPOSITORY" "$FINDROOT" || {
    printf "Error: git clone of oh-my-zsh repo failed\n"
    exit 1
  }
fi

if [ ! -f ~/.eiskrc ]; then
  if [ -f $FINDROOT/templates/.eiskrc ]; then
    cp $FINDROOT/templates/.eiskrc ~/.eiskrc
  else
    printf "${red}"
    echo "No such file or directory."
    printf "${end}"
    exit 1
  fi
fi

if [ ! -f ~/.bash_profile  ]; then
  touch ~/.bash_profile
fi

if ! grep -Fxq "source ~/.eiskrc" ~/.bash_profile  > /dev/null; then
  echo "source ~/.eiskrc" >> ~/.bash_profile
else
  printf "${red}"
  printf "You'll need to remove $FINDROOT if you want to re-install.\n"
  printf "${end}"
  exit 1
fi

printf "${green}"
echo ""
echo ""
echo "▓█████  ██▓  ██████  ██ ▄█▀▄▄▄        █████▒ █████▒▓█████ ▓█████ ";
echo "▓█   ▀ ▓██▒▒██    ▒  ██▄█▒▒████▄    ▓██   ▒▓██   ▒ ▓█   ▀ ▓█   ▀ ";
echo "▒███   ▒██▒░ ▓██▄   ▓███▄░▒██  ▀█▄  ▒████ ░▒████ ░ ▒███   ▒███   ";
echo "▒▓█  ▄ ░██░  ▒   ██▒▓██ █▄░██▄▄▄▄██ ░▓█▒  ░░▓█▒  ░ ▒▓█  ▄ ▒▓█  ▄ ";
echo "░▒████▒░██░▒██████▒▒▒██▒ █▄▓█   ▓██▒░▒█░   ░▒█░    ░▒████▒░▒████▒";
echo "░░ ▒░ ░░▓  ▒ ▒▓▒ ▒ ░▒ ▒▒ ▓▒▒▒   ▓▒█░ ▒ ░    ▒ ░    ░░ ▒░ ░░░ ▒░ ░";
echo "                                                                 ";
echo "Check this repository: $REPOSITORY"
echo ""
printf "${end}"
