# dotfiles

macOS dev environment: LazyVim + tmux + zsh (oh-my-zsh + p10k)

## Structure

```
dotfiles/
├── nvim/           # LazyVim config (~/.config/nvim)
├── tmux/           # tmux config (~/.tmux.conf)
├── zsh/            # zshrc + zprofile
├── Brewfile        # brew packages
└── install.sh      # symlink installer
```

## Quick Start

```bash
git clone git@github.com:diasm3/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh
```

## What's Included

### Neovim (LazyVim)

- **Theme**: github_dark
- **Languages**: TypeScript, Python, Rust, Java, Kotlin, Go, SQL, Docker, Terraform, Helm
- **Extras**: Claude Code AI, yanky, dial, dadbod (DB UI), jinja LSP
- **Clipboard**: OSC 52 (works over SSH)
- **Root**: always uses `cwd`

### tmux

- **Prefix**: `Ctrl+a`
- **Split**: `|` horizontal, `-` vertical
- **Mouse**: enabled
- **Clipboard**: OSC 52 passthrough (SSH remote copy)
- **Scratch terminal**: `Ctrl+a t` (popup, session persists)
- **256 color** + undercurl support

### Zsh

- **Framework**: Oh My Zsh
- **Theme**: Powerlevel10k
- **Plugins**: git, zsh-autosuggestions, zsh-syntax-highlighting, zsh-completions

## New Mac Setup

1. Run `install.sh` — installs brew, oh-my-zsh, plugins, symlinks everything
2. Open `nvim` — LazyVim auto-installs plugins
3. Run `p10k configure` — setup Powerlevel10k prompt
4. Restart terminal
