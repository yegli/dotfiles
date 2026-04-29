#!/bin/bash
set -e

# Imports GPG private keys from age-encrypted exports in the chezmoi source dir.
# To prepare: gpg --export-secret-keys --armor KEY_ID | age -r AGE_PUBLIC_KEY > private-KEY_ID.asc.age
# Then: chezmoi add --encrypt private-KEY_ID.asc.age  (or commit directly)

KEYS_DIR="$CHEZMOI_SOURCE_DIR/gpg-keys"

if [[ ! -d "$KEYS_DIR" ]]; then
    echo "No gpg-keys/ directory found in chezmoi source, skipping GPG import."
    exit 0
fi

for encrypted_key in "$KEYS_DIR"/*.asc.age; do
    [[ -f "$encrypted_key" ]] || continue
    echo "Importing GPG key from $encrypted_key ..."
    age -d -i ~/.config/chezmoi/key.txt "$encrypted_key" | gpg --import
done

echo "GPG keys imported. Trust levels may need to be set manually:"
echo "  gpg --edit-key KEY_ID  →  trust  →  5 (ultimate)"
