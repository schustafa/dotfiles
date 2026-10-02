#!/bin/bash

# Bootstrapped using https://github.com/skalnik/dotfiles/blob/300bb5ce40edf3d7c1bb6780e288c463e0afed81/install.sh

exec > >(tee -i "$HOME/dotfiles_install.log")
exec 2>&1
set -x

DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)" || exit 1

if [ -n "$CODESPACES" ]; then
  echo '📦️ Installing a few packages…'

  # Some codespaces don't have vim?
  sudo apt-get install --assume-yes vim

  # Starship Prompt
  sh -c "$(curl -fsSL https://starship.rs/install.sh)" -- --yes

  # FZF
  git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && ~/.fzf/install --key-bindings --completion --no-update-rc

  # gh-pairing-with
  gh extensions install schustafa/gh-pairing-with

  echo '⚡ Setting default prompt to zsh'
  sudo chsh -s "$(which zsh)" "$(whoami)"
fi

copilot_source="$DIR/copilot/copilot-instructions.md"
copilot_target="$HOME/.copilot/copilot-instructions.md"
copilot_status=0

if ! mkdir -p "$HOME/.copilot"; then
  copilot_status=1
elif [ -e "$copilot_target" ] || [ -L "$copilot_target" ]; then
  if [ -L "$copilot_target" ] || [ ! -f "$copilot_target" ] || ! cmp -s "$copilot_source" "$copilot_target"; then
    echo "Copilot instructions already exist at $copilot_target; reconcile them before reinstalling." >&2
    copilot_status=1
  fi
else
  # VS Code Chat skips symlinks when discovering user instructions.
  cp "$copilot_source" "$copilot_target" || copilot_status=1
fi

# Link all linkable files
for linkable in "$DIR"/**/*.symlink; do
  target="$HOME/.$(basename "$linkable" .symlink)"
  if [ ! -L "$target" ]; then
    echo "🔗 Linking $target → $linkable."
    ln -Ff -s "$linkable" "$target"
  fi
done

touch "$HOME/.dotfiles_ready" || exit 1
exit "$copilot_status"
