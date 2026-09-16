#!/usr/bin/env bash
# ═══════════════════════════════════════════════════════════════
#  dotfiles - cross-platform setup (macOS + Linux)
# ═══════════════════════════════════════════════════════════════
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export DOTFILES_DIR
# shellcheck source=lib/init.sh
source "$DOTFILES_DIR/lib/init.sh"

SEL_TMUX=0 SEL_ZSH=0 SEL_NVIM=0 SEL_GIT=0 SEL_TERMINALS=0 SEL_TOOLS=0 SEL_VSCODE=0
MODE=normal   # normal | packages-only | no-packages
DRY_RUN="${DRY_RUN:-0}"
ASSUME_YES="${ASSUME_YES:-0}"

usage() {
    cat <<USAGE
Usage: ./setup.sh [components] [options]

Components:
  --all            everything below
  --tmux           tmux config + TPM plugins
  --zsh            zsh, oh-my-zsh, powerlevel10k, plugins
  --nvim           neovim config (+ neovim/tree-sitter if missing)
  --git            gitconfig, global ignore, delta
  --terminals      kitty, ghostty, alacritty configs (+ Nerd Font)
  --tools          lazygit, btop, bat configs
  --vscode         VS Code settings.json

Options:
  --packages-only  install packages from packages/ manifests, link nothing
  --no-packages    link/configure only, skip package installs
  --dry-run        print every mutating action, change nothing
  -y, --yes        assume yes for prompts (implied when stdin is not a tty)
  -h, --help       this help

No component flags + interactive terminal -> menu.
USAGE
}

select_all() { SEL_TMUX=1 SEL_ZSH=1 SEL_NVIM=1 SEL_GIT=1 SEL_TERMINALS=1 SEL_TOOLS=1 SEL_VSCODE=1; }
any_selected() { (( SEL_TMUX + SEL_ZSH + SEL_NVIM + SEL_GIT + SEL_TERMINALS + SEL_TOOLS + SEL_VSCODE > 0 )); }

parse_args() {
    while (( $# )); do
        case "$1" in
            --all)           select_all ;;
            --tmux)          SEL_TMUX=1 ;;
            --zsh)           SEL_ZSH=1 ;;
            --nvim)          SEL_NVIM=1 ;;
            --git)           SEL_GIT=1 ;;
            --terminals)     SEL_TERMINALS=1 ;;
            --tools)         SEL_TOOLS=1 ;;
            --vscode)        SEL_VSCODE=1 ;;
            --packages-only) MODE=packages-only ;;
            --no-packages)   MODE=no-packages ;;
            --dry-run)       DRY_RUN=1 ;;
            -y|--yes)        ASSUME_YES=1 ;;
            -h|--help)       usage; exit 0 ;;
            *)               log_error "unknown option: $1"; usage; exit 2 ;;
        esac
        shift
    done
    export DRY_RUN ASSUME_YES
}

menu() {
    local choice
    printf '%sWhat do you want to install?%s\n\n' "$C_YELLOW" "$C_RESET"
    cat <<'MENU'
  [1] Everything
  [2] Shell core   (tmux + zsh + nvim)
  [3] Tmux only
  [4] Zsh only
  [5] Neovim only
  [6] Git only
  [7] Terminals    (kitty / ghostty / alacritty)
  [8] Tools        (lazygit / btop / bat)
  [9] Packages only (no linking)

MENU
    read -r -p "Select (1-9): " choice
    echo
    case "$choice" in
        1) select_all ;;
        2) SEL_TMUX=1 SEL_ZSH=1 SEL_NVIM=1 ;;
        3) SEL_TMUX=1 ;;
        4) SEL_ZSH=1 ;;
        5) SEL_NVIM=1 ;;
        6) SEL_GIT=1 ;;
        7) SEL_TERMINALS=1 ;;
        8) SEL_TOOLS=1 ;;
        9) select_all; MODE=packages-only ;;
        *) die "Invalid choice" ;;
    esac
}

banner() {
    printf '%s' "$C_BLUE"
    echo "╔══════════════════════════════════════════════╗"
    echo "║              dotfiles - setup                ║"
    echo "╚══════════════════════════════════════════════╝"
    printf '%s\n' "$C_RESET"
    log_info "Detected: $DOT_OS $DOT_ARCH ($DOT_DISTRO, pkg=$DOT_PKG)"
    [[ "$DRY_RUN" == 1 ]] && log_warn "DRY RUN: nothing will be changed"
    echo
}

bootstrap_macos() {
    is_macos || return 0
    if ! xcode-select -p >/dev/null 2>&1; then
        if confirm "Xcode Command Line Tools missing. Install now?" y; then
            run xcode-select --install
            if [[ "$DRY_RUN" != 1 ]]; then
                log_info "waiting for Command Line Tools installer to finish..."
                until xcode-select -p >/dev/null 2>&1; do sleep 10; done
            fi
        else
            die "Command Line Tools are required (git, compilers)."
        fi
    fi
    if [[ ! -x "$(brew_prefix)/bin/brew" ]]; then
        confirm "Homebrew not found. Install it with the official installer?" y \
            || die "Homebrew is required on macOS."
        run /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
    load_brew_env
}

bootstrap_linux() {
    is_linux || return 0
    if [[ -n "$SUDO" && "$DRY_RUN" != 1 ]]; then
        has sudo || die "sudo is required to install packages (or run as root)."
        sudo -v
    fi
}

install_packages() {
    log_step "Packages ($DOT_PKG)"
    if [[ "$DOT_PKG" == brew ]]; then
        brew_bundle "$(manifest_for)"
        (( SEL_TERMINALS )) && brew_bundle "$(manifest_for terminals)"
    else
        pkg_install_manifest "$(manifest_for)"
        (( SEL_TERMINALS )) && pkg_install_manifest "$(manifest_for terminals)"
    fi
    # Component-scoped fallbacks for what the manager lacks / ships too old.
    if (( SEL_ZSH )); then
        ensure_eza; ensure_zoxide
        ensure_bin_alias batcat bat
        ensure_bin_alias fdfind fd
        ensure_fzf_git
    fi
    if (( SEL_NVIM )); then ensure_neovim; ensure_tree_sitter; fi
    if (( SEL_GIT )); then ensure_delta; fi
    if (( SEL_TOOLS )); then ensure_lazygit; fi
    if (( SEL_TERMINALS )); then
        ensure_nerd_font
        if is_linux && ! has ghostty && has snap; then
            confirm "Install ghostty via snap (--classic)?" n && run $SUDO snap install ghostty --classic
        fi
    fi
}

run_component() {
    local name="$1"
    log_step "Installing $name"
    bash "$DOTFILES_DIR/$name/install.sh"
}

install_vscode() {
    log_step "Installing vscode settings"
    local dest
    if is_macos; then
        dest="$HOME/Library/Application Support/Code/User/settings.json"
    else
        dest="$HOME/.config/Code/User/settings.json"
    fi
    if [[ -d "$(dirname "$dest")" ]]; then
        link_file "$DOTFILES_DIR/vscode/settings.json" "$dest"
    else
        log_warn "VS Code user dir not found ($(dirname "$dest")); skipping. Link vscode/settings.json manually."
    fi
}

ensure_login_shell_zsh() {
    is_linux || return 0
    local zsh_path
    zsh_path="$(command -v zsh || true)"
    [[ -n "$zsh_path" ]] || return 0
    [[ "${SHELL:-}" == "$zsh_path" ]] && return 0
    if grep -qx "$zsh_path" /etc/shells 2>/dev/null && confirm "Set $zsh_path as your login shell?" y; then
        run chsh -s "$zsh_path"
    fi
}

summary() {
    echo
    printf '%s╔═══════════════════════════════════════════╗%s\n' "$C_GREEN" "$C_RESET"
    printf '%s║  Setup complete!                          ║%s\n' "$C_GREEN" "$C_RESET"
    printf '%s╚═══════════════════════════════════════════╝%s\n' "$C_GREEN" "$C_RESET"
    [[ -d "$DOT_BACKUP_DIR" ]] && log_info "previous configs backed up in $DOT_BACKUP_DIR"
    echo
    echo "Next steps:"
    (( SEL_ZSH ))  && echo "  - exec zsh                 (new shell; edit ~/.zshrc.local for machine-specific bits)"
    (( SEL_TMUX )) && echo "  - tmux, then prefix + I    (Ctrl-a I installs plugins if any are missing)"
    (( SEL_NVIM )) && echo "  - nvim                     (plugins + LSP servers install on first launch)"
    (( SEL_GIT ))  && echo "  - check ~/.gitconfig.local (name/email live there, not in the repo)"
    return 0
}

main() {
    parse_args "$@"
    banner
    if ! any_selected; then
        if [[ -t 0 ]]; then menu; else usage; exit 2; fi
    fi
    any_selected || die "Nothing selected."

    if [[ "$MODE" != no-packages ]]; then
        bootstrap_macos
        bootstrap_linux
        install_packages
        [[ "$MODE" == packages-only ]] && { log_ok "packages installed"; exit 0; }
    fi

    (( SEL_GIT ))       && run_component git
    (( SEL_ZSH ))       && run_component zsh
    (( SEL_TMUX ))      && run_component tmux
    (( SEL_NVIM ))      && run_component nvim
    (( SEL_TOOLS ))     && run_component tools
    (( SEL_TERMINALS )) && run_component terminals
    (( SEL_VSCODE ))    && install_vscode
    (( SEL_ZSH ))       && ensure_login_shell_zsh
    summary
}

main "$@"
