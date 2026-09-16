# 70-tools: fzf, zoxide, direnv, runtimes, pagers

# ── fzf (Catppuccin Mocha) ──
export FZF_DEFAULT_OPTS="
  --height=60% --layout=reverse --border=rounded --info=inline-right
  --prompt='   ' --pointer='' --marker='' --separator='─' --scrollbar='│'
  --color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8
  --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc
  --color=marker:#a6e3a1,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8
  --color=border:#45475a,separator:#45475a,scrollbar:#45475a
"
if (( $+commands[fd] )); then
  export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
fi
export FZF_CTRL_T_OPTS="--preview 'bat --color=always --style=numbers --line-range=:200 {} 2>/dev/null || eza --icons --tree --level=2 {}'"
export FZF_ALT_C_OPTS="--preview 'eza --icons --tree --level=2 {}'"
export FZF_CTRL_R_OPTS="--preview 'echo {}' --preview-window up:3:hidden:wrap --bind 'ctrl-/:toggle-preview'"
export FZF_TMUX_OPTS='-p 80%,70%'

# key bindings + completion: fzf >= 0.48 has --zsh; apt's 0.44 ships example files
if (( $+commands[fzf] )); then
  if fzf --zsh >/dev/null 2>&1; then
    source <(fzf --zsh)
  elif [[ -r /usr/share/doc/fzf/examples/key-bindings.zsh ]]; then
    source /usr/share/doc/fzf/examples/key-bindings.zsh
    [[ -r /usr/share/doc/fzf/examples/completion.zsh ]] && source /usr/share/doc/fzf/examples/completion.zsh
  fi
fi
# ctrl-g ctrl-{f,b,t,r,h,s} git pickers
[[ -r "$HOME/.local/share/fzf-git.sh/fzf-git.sh" ]] && source "$HOME/.local/share/fzf-git.sh/fzf-git.sh"

# ── pagers ──
if (( $+commands[bat] )); then
  export MANPAGER="sh -c 'col -bx | bat -l man -p'"
  export MANROFFOPT="-c"
fi

# ── zoxide (smarter cd) ──
export _ZO_DOCTOR=0           # silences the p10k instant-prompt false positive
(( $+commands[zoxide] )) && eval "$(zoxide init zsh --cmd cd)"

# ── direnv ──
(( $+commands[direnv] )) && eval "$(direnv hook zsh)"

# ── runtimes ──
[[ -e /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]] && . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
FNM_PATH="$HOME/.local/share/fnm"
if [[ -d "$FNM_PATH" ]]; then
  path=("$FNM_PATH" $path)
  eval "$(fnm env --shell zsh --use-on-cd --version-file-strategy=recursive)"
elif (( $+commands[fnm] )); then
  eval "$(fnm env --shell zsh --use-on-cd --version-file-strategy=recursive)"
fi
[[ -s "$HOME/.bun/_bun" ]] && source "$HOME/.bun/_bun"
[[ -r "$HOME/.cargo/env" ]] && . "$HOME/.cargo/env"
path+=("$HOME"/.local/share/gem/ruby/*/bin(N))
