#!/usr/bin/env bash
# battery.sh: "<icon> NN%" on laptops (macOS pmset, Linux sysfs). Nothing on desktops.
pct="" charging=0
if command -v pmset >/dev/null 2>&1; then
    info="$(pmset -g batt 2>/dev/null)"
    pct="$(grep -Eo '[0-9]+%' <<<"$info" | head -1 | tr -d %)"
    grep -q "AC Power" <<<"$info" && charging=1
else
    for b in /sys/class/power_supply/BAT*; do
        [[ -r "$b/capacity" ]] || continue
        pct="$(<"$b/capacity")"
        [[ "$(<"$b/status")" == Charging ]] && charging=1
        break
    done
fi
[[ -z "$pct" ]] && exit 0

if   (( charging ));  then icon=$'\U000f0084' color='#8ec07c'   # battery-charging, aqua
elif (( pct >= 80 )); then icon=$'\U000f0079' color='#b8bb26'   # battery, green
elif (( pct >= 50 )); then icon=$'\U000f12a3' color='#b8bb26'   # battery-high
elif (( pct >= 20 )); then icon=$'\U000f12a2' color='#fabd2f'   # battery-medium, yellow
else                       icon=$'\U000f0083' color='#fb4934'   # battery-alert, red
fi
printf '#[fg=%s]%s %s%%' "$color" "$icon" "$pct"
