#!/usr/bin/env bash
# lib/init.sh - single entry point: source every helper and detect the OS.
# Usage (from any */install.sh):  source "$SCRIPT_DIR/../lib/init.sh"
[[ -n "${_DOT_INIT_LOADED:-}" ]] && return 0
_DOT_INIT_LOADED=1

_LIB_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="${DOTFILES_DIR:-$(dirname "$_LIB_DIR")}"
export DOTFILES_DIR

# shellcheck source=lib/log.sh
source "$_LIB_DIR/log.sh"
# shellcheck source=lib/os.sh
source "$_LIB_DIR/os.sh"
# shellcheck source=lib/link.sh
source "$_LIB_DIR/link.sh"
# shellcheck source=lib/pkg.sh
source "$_LIB_DIR/pkg.sh"
# shellcheck source=lib/fallback.sh
source "$_LIB_DIR/fallback.sh"

detect_os
mkdir -p "$HOME/.local/bin"
# Fallback installers put binaries here; make them visible to `has` within this run.
case ":$PATH:" in *":$HOME/.local/bin:"*) ;; *) PATH="$HOME/.local/bin:$PATH"; export PATH ;; esac
