#!/bin/bash
set -e

section() { echo; echo "==> $1"; }
ok()      { echo "    [done] $1"; }
info()    { echo "    --> $1"; }

section "Folder Structure"

for dir in "$HOME/_code/private" "$HOME/_code/ost" "$HOME/_code/work"; do
    mkdir -p "$dir"
    info "Ensured: $dir"
done

ok "Folder structure ready."
