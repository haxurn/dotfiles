#!/usr/bin/env bash
# lib/log.sh - colored logging, dry-run gate, confirm prompt. bash 3.2 safe.
[[ -n "${_DOT_LOG_LOADED:-}" ]] && return 0
_DOT_LOG_LOADED=1

if [[ -t 1 && -z "${NO_COLOR:-}" ]]; then
    C_RED=$'\033[0;31m' C_GREEN=$'\033[0;32m' C_YELLOW=$'\033[1;33m'
    C_BLUE=$'\033[0;34m' C_DIM=$'\033[2m' C_RESET=$'\033[0m'
else
    C_RED='' C_GREEN='' C_YELLOW='' C_BLUE='' C_DIM='' C_RESET=''
fi

log_info()  { printf '%s[info]%s %s\n' "$C_BLUE" "$C_RESET" "$*"; }
log_ok()    { printf '%s[ ok ]%s %s\n' "$C_GREEN" "$C_RESET" "$*"; }
log_warn()  { printf '%s[warn]%s %s\n' "$C_YELLOW" "$C_RESET" "$*" >&2; }
log_error() { printf '%s[fail]%s %s\n' "$C_RED" "$C_RESET" "$*" >&2; }
log_step()  { printf '\n%s=== %s ===%s\n\n' "$C_BLUE" "$*" "$C_RESET"; }
die()       { log_error "$@"; exit 1; }

# run <cmd...>: every mutating command goes through here. DRY_RUN=1 prints instead.
run() {
    if [[ "${DRY_RUN:-0}" == 1 ]]; then
        printf '%s[dry]%s %s\n' "$C_DIM" "$C_RESET" "$*"
    else
        "$@"
    fi
}

# confirm "Question?" [y|n]  -> 0 yes, 1 no. ASSUME_YES=1 or no tty => default answer.
confirm() {
    local q="$1" def="${2:-n}" ans hint
    if [[ "${ASSUME_YES:-0}" == 1 || ! -t 0 ]]; then
        [[ "$def" == y ]]
        return
    fi
    if [[ "$def" == y ]]; then hint="Y/n"; else hint="y/N"; fi
    read -r -p "$q [$hint] " ans
    ans="${ans:-$def}"
    [[ "$ans" == y || "$ans" == Y ]]
}
