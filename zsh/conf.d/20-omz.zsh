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
  fzf-tab
)

[[ -r "$ZSH/oh-my-zsh.sh" ]] && source "$ZSH/oh-my-zsh.sh"
