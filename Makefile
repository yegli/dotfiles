.PHONY: help apply update diff status add add-encrypted edit \
        age-init gpg-export gpg-import \
        install-homebrew brew-install brew-dump \
        install-ohmyzsh create-folders ssh-keygen-all \
        vscode-extensions mactex-install setup

help:
	@echo "chezmoi"
	@echo "  apply                   apply all dotfiles"
	@echo "  update                  pull latest from GitHub and apply"
	@echo "  diff                    preview pending changes"
	@echo "  status                  show managed files with changes"
	@echo "  add file=<path>         track a plaintext file  (e.g. make add file=~/.zshrc)"
	@echo "  add-encrypted file=<p>  track a file encrypted with age"
	@echo "  edit file=<path>        edit a tracked file     (e.g. make edit file=~/.zshrc)"
	@echo ""
	@echo "age + gpg"
	@echo "  age-init                generate age key (once, on current Mac)"
	@echo "  gpg-export              export + age-encrypt both GPG keys into gpg-keys/"
	@echo "  gpg-import              decrypt + import GPG keys from gpg-keys/"
	@echo ""
	@echo "setup (run individually)"
	@echo "  install-homebrew        install Homebrew"
	@echo "  brew-install            install all packages from Brewfile"
	@echo "  brew-dump               overwrite Brewfile with currently installed packages"
	@echo "  install-ohmyzsh         install oh-my-zsh + plugins"
	@echo "  create-folders          create ~/_code/{private,ost,work}"
	@echo "  ssh-keygen-all          generate SSH keys for all contexts"
	@echo "  vscode-extensions       install VS Code extensions"
	@echo "  mactex-install          download and install MacTeX (~4 GB)"
	@echo ""
	@echo "  setup                   run all setup steps in order"

# ── chezmoi ──────────────────────────────────────────────────────────────────

apply:
	chezmoi apply

update:
	chezmoi update

diff:
	chezmoi diff

status:
	chezmoi status

add:
	@test -n "$(file)" || (echo "Usage: make add file=~/.zshrc" && exit 1)
	chezmoi add $(file)

add-encrypted:
	@test -n "$(file)" || (echo "Usage: make add-encrypted file=~/.ssh/id_ed25519" && exit 1)
	chezmoi add --encrypt $(file)

edit:
	@test -n "$(file)" || (echo "Usage: make edit file=~/.zshrc" && exit 1)
	chezmoi edit $(file)

# ── age encryption ────────────────────────────────────────────────────────────

age-init:
	@mkdir -p ~/.config/chezmoi
	@if [ -f ~/.config/chezmoi/key.txt ]; then \
		echo "age key already exists at ~/.config/chezmoi/key.txt"; \
		echo "Public key:"; \
		grep "^# public key:" ~/.config/chezmoi/key.txt | sed 's/# public key: //'; \
	else \
		age-keygen -o ~/.config/chezmoi/key.txt; \
		echo ""; \
		echo "Key saved to ~/.config/chezmoi/key.txt"; \
		echo ""; \
		echo "Next steps:"; \
		echo "  1. Copy the public key above into .chezmoi.toml.tmpl (recipient = ...)"; \
		echo "  2. Save the PRIVATE key (the entire key.txt) to Proton Pass"; \
		echo "  3. Run: git add .chezmoi.toml.tmpl && git commit && git push"; \
	fi

GPG_KEYS := BF2588A3D74BD253D35745679CCA22896ED60D92 587B0641516FABE626999338E60586625F142A3E
AGE_RECIPIENT := $(shell awk '/public key:/{print $$NF}' ~/.config/chezmoi/key.txt 2>/dev/null)

gpg-export:
	@mkdir -p gpg-keys
	@test -n "$(AGE_RECIPIENT)" || (echo "Run make age-init first" && exit 1)
	@for key in $(GPG_KEYS); do \
		echo "Exporting $$key ..."; \
		gpg --export-secret-keys --armor "$$key" | age -r "$(AGE_RECIPIENT)" > "gpg-keys/$$key.asc.age"; \
		echo "  → gpg-keys/$$key.asc.age"; \
	done
	@echo "Done. Commit gpg-keys/ to the repo."

gpg-import:
	bash run_once_07-gpg-import.sh

# ── setup steps ──────────────────────────────────────────────────────────────

install-homebrew:
	bash run_once_01-install-homebrew.sh

brew-install:
	eval "$$($(brew --prefix)/bin/brew shellenv)" && brew bundle --file=Brewfile

brew-dump:
	brew bundle dump --force --file=Brewfile

install-ohmyzsh:
	bash run_once_03-install-ohmyzsh.sh

create-folders:
	bash run_once_04-create-folders.sh

ssh-keygen-all:
	chezmoi execute-template < run_once_05-ssh-keygen.sh.tmpl | bash

vscode-extensions:
	bash run_once_06-vscode-extensions.sh

mactex-install:
	bash run_once_09-install-mactex.sh

setup: install-homebrew brew-install install-ohmyzsh create-folders ssh-keygen-all vscode-extensions apply
	@echo "Setup complete."
