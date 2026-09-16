# 90-plugins: must be LAST. autosuggestions, syntax highlighting, history substring search.
_src_first() { local f; for f in "$@"; do [[ -r "$f" ]] && { source "$f"; return 0 }; done; return 1 }

_src_first "$ZSH_CUSTOM/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh" \
           "${HOMEBREW_PREFIX:-/nope}/share/zsh-autosuggestions/zsh-autosuggestions.zsh" \
           /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20

# Forge registers its own highlighter before z-s-h loads; keep the main parser enabled too.
typeset -ga ZSH_HIGHLIGHT_HIGHLIGHTERS
(( ${ZSH_HIGHLIGHT_HIGHLIGHTERS[(Ie)main]} )) || ZSH_HIGHLIGHT_HIGHLIGHTERS=(main $ZSH_HIGHLIGHT_HIGHLIGHTERS)
_src_first "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" \
           "${HOMEBREW_PREFIX:-/nope}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" \
           /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

if _src_first "$ZSH/plugins/history-substring-search/history-substring-search.zsh"; then
  bindkey '^[[A' history-substring-search-up
  bindkey '^[[B' history-substring-search-down
  bindkey -M vicmd 'k' history-substring-search-up
  bindkey -M vicmd 'j' history-substring-search-down
fi
unfunction _src_first
