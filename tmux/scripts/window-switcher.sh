#!/usr/bin/env bash
# window-switcher.sh: fzf over every window in every session, with a live preview.
set -euo pipefail
sel="$(tmux list-windows -a -F '#{session_name}:#{window_index}  #{window_name}  #{b:pane_current_path}' \
    | fzf --prompt=' window ❯ ' --with-nth=1.. \
          --preview 'tmux capture-pane -ep -t {1}' --preview-window=right,60%)" || exit 0
tmux switch-client -t "${sel%% *}"
