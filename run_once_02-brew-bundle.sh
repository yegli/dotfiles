#!/bin/bash
set -e

eval "$(/opt/homebrew/bin/brew shellenv)"

echo "Installing packages from Brewfile..."
brew bundle --file="$CHEZMOI_SOURCE_DIR/Brewfile"
