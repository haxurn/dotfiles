#!/usr/bin/env bash
# git-branch.sh <path>: "<icon> branch" for the pane's repo, "*" when dirty.
# Prints nothing outside a git repo.
dir="${1:-$PWD}"
branch="$(git -C "$dir" branch --show-current 2>/dev/null)" || exit 0
[[ -z "$branch" ]] && branch="$(git -C "$dir" rev-parse --short HEAD 2>/dev/null)" || true
[[ -z "$branch" ]] && exit 0
(( ${#branch} > 24 )) && branch="${branch:0:23}…"
dirty=""
[[ -n "$(git -C "$dir" status --porcelain --untracked-files=no 2>/dev/null | head -1)" ]] && dirty="*"
printf ' %s%s' "$branch" "$dirty"
