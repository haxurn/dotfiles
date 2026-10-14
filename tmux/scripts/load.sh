#!/usr/bin/env bash
# load.sh: "<icon> 1.23" 1-minute load average, red once it passes the core count.
if [[ "$(uname)" == Darwin ]]; then
    load="$(sysctl -n vm.loadavg | awk '{print $2}')"
    cores="$(sysctl -n hw.ncpu)"
else
    load="$(cut -d' ' -f1 /proc/loadavg)"
    cores="$(nproc)"
fi
[[ -z "$load" ]] && exit 0
color='#a89984'
awk -v l="$load" -v c="$cores" 'BEGIN { exit !(l > c) }' && color='#fb4934'
printf '#[fg=%s]\U000f04c5 %s' "$color" "$load"   # speedometer
