#!/usr/bin/env bash
# lib/os.sh - OS / arch / package manager detection. bash 3.2 safe.
[[ -n "${_DOT_OS_LOADED:-}" ]] && return 0
_DOT_OS_LOADED=1

has()     { command -v "$1" >/dev/null 2>&1; }
require() { local c; for c in "$@"; do has "$c" || die "'$c' is required"; done; }

# Sets DOT_OS (macos|linux), DOT_ARCH (arm64|x86_64), DOT_DISTRO, DOT_PKG, SUDO.
detect_os() {
    DOT_OS=linux DOT_DISTRO=unknown DOT_PKG=none
    case "$(uname -s)" in
        Darwin) DOT_OS=macos ;;
        Linux)  DOT_OS=linux ;;
        *)      die "Unsupported OS: $(uname -s)" ;;
    esac
    case "$(uname -m)" in
        arm64|aarch64) DOT_ARCH=arm64 ;;
        x86_64|amd64)  DOT_ARCH=x86_64 ;;
        *)             DOT_ARCH="$(uname -m)" ;;
    esac
    if [[ "$DOT_OS" == macos ]]; then
        DOT_PKG=brew DOT_DISTRO=macos
    elif [[ -r /etc/os-release ]]; then
        local ID ID_LIKE
        # shellcheck disable=SC1091
        . /etc/os-release
        case " ${ID:-} ${ID_LIKE:-} " in
            *" ubuntu "*|*" debian "*) DOT_DISTRO=debian DOT_PKG=apt ;;
            *" arch "*)                DOT_DISTRO=arch   DOT_PKG=pacman ;;
            *" fedora "*|*" rhel "*)   DOT_DISTRO=fedora DOT_PKG=dnf ;;
        esac
    fi
    if [[ "$DOT_PKG" == none ]]; then
        if has apt-get; then DOT_PKG=apt
        elif has pacman; then DOT_PKG=pacman
        elif has dnf; then DOT_PKG=dnf
        fi
    fi
    SUDO=""
    [[ "$DOT_OS" == linux && "$EUID" -ne 0 ]] && SUDO="sudo"
    export DOT_OS DOT_ARCH DOT_DISTRO DOT_PKG SUDO
}

is_macos() { [[ "$DOT_OS" == macos ]]; }
is_linux() { [[ "$DOT_OS" == linux ]]; }
is_arm()   { [[ "$DOT_ARCH" == arm64 ]]; }

# Prints the Homebrew prefix without invoking brew (works before brew is installed).
brew_prefix() {
    if   [[ -x /opt/homebrew/bin/brew ]]; then echo /opt/homebrew
    elif [[ -x /usr/local/bin/brew ]]; then echo /usr/local
    elif [[ -x /home/linuxbrew/.linuxbrew/bin/brew ]]; then echo /home/linuxbrew/.linuxbrew
    elif is_macos && is_arm; then echo /opt/homebrew
    else echo /usr/local
    fi
}

load_brew_env() {
    local p
    p="$(brew_prefix)"
    [[ -x "$p/bin/brew" ]] || return 0
    eval "$("$p/bin/brew" shellenv)"
}
