#!/bin/bash

end=$'\033[0m'
red=$'\033[0;31m'
green=$'\033[0;32m'

REPOSITORY="https://github.com/brunomacedo/.eiskaffee.git"

command -v git >/dev/null 2>&1 || {
  echo "Error: git is not installed"
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

function __sourceFileInstall {
  if [ ! -f ~/$1 ]; then
    touch ~/$1
  fi

  # if ! grep -Fxq "source ~/.eiskrc" ~/$1 > /dev/null; then
  if ! command grep -qc "source ~/.eiskrc" "~/$1" > /dev/null; then
    echo "source ~/.eiskrc" >> ~/$1
  else
    printf "${red}"
    printf "You'll need to remove $EISK_HOME if you want to re-install.\n"
    printf "${end}"
    exit 1
  fi
}

__sourceFileInstall ".bashrc"
__sourceFileInstall ".bash_profile"

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
