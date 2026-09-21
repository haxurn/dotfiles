#!/usr/bin/env bash
# lib/fallback.sh - GitHub-release installers for tools the distro lacks or ships too old.
# Everything lands in ~/.local/bin or ~/.local/opt. Each ensure_* is a no-op when the tool exists.
[[ -n "${_DOT_FALLBACK_LOADED:-}" ]] && return 0
_DOT_FALLBACK_LOADED=1

LOCAL_BIN="$HOME/.local/bin"
LOCAL_OPT="$HOME/.local/opt"

linux_triple() { if is_arm; then echo aarch64-unknown-linux-gnu; else echo x86_64-unknown-linux-gnu; fi; }

gh_latest_tag() {
    # capture first, then filter: avoids SIGPIPE under pipefail when head/grep exit early
    local json
    json="$(curl -fsSL "https://api.github.com/repos/$1/releases/latest")" || return 1
    printf '%s\n' "$json" | sed -n 's/.*"tag_name": *"\([^"]*\)".*/\1/p' | sed -n 1p
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
    local v
    v="$(nvim --version 2>/dev/null)"
    [[ "${v%%$'\n'*}" =~ v0\.(1[1-9]|[2-9][0-9])|v[1-9]\. ]]
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
    # shellcheck disable=SC2143  # grep -q would SIGPIPE fc-list under pipefail
    if [[ -n "$(fc-list 2>/dev/null | grep -i "JetBrainsMono.*Nerd Font")" ]] || ls "$d"/*.ttf >/dev/null 2>&1; then
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

ensure_mise() {
    has mise && return 0
    if is_macos; then pkg_install mise; return; fi
    log_info "installing mise via official installer"
    run sh -c "curl -fsSL https://mise.run | sh"
}

ensure_uv() {
    has uv && return 0
    if is_macos; then pkg_install uv; return; fi
    log_info "installing uv via official installer"
    run sh -c "curl -fsSL https://astral.sh/uv/install.sh | sh"
}

ensure_lazydocker() {
    has lazydocker && return 0
    if is_macos; then pkg_install lazydocker; return; fi
    local tag ver arch
    tag="$(gh_latest_tag jesseduffield/lazydocker)" || true
    [[ -n "$tag" ]] || { log_warn "could not resolve lazydocker release"; return 0; }
    ver="${tag#v}"
    if is_arm; then arch=arm64; else arch=x86_64; fi
    gh_release_tarball "https://github.com/jesseduffield/lazydocker/releases/download/${tag}/lazydocker_${ver}_Linux_${arch}.tar.gz" lazydocker
}

ensure_rust() {
    has cargo && return 0
    if is_macos; then pkg_install rustup; return; fi
    log_info "installing rust via rustup"
    # -y: non-interactive; rust-src is required by rust_analyzer
    run sh -c "curl -fsSL https://sh.rustup.rs | sh -s -- -y --no-modify-path --component rust-src,rustfmt,clippy"
}

# Wordlists for the recon/fuzzing tools (ffuf, gobuster, feroxbuster, hydra,
# hashcat). Several GB of shallow clones, so only ever called under --security.
# Blobs over 50m are left on the remote: nothing in these repos that large is
# a wordlist, and it keeps SecLists to a sane size.
_clone_wordlist() {
    local url="$1" dest="$2" name
    name="$(basename "$dest")"
    if [[ -d "$dest/.git" ]]; then
        log_ok "wordlists: $name present"
        return 0
    fi
    log_info "wordlists: cloning $name (this is large)"
    run git clone -q --depth 1 --filter=blob:limit=50m "$url" "$dest" \
        || log_warn "wordlists: $name clone failed"
}

ensure_wordlists() {
    local w="${WORDLISTS:-$HOME/.local/share/wordlists}"
    run mkdir -p "$w"
    _clone_wordlist https://github.com/danielmiessler/SecLists.git          "$w/seclists"
    _clone_wordlist https://github.com/swisskyrepo/PayloadsAllTheThings.git "$w/payloadsallthethings"
    _clone_wordlist https://github.com/fuzzdb-project/fuzzdb.git            "$w/fuzzdb"
    # assetnote: wordlists-cdn.assetnote.io only, no git remote. Fetch manually
    # from https://wordlists.assetnote.io when their CDN is up.
    return 0
}

# GNU binutils is keg-only on macOS because its ld/as/strip would shadow and
# break the native toolchain. But GEF, checksec and pwntools need GNU `readelf`,
# which macOS ships not at all. Symlink ONLY the safe analysis tools into
# ~/.local/bin -- never ld/as/strip. Linux already has them, so macOS-only.
ensure_binutils_shim() {
    is_macos || return 0
    local bindir src
    bindir="$(brew_prefix)/opt/binutils/bin"
    [[ -d "$bindir" ]] || return 0
    run mkdir -p "$LOCAL_BIN"
    # readelf only: macOS lacks it; objdump/nm already exist as llvm builds.
    src="$bindir/readelf"
    [[ -x "$src" && ! -e "$LOCAL_BIN/readelf" ]] && run ln -s "$src" "$LOCAL_BIN/readelf"
    return 0
}

# Shared CTF solve-script venv: pwntools et al isolated as uv tools can't be
# imported from a plain `python3 solve.py`, so give solve scripts one env with
# everything. macOS + Linux; needs uv (from --devtools). No-op if it exists.
ensure_ctf_venv() {
    has uv || { log_warn "ctf venv needs uv (install --devtools first)"; return 0; }
    local venv="$HOME/.venvs/ctf"
    [[ -x "$venv/bin/python" ]] && { log_ok "ctf venv present"; return 0; }
    log_info "creating CTF solve-script venv at $venv"
    run uv venv --python 3.12 "$venv" || { log_warn "ctf venv create failed"; return 0; }
    run uv pip install --python "$venv/bin/python" \
        pwntools pycryptodome sympy gmpy2 requests z3-solver ROPgadget capstone unicorn \
        || log_warn "ctf venv package install incomplete"
    return 0
}
