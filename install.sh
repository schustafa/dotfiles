#!/bin/bash

# Bootstrapped using https://github.com/skalnik/dotfiles/blob/300bb5ce40edf3d7c1bb6780e288c463e0afed81/install.sh

exec > >(tee -i $HOME/dotfiles_install.log)
exec 2>&1
set -x

DIR="$(pwd -P $0)"

if [ -n "$CODESPACES" ]; then
  echo '📦️ Installing a few packages…'

  # Starship Prompt
  sh -c "$(curl -fsSL https://starship.rs/install.sh)" -- --yes

  # FZF
  git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && ~/.fzf/install --key-bindings --completion --no-update-rc

  echo '⚡ Setting default prompt to zsh'
  sudo chsh -s "$(which zsh)" "$(whoami)"
fi

# Link all linkable files
for linkable in $DIR/**/*.symlink; do
  target=$HOME"/."$(basename $linkable | sed 's/.symlink//')
  if [ ! -L $target ]; then
    echo "🔗 Linking $target → $linkable."
    ln -Ff -s $linkable $target
  fi
done
