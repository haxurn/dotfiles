#!/usr/bin/env bash
# Install zsh config: oh-my-zsh, powerlevel10k, plugins, symlinks.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../lib/init.sh
source "$SCRIPT_DIR/../lib/init.sh"

ZSH_DIR="$HOME/.oh-my-zsh"
ZSH_CUSTOM="$ZSH_DIR/custom"

has zsh || pkg_install zsh
require git curl zsh

# Oh My Zsh (unattended, keep our .zshrc, don't switch shell here)
if [[ ! -d "$ZSH_DIR" ]]; then
    log_info "installing Oh My Zsh"
    run env KEEP_ZSHRC=yes RUNZSH=no CHSH=no \
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

clone_if_missing() {   # clone_if_missing <url> <dest>
    if [[ -d "$2" ]]; then log_ok "present: $(basename "$2")"; return 0; fi
    log_info "cloning $(basename "$2")"
    run git clone -q --depth=1 "$1" "$2"
}

clone_if_missing https://github.com/romkatv/powerlevel10k.git            "$ZSH_CUSTOM/themes/powerlevel10k"
clone_if_missing https://github.com/zsh-users/zsh-completions.git         "$ZSH_CUSTOM/plugins/zsh-completions"
clone_if_missing https://github.com/zsh-users/zsh-autosuggestions.git     "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
clone_if_missing https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
clone_if_missing https://github.com/Aloxaf/fzf-tab.git                    "$ZSH_CUSTOM/plugins/fzf-tab"

# CLI tools (no-ops when already present; setup.sh normally installs these via manifests)
has fzf    || pkg_install fzf
ensure_fzf
has eza    || ensure_eza
has bat    || { pkg_install bat; ensure_bin_alias batcat bat; }
has fd     || { pkg_install fd;  ensure_bin_alias fdfind fd; }
has zoxide || ensure_zoxide
ensure_fzf_git

link_file "$SCRIPT_DIR/.zshrc"    "$HOME/.zshrc"
link_file "$SCRIPT_DIR/.p10k.zsh" "$HOME/.p10k.zsh"
copy_if_missing "$SCRIPT_DIR/zshrc.local.example" "$HOME/.zshrc.local"

log_ok "zsh ready. Run 'exec zsh'. Machine-specific config: ~/.zshrc.local"
