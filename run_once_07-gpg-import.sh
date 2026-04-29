#!/bin/bash
set -e

# Imports GPG private keys from age-encrypted exports in the chezmoi source dir.
# To prepare: gpg --export-secret-keys --armor KEY_ID | age -r AGE_PUBLIC_KEY > private-KEY_ID.asc.age
# Then: chezmoi add --encrypt private-KEY_ID.asc.age  (or commit directly)

section() { echo; echo "==> $1"; }
ok()      { echo "    [done] $1"; }
skip()    { echo "    [skip] $1"; }
info()    { echo "    --> $1"; }
warn()    { echo "    [warn] $1"; }

section "GPG Key Import"

KEYS_DIR="$CHEZMOI_SOURCE_DIR/gpg-keys"

if [[ ! -d "$KEYS_DIR" ]]; then
    skip "No gpg-keys/ directory found in chezmoi source."
    exit 0
fi

AGE_KEY="$HOME/.config/chezmoi/key.txt"
if [[ ! -f "$AGE_KEY" ]]; then
    warn "Age key not found at $AGE_KEY — cannot decrypt GPG keys."
    info "Run 'make age-init' or restore key.txt from your password manager first."
    exit 1
fi

count=0
for encrypted_key in "$KEYS_DIR"/*.asc.age; do
    [[ -f "$encrypted_key" ]] || continue
    info "Decrypting and importing: $(basename "$encrypted_key")..."
    age -d -i "$AGE_KEY" "$encrypted_key" | gpg --import
    count=$((count + 1))
done

if [[ $count -eq 0 ]]; then
    skip "No .asc.age key files found in $KEYS_DIR."
    exit 0
fi

ok "$count GPG key(s) imported."
warn "Trust levels may need to be set manually:"
info "  gpg --edit-key KEY_ID  then type: trust → 5 (ultimate) → save"
