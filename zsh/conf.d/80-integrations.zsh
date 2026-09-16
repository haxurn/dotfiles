# 80-integrations: terminal / tool shell hooks (all guarded)

# Kiro
if [[ "$TERM_PROGRAM" == "kiro" ]] && (( $+commands[kiro] )); then
  _kiro_integration="$(kiro --locate-shell-integration-path zsh)"
  [[ -r "$_kiro_integration" ]] && source "$_kiro_integration"
  unset _kiro_integration
fi

# Warp (also when running inside tmux under Warp)
if [[ "$DOTFILES_TERM" == "warp" || "$TERM_PROGRAM" == "Warp" ]]; then
  export TERM=xterm-256color COLORTERM=truecolor PROMPT_EOL_MARK=''
fi

# Forge: plugin only (its theme fights p10k)
if (( $+commands[forge] )) && [[ -z "$_FORGE_PLUGIN_LOADED" ]]; then
  eval "$(forge zsh plugin)"
  export FORGE_EDITOR="nvim"
fi

# lockenv completions (sed '$d' drops the trailing compdef line; portable, unlike head -n -1)
if (( $+commands[lockenv] )); then
  source <(lockenv completion zsh | sed '$d')
  compdef _lockenv lockenv
fi

[[ -r "$HOME/.openclaw/completions/openclaw.zsh" ]] && source "$HOME/.openclaw/completions/openclaw.zsh"
