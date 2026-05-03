#!/bin/bash
# Install neovim config and dependencies

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
NVIM_DIR="$HOME/.config/nvim"

link_dir() {
    local src="$1"
    local dest="$2"
    local backup_dir

    mkdir -p "$(dirname "$dest")"
    if [ -L "$dest" ] && [ "$(readlink "$dest")" = "$src" ]; then
        echo "Already linked: $dest -> $src"
        return
    fi

    if [ -e "$dest" ] || [ -L "$dest" ]; then
        backup_dir="$HOME/.dotfiles_backup/$(date +%Y%m%d_%H%M%S)"
        mkdir -p "$backup_dir"
        mv "$dest" "$backup_dir/$(basename "$dest")"
        echo "Backed up existing config to $backup_dir/$(basename "$dest")"
    fi

    ln -sfn "$src" "$dest"
}

echo "Installing neovim config..."

# Install neovim if not present
if ! command -v nvim &> /dev/null; then
    echo "Neovim not found. Please install it first."
    exit 1
fi

# Install curl if not present (needed for vim-plug)
if ! command -v curl &> /dev/null; then
    echo "curl is required for vim-plug bootstrap. Please install curl first."
    exit 1
fi

# Create symlink to config
echo "Creating symlink to ~/.config/nvim..."
link_dir "$SCRIPT_DIR" "$NVIM_DIR"

echo ""
echo "Neovim config installed!"
echo "Run 'nvim' and then ':PlugInstall' to install plugins."
echo "Or restart neovim and plugins will auto-install on first run."
