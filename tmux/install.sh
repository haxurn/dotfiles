#!/bin/bash
# Install tmux plugins (run this after cloning dotfiles)

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PLUGIN_DIR="${HOME}/.tmux/plugins"

link_file() {
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

    ln -sf "$src" "$dest"
}

command -v git >/dev/null || { echo "git is required."; exit 1; }
command -v tmux >/dev/null || echo "tmux is not installed yet; install it with your package manager."

mkdir -p "$PLUGIN_DIR"

# Clone TPM if not exists
if [ ! -d "$PLUGIN_DIR/tpm" ]; then
    git clone --depth=1 https://github.com/tmux-plugins/tpm "$PLUGIN_DIR/tpm"
fi

# Install other plugins
# vim-tmux-navigator
if [ ! -d "$PLUGIN_DIR/vim-tmux-navigator" ]; then
    git clone --depth=1 https://github.com/christoomey/vim-tmux-navigator "$PLUGIN_DIR/vim-tmux-navigator"
fi

# tmux-resurrect
if [ ! -d "$PLUGIN_DIR/tmux-resurrect" ]; then
    git clone --depth=1 https://github.com/tmux-plugins/tmux-resurrect "$PLUGIN_DIR/tmux-resurrect"
fi

# tmux-continuum
if [ ! -d "$PLUGIN_DIR/tmux-continuum" ]; then
    git clone --depth=1 https://github.com/tmux-plugins/tmux-continuum "$PLUGIN_DIR/tmux-continuum"
fi

# tmux-cpu-mem-monitor
if [ ! -d "$PLUGIN_DIR/tmux-cpu-mem-monitor" ]; then
    git clone --depth=1 https://github.com/hendrikmi/tmux-cpu-mem-monitor "$PLUGIN_DIR/tmux-cpu-mem-monitor"
fi

# Create symlink to config
link_file "${SCRIPT_DIR}/tmux.conf" "${HOME}/.config/tmux/tmux.conf"

echo "Tmux plugins installed! Press prefix + I (Ctrl-a then I) to install plugins in tmux."
