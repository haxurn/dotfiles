#!/usr/bin/env bash
# lib/fallback.sh - GitHub-release installers for tools the distro lacks or ships too old.
# Everything lands in ~/.local/bin or ~/.local/opt. Each ensure_* is a no-op when the tool exists.
[[ -n "${_DOT_FALLBACK_LOADED:-}" ]] && return 0
_DOT_FALLBACK_LOADED=1

LOCAL_BIN="$HOME/.local/bin"
LOCAL_OPT="$HOME/.local/opt"

linux_triple() { if is_arm; then echo aarch64-unknown-linux-gnu; else echo x86_64-unknown-linux-gnu; fi; }

gh_latest_tag() {
    curl -fsSL "https://api.github.com/repos/$1/releases/latest" \
        | sed -n 's/.*"tag_name": *"\([^"]*\)".*/\1/p' | head -n 1
}

# gh_release_tarball <url> <bin-name>: download tar.gz, find executable, install to ~/.local/bin
gh_release_tarball() {
    local url="$1" bin="$2" tmp found
    tmp="$(mktemp -d)"
    log_info "downloading $url"
    if [[ "${DRY_RUN:-0}" == 1 ]]; then
        run curl -fsSL "$url" -o "$tmp/pkg.tgz"
        rm -rf "$tmp"
        return 0
    fi
    curl -fsSL "$url" -o "$tmp/pkg.tgz" || { rm -rf "$tmp"; log_error "download failed: $url"; return 1; }
    tar xzf "$tmp/pkg.tgz" -C "$tmp" || { rm -rf "$tmp"; log_error "extract failed: $url"; return 1; }
    found="$(find "$tmp" -type f -name "$bin" -perm -u+x | head -n 1)"
    [[ -n "$found" ]] || { rm -rf "$tmp"; log_error "$bin not found in archive"; return 1; }
    mkdir -p "$LOCAL_BIN"
    install -m 0755 "$found" "$LOCAL_BIN/$bin"
    rm -rf "$tmp"
    log_ok "installed $LOCAL_BIN/$bin"
}

# nvim >= 0.11 required (vim.lsp.config). apt on Ubuntu 24.04 ships 0.9.5.
nvim_is_recent() {
    has nvim || return 1
    nvim --version 2>/dev/null | head -n 1 | grep -qE 'v0\.(1[1-9]|[2-9][0-9])|v[1-9]\.'
}

ensure_neovim() {
    nvim_is_recent && return 0
    if is_macos; then pkg_install neovim; return; fi
    local asset tmp
    if is_arm; then asset="nvim-linux-arm64"; else asset="nvim-linux-x86_64"; fi
    log_info "installing neovim from GitHub release ($asset)"
    tmp="$(mktemp -d)"
    run curl -fsSL "https://github.com/neovim/neovim/releases/latest/download/${asset}.tar.gz" -o "$tmp/nvim.tgz"
    run mkdir -p "$LOCAL_OPT"
    run rm -rf "$LOCAL_OPT/nvim"
    if [[ "${DRY_RUN:-0}" != 1 ]]; then
        tar xzf "$tmp/nvim.tgz" -C "$LOCAL_OPT" && mv "$LOCAL_OPT/$asset" "$LOCAL_OPT/nvim"
    fi
    run mkdir -p "$LOCAL_BIN"
    run ln -sfn "$LOCAL_OPT/nvim/bin/nvim" "$LOCAL_BIN/nvim"
    rm -rf "$tmp"
    log_ok "neovim -> $LOCAL_OPT/nvim"
}

ensure_lazygit() {
    has lazygit && return 0
    if is_macos; then pkg_install lazygit; return; fi
    local tag ver arch
    tag="$(gh_latest_tag jesseduffield/lazygit)" || true
    [[ -n "$tag" ]] || { log_warn "could not resolve lazygit release"; return 0; }
    ver="${tag#v}"
    if is_arm; then arch=arm64; else arch=x86_64; fi
    gh_release_tarball "https://github.com/jesseduffield/lazygit/releases/download/${tag}/lazygit_${ver}_Linux_${arch}.tar.gz" lazygit
}

ensure_eza() {
    has eza && return 0
    if is_macos; then pkg_install eza; return; fi
    gh_release_tarball "https://github.com/eza-community/eza/releases/latest/download/eza_$(linux_triple).tar.gz" eza
}

ensure_delta() {
    has delta && return 0
    if is_macos; then pkg_install delta; return; fi
    local tag
    tag="$(gh_latest_tag dandavison/delta)" || true
    [[ -n "$tag" ]] || { log_warn "could not resolve delta release"; return 0; }
    gh_release_tarball "https://github.com/dandavison/delta/releases/download/${tag}/delta-${tag}-$(linux_triple).tar.gz" delta
}

ensure_zoxide() {
    has zoxide && return 0
    if is_macos; then pkg_install zoxide; return; fi
    log_info "installing zoxide via official installer"
    run sh -c "$(curl -fsSL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh)"
}

ensure_tree_sitter() {
    has tree-sitter && return 0
    pkg_install tree-sitter
    has tree-sitter && return 0
    if has npm; then
        run npm install -g tree-sitter-cli
    elif has cargo; then
        run cargo install tree-sitter-cli
    else
        log_warn "install tree-sitter-cli manually (npm i -g tree-sitter-cli); treesitter parsers won't build"
    fi
}

# Linux only; on macOS the cask in Brewfile.terminals handles it.
ensure_nerd_font() {
    is_linux || return 0
    local d="$HOME/.local/share/fonts/JetBrainsMonoNerd" tmp
    if fc-list 2>/dev/null | grep -qi "JetBrainsMono.*Nerd Font" || ls "$d"/*.ttf >/dev/null 2>&1; then
        log_ok "JetBrainsMono Nerd Font present"
        return 0
    fi
    log_info "installing JetBrainsMono Nerd Font"
    tmp="$(mktemp -d)"
    run curl -fsSL https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.tar.xz -o "$tmp/font.tar.xz"
    run mkdir -p "$d"
    [[ "${DRY_RUN:-0}" != 1 ]] && tar xJf "$tmp/font.tar.xz" -C "$d"
    run fc-cache -f
    rm -rf "$tmp"
}

# ensure_bin_alias <distro-name> <wanted-name>: e.g. batcat -> bat, fdfind -> fd (Debian renames)
ensure_bin_alias() {
    has "$2" && return 0
    has "$1" || return 0
    run mkdir -p "$LOCAL_BIN"
    run ln -sf "$(command -v "$1")" "$LOCAL_BIN/$2"
    log_ok "$2 -> $(command -v "$1")"
}

ensure_fzf_git() {
    local d="$HOME/.local/share/fzf-git.sh"
    [[ -d "$d" ]] && return 0
    run git clone -q --depth=1 https://github.com/junegunn/fzf-git.sh "$d"
}

# fzf >= 0.48 provides `fzf --zsh`; apt on Ubuntu 24.04 ships 0.44. Install latest to ~/.local/bin.
ensure_fzf() {
    if has fzf && fzf --zsh >/dev/null 2>&1; then return 0; fi
    if is_macos; then pkg_install fzf; return; fi
    local tag ver arch
    tag="$(gh_latest_tag junegunn/fzf)" || true
    [[ -n "$tag" ]] || { log_warn "could not resolve fzf release; keeping distro fzf"; return 0; }
    ver="${tag#v}"
    if is_arm; then arch=arm64; else arch=amd64; fi
    gh_release_tarball "https://github.com/junegunn/fzf/releases/download/${tag}/fzf-${ver}-linux_${arch}.tar.gz" fzf
}
