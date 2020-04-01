#!/bin/bash

__command_exists git || {
  echo "git is not installed."
  return
}

__git_run_update() {
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
}

__git_check_update() {
  local CURRENT_DIR="$PWD"
  cd "$EISK_HOME"

  git fetch --quiet
  __GIT_CHECK_REF="$(command git log HEAD..origin --pretty=format:%h 2> /dev/null)"

  if [[ "$__GIT_CHECK_REF" ]]; then
    printf "\nWould you like to update? ${yellowb}[Y/n]${end}: \n"
    read line
    if [[ "$line" == Y* ]] || [[ "$line" == y* ]] || [ -z "$line" ]; then
      __git_run_update
    fi
  fi

  cd "$CURRENT_DIR"
}

__git_check_update
