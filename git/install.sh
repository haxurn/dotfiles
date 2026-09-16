#!/usr/bin/env bash
# Install git config: gitconfig, global ignore, delta theme; seed ~/.gitconfig.local.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../lib/init.sh
source "$SCRIPT_DIR/../lib/init.sh"

LOCAL_CFG="$HOME/.gitconfig.local"

has git || pkg_install git
has gh  || pkg_install gh
ensure_delta

# Seed identity before we replace ~/.gitconfig: reuse what the current config has.
if [[ ! -e "$LOCAL_CFG" ]]; then
    name="$(git config --global user.name 2>/dev/null || true)"
    email="$(git config --global user.email 2>/dev/null || true)"
    if [[ -n "$name" && -n "$email" ]]; then
        log_info "seeding $LOCAL_CFG from existing identity ($name <$email>)"
        run cp "$SCRIPT_DIR/gitconfig.local.example" "$LOCAL_CFG"
        run git config -f "$LOCAL_CFG" user.name "$name"
        run git config -f "$LOCAL_CFG" user.email "$email"
    elif [[ -t 0 && "${ASSUME_YES:-0}" != 1 ]]; then
        run cp "$SCRIPT_DIR/gitconfig.local.example" "$LOCAL_CFG"
        read -r -p "git user.name: " name
        read -r -p "git user.email: " email
        [[ -n "$name" ]]  && run git config -f "$LOCAL_CFG" user.name "$name"
        [[ -n "$email" ]] && run git config -f "$LOCAL_CFG" user.email "$email"
    else
        copy_if_missing "$SCRIPT_DIR/gitconfig.local.example" "$LOCAL_CFG"
        log_warn "edit $LOCAL_CFG with your name/email"
    fi
fi

link_file "$SCRIPT_DIR/gitconfig"                  "$HOME/.gitconfig"
link_file "$SCRIPT_DIR/ignore"                     "$HOME/.config/git/ignore"
link_file "$SCRIPT_DIR/delta-catppuccin.gitconfig" "$HOME/.config/git/delta-catppuccin.gitconfig"

log_ok "git ready (identity in $LOCAL_CFG)"
