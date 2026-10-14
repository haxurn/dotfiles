#!/usr/bin/env bash
# net.sh: "<down> 1.2M <up> 40K" bytes/s on the default-route interface.
# Keeps the last byte counters in a cache file to work out the rate between
# calls; several tmux clients share it, so calls under 1s apart reuse the
# last output.
cache="${TMPDIR:-/tmp}/tmux-net-${USER}"

if [[ "$(uname)" == Darwin ]]; then
    iface="$(route -n get default 2>/dev/null | awk '/interface:/{print $2}')"
    [[ -z "$iface" ]] && exit 0
    read -r rx tx < <(netstat -ibn | awk -v i="$iface" '$1==i && $3 ~ /Link/ {print $7, $10; exit}')
else
    iface="$(ip route show default 2>/dev/null | awk '{for(n=1;n<NF;n++) if($n=="dev"){print $(n+1); exit}}')"
    [[ -z "$iface" ]] && exit 0
    rx="$(<"/sys/class/net/$iface/statistics/rx_bytes")"
    tx="$(<"/sys/class/net/$iface/statistics/tx_bytes")"
fi
[[ -z "$rx" ]] && exit 0
now="$(date +%s)"

human() {
    awk -v b="$1" 'BEGIN {
        split("B K M G", u); i = 1
        while (b >= 1000 && i < 4) { b /= 1024; i++ }
        printf (b < 10 && i > 1) ? "%.1f%s" : "%.0f%s", b, u[i]
    }'
}

out=""
if [[ -r "$cache" ]]; then
    read -r t0 rx0 tx0 last < "$cache"
    dt=$(( now - t0 ))
    if (( dt < 1 )); then
        printf '%s' "${last//_/ }"
        exit 0
    fi
    down="$(human $(( (rx - rx0) / dt )))"
    up="$(human $(( (tx - tx0) / dt )))"
    out="#[fg=#8ec07c]\U000f01da ${down} #[fg=#83a598]\U000f0552 ${up}"   # download / upload
fi
out="$(printf '%b' "$out")"
printf '%s %s %s %s\n' "$now" "$rx" "$tx" "${out// /_}" > "$cache"
printf '%s' "$out"
