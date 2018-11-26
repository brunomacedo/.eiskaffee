end=$'\033[0m'
red=$'\033[0;31m'
green=$'\033[0;32m'

read -r -p "Are you sure you want to remove Eiskaffee? [${green}y/N${end}] " confirmation
if [ "$confirmation" != y ] && [ "$confirmation" != Y ]; then
  echo "${red}Uninstall cancelled.${end}"
  exit
fi

if [ -d ~/.eiskaffee ]; then
  echo "${red}Removing ~/.eiskaffee${end}"
  rm -rf ~/.eiskaffee
fi

if [ -f ~/.eiskrc ] || [ -h ~/.eiskrc ]; then
  rm ~/.eiskrc
  echo "${red}Removing ~/.eiskrc${end}"
fi

function sourceFileRemove {
  if grep -Fxq "source ~/.eiskrc" ~/$1  > /dev/null; then

    if [ "$OSTYPE" = "msys" ]; then
      sed -i "/source ~\/.eiskrc/d" ~/$1
    else
      sed -i "" "/source ~\/.eiskrc/d" ~/$1
    fi

    echo "Removing line ${red}~/.eiskrc${end} from ~/$1"
  fi
}

sourceFileRemove .bashrc
sourceFileRemove .bash_profile

echo "${green}Thanks for trying out Eiskaffee. It's been uninstalled.${end}"
