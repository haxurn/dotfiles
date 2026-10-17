#!/usr/bin/env bash
# window-join: fzf-pick a window (any session) and pull its active pane into
# the current window as a split.
set -euo pipefail
target="$(tmux display -p '#{pane_id}')"
sel="$(tmux list-windows -a -F '#{session_name}:#{window_index}  #{window_name}  (#{window_panes} panes)' \
    | grep -v "^$(tmux display -p '#S:#I') " \
    | fzf --prompt='  join pane from ❯ ' \
          --preview 'tmux capture-pane -ep -t {1}' --preview-window 'right,60%')" || exit 0
tmux join-pane -h -s "${sel%% *}" -t "$target"
