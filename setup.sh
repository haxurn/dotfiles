#!/bin/bash
# ═══════════════════════════════════════════════════════════════
#  dotfiles - Quick Setup
# ═══════════════════════════════════════════════════════════════

set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INSTALL_TMUX=0
INSTALL_ZSH=0
INSTALL_NVIM=0

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
if [[ "${1:-}" == "--all" ]]; then
    INSTALL_TMUX=1
    INSTALL_ZSH=1
    INSTALL_NVIM=1
elif [[ "${1:-}" == "--tmux" ]]; then
    INSTALL_TMUX=1
elif [[ "${1:-}" == "--zsh" ]]; then
    INSTALL_ZSH=1
elif [[ "${1:-}" == "--nvim" ]]; then
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

# ─── Install Tmux ─────────────────────────────────────────
install_tmux() {
    echo -e "\n${BLUE}═══ Installing Tmux ═══${NC}\n"

    bash "$DOTFILES_DIR/tmux/install.sh"
}

# ─── Install Zsh ─────────────────────────────────────────
install_zsh() {
    echo -e "\n${BLUE}═══ Installing Zsh ═══${NC}\n"

    bash "$DOTFILES_DIR/zsh/install.sh"
}

# ─── Install Neovim ───────────────────────────────────────
install_neovim() {
    echo -e "\n${BLUE}═══ Installing Neovim ═══${NC}\n"

    bash "$DOTFILES_DIR/nvim/install.sh"
}

# ─── Main ────────────────────────────────────────────────
if [[ "$INSTALL_TMUX" == "0" && "$INSTALL_ZSH" == "0" && "$INSTALL_NVIM" == "0" ]]; then
    echo -e "${RED}Nothing selected.${NC}"
    exit 0
fi

# Install selected configs
[[ "$INSTALL_TMUX" == "1" ]] && install_tmux
[[ "$INSTALL_ZSH" == "1" ]] && install_zsh
[[ "$INSTALL_NVIM" == "1" ]] && install_neovim

echo -e "\n${GREEN}╔═══════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║  Setup complete!                           ║${NC}"
echo -e "${GREEN}╚═══════════════════════════════════════════╝${NC}"
