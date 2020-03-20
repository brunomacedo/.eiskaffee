#!/bin/bash

end='\033[0m'
redb='\033[1;31m'
green='\033[0;32m'
blue='\033[0;34m'

printf "\nAre you sure you want to remove Eiskaffee? [ ${green} y/N ${end} ] "
read confirmation
if [ "$confirmation" != y ] && [ "$confirmation" != Y ]; then
  printf "${redb}Uninstall cancelled.${end}\n\n"
  exit
fi

if [ -d ~/.eiskaffee ]; then
  printf "\nRemoving ${redb}~/.eiskaffee${end}\n"
  rm -rf ~/.eiskaffee
fi

if [ -f ~/.eiskrc ] || [ -h ~/.eiskrc ]; then
  printf "Removing ${redb}~/.eiskrc${end}\n"
  rm ~/.eiskrc
fi

__sourceFileRemove() {
  if grep "source ~/.eiskrc" ~/$1 > /dev/null
  then
    sed -i "/source ~\/.eiskrc/d" ~/$1
    printf "\nRemoving line ${redb}~/.eiskrc${end} from ${blue}~/$1${end}"
  fi
}

__sourceFileRemove ".bashrc"
__sourceFileRemove ".bash_profile"
__sourceFileRemove ".zshrc"

printf "\n\n${green}Thanks for trying out Eiskaffee. It's been uninstalled.${end}\n\n"
