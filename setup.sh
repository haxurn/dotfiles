#!/bin/bash
# ═══════════════════════════════════════════════════════════════
#  dotfiles - Quick Setup
# ═══════════════════════════════════════════════════════════════

set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME/.dotfiles_backup/$(date +%Y%m%d_%H%M%S)"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}"
echo "╔══════════════════════════════════════════════╗"
echo "║         dotfiles - Quick Setup             ║"
echo "╚══════════════════════════════════════════════╝"
echo -e "${NC}"
echo ""

# Check if running in CI/script mode
if [[ "$1" == "--all" ]]; then
    INSTALL_TMUX=1
    INSTALL_ZSH=1
    INSTALL_NVIM=1
elif [[ "$1" == "--tmux" ]]; then
    INSTALL_TMUX=1
elif [[ "$1" == "--zsh" ]]; then
    INSTALL_ZSH=1
elif [[ "$1" == "--nvim" ]]; then
    INSTALL_NVIM=1
else
    # Interactive mode
    echo -e "${YELLOW}What do you want to install?${NC}"
    echo ""
    echo "  [1] All configs"
    echo "  [2] Tmux only"
    echo "  [3] Zsh only"
    echo "  [4] Neovim only"
    echo "  [5] Tmux + Zsh"
    echo "  [6] Tmux + Neovim"
    echo "  [7] Zsh + Neovim"
    echo ""
    read -p "Select (1-7): " choice
    echo ""

    case $choice in
        1) INSTALL_TMUX=1; INSTALL_ZSH=1; INSTALL_NVIM=1 ;;
        2) INSTALL_TMUX=1 ;;
        3) INSTALL_ZSH=1 ;;
        4) INSTALL_NVIM=1 ;;
        5) INSTALL_TMUX=1; INSTALL_ZSH=1 ;;
        6) INSTALL_TMUX=1; INSTALL_NVIM=1 ;;
        7) INSTALL_ZSH=1; INSTALL_NVIM=1 ;;
        *) echo "Invalid choice"; exit 1 ;;
    esac
fi

# Detect OS
OS="$(uname -s)"
if [[ "$OS" == "Darwin" ]]; then
    PKG_MANAGER="brew"
elif command -v apt &>/dev/null; then
    PKG_MANAGER="apt"
elif command -v pacman &>/dev/null; then
    PKG_MANAGER="pacman"
elif command -v dnf &>/dev/null; then
    PKG_MANAGER="dnf"
elif command -v nix-env &>/dev/null; then
    PKG_MANAGER="nix"
else
    PKG_MANAGER="unknown"
fi

echo -e "${YELLOW}Detected OS: $OS ($PKG_MANAGER)${NC}"
echo ""

# ─── Backup existing configs ───────────────────────────────
backup_config() {
    if [[ -e "$1" ]]; then
        mkdir -p "$BACKUP_DIR"
        echo -e "${YELLOW}Backing up existing: $1${NC}"
        cp -r "$1" "$BACKUP_DIR/"
    fi
}

# ─── Create symlinks ──────────────────────────────────────
link_config() {
    local src="$1"
    local dest="$2"
    local dir=$(dirname "$dest")

    mkdir -p "$dir"
    if [[ -L "$dest" ]]; then
        rm "$dest"
    elif [[ -e "$dest" ]]; then
        backup_config "$dest"
        rm "$dest"
    fi

    ln -sf "$src" "$dest"
    echo -e "${GREEN}Linked: $dest -> $src${NC}"
}

# ─── Install Tmux ─────────────────────────────────────────
install_tmux() {
    echo -e "\n${BLUE}═══ Installing Tmux ═══${NC}\n"

    link_config "$DOTFILES_DIR/tmux/tmux.conf" "$HOME/.config/tmux/tmux.conf"

    # Install TPM
    local tpm_dir="$HOME/.tmux/plugins/tpm"
    if [[ ! -d "$tpm_dir" ]]; then
        echo "Installing TPM..."
        mkdir -p "$(dirname "$tpm_dir")"
        git clone --depth 1 https://github.com/tmux-plugins/tpm "$tpm_dir"
    fi

    echo -e "${GREEN}Tmux installed!${NC}"
    echo "Press Ctrl+a then I in tmux to install plugins."
}

# ─── Install Zsh ─────────────────────────────────────────
install_zsh() {
    echo -e "\n${BLUE}═══ Installing Zsh ═══${NC}\n"

    # Install Oh My Zsh if not present
    if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
        echo "Installing Oh My Zsh..."
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    fi

    # Install Powerlevel10k
    if [[ ! -d "$HOME/.oh-my-zsh/custom/themes/powerlevel10k" ]]; then
        echo "Installing Powerlevel10k..."
        git clone --depth 1 https://github.com/romkatv/powerlevel10k.git "$HOME/.oh-my-zsh/custom/themes/powerlevel10k"
    fi

    # Install plugins
    local plugins=(
        "zsh-completions:https://github.com/zsh-users/zsh-completions.git"
        "zsh-autosuggestions:https://github.com/zsh-users/zsh-autosuggestions.git"
        "zsh-syntax-highlighting:https://github.com/zsh-users/zsh-syntax-highlighting.git"
        "fzf-tab:https://github.com/Aloxaf/fzf-tab.git"
    )

    for plugin_info in "${plugins[@]}"; do
        plugin_name="${plugin_info%%:*}"
        plugin_url="${plugin_info##*:}"
        plugin_path="$HOME/.oh-my-zsh/custom/plugins/$plugin_name"

        if [[ ! -d "$plugin_path" ]]; then
            echo "Installing $plugin_name..."
            git clone --depth 1 "$plugin_url" "$plugin_path"
        fi
    done

    link_config "$DOTFILES_DIR/zsh/.zshrc" "$HOME/.zshrc"

    # Link p10k config
    if [[ -f "$DOTFILES_DIR/zsh/.p10k.zsh" ]]; then
        link_config "$DOTFILES_DIR/zsh/.p10k.zsh" "$HOME/.p10k.zsh"
    fi

    echo -e "${GREEN}Zsh installed!${NC}"
    echo "Restart your terminal or run: source ~/.zshrc"
}

# ─── Install Neovim ───────────────────────────────────────
install_neovim() {
    echo -e "\n${BLUE}═══ Installing Neovim ═══${NC}\n"

    link_config "$DOTFILES_DIR/nvim" "$HOME/.config/nvim"

    echo -e "${GREEN}Neovim installed!${NC}"
    echo "Run 'nvim' and then ':PlugInstall' to install plugins."
}

# ─── Main ────────────────────────────────────────────────
if [[ -z "$INSTALL_TMUX" && -z "$INSTALL_ZSH" && -z "$INSTALL_NVIM" ]]; then
    echo -e "${RED}Nothing selected.${NC}"
    exit 0
fi

# Install selected configs
[[ "$INSTALL_TMUX" == "1" ]] && install_tmux
[[ "$INSTALL_ZSH" == "1" ]] && install_zsh
[[ "$INSTALL_NVIM" == "1" ]] && install_nvim

echo -e "\n${GREEN}╔═══════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║  Setup complete!                           ║${NC}"
echo -e "${GREEN}╚═══════════════════════════════════════════╝${NC}"

if [[ -n "$BACKUP_DIR" && -d "$BACKUP_DIR" ]]; then
    echo -e "\nBackup saved to: $BACKUP_DIR"
fi