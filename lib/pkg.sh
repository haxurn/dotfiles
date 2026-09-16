#!/usr/bin/env bash
# lib/pkg.sh - package-manager abstraction (brew/apt/pacman/dnf). bash 3.2 safe.
[[ -n "${_DOT_PKG_LOADED:-}" ]] && return 0
_DOT_PKG_LOADED=1

# pkg_name <generic>: manager-specific package name(s). Empty = skip here (fallback handles it).
pkg_name() {
    local g="$1"
    case "$DOT_PKG:$g" in
        apt:fd|dnf:fd)              echo fd-find ;;
        pacman:gh)                  echo github-cli ;;
        apt:node|pacman:node|dnf:node) echo "nodejs npm" ;;
        brew:node)                  echo node ;;
        apt:build-tools)            echo build-essential ;;
        pacman:build-tools)         echo base-devel ;;
        dnf:build-tools)            echo "gcc make" ;;
        brew:build-tools)           echo "" ;;
        apt:neovim)                 echo "" ;;   # apt ships 0.9.5 -> ensure_neovim
        apt:lazygit|dnf:lazygit)    echo "" ;;   # -> ensure_lazygit
        apt:delta|dnf:delta)        echo "" ;;   # -> ensure_delta
        brew:delta|pacman:delta)    echo git-delta ;;
        apt:tree-sitter|dnf:tree-sitter) echo "" ;;  # -> ensure_tree_sitter
        pacman:tree-sitter)         echo tree-sitter-cli ;;
        apt:nerd-font|dnf:nerd-font|brew:nerd-font) echo "" ;;  # cask / ensure_nerd_font
        pacman:nerd-font)           echo ttf-jetbrains-mono-nerd ;;
        brew:wl-clipboard|brew:xclip|brew:fontconfig|brew:ca-certificates) echo "" ;;
        dnf:shellcheck)             echo ShellCheck ;;
        apt:ghostty|dnf:ghostty)    echo "" ;;   # snap / copr
        *)                          echo "$g" ;;
    esac
}

pkg_update() {
    [[ -n "${_PKG_UPDATED:-}" ]] && return 0
    _PKG_UPDATED=1
    case "$DOT_PKG" in
        apt)    run $SUDO apt-get update -qq ;;
        pacman) run $SUDO pacman -Sy --noconfirm ;;
        *)      : ;;
    esac
}

pkg_available() {
    case "$DOT_PKG" in
        apt) [[ -n "$(apt-cache policy "$1" 2>/dev/null | awk '/Candidate:/ && $2!="(none)"{print $2}')" ]] ;;
        *)   return 0 ;;
    esac
}

# pkg_install <generic>...: map names, drop empties, one manager call.
pkg_install() {
    local g mapped n list=""
    for g in "$@"; do
        mapped="$(pkg_name "$g")"
        [[ -z "$mapped" ]] && continue
        for n in $mapped; do
            if pkg_available "$n"; then
                list="$list $n"
            else
                log_warn "$n not available via $DOT_PKG; relying on fallback"
            fi
        done
    done
    [[ -z "$list" ]] && return 0
    pkg_update
    # shellcheck disable=SC2086
    case "$DOT_PKG" in
        brew)   run brew install $list ;;
        apt)    run $SUDO env DEBIAN_FRONTEND=noninteractive apt-get install -y -qq $list ;;
        pacman) run $SUDO pacman -S --needed --noconfirm $list ;;
        dnf)    run $SUDO dnf install -y $list ;;
        *)      log_warn "No supported package manager; install manually:$list" ;;
    esac
}

# pkg_install_manifest <file>: one generic name per line, '#' comments allowed.
pkg_install_manifest() {
    local f="$1" line pkgs=""
    [[ -r "$f" ]] || { log_warn "manifest not found: $f"; return 0; }
    while IFS= read -r line || [[ -n "$line" ]]; do
        line="${line%%#*}"
        line="${line//[[:space:]]/}"
        [[ -n "$line" ]] && pkgs="$pkgs $line"
    done < "$f"
    # shellcheck disable=SC2086
    pkg_install $pkgs
}

brew_bundle() { run brew bundle --file="$1" --no-upgrade; }

# manifest_for [terminals]: path of the manifest for the current manager.
manifest_for() {
    local kind="${1:-}"
    case "$DOT_PKG" in
        brew) echo "$DOTFILES_DIR/packages/Brewfile${kind:+.$kind}" ;;
        *)    echo "$DOTFILES_DIR/packages/${DOT_PKG}${kind:+-$kind}.txt" ;;
    esac
}
