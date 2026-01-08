#!/bin/bash

# Dotfiles Installation Script
# Supports both zsh and fish shells

set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME/.dotfiles_backup/$(date +%Y%m%d_%H%M%S)"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

log_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

backup_if_exists() {
    if [ -e "$1" ] || [ -L "$1" ]; then
        mkdir -p "$BACKUP_DIR"
        mv "$1" "$BACKUP_DIR/"
        log_warn "Backed up existing $1 to $BACKUP_DIR/"
    fi
}

detect_shell() {
    if [ -n "$FISH_VERSION" ]; then
        echo "fish"
    elif [ -n "$ZSH_VERSION" ]; then
        echo "zsh"
    else
        basename "$SHELL"
    fi
}

install_homebrew() {
    if ! command -v brew &> /dev/null; then
        log_info "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    else
        log_success "Homebrew already installed"
    fi
}

install_dependencies() {
    log_info "Installing dependencies via Homebrew..."
    brew install tmux neovim git ripgrep fd lazygit node bun
}

install_tmux() {
    log_info "Installing tmux config..."
    backup_if_exists "$HOME/.tmux.conf"
    ln -sf "$DOTFILES_DIR/tmux/tmux.conf" "$HOME/.tmux.conf"
    log_success "tmux config installed"
}

install_nvim() {
    log_info "Installing nvim config..."
    backup_if_exists "$HOME/.config/nvim"
    mkdir -p "$HOME/.config"
    ln -sf "$DOTFILES_DIR/nvim" "$HOME/.config/nvim"
    log_success "nvim config installed (run nvim to install plugins)"
}

install_zsh() {
    log_info "Installing zsh config..."
    
    # Install Oh My Zsh if not present
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        log_info "Installing Oh My Zsh..."
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    fi
    
    # Install Powerlevel10k
    if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" ]; then
        log_info "Installing Powerlevel10k..."
        git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
    fi
    
    # Install zsh plugins
    ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
    
    if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
        git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
    fi
    
    if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
        git clone https://github.com/zsh-users/zsh-syntax-highlighting "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
    fi
    
    if [ ! -d "$ZSH_CUSTOM/plugins/zsh-completions" ]; then
        git clone https://github.com/zsh-users/zsh-completions "$ZSH_CUSTOM/plugins/zsh-completions"
    fi
    
    # Link configs
    backup_if_exists "$HOME/.zshrc"
    backup_if_exists "$HOME/.p10k.zsh"
    ln -sf "$DOTFILES_DIR/zsh/zshrc" "$HOME/.zshrc"
    ln -sf "$DOTFILES_DIR/zsh/p10k.zsh" "$HOME/.p10k.zsh"
    
    log_success "zsh config installed"
}

install_fish() {
    log_info "Installing fish config..."
    
    # Install fish if not present
    if ! command -v fish &> /dev/null; then
        log_info "Installing fish shell..."
        brew install fish
    fi
    
    # Install Fisher (fish plugin manager)
    if [ ! -f "$HOME/.config/fish/functions/fisher.fish" ]; then
        log_info "Installing Fisher..."
        fish -c "curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher"
    fi
    
    # Create fish config directory
    mkdir -p "$HOME/.config/fish"
    
    # Link fish config if exists
    if [ -f "$DOTFILES_DIR/fish/config.fish" ]; then
        backup_if_exists "$HOME/.config/fish/config.fish"
        ln -sf "$DOTFILES_DIR/fish/config.fish" "$HOME/.config/fish/config.fish"
    fi
    
    # Install tide prompt (similar to powerlevel10k)
    fish -c "fisher install IlanCosman/tide@v6" 2>/dev/null || true
    
    # Install useful fish plugins
    fish -c "fisher install PatrickF1/fzf.fish" 2>/dev/null || true
    fish -c "fisher install jethrokuan/z" 2>/dev/null || true
    
    log_success "fish config installed"
}

install_opencode() {
    log_info "Installing opencode config..."
    mkdir -p "$HOME/.config/opencode"
    
    if [ -f "$DOTFILES_DIR/opencode/opencode.json" ]; then
        backup_if_exists "$HOME/.config/opencode/opencode.json"
        cp "$DOTFILES_DIR/opencode/opencode.json" "$HOME/.config/opencode/opencode.json"
        log_warn "opencode.json copied - remember to update API keys!"
    fi
    
    if [ -f "$DOTFILES_DIR/opencode/oh-my-opencode.json" ]; then
        backup_if_exists "$HOME/.config/opencode/oh-my-opencode.json"
        ln -sf "$DOTFILES_DIR/opencode/oh-my-opencode.json" "$HOME/.config/opencode/oh-my-opencode.json"
    fi
    
    # Install opencode if not present
    if ! command -v opencode &> /dev/null; then
        log_info "Installing opencode..."
        curl -fsSL https://opencode.ai/install | bash
    fi
    
    log_success "opencode config installed"
}

install_fonts() {
    log_info "Installing fonts..."
    
    # Determine font directory based on OS
    if [[ "$OSTYPE" == "darwin"* ]]; then
        FONT_DIR="$HOME/Library/Fonts"
    else
        FONT_DIR="$HOME/.local/share/fonts"
    fi
    
    mkdir -p "$FONT_DIR"
    
    if [ -d "$DOTFILES_DIR/fonts" ]; then
        cp "$DOTFILES_DIR/fonts/"*.ttf "$FONT_DIR/" 2>/dev/null || true
        cp "$DOTFILES_DIR/fonts/"*.ttc "$FONT_DIR/" 2>/dev/null || true
        
        # Refresh font cache on Linux
        if [[ "$OSTYPE" != "darwin"* ]]; then
            fc-cache -fv
        fi
        
        log_success "Fonts installed to $FONT_DIR"
    else
        log_warn "No fonts directory found"
    fi
}

show_usage() {
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  --all         Install everything"
    echo "  --zsh         Install zsh configuration"
    echo "  --fish        Install fish configuration"
    echo "  --tmux        Install tmux configuration"
    echo "  --nvim        Install neovim configuration"
    echo "  --opencode    Install opencode configuration"
    echo "  --fonts       Install fonts"
    echo "  --deps        Install dependencies (brew, etc.)"
    echo "  --help        Show this help message"
    echo ""
    echo "Example:"
    echo "  $0 --all              # Install everything with zsh"
    echo "  $0 --fish --tmux      # Install fish and tmux only"
}

main() {
    if [ $# -eq 0 ]; then
        show_usage
        exit 0
    fi
    
    local install_all=false
    local install_zsh_flag=false
    local install_fish_flag=false
    local install_tmux_flag=false
    local install_nvim_flag=false
    local install_opencode_flag=false
    local install_fonts_flag=false
    local install_deps_flag=false
    
    while [[ $# -gt 0 ]]; do
        case $1 in
            --all)
                install_all=true
                shift
                ;;
            --zsh)
                install_zsh_flag=true
                shift
                ;;
            --fish)
                install_fish_flag=true
                shift
                ;;
            --tmux)
                install_tmux_flag=true
                shift
                ;;
            --nvim)
                install_nvim_flag=true
                shift
                ;;
            --opencode)
                install_opencode_flag=true
                shift
                ;;
            --fonts)
                install_fonts_flag=true
                shift
                ;;
            --deps)
                install_deps_flag=true
                shift
                ;;
            --help)
                show_usage
                exit 0
                ;;
            *)
                log_error "Unknown option: $1"
                show_usage
                exit 1
                ;;
        esac
    done
    
    echo ""
    echo "╔══════════════════════════════════════╗"
    echo "║       Dotfiles Installation          ║"
    echo "╚══════════════════════════════════════╝"
    echo ""
    
    if $install_all || $install_deps_flag; then
        install_homebrew
        install_dependencies
    fi
    
    if $install_all || $install_fonts_flag; then
        install_fonts
    fi
    
    if $install_all || $install_tmux_flag; then
        install_tmux
    fi
    
    if $install_all || $install_nvim_flag; then
        install_nvim
    fi
    
    if $install_all || $install_zsh_flag; then
        install_zsh
    fi
    
    if $install_fish_flag; then
        install_fish
    fi
    
    if $install_all || $install_opencode_flag; then
        install_opencode
    fi
    
    echo ""
    log_success "Installation complete!"
    echo ""
    echo "Next steps:"
    echo "  1. Restart your terminal"
    echo "  2. Run 'nvim' to install plugins"
    echo "  3. Update API keys in ~/.config/opencode/opencode.json"
    if $install_zsh_flag || $install_all; then
        echo "  4. Run 'p10k configure' to customize your prompt"
    fi
    if $install_fish_flag; then
        echo "  4. Run 'tide configure' to customize fish prompt"
    fi
}

main "$@"
