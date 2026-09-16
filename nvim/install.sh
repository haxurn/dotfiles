#!/usr/bin/env bash
# Install neovim config (+ neovim / tree-sitter CLI when missing or too old).
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../lib/init.sh
source "$SCRIPT_DIR/../lib/init.sh"

NVIM_DIR="$HOME/.config/nvim"

require git curl
ensure_neovim
nvim_is_recent || die "neovim >= 0.11 is required (found: $(nvim --version 2>/dev/null | head -n1 || echo none))"
ensure_tree_sitter
has unzip || pkg_install unzip
has npm   || pkg_install node

# Whole config dir is the symlink; an existing clone is moved to the backup dir intact.
link_dir "$SCRIPT_DIR" "$NVIM_DIR"

if [[ "${DRY_RUN:-0}" != 1 ]] && confirm "Install neovim plugins headless now?" y; then
    if nvim --headless "+PlugInstall --sync" +qa >/dev/null 2>&1; then
        log_ok "plugins installed"
    else
        log_warn "headless PlugInstall failed; plugins will install on first launch"
    fi
fi

log_ok "neovim ready. First launch installs LSP servers via mason (watch :Mason)."
