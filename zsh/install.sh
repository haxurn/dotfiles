#!/bin/bash
# Install zsh config and dependencies

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ZSH_DIR="$HOME/.oh-my-zsh"
ZSH_CUSTOM="$ZSH_DIR/custom"
DOTFILES_DIR="$(dirname "$SCRIPT_DIR")"

echo "Installing zsh config..."

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
    git clone --depth=1 https://github.com/junegunn/fzf.git ~/.fzf
    ~/.fzf/install --all
fi

# Install eza (better ls)
if ! command -v eza &> /dev/null; then
    echo "Installing eza..."
    mkdir -p ~/tools
    cd ~/tools
    if command -v nix-env &> /dev/null; then
        nix-env -iA nixpkgs.eza
    else
        curl -sSL https://github.com/eza-community/eza/releases/latest/download/eza_x86_64-unknown-linux-gnu.tar.gz | tar xz
        mv eza ~/.local/bin/
    fi
    cd - > /dev/null
fi

# Install bat
if ! command -v bat &> /dev/null; then
    echo "Installing bat..."
    if command -v nix-env &> /dev/null; then
        nix-env -iA nixpkgs.bat
    else
        mkdir -p ~/tools
        cd ~/tools
        curl -sSL https://github.com/sharkdp/bat/releases/latest/download/bat-x86_64-unknown-linux-gnu.tar.gz | tar xz
        mv bat ~/.local/bin/
        cd - > /dev/null
    fi
fi

# Install zoxide
if ! command -v zoxide &> /dev/null; then
    echo "Installing zoxide..."
    curl -sSL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
fi

# Create symlink to .zshrc
echo "Creating symlink to ~/.zshrc..."
ln -sf "$SCRIPT_DIR/.zshrc" "$HOME/.zshrc"

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