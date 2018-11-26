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
    printf "Error: git clone of eiskaffee repo failed\n"
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

function sourceFileInstall {
  if [ ! -f ~/$1 ]; then
    touch ~/$1
  fi

  if ! grep -Fxq "source ~/.eiskrc" ~/$1  > /dev/null; then
    echo "source ~/.eiskrc" >> ~/$1
  else
    printf "${red}"
    printf "You'll need to remove $FINDROOT if you want to re-install.\n"
    printf "${end}"
    exit 1
  fi
}

sourceFileInstall .bashrc
sourceFileInstall .bash_profile

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
