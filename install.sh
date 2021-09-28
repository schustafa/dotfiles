#!/bin/sh

# Bootstrapped using https://github.com/skalnik/dotfiles/blob/300bb5ce40edf3d7c1bb6780e288c463e0afed81/install.sh

exec > >(tee -i $HOME/dotfiles_install.log)
exec 2>&1
set -x

DIR="$(pwd -P $0)"

# Link all linkable files
for linkable in $DIR/**/*.symlink; do
  target=$HOME"/."$(basename $linkable | sed 's/.symlink//')
  if [ ! -L $target ]; then
    echo "🔗 Linking $target → $linkable."
    ln -Ff -s $linkable $target
  fi
done
