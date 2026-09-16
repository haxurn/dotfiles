#!/usr/bin/env bash
# Static checks: bash syntax, shellcheck, zsh syntax, tmux parse, lua load, dry-run.
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"
fail=0
step() { printf '\n== %s\n' "$*"; }

SH_FILES=(setup.sh lib/*.sh ./*/install.sh scripts/*.sh tmux/scripts/*.sh)

step "bash -n"
bash -n "${SH_FILES[@]}" && echo ok || fail=1

step "shellcheck"
if command -v shellcheck >/dev/null 2>&1; then
    shellcheck -x "${SH_FILES[@]}" && echo ok || fail=1
elif command -v docker >/dev/null 2>&1; then
    docker run --rm -v "$ROOT:/mnt:ro" -w /mnt koalaman/shellcheck:stable -x "${SH_FILES[@]}" && echo ok || fail=1
else
    echo "skipped (no shellcheck / docker)"
fi

step "zsh -n"
for f in zsh/.zshrc zsh/conf.d/*.zsh zsh/zshrc.local.example zsh/functions/*; do
    zsh -n "$f" || { echo "FAIL $f"; fail=1; }
done; echo ok

step "tmux config parses"
if command -v tmux >/dev/null 2>&1; then
    out="$(tmux -L dotcheck -f tmux/tmux.conf new-session -d 'sleep 1' 2>&1 || true)"
    tmux -L dotcheck kill-server 2>/dev/null || true
    # TPM missing is expected in CI; anything else is a real error
    if [[ -n "$out" && "$out" != *"tpm/tpm"* ]]; then echo "$out"; fail=1; else echo ok; fi
else
    echo "skipped (no tmux)"
fi

step "nvim lua loadfile"
if command -v nvim >/dev/null 2>&1; then
    nvim --clean --headless -c 'lua local bad=0 for _,f in ipairs(vim.fn.glob("nvim/**/*.lua",1,1)) do if not loadfile(f) then print("LOADFAIL "..f) bad=bad+1 end end if not loadfile("nvim/init.lua") then bad=bad+1 end if bad>0 then vim.cmd("cq") end' -c q && echo ok || fail=1
else
    echo "skipped (no nvim)"
fi

step "setup.sh --all --dry-run"
n="$(./setup.sh --all --dry-run -y 2>&1 | grep -c '^\[dry\]' || true)"
if [[ "$n" -gt 0 ]]; then echo "ok ($n dry actions)"; else echo "FAIL: dry-run produced no actions"; fail=1; fi

printf '\n'
if [[ $fail -eq 0 ]]; then echo "ALL CHECKS PASSED"; else echo "CHECKS FAILED"; exit 1; fi
