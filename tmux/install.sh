#!/bin/bash
# Install tmux plugins (run this after cloning dotfiles)

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PLUGIN_DIR="${HOME}/.tmux/plugins"

# Clone TPM if not exists
if [ ! -d "$PLUGIN_DIR/tpm" ]; then
    git clone https://github.com/tmux-plugins/tpm "$PLUGIN_DIR/tpm"
fi

# Install other plugins
mkdir -p "$PLUGIN_DIR"

# vim-tmux-navigator
if [ ! -d "$PLUGIN_DIR/vim-tmux-navigator" ]; then
    git clone https://github.com/christoomey/vim-tmux-navigator "$PLUGIN_DIR/vim-tmux-navigator"
fi

# tmux-resurrect
if [ ! -d "$PLUGIN_DIR/tmux-resurrect" ]; then
    git clone https://github.com/tmux-plugins/tmux-resurrect "$PLUGIN_DIR/tmux-resurrect"
fi

# tmux-continuum
if [ ! -d "$PLUGIN_DIR/tmux-continuum" ]; then
    git clone https://github.com/tmux-plugins/tmux-continuum "$PLUGIN_DIR/tmux-continuum"
fi

# tmux-cpu-mem-monitor
if [ ! -d "$PLUGIN_DIR/tmux-cpu-mem-monitor" ]; then
    git clone https://github.com/hendrikmi/tmux-cpu-mem-monitor "$PLUGIN_DIR/tmux-cpu-mem-monitor"
fi

# Create symlink to config
mkdir -p "${HOME}/.config/tmux"
ln -sf "${SCRIPT_DIR}/tmux.conf" "${HOME}/.config/tmux/tmux.conf"

echo "Tmux plugins installed! Press prefix + I (Ctrl-a then I) to install plugins in tmux."
