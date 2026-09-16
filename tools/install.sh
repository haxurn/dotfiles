#!/usr/bin/env bash
# Install TUI tool configs: lazygit, btop, bat (+ Catppuccin Mocha themes).
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../lib/init.sh
source "$SCRIPT_DIR/../lib/init.sh"

has btop || pkg_install btop
has bat  || { pkg_install bat; ensure_bin_alias batcat bat; }
ensure_lazygit

# lazygit: whole dir
link_dir "$SCRIPT_DIR/lazygit" "$HOME/.config/lazygit"

# btop rewrites btop.conf on exit -> copy once; theme file is linked
copy_if_missing "$SCRIPT_DIR/btop/btop.conf" "$HOME/.config/btop/btop.conf"
run mkdir -p "$HOME/.config/btop/themes"
link_file "$SCRIPT_DIR/btop/themes/catppuccin_mocha.theme" "$HOME/.config/btop/themes/catppuccin_mocha.theme"

# bat: config + theme, then rebuild the theme cache
bat_cfg_dir="$HOME/.config/bat"
link_file "$SCRIPT_DIR/bat/config" "$bat_cfg_dir/config"
run mkdir -p "$bat_cfg_dir/themes"
link_file "$SCRIPT_DIR/bat/themes/Catppuccin Mocha.tmTheme" "$bat_cfg_dir/themes/Catppuccin Mocha.tmTheme"
if has bat && [[ "${DRY_RUN:-0}" != 1 ]]; then
    if bat cache --build >/dev/null 2>&1; then log_ok "bat theme cache rebuilt"; else log_warn "bat cache --build failed"; fi
fi

log_ok "tools configured (lazygit, btop, bat)"
