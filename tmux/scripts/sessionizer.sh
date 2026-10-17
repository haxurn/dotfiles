#!/usr/bin/env bash
# sessionizer: fzf over project dirs (or --sessions) -> create/attach a tmux session named after the dir.
# New sessions get a layout: windows edit (nvim) / shell / git (lazygit, git repos only).
# A project can ship its own .tmux-layout script instead; it only runs once you trust
# that folder with `sessionizer.sh --trust [dir]` (a cloned repo cannot run code on you).
# SESSIONIZER_LAYOUT=0 gives a plain one-window session.
set -euo pipefail

trust_file="$HOME/.config/tmux/trusted-layouts"
if [[ "${1:-}" == --trust ]]; then
    dir="$(cd "${2:-.}" && pwd -P)"
    [[ -f "$dir/.tmux-layout" ]] || { echo "no .tmux-layout in $dir" >&2; exit 1; }
    mkdir -p "$(dirname "$trust_file")"
    grep -Fxq "$dir" "$trust_file" 2>/dev/null || echo "$dir" >> "$trust_file"
    echo "trusted: $dir/.tmux-layout"
    exit 0
fi

if [[ "${1:-}" == --sessions ]]; then
    sel="$(tmux ls -F '#S' 2>/dev/null | fzf --prompt=' session ❯ ')" || exit 0
    [[ -n "$sel" ]] && tmux switch-client -t "$sel"
    exit 0
fi

roots=("$HOME/dev" "$HOME"/dev/* "$HOME/.config")
list_projects() {
    local r
    for r in "${roots[@]}"; do
        [[ -d "$r" ]] && find "$r" -mindepth 1 -maxdepth 1 -type d -not -name '.*'
    done
    command -v zoxide >/dev/null 2>&1 && zoxide query -l 2>/dev/null
    true
}

if [[ -n "${1:-}" ]]; then
    sel="$1"
else
    sel="$(list_projects | awk '!seen[$0]++' \
        | fzf --prompt=' project ❯ ' --preview 'eza --icons --tree --level=1 --color=always {} 2>/dev/null || ls {}')" || exit 0
fi
[[ -z "$sel" ]] && exit 0

name="$(basename "$sel" | tr '.:' '__')"
create_session() {   # create_session <dir> <name>
    local dir="$1" name="$2" real
    real="$(cd "$dir" && pwd -P)"
    if [[ "${SESSIONIZER_LAYOUT:-1}" == 0 ]]; then
        tmux new-session -ds "$name" -c "$dir"
        return
    fi
    if [[ -f "$dir/.tmux-layout" ]]; then
        if grep -Fxq "$real" "$trust_file" 2>/dev/null; then
            # The script gets the session name and folder; it must create the session.
            bash "$dir/.tmux-layout" "$name" "$dir"
            tmux has-session -t="$name" 2>/dev/null && return
        else
            tmux display -d 5000 "untrusted .tmux-layout in $name: run 'ts --trust $dir' to use it"
        fi
    fi
    tmux new-session -ds "$name" -c "$dir" -n edit
    tmux send-keys -t "$name:edit" "${EDITOR:-nvim}" Enter
    tmux new-window -dt "$name:" -c "$dir" -n shell
    if git -C "$dir" rev-parse --is-inside-work-tree >/dev/null 2>&1 && command -v lazygit >/dev/null; then
        tmux new-window -dt "$name:" -c "$dir" -n git
        tmux send-keys -t "$name:git" lazygit Enter
    fi
    tmux select-window -t "$name:edit"
}

tmux has-session -t="$name" 2>/dev/null || create_session "$sel" "$name"
if [[ -n "${TMUX:-}" ]]; then
    tmux switch-client -t "$name"
else
    tmux attach -t "$name"
fi
