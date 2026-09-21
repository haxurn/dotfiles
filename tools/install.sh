#!/usr/bin/env bash
# Install TUI tool configs: lazygit, btop, bat (Gruvbox Dark).
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../lib/init.sh
source "$SCRIPT_DIR/../lib/init.sh"

has btop || pkg_install btop
has bat  || { pkg_install bat; ensure_bin_alias batcat bat; }
ensure_lazygit

# lazygit: whole dir
link_dir "$SCRIPT_DIR/lazygit" "$HOME/.config/lazygit"

# btop rewrites btop.conf on exit -> copy once (gruvbox_dark_v2 ships with btop)
copy_if_missing "$SCRIPT_DIR/btop/btop.conf" "$HOME/.config/btop/btop.conf"

# bat: config only (gruvbox-dark is a built-in theme)
link_file "$SCRIPT_DIR/bat/config" "$HOME/.config/bat/config"

# gdb: GEF loader (~/.gdbinit). Harmless if gdb / GEF are absent.
link_file "$SCRIPT_DIR/gdb/gdbinit" "$HOME/.gdbinit"

log_ok "tools configured (lazygit, btop, bat, gdb)"
