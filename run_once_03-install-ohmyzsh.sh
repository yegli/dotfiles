#!/bin/bash
set -e

section() { echo; echo "==> $1"; }
ok()      { echo "    [done] $1"; }
skip()    { echo "    [skip] $1"; }
info()    { echo "    --> $1"; }

section "oh-my-zsh Installation"

if [[ -d "$HOME/.oh-my-zsh" ]]; then
    skip "oh-my-zsh already installed at $HOME/.oh-my-zsh."
    exit 0
fi

info "Downloading and running oh-my-zsh installer..."
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
ok "oh-my-zsh installed."

CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

info "Installing plugin: zsh-autosuggestions..."
git clone https://github.com/zsh-users/zsh-autosuggestions "$CUSTOM/plugins/zsh-autosuggestions"
ok "zsh-autosuggestions installed."

info "Installing plugin: zsh-syntax-highlighting..."
git clone https://github.com/zsh-users/zsh-syntax-highlighting "$CUSTOM/plugins/zsh-syntax-highlighting"
ok "zsh-syntax-highlighting installed."
