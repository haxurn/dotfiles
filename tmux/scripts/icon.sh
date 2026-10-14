#!/usr/bin/env bash
# icon.sh <command>: print a Nerd Font icon for the program running in a pane.
# Used by window and pane-border formats. Codepoints: nerdfonts.com/cheat-sheet.
case "${1:-}" in
    nvim|vim|vi)                   printf '' ;;      # vim
    zsh|-zsh|bash|fish|sh)         printf '' ;;      # terminal
    lazygit|git|tig|gitui)         printf '' ;;      # git
    btop|htop|top|glances)         printf '\U000f012a' ;;  # chart-line
    node|bun|deno|npm|pnpm|yarn)   printf '\U000f0399' ;;  # nodejs
    python*|ipython|uv)            printf '\U000f0320' ;;  # python
    go|gopls)                      printf '\U000f07d3' ;;  # go
    cargo|rustc|rust-analyzer)     printf '\U000f1617' ;;  # rust
    dart|flutter)                  printf '' ;;      # dart
    docker|lazydocker|dive)        printf '\U000f0868' ;;  # docker
    kubectl|k9s)                   printf '\U000f10fe' ;;  # kubernetes
    ssh|mosh|scp)                  printf '\U000f08c0' ;;  # ssh
    psql|mysql|sqlite3|redis-cli)  printf '\U000f01bc' ;;  # database
    man|less|bat|glow)             printf '\U000f05da' ;;  # book
    claude|codex|aider)            printf '\U000f06a9' ;;  # robot
    gdb|lldb|r2|radare2|rizin)     printf '\U000f00e4' ;;  # bug
    nmap|ffuf|sqlmap|nuclei|msfconsole) printf '\U000f13da' ;;  # shield-bug
    *)                             printf '\U000f018d' ;;  # console
esac
