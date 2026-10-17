# 50-keybinds (omz already binds ctrl-arrows / Home / End)
bindkey '^[[1;3C' forward-word          # alt/option-right  (mac: option_as_alt in terminal config)
bindkey '^[[1;3D' backward-word         # alt/option-left
bindkey '^H'      backward-kill-word    # ctrl-backspace (kitty / ghostty)
bindkey '^[[3;5~' kill-word             # ctrl-delete
bindkey '^[[3~'   delete-char
# up/down -> history-substring-search, bound in 90-plugins.zsh once the plugin is loaded

# Ctrl-z: on an empty line, bring the last suspended job back (fg). On a typed
# line, park the line, run fg, and restore the line after. Suspend vim with
# Ctrl-z, then Ctrl-z again to return.
_fancy_ctrl_z() {
  if [[ -z $BUFFER ]]; then
    BUFFER=fg; zle accept-line
  else
    zle push-input; BUFFER=fg; zle accept-line
  fi
}
zle -N _fancy_ctrl_z
bindkey '^Z' _fancy_ctrl_z

# Alt-.: insert the last argument of the previous command (repeat to go further back)
bindkey '^[.' insert-last-word

# Alt-s: put `sudo` in front of the line (omz sudo plugin; Esc Esc still works too)
(( $+widgets[sudo-command-line] )) && bindkey '^[s' sudo-command-line

# Ctrl-o: copy the current command line to the clipboard (clipcopy from oh-my-zsh)
_copy_buffer() {
  print -rn -- "$BUFFER" | clipcopy && zle -M "copied: $BUFFER"
}
zle -N _copy_buffer
bindkey '^O' _copy_buffer

# Auto `ls` after every directory change (cd, z, popd). Big folders get a
# count instead of a wall of names. AUTO_LS=0 in ~/.zshrc.local turns it off.
_auto_ls() {
  [[ ${AUTO_LS:-1} == 1 && -o interactive ]] || return
  local -a entries=( *(N) )
  if (( $#entries <= 60 )); then
    ls
  else
    print -P "%F{8}$#entries entries (ls to list)%f"
  fi
}
autoload -Uz add-zsh-hook
add-zsh-hook chpwd _auto_ls
