#!/bin/bash
# Install neovim config and dependencies

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
NVIM_DIR="$HOME/.config/nvim"
DOTFILES_DIR="$(dirname "$SCRIPT_DIR")"

echo "Installing neovim config..."

# Install neovim if not present
if ! command -v nvim &> /dev/null; then
    echo "Neovim not found. Please install it first."
    exit 1
fi

# Install curl if not present (needed for vim-plug)
if ! command -v curl &> /dev/null; then
    echo "Installing curl..."
    if command -v nix-env &> /dev/null; then
        nix-env -iA nixpkgs.curl
    fi
fi

# Create symlink to config
echo "Creating symlink to ~/.config/nvim..."
mkdir -p "$(dirname "$NVIM_DIR")"
ln -sf "$SCRIPT_DIR" "$NVIM_DIR"

echo ""
echo "Neovim config installed!"
echo "Run 'nvim' and then ':PlugInstall' to install plugins."
echo "Or restart neovim and plugins will auto-install on first run."