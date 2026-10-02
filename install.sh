#!/bin/bash

# Bootstrapped using https://github.com/skalnik/dotfiles/blob/300bb5ce40edf3d7c1bb6780e288c463e0afed81/install.sh

exec > >(tee -i "$HOME/dotfiles_install.log")
exec 2>&1
set -x
set -o pipefail

finish_install() {
  local status=$?
  if [ "$status" -eq 0 ]; then
    touch "$HOME/.dotfiles_ready" || status=1
  fi
  if [ "$status" -ne 0 ]; then
    rm -f "$HOME/.dotfiles_ready" || status=1
    touch "$HOME/.dotfiles_failed" || status=1
    echo "Dotfiles installation failed; see $HOME/dotfiles_install.log." >&2
  fi
  exit "$status"
}

trap finish_install EXIT
trap 'exit 130' INT
trap 'exit 143' TERM
rm -f "$HOME/.dotfiles_ready" "$HOME/.dotfiles_failed" || exit 1
install_status=0

DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)" || exit 1

if [ -n "$CODESPACES" ]; then
  echo '📦️ Installing a few packages…'

  # Some codespaces don't have vim?
  sudo apt-get install --assume-yes vim || install_status=1

  # Starship Prompt
  curl -fsSL https://starship.rs/install.sh | sh -s -- --yes || install_status=1

  # FZF
  if [ ! -x "$HOME/.fzf/install" ]; then
    git clone --depth 1 https://github.com/junegunn/fzf.git "$HOME/.fzf" || install_status=1
  fi
  "$HOME/.fzf/install" --key-bindings --completion --no-update-rc || install_status=1

  # gh-pairing-with
  if installed_extensions="$(gh extension list)"; then
    if [[ "$installed_extensions" != *$'\tschustafa/gh-pairing-with\t'* ]]; then
      gh extensions install schustafa/gh-pairing-with || install_status=1
    fi
  else
    install_status=1
  fi

  echo '⚡ Setting default prompt to zsh'
  if zsh_path="$(command -v zsh)"; then
    sudo chsh -s "$zsh_path" "$(whoami)" || install_status=1
  else
    echo "zsh is not installed." >&2
    install_status=1
  fi
fi

copilot_source="$DIR/copilot/copilot-instructions.md"
copilot_target="$HOME/.copilot/copilot-instructions.md"

if ! mkdir -p "$HOME/.copilot"; then
  install_status=1
elif [ -e "$copilot_target" ] || [ -L "$copilot_target" ]; then
  if [ -L "$copilot_target" ] || [ ! -f "$copilot_target" ] || ! cmp -s "$copilot_source" "$copilot_target"; then
    echo "Copilot instructions already exist at $copilot_target; reconcile them before reinstalling." >&2
    install_status=1
  fi
else
  # VS Code Chat skips symlinks when discovering user instructions.
  cp "$copilot_source" "$copilot_target" || install_status=1
fi

# Link all linkable files
for linkable in "$DIR"/**/*.symlink; do
  target="$HOME/.$(basename "$linkable" .symlink)"
  if [ ! -L "$target" ]; then
    echo "🔗 Linking $target → $linkable."
    ln -Ff -s "$linkable" "$target" || install_status=1
  fi
done

exit "$install_status"
