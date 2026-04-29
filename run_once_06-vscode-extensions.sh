#!/bin/bash
set -e

section() { echo; echo "==> $1"; }
ok()      { echo "    [done] $1"; }
skip()    { echo "    [skip] $1"; }
info()    { echo "    --> $1"; }

section "VS Code Extensions"

if ! command -v code &>/dev/null; then
    skip "VS Code CLI ('code') not found."
    info "Open VS Code and run: Shell Command: Install 'code' command in PATH"
    info "Then re-run: make vscode-extensions"
    exit 0
fi

info "VS Code CLI found at: $(command -v code)"

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

total=${#extensions[@]}
count=0
for ext in "${extensions[@]}"; do
    count=$((count + 1))
    info "[$count/$total] Installing $ext..."
    code --install-extension "$ext" --force 2>&1 | tail -1
done

ok "All $total VS Code extensions installed."
