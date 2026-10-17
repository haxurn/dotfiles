#!/usr/bin/env bash
# scrollback: dump a pane's whole history to a file.
#   scrollback.sh edit <pane_id>   open it in nvim (runs inside a popup), file deleted after
#   scrollback.sh save <pane_id>   keep it under ~/.local/share/tmux/scrollback/
set -euo pipefail
mode="${1:?edit|save}"; pane="${2:?pane id}"

if [[ "$mode" == save ]]; then
    dir="$HOME/.local/share/tmux/scrollback"
    mkdir -p "$dir"
    name="$(tmux display -p -t "$pane" '#S-#W')"
    file="$dir/${name//[^A-Za-z0-9_.-]/_}-$(date +%Y%m%d-%H%M%S).log"
    tmux capture-pane -p -J -S - -t "$pane" > "$file"
    tmux display "scrollback saved: ${file/#$HOME/~}"
    exit 0
fi

file="$(mktemp -t tmux-scrollback.XXXXXX)"
trap 'rm -f "$file"' EXIT
# -J joins wrapped lines; drop the trailing blank lines below the prompt
tmux capture-pane -p -J -S - -t "$pane" \
    | awk '{ l[NR] = $0 } NF { last = NR } END { for (i = 1; i <= last; i++) print l[i] }' > "$file"
"${EDITOR:-nvim}" -c 'setlocal nomodified buftype=nofile' + "$file"
