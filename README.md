# dotfiles

macOS dotfiles managed with [chezmoi](https://chezmoi.io) and [age](https://age-encryption.org) encryption.

---

## Setting up a new Mac

### Step 1 — Restore your age key (do this first)

The age key decrypts secrets stored in this repo. Without it, chezmoi will error.

Retrieve `key.txt` from Proton Pass, then:

```sh
mkdir -p ~/.config/chezmoi
nano ~/.config/chezmoi/key.txt   # paste the key contents, save
```

### Step 2 — Run the bootstrap one-liner

```sh
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply yegli
```

This installs chezmoi (no Homebrew needed), clones this repo, prompts for your three email addresses, then applies everything. The scripts run automatically in order:

| Script | What it does | Notes |
|--------|-------------|-------|
| `run_once_01` | Install Homebrew | Will prompt for sudo |
| `run_onchange_02` | `brew bundle` — all CLI tools, casks, VS Code extensions | App Store apps need Step 3 first |
| `run_once_03` | Install oh-my-zsh + plugins | |
| `run_once_04` | Create `~/_code/{private,ost,work}` | |
| `run_once_05` | Generate SSH keys, write `~/.ssh/config` | Prints public keys — see Step 4 |
| `run_once_06` | Install VS Code extensions (fallback list) | Skips if `code` CLI not in PATH yet |
| `run_once_07` | Import GPG keys from encrypted repo | Requires age key from Step 1 |
| `run_onchange_08` | Configure Dock | |
| `run_once_09` | Download and install MacTeX (~4 GB) | Long download — grab a coffee |

### Step 3 — App Store apps (if needed)

The App Store section in the Brewfile is currently commented out. If you uncomment `mas` lines:

1. Sign into the App Store manually
2. Run `make brew-install` to retry

### Step 4 — Add SSH keys to your accounts

After Step 2 finishes, the terminal will have printed three public keys. Add them:

- `~/.ssh/id_ed25519_private.pub` → [github.com](https://github.com) (personal account)
- `~/.ssh/id_ed25519_ost.pub` → OST GitLab
- `~/.ssh/id_ed25519_work.pub` → work GitHub / GitLab

```sh
# Print any key again if you missed it
cat ~/.ssh/id_ed25519_private.pub
```

### Step 5 — Set GPG key trust (if using GPG)

If `run_once_07` imported your GPG keys, set ultimate trust:

```sh
gpg --edit-key BF2588A3D74BD253D35745679CCA22896ED60D92
# type: trust → 5 → y → save
```

### Step 6 — VS Code CLI (if extensions were skipped)

If `code` was not in PATH during bootstrap, install extensions now:

1. Open VS Code
2. Open the command palette (`Cmd+Shift+P`) → **Shell Command: Install 'code' command in PATH**
3. Run `make vscode-extensions`

---

## Git context routing

Repos under `~/_code/<context>/` automatically use the right identity and SSH key:

```
~/_code/private/  →  ~/.gitconfig-private  →  git@github-private:...
~/_code/ost/      →  ~/.gitconfig-ost      →  git@github-ost:...
~/_code/work/     →  ~/.gitconfig-work     →  git@github-work:...
```

Use the SSH host aliases when cloning:

```sh
# personal repo
git clone git@github-private:yegli/repo.git

# instead of the plain
git clone git@github.com:yegli/repo.git
```

---

## Day-to-day workflow

```sh
chezmoi edit ~/.zshrc          # edit a tracked file (auto-commits + pushes)
make add file=~/.zshrc         # start tracking a new plaintext file
make add-encrypted file=~/.foo # start tracking a new secret file
make update                    # pull latest on another machine and apply
make diff                      # preview pending changes before applying
```

---

## First-time setup on a new Mac (age key not yet created)

Only needed if you're starting fresh and have no `key.txt` yet.

```sh
make age-init
```

This generates `~/.config/chezmoi/key.txt` and prints your public key.

1. Copy the public key into `.chezmoi.toml.tmpl` → `recipient = "age1..."`
2. Save the entire `key.txt` to Proton Pass
3. Commit and push `.chezmoi.toml.tmpl`

---

## All Makefile targets

```sh
make help                        # print all targets

# Dotfiles
make apply                       # apply dotfiles now
make update                      # pull from GitHub + apply
make diff                        # preview pending changes
make status                      # show tracked files with changes
make add file=~/.zshrc           # track a plaintext file
make add-encrypted file=~/.foo   # track an age-encrypted file
make edit file=~/.zshrc          # edit a tracked file

# Encryption / GPG
make age-init                    # generate age key (once per machine)
make gpg-export                  # export + encrypt GPG keys into gpg-keys/
make gpg-import                  # decrypt + import GPG keys

# Individual setup steps (run manually if something failed during bootstrap)
make install-homebrew
make brew-install
make brew-dump                   # overwrite Brewfile from currently installed packages
make install-ohmyzsh
make create-folders
make ssh-keygen-all
make vscode-extensions
make mactex-install              # download + install MacTeX (~4 GB)

make setup                       # run all setup steps in order
```
