#!/bin/bash
set -e

eval "$(/opt/homebrew/bin/brew shellenv)"

echo "Installing packages from Brewfile..."
brew bundle --file="$CHEZMOI_SOURCE_DIR/Brewfile" --no-upgrade || {
    echo "brew bundle reported failures (App Store apps require signing in first — run 'make brew-install' after signing in)"
}
