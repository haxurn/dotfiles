# 40-completion: zstyles + fzf-tab
zstyle ':completion:*' matcher-list 'm:{a-zA-Z-_}={A-Za-z_-}' 'r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompcache"
zstyle ':completion:*' menu no                        # fzf-tab takes over
zstyle ':completion:*' group-name ''
zstyle ':completion:*' special-dirs true
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

zstyle ':fzf-tab:*' use-fzf-default-opts yes
zstyle ':fzf-tab:*' switch-group '<' '>'
zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup        # popup when inside tmux
# Geometry: ftb-tmux-popup sizes itself to the longest match, which truncates
# names to a few chars and leaves fzf no room to draw the preview. Give it a
# floor and an explicit preview pane.
zstyle ':fzf-tab:*' popup-min-size 120 18
zstyle ':fzf-tab:*' popup-pad 0 0
zstyle ':fzf-tab:*' fzf-min-height 18
zstyle ':fzf-tab:*' fzf-flags --preview-window=right:60%:wrap --border=rounded --ansi
zstyle ':fzf-tab:complete:(cd|z|ls|eza|ll|la|lst):*' fzf-preview 'eza --icons --tree --level=2 --color=always $realpath 2>/dev/null || ls -la $realpath'
zstyle ':fzf-tab:complete:git-(add|diff|restore|checkout):*' fzf-preview 'git diff --color=always -- $word | delta 2>/dev/null || git diff --color=always -- $word'
zstyle ':fzf-tab:complete:(\\|*/|)man:*' fzf-preview 'man $word'
# processes: full command line + resource use
zstyle ':completion:*:*:*:*:processes' command 'ps -u $USER -o pid,user,comm -w'
zstyle ':fzf-tab:complete:(kill|ps):argument-rest' fzf-preview '[[ $group == "[process ID]" ]] && ps -p $word -o pid,ppid,%cpu,%mem,etime,command -ww'
zstyle ':fzf-tab:complete:(kill|ps):argument-rest' fzf-flags --preview-window=down:4:wrap
# environment variables: show the value
zstyle ':fzf-tab:complete:(-parameter-|-brace-parameter-|export|unset|expand):*' fzf-preview 'echo ${(P)word}'
# brew: package info
zstyle ':fzf-tab:complete:brew-(install|uninstall|info|upgrade|reinstall|home):*' fzf-preview 'brew info $word 2>/dev/null | head -40'
# git: log for branches, show for commits
zstyle ':fzf-tab:complete:git-(checkout|switch|merge|rebase|branch):*' fzf-preview 'git log --oneline --graph --color=always -20 $word 2>/dev/null'
zstyle ':fzf-tab:complete:git-show:*' fzf-preview 'git show --color=always $word | delta 2>/dev/null || git show --color=always $word'
# docker: container / image details
zstyle ':fzf-tab:complete:docker-(start|stop|restart|rm|logs|exec|inspect):*' fzf-preview 'docker inspect $word 2>/dev/null | head -50'
# commands: tldr page
zstyle ':fzf-tab:complete:-command-:*' fzf-preview '(( $+commands[$word] )) && { tldr --color always $word 2>/dev/null || man $word 2>/dev/null | col -bx | head -40 } || echo ${(P)word}'
# systemd (Linux)
zstyle ':fzf-tab:complete:systemctl-*:*' fzf-preview 'SYSTEMD_COLORS=1 systemctl status $word'
zstyle ':fzf-tab:complete:*:*' fzf-preview 'bat --color=always --style=numbers --line-range=:200 $realpath 2>/dev/null || eza --icons --tree --level=2 --color=always $realpath 2>/dev/null'
