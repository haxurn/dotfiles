#!/usr/bin/env bash
# Install tmux config, TPM and plugins.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../lib/init.sh
source "$SCRIPT_DIR/../lib/init.sh"

PLUGIN_DIR="$HOME/.config/tmux/plugins"

has git || pkg_install git
has tmux || pkg_install tmux
has tmux || die "tmux could not be installed"

run mkdir -p "$PLUGIN_DIR" "$HOME/.local/share/tmux/resurrect"

if [[ ! -d "$PLUGIN_DIR/tpm" ]]; then
    log_info "cloning TPM"
    run git clone -q --depth=1 https://github.com/tmux-plugins/tpm "$PLUGIN_DIR/tpm"
fi

link_file "$SCRIPT_DIR/tmux.conf" "$HOME/.config/tmux/tmux.conf"
link_dir  "$SCRIPT_DIR/scripts"   "$HOME/.config/tmux/scripts"

# Install plugins headless (idempotent: TPM skips already-cloned plugins).
if [[ -x "$PLUGIN_DIR/tpm/bin/install_plugins" && "${DRY_RUN:-0}" != 1 ]]; then
    if TMUX_PLUGIN_MANAGER_PATH="$PLUGIN_DIR/" "$PLUGIN_DIR/tpm/bin/install_plugins" >/dev/null 2>&1; then
        log_ok "tmux plugins installed"
    else
        log_warn "TPM headless install failed; run prefix + I inside tmux"
    fi
fi

# macOS: Homebrew tmux needs the tmux-256color terminfo entry; ncurses ships a modern one.
if is_macos && ! infocmp tmux-256color >/dev/null 2>&1; then
    log_info "installing tmux-256color terminfo"
    pkg_install ncurses
    t="$(mktemp)"
    if "$(brew_prefix)/opt/ncurses/bin/infocmp" -x tmux-256color > "$t" 2>/dev/null; then
        run tic -x -o "$HOME/.terminfo" "$t"
    else
        log_warn "could not export tmux-256color terminfo; TERM inside tmux may fall back"
    fi
    rm -f "$t"
fi

[[ -d "$HOME/.tmux/plugins" ]] && log_warn "legacy ~/.tmux/plugins exists; plugins now live in $PLUGIN_DIR (safe to delete the old dir)"

log_ok "tmux ready. Reload with prefix + r; prefix + I installs any missing plugins."
