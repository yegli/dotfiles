#!/bin/bash
set -e

section() { echo; echo "==> $1"; }
ok()      { echo "    [done] $1"; }
skip()    { echo "    [skip] $1"; }
info()    { echo "    --> $1"; }

section "Homebrew Installation"

if command -v brew &>/dev/null; then
    skip "Homebrew already installed at $(command -v brew)."
    brew --version | head -1 | { read v; info "Version: $v"; }
    exit 0
fi

info "Downloading and running Homebrew installer..."
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

if [[ -f /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
    ok "Homebrew installed at /opt/homebrew/bin/brew."
else
    ok "Homebrew installed."
fi
