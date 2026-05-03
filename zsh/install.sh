#!/bin/bash
# Install zsh config and dependencies

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ZSH_DIR="$HOME/.oh-my-zsh"
ZSH_CUSTOM="$ZSH_DIR/custom"
LOCAL_BIN="$HOME/.local/bin"

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

install_latest_bat() {
    local tag tmp_dir bat_bin

    tag="$(curl -fsSL https://api.github.com/repos/sharkdp/bat/releases/latest | sed -n 's/.*"tag_name": "\(v[^"]*\)".*/\1/p' | head -n 1)"
    if [ -z "$tag" ]; then
        echo "Could not determine latest bat release tag."
        return 1
    fi

    tmp_dir="$(mktemp -d)"
    trap 'rm -rf "$tmp_dir"; trap - RETURN' RETURN

    curl -fsSL "https://github.com/sharkdp/bat/releases/download/${tag}/bat-${tag}-x86_64-unknown-linux-gnu.tar.gz" \
        | tar xz -C "$tmp_dir"
    bat_bin="$(find "$tmp_dir" -type f -name bat -perm -u+x -print -quit)"
    if [ -z "$bat_bin" ]; then
        echo "bat binary was not found in downloaded archive."
        return 1
    fi

    install -m 0755 "$bat_bin" "$LOCAL_BIN/bat"
    rm -rf "$tmp_dir"
    trap - RETURN
}

install_latest_eza() {
    local tmp_dir eza_bin

    tmp_dir="$(mktemp -d)"
    trap 'rm -rf "$tmp_dir"; trap - RETURN' RETURN

    curl -fsSL https://github.com/eza-community/eza/releases/latest/download/eza_x86_64-unknown-linux-gnu.tar.gz \
        | tar xz -C "$tmp_dir"
    eza_bin="$(find "$tmp_dir" -type f -name eza -perm -u+x -print -quit)"
    if [ -z "$eza_bin" ]; then
        echo "eza binary was not found in downloaded archive."
        return 1
    fi

    install -m 0755 "$eza_bin" "$LOCAL_BIN/eza"
    rm -rf "$tmp_dir"
    trap - RETURN
}

echo "Installing zsh config..."

command -v git >/dev/null || { echo "git is required."; exit 1; }
command -v curl >/dev/null || { echo "curl is required."; exit 1; }
mkdir -p "$LOCAL_BIN"

# Install Oh My Zsh if not present
if [ ! -d "$ZSH_DIR" ]; then
    echo "Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# Install Powerlevel10k
if [ ! -d "$ZSH_CUSTOM/themes/powerlevel10k" ]; then
    echo "Installing Powerlevel10k..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$ZSH_CUSTOM/themes/powerlevel10k"
fi

# Install plugins
plugins=(
    "zsh-completions:https://github.com/zsh-users/zsh-completions.git"
    "zsh-autosuggestions:https://github.com/zsh-users/zsh-autosuggestions.git"
    "zsh-syntax-highlighting:https://github.com/zsh-users/zsh-syntax-highlighting.git"
    "fzf-tab:https://github.com/Aloxaf/fzf-tab.git"
)

for plugin_info in "${plugins[@]}"; do
    plugin_name="${plugin_info%%:*}"
    plugin_url="${plugin_info##*:}"
    
    if [ ! -d "$ZSH_CUSTOM/plugins/$plugin_name" ]; then
        echo "Installing $plugin_name..."
        git clone --depth=1 "$plugin_url" "$ZSH_CUSTOM/plugins/$plugin_name"
    fi
done

# Install fzf
if ! command -v fzf &> /dev/null; then
    echo "Installing fzf..."
    if [ ! -d "$HOME/.fzf" ]; then
        git clone --depth=1 https://github.com/junegunn/fzf.git "$HOME/.fzf"
    fi
    "$HOME/.fzf/install" --all
fi

# Install eza (better ls)
if ! command -v eza &> /dev/null; then
    echo "Installing eza..."
    if command -v nix-env &> /dev/null; then
        nix-env -iA nixpkgs.eza
    else
        install_latest_eza
    fi
fi

# Install bat
if ! command -v bat &> /dev/null; then
    echo "Installing bat..."
    if command -v nix-env &> /dev/null; then
        nix-env -iA nixpkgs.bat
    else
        install_latest_bat
    fi
fi

# Install zoxide
if ! command -v zoxide &> /dev/null; then
    echo "Installing zoxide..."
    curl -sSL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
fi

# Create symlink to .zshrc
echo "Creating symlink to ~/.zshrc..."
link_file "$SCRIPT_DIR/.zshrc" "$HOME/.zshrc"

# Install p10k config (optional - copy if exists)
if [ -f "$HOME/.p10k.zsh" ] && [ ! -f "$SCRIPT_DIR/.p10k.zsh" ]; then
    cp "$HOME/.p10k.zsh" "$SCRIPT_DIR/.p10k.zsh"
    echo "Copied existing .p10k.zsh config"
fi

echo ""
echo "Zsh config installed successfully!"
echo "Run 'source ~/.zshrc' or restart your terminal."
echo ""
echo "Optional: Run 'p10k configure' to customize the Powerlevel10k prompt."
