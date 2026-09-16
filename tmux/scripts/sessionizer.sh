#!/usr/bin/env bash
# sessionizer: fzf over project dirs (or --sessions) -> create/attach a tmux session named after the dir.
set -euo pipefail

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
tmux has-session -t="$name" 2>/dev/null || tmux new-session -ds "$name" -c "$sel"
if [[ -n "${TMUX:-}" ]]; then
    tmux switch-client -t "$name"
else
    tmux attach -t "$name"
fi
