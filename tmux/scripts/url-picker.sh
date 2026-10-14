#!/usr/bin/env bash
# url-picker.sh: fzf over URLs in the current pane (plus scrollback), newest first; open the picks.
set -euo pipefail
urls="$(tmux capture-pane -J -p -S -2000 \
    | grep -Eo '(https?|file)://[^][[:space:]"<>`'"'"'(){}]+' \
    | sed -E 's/[.,;:!?]+$//' \
    | awk '{ l[NR] = $0 } END { for (i = NR; i > 0; i--) print l[i] }' \
    | awk '!seen[$0]++' || true)"
[[ -z "$urls" ]] && { tmux display-message "no URLs in this pane"; exit 0; }
sel="$(fzf --prompt=' url ❯ ' --multi <<<"$urls")" || exit 0
opener="open"; command -v open >/dev/null 2>&1 || opener="xdg-open"
while IFS= read -r u; do [[ -n "$u" ]] && "$opener" "$u" >/dev/null 2>&1 & done <<<"$sel"
