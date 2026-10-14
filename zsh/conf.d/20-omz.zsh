# 20-omz: oh-my-zsh. compinit runs ONCE here — add completion dirs to fpath above this line.
export ZSH="$HOME/.oh-my-zsh"
export ZSH_CUSTOM="${ZSH_CUSTOM:-$ZSH/custom}"
ZSH_THEME=""                                   # p10k is sourced in .zshrc
ZSH_COMPDUMP="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompdump-${ZSH_VERSION}"
mkdir -p "${ZSH_COMPDUMP:h}"
DISABLE_AUTO_UPDATE=true
DISABLE_MAGIC_FUNCTIONS=true                   # faster paste

# Extra completion sources (must precede compinit)
[[ -d "$ZSH_CUSTOM/plugins/zsh-completions/src" ]] && fpath=("$ZSH_CUSTOM/plugins/zsh-completions/src" $fpath)
[[ -d "$HOME/.grok/completions/zsh" ]] && fpath=("$HOME/.grok/completions/zsh" $fpath)

# NOTE: no `git` plugin (its gst/gwip clash with ours), no `zsh-completions` (fpath above),
# autosuggestions / syntax-highlighting are sourced last in 90-plugins.zsh.
plugins=(
  docker docker-compose npm golang
  command-not-found extract sudo jsontools web-search
  copypath copyfile dirhistory
  safe-paste aliases                # paste never auto-runs; `als` lists/searches aliases
  fzf-tab
)

# oh-my-zsh deletes, rebuilds and then appends to $ZSH_COMPDUMP. When several shells
# start at once (tmux-resurrect restoring panes) they write it together and corrupt
# it ("zcompdump:NNNN: no such file or directory"). A file lock lets one shell at a
# time load oh-my-zsh; others wait a few ms. If locking fails, load without it.
if [[ -r "$ZSH/oh-my-zsh.sh" ]]; then
  zmodload -F zsh/system b:zsystem 2>/dev/null
  : >> "${ZSH_COMPDUMP}.omz-lock" 2>/dev/null    # zsystem flock needs an existing file
  if (( $+builtins[zsystem] )) && zsystem flock -t 10 -f _omz_lock_fd "${ZSH_COMPDUMP}.omz-lock" 2>/dev/null; then
    source "$ZSH/oh-my-zsh.sh"
    zsystem flock -u $_omz_lock_fd
  else
    source "$ZSH/oh-my-zsh.sh"
  fi
  unset _omz_lock_fd
fi

# oh-my-zsh's lib/key-bindings.zsh runs `bindkey -e`, which undoes zsh-vi-mode
# (15-vi-mode.zsh). Put the vi insert keymap back as main so it, and every
# binding made after this point, is active.
(( $+functions[zvm_init] )) && bindkey -A viins main
