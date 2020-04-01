#!/bin/bash

__command_exists git || {
  echo "git is not installed."
  return
}

git fetch --quiet
checkRef="$(command git log HEAD..origin --pretty=format:%h 2> /dev/null)"

if [[ "$checkRef" ]]; then
  printf "\nWould you like to update? ${yellowb}[Y/n]${end}: \n"
  read line
  if [[ "$line" == Y* ]] || [[ "$line" == y* ]] || [ -z "$line" ]; then
    git pull --quiet

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
    echo "Eiskaffee has been updated."
    echo ""
    printf "${end}"
  fi
fi
