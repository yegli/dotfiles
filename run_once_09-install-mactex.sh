#!/bin/bash
set -e

section() { echo; echo "==> $1"; }
ok()      { echo "    [done] $1"; }
skip()    { echo "    [skip] $1"; }
info()    { echo "    --> $1"; }
warn()    { echo "    [warn] $1"; }

section "MacTeX Installation"

# Check for an existing TeX Live installation
if [[ -d "/usr/local/texlive" ]] || command -v pdflatex &>/dev/null; then
    skip "MacTeX / TeX Live already installed."
    if command -v pdflatex &>/dev/null; then
        info "pdflatex: $(pdflatex --version | head -1)"
    fi
    exit 0
fi

MACTEX_URL="https://mirror.ctan.org/systems/mac/mactex/MacTeX.pkg"
MACTEX_PKG="/tmp/MacTeX.pkg"

warn "MacTeX is ~4 GB — this download will take a while."
info "Source: $MACTEX_URL"
info "Destination: $MACTEX_PKG"

curl -L --progress-bar -o "$MACTEX_PKG" "$MACTEX_URL"
ok "Download complete ($(du -sh "$MACTEX_PKG" | cut -f1))."

info "Running installer (requires sudo)..."
sudo installer -pkg "$MACTEX_PKG" -target /
ok "MacTeX installed."

info "Cleaning up $MACTEX_PKG..."
rm -f "$MACTEX_PKG"

ok "MacTeX installation complete."
info "TeX binaries: /Library/TeX/texbin"
info "You may need to open a new terminal for PATH to take effect."
