#!/bin/bash
set -e

section() { echo; echo "==> $1"; }
ok()      { echo "    [done] $1"; }
info()    { echo "    --> $1"; }

section "Dock Configuration"

if ! command -v dockutil &>/dev/null; then
    info "dockutil not found, installing via brew..."
    brew install dockutil
    ok "dockutil installed."
fi

info "Clearing existing Dock items..."

dockutil --remove all --no-restart

# ── Apps (add in desired order after Finder) ─────────────────────────────────
dockutil --add /System/Applications/Mission\ Control.app                      --no-restart
dockutil --add /Applications/Google\ Chrome.app                               --no-restart
dockutil --add /System/Applications/Calendar.app                              --no-restart
dockutil --add /System/Applications/Reminders.app                             --no-restart
dockutil --add /System/Applications/Photos.app                                --no-restart
dockutil --add /System/Applications/System\ Settings.app                      --no-restart
dockutil --add /Applications/Visual\ Studio\ Code.app                         --no-restart
dockutil --add /Applications/UTM.app                                          --no-restart
dockutil --add /Applications/iTerm.app                                        --no-restart
# Add more apps here ↓

# ── Right side: Applications folder as a stack ────────────────────────────────
dockutil --add /Applications --view grid --display folder --sort name         --no-restart

info "Restarting Dock..."
killall Dock
ok "Dock configured."
