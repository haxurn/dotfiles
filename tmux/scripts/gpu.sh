#!/usr/bin/env bash
# gpu.sh: "<icon> NN%" GPU load. Apple Silicon via ioreg (no sudo), NVIDIA via
# nvidia-smi, AMD/Intel via sysfs. Prints nothing when no source is found.
pct=""
if [[ "$(uname)" == Darwin ]]; then
    pct="$(ioreg -r -d 1 -w 0 -c IOAccelerator 2>/dev/null |
        grep -Eo '"Device Utilization %"=[0-9]+' | head -1 | cut -d= -f2)"
elif command -v nvidia-smi >/dev/null 2>&1; then
    pct="$(nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits 2>/dev/null | head -1 | tr -d ' ')"
else
    for f in /sys/class/drm/card*/device/gpu_busy_percent; do
        [[ -r "$f" ]] && { pct="$(<"$f")"; break; }
    done
fi
[[ -z "$pct" ]] && exit 0

if   (( pct >= 80 )); then color='#fb4934'   # red
elif (( pct >= 50 )); then color='#fabd2f'   # yellow
else                       color='#d3869b'   # purple
fi
printf '#[fg=%s]\U000f08ae %s%%' "$color" "$pct"   # expansion-card
