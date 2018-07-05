#!/usr/bin/env bash

function inst() {
  git pull -q origin master
  sudo cp -v abbs.sh /usr/bin/abbs
  sudo cp -v autocomplete/abbs.bash /etc/bash_completion.d/abbs
  sudo cp -v autocomplete/abbs.zsh /usr/share/zsh/vendor-completions/_abbs
}

if [[ $1 = "-u" ]]; then
  echo "Updating abbs... "
  sudo rm /usr/bin/abbs
  sudo rm /etc/bash_completion.d/abbs
  sudo rm /usr/share/zsh/vendor-completions/_abbs
  inst
  echo "Update complete"
else
  echo "Installing abbs... "
  inst
  echo "Install complete"
fi
