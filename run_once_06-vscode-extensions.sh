#!/bin/bash
set -e

if ! command -v code &>/dev/null; then
    echo "VS Code CLI not found, skipping extension install."
    echo "Open VS Code and run: Shell Command: Install 'code' command in PATH"
    exit 0
fi

extensions=(
    # Git
    "eamodio.gitlens"

    # Editor quality
    "esbenp.prettier-vscode"
    "dbaeumer.vscode-eslint"
    "editorconfig.editorconfig"

    # Utilities
    "streetsidesoftware.code-spell-checker"
    "gruntfuggly.todo-tree"

    # Add your own below
)

for ext in "${extensions[@]}"; do
    echo "Installing $ext..."
    code --install-extension "$ext" --force
done

echo "VS Code extensions installed."
