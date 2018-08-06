source "../lib/colors.eisk"

if [ ! -f ~/.bash_profile ]; then
  touch ~/.bash_profile
fi

if ! grep -Fxq "source ~/.eiskrc" ~/.bash_profile > /dev/null; then
  if [ ! -f ~/.eiskrc ]; then
    if [ -f .eiskrc ]; then
      cp .eiskrc ~/.eiskrc
    else
      echo -e "${redb}No such file or directory.${end}"
    fi
  fi

  echo "source ~/.eiskrc" >> ~/.bash_profile

  printf "${greenb}"
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
  echo -e "${greenb}Eiskaffee already has been installed!${end}"
fi
