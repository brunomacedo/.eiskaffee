#!/bin/bash

end=$'\033[0m'
red=$'\033[0;31m'
green=$'\033[0;32m'

read -r -p "Are you sure you want to remove Eiskaffee? [${green}y/N${end}] " confirmation
if [ "$confirmation" != y ] && [ "$confirmation" != Y ]; then
  printf "${red}"
  echo "Uninstall cancelled."
  printf "${end}"
  exit
fi

if [ -d ~/.eiskaffee ]; then
  printf "${red}"
  echo "Removing ~/.eiskaffee"
  printf "${end}"
  rm -rf ~/.eiskaffee
fi

if [ -f ~/.eiskrc ] || [ -h ~/.eiskrc ]; then
  rm ~/.eiskrc
  printf "${red}"
  echo "Removing ~/.eiskrc"
  printf "${end}"
fi

function __sourceFileRemove {
  if grep "source ~/.eiskrc" ~/$1 > /dev/null; then

    if [ "$OSTYPE" = "msys" ]; then
      sed -i "/source ~\/.eiskrc/d" ~/$1
    else
      sed -i "" "/source ~\/.eiskrc/d" ~/$1
    fi

    echo ""
    printf "Removing line ${red}~/.eiskrc${end} from ~/$1"
    echo ""
  fi
}

__sourceFileRemove ".bashrc"
__sourceFileRemove ".bash_profile"
__sourceFileRemove ".zshrc"

printf "${green}Thanks for trying out Eiskaffee. It's been uninstalled.${end}"
