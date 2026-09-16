# 50-keybinds (omz already binds ctrl-arrows / Home / End)
bindkey '^[[1;3C' forward-word          # alt/option-right  (mac: option_as_alt in terminal config)
bindkey '^[[1;3D' backward-word         # alt/option-left
bindkey '^H'      backward-kill-word    # ctrl-backspace (kitty / ghostty)
bindkey '^[[3;5~' kill-word             # ctrl-delete
bindkey '^[[3~'   delete-char
# up/down -> history-substring-search, bound in 90-plugins.zsh once the plugin is loaded
