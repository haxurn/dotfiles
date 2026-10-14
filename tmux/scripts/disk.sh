#!/usr/bin/env bash
# disk.sh: "<icon> NN%" used space on /, yellow at 80%, red at 90%.
pct="$(df -P / 2>/dev/null | awk 'NR==2 {sub("%", "", $5); print $5}')"
[[ -z "$pct" ]] && exit 0
if   (( pct >= 90 )); then color='#fb4934'
elif (( pct >= 80 )); then color='#fabd2f'
else                       color='#a89984'
fi
printf '#[fg=%s]\U000f02ca %s%%' "$color" "$pct"   # harddisk
