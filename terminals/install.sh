#!/usr/bin/env bash
# Install terminal emulator configs (kitty / ghostty / alacritty) + Nerd Font on Linux.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../lib/init.sh
source "$SCRIPT_DIR/../lib/init.sh"

ensure_nerd_font

# Whole dirs are linked so theme edits from inside the app land in the repo.
link_dir "$SCRIPT_DIR/kitty"     "$HOME/.config/kitty"
link_dir "$SCRIPT_DIR/ghostty"   "$HOME/.config/ghostty"
link_dir "$SCRIPT_DIR/alacritty" "$HOME/.config/alacritty"

for t in kitty ghostty alacritty; do
    has "$t" || log_warn "$t not installed (config linked anyway). macOS: brew bundle --file=packages/Brewfile.terminals"
done
log_ok "terminal configs linked"
