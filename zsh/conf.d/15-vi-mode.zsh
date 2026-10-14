# 15-vi-mode: zsh-vi-mode (vi editing on the command line).
# Loads before oh-my-zsh and every later keybind. ZVM_INIT_MODE=sourcing makes
# it set up keymaps right now instead of on the first prompt, so bindings made
# later (fzf, atuin, fzf-tab, history-substring-search, autopair, abbr) stay put.
#   Esc: normal mode. `vv` in normal mode: edit the line in $EDITOR.
#   Text objects (ciw, di", ya( ...), surround (sa / sd / sr), visual mode.
ZVM_INIT_MODE=sourcing
ZVM_KEYTIMEOUT=0.15                      # short Esc delay
ZVM_LINE_INIT_MODE=i                     # every new prompt starts in insert mode
ZVM_SYSTEM_CLIPBOARD_ENABLED=true        # y / p use the system clipboard
ZVM_VI_EDITOR=${EDITOR:-nvim}
_zvm="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-vi-mode/zsh-vi-mode.plugin.zsh"
[[ -r "$_zvm" ]] && source "$_zvm"
unset _zvm
