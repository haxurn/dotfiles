# ~/.zshrc  (linked from dotfiles/zsh/.zshrc) — keep tiny; modules live in conf.d/
# ZPROF=1 zsh -i -c exit   -> startup profile

# direnv must export before the instant prompt (p10k docs)
(( $+commands[direnv] )) && emulate zsh -c "$(direnv export zsh)"

# ── Powerlevel10k instant prompt (must be first) ─────────────────────────
if [[ -t 1 && -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
[[ -n $ZPROF ]] && zmodload zsh/zprof

POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=true
[[ -r "$HOME/.oh-my-zsh/custom/themes/powerlevel10k/powerlevel10k.zsh-theme" ]] \
  && source "$HOME/.oh-my-zsh/custom/themes/powerlevel10k/powerlevel10k.zsh-theme"

# ── Modules ─────────────────────────────────────────────────────────────
DOTFILES_ZSH="${${(%):-%x}:A:h}"          # resolves the symlink -> <repo>/zsh
fpath=("$DOTFILES_ZSH/functions" $fpath)
autoload -Uz "$DOTFILES_ZSH"/functions/*(N.:t)
for _f in "$DOTFILES_ZSH"/conf.d/*.zsh(N); do source "$_f"; done; unset _f

# ── Machine-specific (untracked) ────────────────────────────────────────
[[ -r "$HOME/.zshrc.local" ]] && source "$HOME/.zshrc.local"

# ── Powerlevel10k prompt config ─────────────────────────────────────────
# No `-t 1` guard here: p10k's instant prompt redirects fd 1 to a buffer while
# .zshrc runs, so `[[ -t 1 ]]` is false during init. Gating on it skips this
# source and p10k falls back to its built-in powerline default. .zshrc only runs
# for interactive shells anyway, so an unconditional source is correct.
[[ -r ~/.p10k.zsh ]] && source ~/.p10k.zsh

[[ -n $ZPROF ]] && zprof

# Keep the file's exit status at 0. Without this, the final conditional above
# decides it, so `source ~/.zshrc` reports failure and the prompt shows 1.
true
