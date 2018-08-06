end="\033[0m"
red="\033[0;31m"
green="\033[0;32m"

if [ ! -f ~/.eiskrc ]; then
  if [ -f ~/.eiskaffee/tools/.eiskrc ]; then
    cp ~/.eiskaffee/tools/.eiskrc ~/.eiskrc
  else
    printf "${red}"
    echo "No such file or directory."
    printf "${end}"
  fi
fi

if [ ! -f ~/.bash_profile  ]; then
  touch ~/.bash_profile
fi

if ! grep -Fxq "source ~/.eiskrc" ~/.bash_profile  > /dev/null; then
  echo "source ~/.eiskrc" >> ~/.bash_profile

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
  echo "Check this repository: https://github.com/brunomacedo/.eiskaffee.git "
  echo ""
  printf "${end}"
else
  printf "${green}"
  echo "You already have Eiskaffee installed."
  printf "${end}"
fi
