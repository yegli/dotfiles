# dotfiles

Dotfiles and macOS setup managed with [chezmoi](https://chezmoi.io).

## Bootstrap a new Mac (one command)

```sh
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply yegli
```

chezmoi looks for `<github-user>/dotfiles` by default, so the short form works.  
It installs chezmoi, clones this repo, prompts for your emails, and applies everything.  
The `run_once_` scripts then handle the rest automatically.

> **Before running on a new Mac:** restore `~/.config/chezmoi/key.txt` from Proton Pass first
> so chezmoi can decrypt encrypted files.

```sh
mkdir -p ~/.config/chezmoi
# paste key.txt content from Proton Pass, then:
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply yegli
```

## Why public repo + age encryption?

The repo is public so the one-liner bootstrap works without pre-configuring SSH or tokens.
Sensitive files (SSH keys, secrets) are encrypted with [age](https://age-encryption.org) before
being committed — the ciphertext is useless without your private key, which never touches the repo.

## First-time age setup (do this once on your current Mac)

```sh
make age-init
```

This generates `~/.config/chezmoi/key.txt` and prints your public key.

1. Copy the public key into `.chezmoi.toml.tmpl` → `recipient = "age1..."`
2. Save the **entire `key.txt`** to Proton Pass (this is your decryption key)
3. Commit and push the updated `.chezmoi.toml.tmpl`

To encrypt a file before tracking it:

```sh
make add-encrypted file=~/.ssh/id_ed25519
# or directly:
chezmoi add --encrypt ~/.ssh/id_ed25519
```

Encrypted files are stored as `encrypted_<name>.age` in the source directory — safe to commit publicly.

## What gets set up automatically

| Script | What it does |
|---|---|
| `run_once_01` | Install Homebrew |
| `run_once_02` | `brew bundle` — all apps from `Brewfile` |
| `run_once_03` | Install oh-my-zsh + autosuggestions + syntax-highlighting |
| `run_once_04` | Create `~/_code/{private,ost,work}` |
| `run_once_05` | Generate SSH keys per context, write `~/.ssh/config` |
| `run_once_06` | Install VS Code extensions |

## Dotfiles managed

- `~/.zshrc`
- `~/.gitconfig` (with `includeIf` per code folder)
- `~/.gitconfig-private` / `~/.gitconfig-ost` / `~/.gitconfig-work`
- `~/.ssh/id_ed25519_*` (encrypted)

## Git context routing

Repos under `~/_code/<context>/` automatically pick up the right email and SSH key:

```
~/_code/private/  →  ~/.gitconfig-private  →  ~/.ssh/id_ed25519_private
~/_code/ost/      →  ~/.gitconfig-ost      →  ~/.ssh/id_ed25519_ost
~/_code/work/     →  ~/.gitconfig-work     →  ~/.ssh/id_ed25519_work
```

Use the SSH host aliases from `~/.ssh/config` for remote URLs:

```sh
# instead of git@github.com:yegli/repo.git
git clone git@github-private:yegli/repo.git
```

## Auto-commit

`[git] autoCommit = true / autoPush = true` is set in `.chezmoi.toml.tmpl`.  
Every `chezmoi add` or `chezmoi edit` automatically commits and pushes to GitHub.

## Manual Makefile targets

```sh
make help                        # show all targets

# Dotfiles
make apply                       # apply dotfiles
make update                      # pull + apply
make diff                        # preview changes
make status                      # show what changed
make add file=~/.zshrc           # track a plaintext file
make add-encrypted file=~/.foo   # track an age-encrypted file
make edit file=~/.zshrc          # edit a tracked file

# Encryption
make age-init                    # generate age key (once, on current Mac)

# Setup steps (run individually if needed)
make install-homebrew
make brew-install
make brew-dump                   # overwrite Brewfile from current installs
make install-ohmyzsh
make create-folders
make ssh-keygen-all
make vscode-extensions

make setup                       # run everything in order
```

## App Store apps

Installed via `mas` (included in Brewfile). You must be signed into the App Store first.

- Magnet
- WhatsApp
- GoodNotes 5
- Microsoft Outlook

## Day-to-day workflow

```sh
# Edit a dotfile — auto-commits and pushes
chezmoi edit ~/.zshrc

# Track a new plaintext file
make add file=~/.zshrc

# Track a new secret file (SSH key, token, etc.)
make add-encrypted file=~/.ssh/id_ed25519

# Pull latest on another machine
make update
```
