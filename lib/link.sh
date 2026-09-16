#!/usr/bin/env bash
# lib/link.sh - idempotent symlinks with a single per-run backup dir. bash 3.2 safe.
[[ -n "${_DOT_LINK_LOADED:-}" ]] && return 0
_DOT_LINK_LOADED=1

: "${DOT_BACKUP_DIR:=$HOME/.dotfiles_backup/$(date +%Y%m%d_%H%M%S)}"
export DOT_BACKUP_DIR

# backup_path <dest>: move dest to $DOT_BACKUP_DIR/<path relative to $HOME>
backup_path() {
    local dest="$1" rel="${1#"$HOME"/}"
    run mkdir -p "$DOT_BACKUP_DIR/$(dirname "$rel")"
    run mv "$dest" "$DOT_BACKUP_DIR/$rel"
    log_warn "backed up $dest -> $DOT_BACKUP_DIR/$rel"
}

# _link <src> <dest> <ln-flags>
_link() {
    local src="$1" dest="$2" flags="$3"
    [[ -e "$src" ]] || die "link source missing: $src"
    run mkdir -p "$(dirname "$dest")"
    if [[ -L "$dest" && "$(readlink "$dest")" == "$src" ]]; then
        log_ok "linked: $dest"
        return 0
    fi
    if [[ -e "$dest" || -L "$dest" ]]; then
        backup_path "$dest"
    fi
    run ln "$flags" "$src" "$dest"
    log_ok "$dest -> $src"
}

link_file() { _link "$1" "$2" -s; }
link_dir()  { [[ -d "$1" ]] || die "not a directory: $1"; _link "$1" "$2" -sn; }

# copy_if_missing <src> <dest>: seed a template once, never overwrite.
copy_if_missing() {
    local src="$1" dest="$2"
    if [[ -e "$dest" ]]; then
        log_ok "exists: $dest"
        return 0
    fi
    run mkdir -p "$(dirname "$dest")"
    run cp "$src" "$dest"
    log_ok "created $dest from template"
}
