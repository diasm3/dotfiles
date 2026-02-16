#!/bin/bash
set -e

DOTFILES="$(cd "$(dirname "$0")" && pwd)"

echo "=== Dotfiles Installer ==="
echo "Source: $DOTFILES"
echo ""

# --- Homebrew ---
if ! command -v brew &>/dev/null; then
  echo "[1/5] Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/opt/homebrew/bin/brew shellenv)"
else
  echo "[1/5] Homebrew already installed"
fi

# --- Brew packages ---
echo "[2/5] Installing brew packages..."
brew bundle --file="$DOTFILES/Brewfile" --no-lock

# --- Oh My Zsh ---
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "[3/5] Installing Oh My Zsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
  echo "[3/5] Oh My Zsh already installed"
fi

# Zsh plugins
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
[ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ] && \
  git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
[ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ] && \
  git clone https://github.com/zsh-users/zsh-syntax-highlighting "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
[ ! -d "$ZSH_CUSTOM/plugins/zsh-completions" ] && \
  git clone https://github.com/zsh-users/zsh-completions "$ZSH_CUSTOM/plugins/zsh-completions"

# Powerlevel10k
[ ! -d "$ZSH_CUSTOM/themes/powerlevel10k" ] && \
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$ZSH_CUSTOM/themes/powerlevel10k"

# --- Symlinks ---
echo "[4/5] Creating symlinks..."

link() {
  local src="$1" dst="$2"
  if [ -e "$dst" ] || [ -L "$dst" ]; then
    echo "  backup: $dst -> ${dst}.bak"
    mv "$dst" "${dst}.bak"
  fi
  ln -sf "$src" "$dst"
  echo "  linked: $src -> $dst"
}

# Neovim
mkdir -p "$HOME/.config"
link "$DOTFILES/nvim" "$HOME/.config/nvim"

# Tmux
link "$DOTFILES/tmux/.tmux.conf" "$HOME/.tmux.conf"

# Zsh
link "$DOTFILES/zsh/.zshrc" "$HOME/.zshrc"
link "$DOTFILES/zsh/.zprofile" "$HOME/.zprofile"

# --- Post-install ---
echo "[5/5] Post-install..."
echo "  Run 'nvim' to let LazyVim install plugins automatically."
echo "  Run 'p10k configure' to setup Powerlevel10k theme."
echo ""
echo "=== Done! Restart your terminal. ==="
