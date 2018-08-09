end=$'\033[0m'
red=$'\033[0;31m'
green=$'\033[0;32m'

read -r -p "Are you sure you want to remove Eiskaffee? [${green}y/N${end}] " confirmation
if [ "$confirmation" != y ] && [ "$confirmation" != Y ]; then
  echo -e "${red}Uninstall cancelled.${end}"
  exit
fi

if [ -d ~/.eiskaffee ]; then
  echo -e "${red}Removing ~/.eiskaffee${end}"
  rm -rf ~/.eiskaffee
fi

if [ -f ~/.eiskrc ] || [ -h ~/.eiskrc ]; then
  rm ~/.eiskrc
  echo -e "${red}Removing ~/.eiskrc${end}"
fi

if grep -Fxq "source ~/.eiskrc" ~/.bash_profile  > /dev/null; then
  sed -i "/source ~\/.eiskrc/Id" ~/.bash_profile
  echo -e "Removing line ${red}~/.eiskrc${end} from ~/.bashprofile"
fi

echo -e "${green}Thanks for trying out Eiskaffee. It's been uninstalled.${end}"
