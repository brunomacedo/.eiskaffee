#!/bin/bash

end='\033[0m'
red='\033[0;31m'
green='\033[0;32m'

REPOSITORY="https://github.com/brunomacedo/.eiskaffee.git"

command -v git >/dev/null 2>&1 || {
  printf "${red}"
  echo "Error: git is not installed"
  printf "${end}"
  exit 1
}

if [ ! -n "$EISK_HOME" ]; then
  EISK_HOME=~/.eiskaffee
fi

if [ ! -d $EISK_HOME ]; then
  env git clone --depth=1 "$REPOSITORY" "$EISK_HOME" || {
    printf "Error: git clone of eiskaffee repo failed\n"
    exit 1
  }
fi

__sourceFileInstall() {
  if [ ! -f ~/$1 ]; then
    touch ~/$1
  fi

  if grep -q "source ~/.eiskaffee" ~/$1
  then
    printf "${red}"
    printf "You'll need to remove $EISK_HOME if you want to re-install.\n"
    printf "${end}"
    return
  fi

  printf "\nsource ~/.eiskrc" >> ~/$1
  return
}

if [ ! -f ~/.eiskrc ]; then
  if [ -f $EISK_HOME/templates/.eiskrc ]; then
    cp $EISK_HOME/templates/.eiskrc ~/.eiskrc
  else
    printf "${red}"
    echo "No such file or directory."
    printf "${end}"
    exit 1
  fi
fi

__sourceFileInstall ".bashrc"
__sourceFileInstall ".bash_profile"
__sourceFileInstall ".zshrc"

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
echo "Author: Bruno Macedo"
echo "Repository: $REPOSITORY"
echo ""
printf "${end}"
